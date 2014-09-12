package com.bojinx.reflection.registry
{
	import flash.utils.Dictionary;
	
	[ExcludeClass]
	public class GlobalInfoLookup
	{
		public function GlobalInfoLookup()
		{
		}
		
		
		/*============================================================================*/
		/*= STATIC PRIVATE PROPERTIES                                                 */
		/*============================================================================*/
		
		private static var allInterfaces:Dictionary = new Dictionary();
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function addInterface( name:String ):void
		{
			allInterfaces[ name ] = true;
		}
		
		public function containsInterface( name:String ):Boolean
		{
			return allInterfaces[ name ];
		}
	}
}