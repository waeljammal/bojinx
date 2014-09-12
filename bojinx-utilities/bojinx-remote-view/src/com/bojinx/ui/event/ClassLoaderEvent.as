package com.bojinx.ui.event
{
	import flash.events.Event;
	
	public class ClassLoaderEvent extends Event
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _data:*;
		
		public function get data():*
		{
			return _data;
		}
		
		public function ClassLoaderEvent( type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean =
										  false )
		{
			super( type, bubbles, cancelable );
			
			_data = data;
		}
		
		
		/*============================================================================*/
		/*= STATIC PUBLIC PROPERTIES                                                  */
		/*============================================================================*/
		
		public static const COMPLETE:String = "complete";
	}
}