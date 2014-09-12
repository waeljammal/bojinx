package com.bojinx.injection.operation
{
	import com.bojinx.injection.descriptor.BindingItem;
	import com.bojinx.injection.meta.Inject;
	import com.bojinx.reflection.Method;
	import com.bojinx.reflection.Property;
	import com.bojinx.system.cache.definition.MetaDefinition;
	import com.bojinx.system.cache.definition.ObjectDefinition;
	import com.bojinx.system.processor.AbstractProcessor;
	import com.bojinx.utils.FactoryUtil;
	import com.bojinx.utils.logging.Logger;
	import com.bojinx.utils.logging.LoggingContext;
	
	import flash.utils.Dictionary;
	
	public class InjectionOperation extends AbstractProcessor
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		public var autoNullProperties:Boolean;
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var bindings:Dictionary = new Dictionary( false );
		
		public function InjectionOperation()
		{
		}
		
		/*============================================================================*/
		/*= STATIC PROTECTED PROPERTIES                                               */
		/*============================================================================*/
		
		CONFIG::log
		protected static var log:Logger = LoggingContext.getLogger( InjectionOperation );
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		override public function process( value:MetaDefinition ):void
		{
			if ( value.member is Property )
				processProperty( value );
			else if ( value.member is Method )
				processMethod( value );
		}
		
		override public function release( value:MetaDefinition ):void
		{
			if ( autoNullProperties && value.member is Property )
				processReleaseProperty( value );
			
			var key:String = value.member.name + "_" + value.owner.type.name;
			var binding:BindingItem = bindings[ key ];
			
			if ( binding )
			{
				binding.release();
				delete( bindings[ key ]);
			}
			
			complete( value );
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function processMethod( value:MetaDefinition ):void
		{
			var method:Method = value.member as Method;
			var meta:Inject = value.meta as Inject;
			
			var params:Array = [];
			
			for each ( var i:ObjectDefinition in value.dependencies )
			{
				params.push( i.bean.factoryMethod ? FactoryUtil.valueFromFactory(i) : i.target );
			}
			
			if ( params.length == 0 )
				throw new Error( "Missing dependency for Method " + method.name + " in " + value.owner.target );
			
			if ( method.parameters.length != params.length )
				throw new Error( "Incorrect number of parameters for Method " + method.name + " in " + value.owner.target +
								 " expected " + method.parameters.length + " resolved " + value.dependencies.length );
			
			CONFIG::log
			{
				log.debug( "Injecting Method " + method.name + " in " + value.owner.target );
			}
			
			if ( params.length == 0 && !meta.required )
			{
//				CONFIG::log
//				{
//					log.warn( "Injecting Method " + method.name + " in target " + method.declaredBy.name + " failed silently - Missing Parameters" );
//				}
				
				complete( value );
				return;
			}
			else if ( meta.property )
			{
				setupMethodBinding( value );
				return;
			}
			else
			{
				method.invoke( value.owner.target, params );
			}
			
			complete( value );
		}
		
		private function processProperty( value:MetaDefinition ):void
		{
			var property:Property = value.member as Property;
			var meta:Inject = value.meta as Inject;
			var dependency:* = value.dependencies.length > 0 ? value.dependencies[ 0 ] : null;
			var factoryName:String;
			
			if ( !dependency && meta.required )
			{
				var errorMessage:String = "Property " + property.name + " Injection is required but no " +
					"managed dependency was found for " + property.returnType.name + " in " + value.owner.type.name +
					" or id was not speccified on the meta data or context";
				
				error( value, errorMessage );
				return;
			}
			
			factoryName = ObjectDefinition(dependency).bean.factoryMethod;
			
			CONFIG::log
			{
				log.debug( "Injecting Property " + property.name + " in " + value.owner.target );
			}
			
			if ( !dependency && !meta.required )
			{
				CONFIG::log
				{
					log.warn( "Injecting Property " + property.name + " in target " + property.declaredBy.name +
							  " failed silently - Could not resolve value" );
				}
				
				complete( value );
				return;
			}
			else if ( meta.property )
			{
				setupPropertyBinding( value );
				return;
			}
			else
			{
				property.setValue( value.owner.target, factoryName ? 
					FactoryUtil.valueFromFactory(dependency) : ObjectDefinition( dependency ).target );
			}
			
			complete( value );
		}
		
		private function processReleaseProperty( value:MetaDefinition ):void
		{
			var property:Property = value.member as Property;
			
			CONFIG::log
			{
				log.debug( "Nullifying Injected property " + property.name + " in " + value.owner.target );
			}
			
			property.setValue( value.owner.target, null );
		}
		
		private function setupMethodBinding( value:MetaDefinition ):void
		{
			var binding:BindingItem = new BindingItem( value );
			binding.setupMethodBinding();
			
			bindings[ value.member.name + "_" + value.owner.type.name ] = binding;
			
			complete( value );
		}
		
		private function setupPropertyBinding( value:MetaDefinition ):void
		{
			var binding:BindingItem = new BindingItem( value );
			binding.setupPropertyBinding();
			
			bindings[ value.member.name + "_" + value.owner.type.name ] = binding;
			
			complete( value );
		}
	}
}
