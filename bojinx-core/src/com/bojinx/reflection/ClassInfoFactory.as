package com.bojinx.reflection
{
	import com.bojinx.utils.data.HashMap;
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	import avmplus.getQualifiedClassName;
	
	public class ClassInfoFactory
	{
		
		public function ClassInfoFactory()
		{
		}
		
		/*============================================================================*/
		/*= STATIC PRIVATE PROPERTIES                                                 */
		/*============================================================================*/
		
		private static var cache:HashMap = new HashMap( false );
		
		/*============================================================================*/
		/*= STATIC PUBLIC METHODS                                                     */
		/*============================================================================*/
		
		public static function forClass( clazz:Class, domain:ApplicationDomain = null,
										 filter:Boolean = true ):ClassInfo
		{
			var classInfo:ClassInfo = cache.getValue( clazz );
			
			if ( !classInfo )
			{
				classInfo = new ClassInfo( clazz, domain, filter );
				cache.put( clazz, classInfo );
			}
			
			return classInfo;
		}
		
		public static function forInstance( instance:Object, domain:ApplicationDomain = null,
											filter:Boolean = true ):ClassInfo
		{
			var name:String = getQualifiedClassName( instance ).replace( "::", "." );
			
			return forName( name, domain, filter );
		}
		
		
		public static function forName( value:String, domain:ApplicationDomain = null,
										filter:Boolean = true ):ClassInfo
		{
			if ( !value )
				return null;
			
			var clazz:Class = domain ?
				domain.getDefinition( value ) as Class :
				getDefinitionByName( value ) as Class;
			
			if ( clazz )
				return forClass( clazz, domain, filter );
			
			return null;
		}
		
		public static function removeForClass( clazz:Class ):void
		{
			cache.remove( clazz );
		}
	}
}
