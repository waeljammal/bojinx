package com.bojinx.system.processor.event
{
	import com.bojinx.api.processor.metadata.IMetaDefinition;
	import com.bojinx.system.cache.definition.MetaDefinition;
	import com.bojinx.system.cache.definition.ObjectDefinition;
	
	import flash.events.Event;
	
	public class ProcessorQueueEvent extends Event
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _owner:ObjectDefinition;
		
		public function get owner():ObjectDefinition
		{
			return _owner;
		}
		
		private var _meta:MetaDefinition;

		public function get meta():MetaDefinition
		{
			return _meta;
		}
		
		public function ProcessorQueueEvent( type:String, owner:ObjectDefinition, meta:MetaDefinition = null, 
											 bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable );
			_meta = meta;
			_owner = owner;
		}
		
		/*============================================================================*/
		/*= STATIC PUBLIC PROPERTIES                                                  */
		/*============================================================================*/
		
		public static const ALL_COMPLETE:String = "allComplete";
		
		public static const COMPLETE:String = "complete";
	}
}
