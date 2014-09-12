package com.bojinx.system.processor.event
{
	import flash.events.Event;
	
	public class ProcessorQueueFaultEvent extends Event
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _message:String;
		
		public function get message():String
		{
			return _message;
		}
		
		public function ProcessorQueueFaultEvent( type:String, message:String, bubbles:Boolean = false,
												  cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable );
			_message = message;
		}
		
		
		/*============================================================================*/
		/*= STATIC PUBLIC PROPERTIES                                                  */
		/*============================================================================*/
		
		public static const FAULT:String = "fault";
	}
}