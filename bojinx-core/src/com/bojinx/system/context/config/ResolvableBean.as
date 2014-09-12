package com.bojinx.system.context.config
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.api.context.config.IBean;
	import com.bojinx.api.context.config.IResolvableBean;
	import com.bojinx.api.context.config.support.IBeanFactory;
	import com.bojinx.included.meta.FactoryMetadata;
	import com.bojinx.reflection.ClassInfo;
	import com.bojinx.reflection.ClassInfoFactory;
	import com.bojinx.reflection.Method;
	import com.bojinx.reflection.Property;
	import com.bojinx.system.cache.definition.ObjectDefinition;
	import com.bojinx.utils.GUID;
	import com.bojinx.utils.logging.Logger;
	import com.bojinx.utils.logging.LoggingContext;
	import com.bojinx.utils.type.ClassUtils;
	
	public class ResolvableBean implements IResolvableBean, IBean, IBeanFactory
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _factoryMethod:String;
		
		/**
		 * Name of the optional factory method to use
		 * when new instances of the object are requested.
		 */
		public function get factoryMethod():String
		{
			return _factoryMethod;
		}
		
		/**
		 * @private
		 */
		public function set factoryMethod( value:String ):void
		{
			_factoryMethod = value;
		}
		
		private var _constructorArgs:Array;
		
		[ArrayElementType( "com.bojinx.system.context.config.ConstructorArg" )]
		public function get constructorArgs():Array
		{
			return _constructorArgs;
		}
		
		public function set constructorArgs( value:Array ):void
		{
			_constructorArgs = value;
		}
		
		private var _id:String;
		
		/**
		 * Optional identifier for the object entry
		 * this can be used when you want multiple
		 * instances of the object.
		 */
		public function get id():String
		{
			return _id;
		}
		
		/**
		 * @private
		 */
		public function set id( value:String ):void
		{
			_id = value;
		}
		
		private var _methodInvokers:Array;
		
		[ArrayElementType( "com.bojinx.system.context.config.MethodInvoker" )]
		public function get methodInvokers():Array
		{
			return _methodInvokers;
		}
		
		public function set methodInvokers( value:Array ):void
		{
			_methodInvokers = value;
		}
		
		private var _priority:int = 0;
		
		/**
		 * The priority of the entry, higher priority
		 * means it gets processed first.
		 */
		public function get priority():int
		{
			return _priority;
		}
		
		/**
		 * @private
		 */
		public function set priority( value:int ):void
		{
			_priority = value;
		}
		
		private var _properties:Array;
		
		[ArrayElementType( "com.bojinx.system.context.config.Property" )]
		public function get properties():Array
		{
			return _properties;
		}
		
		public function set properties( value:Array ):void
		{
			_properties = value;
		}
		
		private var _source:Class;
		
		/**
		 * The source class type of the object you
		 * want the framework to manage, an instance
		 * will be created when the object is requested
		 * or if the object is a singleton it will be created
		 * during the bootstrap phase.
		 */
		public function get source():Class
		{
			return _source;
		}
		
		/**
		 * @private
		 */
		public function set source( value:Class ):void
		{
			_source = value;
		}
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var context:IApplicationContext;
		
		private var info:ClassInfo;
		
		public function ResolvableBean( source:Class = null, id:String = null )
		{
			_source = source;
			
			if ( id )
				this._id = id;
			else
				this._id = GUID.create();
		}
		
		
		/*============================================================================*/
		/*= STATIC PRIVATE PROPERTIES                                                 */
		/*============================================================================*/
		
		private static const log:Logger = LoggingContext.getLogger( ResolvableBean );
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function addConstructorArg(value:com.bojinx.system.context.config.ConstructorArg):void
		{
			if(!constructorArgs)
				constructorArgs = [];
			
			constructorArgs.push(value);
		}
		
		public function addProperty(value:com.bojinx.system.context.config.Property):void
		{
			if(!properties)
				properties = [];
			
			properties.push(value);
		}
		
		public function addMethod(value:com.bojinx.system.context.config.MethodInvoker):MethodInvoker
		{
			if(!methodInvokers)
				methodInvokers = [];
			
			properties.push(value);
			
			return value;
		}
		
		public function getInstance():ObjectDefinition
		{
			log.debug( "- Resolving Bean [ID]: " + id + " [Source]: " + source );
			
			if ( !info )
				info = getType();
			
			var definition:ObjectDefinition = context.cache.definitions.getDefinitionById( id );
			
			if(!definition || !isSingleton())
				definition = new ObjectDefinition();
			
			if(!definition.isResolved)
			{
				var constructorArgs:Array = resolveConstructorArgs();
				
				definition.target = ClassUtils.newInstance( source, constructorArgs );
				definition.bean = this;
				definition.type = info;
				definition.context = context;
				
				if ( definition && isSingleton())
					context.cache.definitions.registerDefinition( definition );
				
				resolveProperties( definition );
				resolveMethods( definition );
				
				definition.isResolved = true;
			}
			
			return definition;
		}
		
		public function register( context:IApplicationContext ):void
		{
			this.context = context;
			context.cache.beans.register( this );
		}
		
		public function implementsInterface(name:String):Boolean
		{
			if(!info)
				getType();
			
			return info.implementsInterface(name);
		}
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		protected function isSingleton():Boolean
		{
			return false;
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function resolveConstructorArgs():Array
		{
			var params:Array = info.constructor ? info.constructor.parameters : null;
			var result:Array;
			
			for each ( var i:ConstructorArg in constructorArgs )
			{
				if ( !result )
					result = [];
				
				var ref:IResolvableBean = validateAndReturnReference( i.ref );
				
				if ( ref )
				{
					for each ( var j:ConstructorArg in source.constructorArgs )
					{
						if ( j.ref == id )
							throw new Error( "Circular Constructor references detected between Beans [ID 1]: " + ref.id + " and [ID 2]: " + id );
					}
				}
				
				if(CONFIG::log)
				{
					log.debug("-- Resolving Constructor Dependency For Bean [ID]: " + id + " [Dependency ID]: " + i.ref);
				}
				
				if ( i.ref )
					result.push( resolveReference( i.ref ));
				else if ( i.value )
					result.push( i.value );
			}
			
			return result;
		}
		
		private function resolveMethods( definition:ObjectDefinition ):void
		{
			for each(var i:MethodInvoker in methodInvokers)
			{
				var m:Method = info.getMethod(i.name);
				var params:Array = [];
				
				if ( !m )
					throw new Error( "Method " + i.name + " does not exist on Object " + info.name + " [Bean]: " + id );
				
				for each(var mp:MethodParameter in i.parameters)
				{
					if(mp.ref)
						params.push(resolveReference(mp.ref));
					else if(mp.value)
						params.push(mp.value);
					else
						throw new Error( "Could not resolve Method Parameter belonging to [Bean]: " + id + " due to missing reference and/or value" );
				}
				
				if(params.length == 0)
					params = null;
				
				m.invoke(definition.target, params);
			}
			
			var factoryMethod:Array = info.getMethodsWithMeta(FactoryMetadata);
			
			// We only use the first method! multiple factories in one class
			// are not supported
			if(factoryMethod.length == 1)
				this.factoryMethod = Method(factoryMethod[0]).name;
			else if(factoryMethod.length > 1)
				throw new Error("Only one factory method can be assigned to Class " + source);
				
		}
		
		private function resolveProperties( definition:ObjectDefinition ):void
		{
			for each ( var i:com.bojinx.system.context.config.Property in properties )
			{
				var p:com.bojinx.reflection.Property = info.getProperty( i.name ) as com.bojinx.reflection.
					Property;
				
				if ( !p )
					throw new Error( "Property " + i.name + " does not exist on Object " + info.name + " [Bean]: " + id );
				else if ( !p.isReadable )
					throw new Error( "Property " + i.name + " is read only on Object " + info.name + " [Bean]: " + id );
				
				var valueType:* = typeof( i.value );
				
				if ( i.ref )
					p.setValue( definition.target, resolveReference( i.ref ));
				else if ( (!i.ref && (valueType != "boolean" && i.value)) || (!i.ref && valueType == "boolean") )
					p.setValue( definition.target, i.value );
				else
					throw new Error( "Could not set value of property belonging to [Bean]: " + id + " due to missing reference and/or value" );
			}
		}
		
		private function resolveReference( refId:String ):Object
		{
			var ref:IResolvableBean = validateAndReturnReference( refId );
			var definition:ObjectDefinition = context.cache.definitions.getDefinitionById( refId );
			
			if ( !definition )
				definition = ref.getInstance();
			
			return definition ? definition.target : null;
		}
		
		private function validateAndReturnReference( refId:String ):IResolvableBean
		{
			var ref:IBean = context.cache.beans.getBeanById( refId );
			
			if ( refId && !ref )
				throw new Error( "Bean [ID]: " + id + " references a non existing Bean with [ID]: " + refId );
			else if ( ref && !( ref is IResolvableBean ))
				throw new Error( "Bean [ID]: + " + id + " references a Bean that is not resolvable with [ID]: " + refId );
			
			return ref as IResolvableBean;
		}
		
		public function getType():ClassInfo
		{
			if(!info)
				info = ClassInfoFactory.forClass( source, context.applicationDomain );
			
			return info;
		}
	}
}
