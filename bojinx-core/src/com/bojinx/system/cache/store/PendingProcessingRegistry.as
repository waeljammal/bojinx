package com.bojinx.system.cache.store
{
	import com.bojinx.system.cache.definition.ObjectDefinition;
	
	public class PendingProcessingRegistry
	{
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var queue:Array = [];
		
		public function PendingProcessingRegistry()
		{
		}
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function dispose():void
		{
			queue = null;
		}
		
		public function getAll( clear:Boolean = true ):Array
		{
			var result:Array = queue.concat();
			
			if ( clear )
				queue.splice( 0, queue.length );
			
			return result;
		}
		
		public function register( definition:ObjectDefinition ):void
		{
			queue.push( definition );
		}
	}
}
