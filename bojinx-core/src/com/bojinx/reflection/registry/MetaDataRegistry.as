package com.bojinx.reflection.registry
{
	import com.bojinx.reflection.ClassInfo;
	import com.bojinx.reflection.MetaDataAware;
	import com.bojinx.reflection.MetaDataDescriptor;
	import com.bojinx.reflection.Method;
	
	import flash.utils.Dictionary;
	
	public class MetaDataRegistry
	{
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var ALLOWED_METADATA:Dictionary = new Dictionary();
		
		private var metaData:Dictionary = new Dictionary();
		
		public function MetaDataRegistry( p_key:SingletonBlocker )
		{
			if ( p_key == null )
				throw new Error( "Error: Instantiation failed: Use MetaDataRegistry.getInstance() instead of new." );
		}
		
		
		/*============================================================================*/
		/*= STATIC PRIVATE PROPERTIES                                                 */
		/*============================================================================*/
		
		private static var instance:MetaDataRegistry;
		
		
		/*============================================================================*/
		/*= STATIC PUBLIC METHODS                                                     */
		/*============================================================================*/
		
		public static function getInstance():MetaDataRegistry
		{
			if ( instance == null )
				instance = new MetaDataRegistry( new SingletonBlocker());
			
			return instance;
		}
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public final function isAllowed( data:Array ):Boolean
		{
			for each ( var i:Object in data )
			{
				if ( ALLOWED_METADATA[ i.name ])
					return true;
			}
			
			return false;
		}
		
		public final function isMetaAllowed( meta:Object ):Boolean
		{
			if ( !meta )
				return false;
			else if ( ALLOWED_METADATA[ meta.name ])
				return true;
			
			return false;
		}
		
		public function parse( i:Object, type:int, member:MetaDataAware ):*
		{
			var entry:Object = metaData[ i.name ];
			
			var conf:MetaDataDescriptor = entry.config;
			var clazz:Class = entry.clazz;
			
			// Check meta supports member
			if ( !( type & conf.supportedMembers ))
				throw new Error( conf.tagName + " can not be used on " + member.name );
			
			// Create an isntance
			var instance:Object = new clazz();
			
			// Set Values
			for each ( var metaEntry:Object in i.value )
			{
				var key:String = metaEntry.key;
				
				if ( key == "" || !key && conf.defaultProperty )
					key = conf.defaultProperty;
				else if ( !conf.defaultProperty && key == "" )
					throw new Error( "Could not set property value " + metaEntry.value + " because " +
									 "no key was specified, try setting the default " +
									 "property on your MetaDataDescriptor or use the property name like [Meta(test='value')]" );
				
				try {
					instance[ key ] = metaEntry.value;
				} catch(e:Error) {
					// Ignore these
				}
			}
			
			// Validate required properties
			for ( var requiredEntry:String in conf.requiredProperties )
			{
				if ( !instance[ requiredEntry ])
				{
					var declaredBy:ClassInfo = member is Method ? Method( member ).declaredBy : null;
					var target:String = declaredBy ? " in Object " + declaredBy.name : "";
					throw new Error( requiredEntry + " is required by " + conf.tagName + " Annotation used on " + member.name + target );
				}
			}
			
			return instance;
		}
		
		public final function registerMetaData( clazz:Class ):void
		{
			var config:MetaDataDescriptor;
			config = clazz[ "config" ];
			
			if ( !config )
				throw new Error( "Metadata " + clazz + " is missing the static get config():MetaDataDescriptor getter" );
			
			if ( !metaData[ config.tagName ])
			{
				metaData[ config.tagName ] = { config: config, clazz: clazz };
				ALLOWED_METADATA[ config.tagName ] = true;
			}
		}
	}
}

internal class SingletonBlocker
{
}
