package com.bojinx.reflection
{
	import avmplus.DescribeTypeJSON;
	
	import com.bojinx.reflection.registry.GlobalInfoLookup;
	import com.bojinx.reflection.registry.MetaDataRegistry;
	import com.bojinx.utils.type.ClassUtils;
	
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	public class ClassInfo extends MetaDataAware
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _applicationDomain:ApplicationDomain;
		
		public function get applicationDomain():ApplicationDomain
		{
			return _applicationDomain;
		}
		
		private var _bases:Array = [];
		
		public function get bases():Array
		{
			return _bases;
		}
		
		private var _constructor:Constructor;
		
		public function get constructor():Constructor
		{
			return _constructor;
		}
		
		private var _isInterface:Boolean;
		
		public function get isInterface():Boolean
		{
			return _isInterface;
		}
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var clazz:Class;
		
		private var describeType:Function;
		
		private var filter:Boolean = false;
		
		private var instances:Object;
		
		private var interfaces:Dictionary = new Dictionary( false );
		
		private var method:Method, methods:Array, methodsNameMap:Dictionary;
		
		private var property:Property, properties:Array, propertiesNameMap:Dictionary;
		
		private var statics:Object;
		
		public function ClassInfo( clazz:Class, domain:ApplicationDomain = null, filter:Boolean = true )
		{
			this.clazz = clazz;
			this.filter = filter;
			_applicationDomain = domain;
			initDescribeType();
			super( instances.traits, MetaDataDescriptor.CLASS, this, instances.name );
		}
		
		
		/*============================================================================*/
		/*= STATIC PUBLIC PROPERTIES                                                  */
		/*============================================================================*/
		
		private static var _globalLookup:GlobalInfoLookup = new GlobalInfoLookup();
		
		public static function get globalLookup():GlobalInfoLookup
		{
			return _globalLookup;
		}
		
		/*============================================================================*/
		/*= STATIC PRIVATE PROPERTIES                                                 */
		/*============================================================================*/
		
		private static var registry:MetaDataRegistry = MetaDataRegistry.getInstance();
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function getClass():Class
		{
			return clazz;
		}
		
		public function getInterface( name:String ):Class
		{
			return interfaces[ name ] ? ClassUtils.forName( interfaces[ name ], applicationDomain ) : null;
		}
		
		public function getMethod( name:String ):Method
		{
			if ( !methods )
				initMethods();
			
			if ( !methodsNameMap[ name ])
			{
				parseMethod( instances.traits.methods, false, name );
				parseMethod( statics.traits.methods, true, name );
			}
			
			return methodsNameMap[ name ];
		}
		
		public function getMethods():Array
		{
			if ( !methods )
				initMethods();
			
			return methods;
		}
		
		public function getMethodsWithMeta( type:Class ):Array
		{
			var result:Array = [];
			var methods:Array = getMethods();
			
			for each ( var i:Method in methods )
				if ( i.getMetadata( type ).length > 0 )
					result.push( i );
			
			return result;
		}
		
		public function getProperties():Array
		{
			if ( !properties )
				initProperties();
			
			return properties;
		}
		
		public function getProperty( name:String ):MetaDataAware
		{
			if ( !properties )
				initProperties();
			
			if ( !propertiesNameMap[ name ])
			{
				parseProperty( instances.traits.accessors, false, name );
				parseProperty( instances.traits.variables, false, name );
				parseProperty( statics.traits.variables, true, name );
				parseProperty( statics.traits.accessors, true, name );
			}
			
			return propertiesNameMap[ name ];
		}
		
		public function implementsInterface( name:String ):Boolean
		{
			if ( interfaces[ name ])
				return true;
			
			return false;
		}
		
		/*============================================================================*/
		/*= INTERNAL METHODS                                                          */
		/*============================================================================*/
		
		internal function getDeclaredBy( value:String, domain:ApplicationDomain ):ClassInfo
		{
			return ClassInfoFactory.forName( value, domain );
		}
		
		internal function getMetaData( value:Object, type:int, member:MetaDataAware ):Array
		{
			var result:Array = [];
			var meta:*;
			
			for each ( var i:Object in value )
			{
				if ( registry.isMetaAllowed( i ))
				{
					meta = registry.parse( i, type, member );
					
					if ( meta )
						result.push( meta );
				}
			}
			
			return result;
		}
		
		internal function getMethodParameters( value:Array ):Array
		{
			var result:Array = [];
			
			for each ( var i:Object in value )
			{
				var classInfo:ClassInfo = ClassInfoFactory.forName( convertType( i.type ), applicationDomain );
				result.push( new Parameter( i, classInfo ));
			}
			
			return result;
		}
		
		internal function getReturnType( value:String ):ClassInfo
		{
			var classInfo:ClassInfo;
			var converted:* = convertType( value );
			
			if ( converted )
				classInfo = ClassInfoFactory.forName( converted, applicationDomain );
			
			return classInfo;
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function convertType( value:* ):String
		{
			switch ( value )
			{
				case "*":
					return "Object";
					break;
				case "void":
					return null;
					break;
				default:
					return value;
					break;
			}
		}
		
		private function initDescribeType():void
		{
			describeType = DescribeTypeJSON.jsonType;
			instances = describeType( clazz, DescribeTypeJSON.instances );
			statics = describeType( clazz, DescribeTypeJSON.statics );
			
			if ( instances.traits.bases.indexOf( "Object" ) == -1 )
				_isInterface = true;
			
			for each ( var i:String in instances.traits.interfaces )
			{
				globalLookup.addInterface( i );
				interfaces[ i ] = i;
			}
			
			for each ( var j:String in instances.traits.bases )
				_bases.push( j );
			
			_constructor = parseConstructor( instances.traits.constructor );
		}
		
		private function initMethods():void
		{
			methods = [];
			methodsNameMap = new Dictionary( false );
			parseMethods( instances.traits.methods, false );
			parseMethods( statics.traits.methods, true );
		}
		
		private function initProperties():void
		{
			properties = [];
			propertiesNameMap = new Dictionary( false );
			parseProperties( instances.traits.accessors, false );
			parseProperties( instances.traits.variables, false );
			parseProperties( statics.traits.variables, true );
			parseProperties( statics.traits.accessors, true );
		}
		
		private function parseConstructor( info:Object ):Constructor
		{
			return new Constructor( info, null, this );
		}
		
		private function parseMethod( data:Array, isStatic:Boolean, name:String ):void
		{
			if ( !data )
				return;
			
			for each ( var m:Object in data )
			{
				if ( m.name == name )
				{
					method = new Method( m, this, isStatic );
					methods.push( method );
					methodsNameMap[ method.name ] = method;
					break;
				}
			}
		}
		
		private function parseMethods( data:Array, statics:Boolean ):void
		{
			if ( !data )
				return;
			
			for each ( var m:Object in data )
			{
				if ( !filter || registry.isAllowed( m.metadata ))
				{
					method = new Method( m, this, statics );
					methods.push( method );
					methodsNameMap[ method.name ] = method;
				}
			}
			
			method = null;
		}
		
		private function parseProperties( data:Array, statics:Boolean ):void
		{
			if ( !data )
				return;
			
			for each ( var i:Object in data )
			{
				if ( !filter || registry.isAllowed( i.metadata ))
				{
					property = new Property( i, this, statics );
					properties.push( property );
					propertiesNameMap[ property.name ] = property;
				}
			}
			
			property = null;
		}
		
		private function parseProperty( data:Array, statics:Boolean, name:String ):void
		{
			if ( !data )
				return;
			
			for each ( var i:Object in data )
			{
				if ( i.name == name )
				{
					property = new Property( i, this, statics );
					properties.push( property );
					propertiesNameMap[ property.name ] = property;
					break;
				}
			}
			
			property = null;
		}
	}
}
