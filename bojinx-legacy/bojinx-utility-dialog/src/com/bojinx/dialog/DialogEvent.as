package com.bojinx.dialog
{
	import flash.events.Event;
	
	public class DialogEvent extends Event
	{
		
		public function DialogEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable );
		}
		
		
		/*============================================================================*/
		/*= STATIC PUBLIC PROPERTIES                                                  */
		/*============================================================================*/
		
		public static var DEPTH_CHANGED:String = "depthChanged";
		
		public static var EFFECT_COMPLETE:String = "effectComplete";
		
		public static var EFFECT_STARTED:String = "effectStarted";
		
		public static var HIDE_COMPLETE:String = "hideComplete";
		
		public static var SHOW_COMPLETE:String = "showComplete";
		
		public static var UPDATE:String = "update";
		
		public static var VISIBLE_CHANGED:String = "visibleChanged";
		
		public static var WINDOW_ADDED:String = "windowAdded";
		
		public static var WINDOW_REMOVED:String = "windowRemoved";
	}
}