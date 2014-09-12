package com.bojinx.system.processor.event
{
	import com.bojinx.api.processor.metadata.IMetaDefinition;
	
	import flash.events.Event;
	
	public class ProcessorEvent extends Event
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _message:String;
		
		public function get message():String
		{
			return _message;
		}
		
		private var _meta:IMetaDefinition;
		
		public function get meta():IMetaDefinition
		{
			return _meta;
		}
		
		public function ProcessorEvent( type:String, meta:IMetaDefinition, message:String )
		{
			_message = message;
			_meta = meta;
			
			super( type, bubbles, true );
		}
		
		override public function clone():Event
		{
			var e:ProcessorEvent = new ProcessorEvent(type, meta, message);
			return e;
		}
		
		/*============================================================================*/
		/*= STATIC PUBLIC PROPERTIES                                                  */
		/*============================================================================*/
		
		public static var COMPLETE:String = "complete";
		
		public static var ERROR:String = "error";
	}
}
