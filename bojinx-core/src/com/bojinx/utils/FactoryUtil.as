package com.bojinx.utils
{
	import com.bojinx.reflection.Method;
	import com.bojinx.system.cache.definition.ObjectDefinition;
	
	public final class FactoryUtil
	{
		public function FactoryUtil()
		{
		}
		
		
		/*============================================================================*/
		/*= STATIC PUBLIC METHODS                                                     */
		/*============================================================================*/
		
		public static function valueFromFactory( dependency:ObjectDefinition ):*
		{
			var method:Method = dependency.type.getMethod( dependency.bean.factoryMethod );
			
			if ( method )
				return method.invoke( dependency.target );
			else
				throw new Error( "Factory method " + dependency.bean.factoryMethod +
								 " does not exist in " + dependency.type.name );
			
			return null;
		}
	}
}
