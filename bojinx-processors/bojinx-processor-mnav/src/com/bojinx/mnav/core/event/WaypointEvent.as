package com.bojinx.mnav.core.event
{
	import flash.events.Event;
	
	public class WaypointEvent extends Event
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _name:String;
		
		public function get name():String
		{
			return _name;
		}
		
		public function WaypointEvent( name:String )
		{
			super( EVENT_NAME, false, false );
			this._name = name;
		}
		
		
		/*============================================================================*/
		/*= STATIC PUBLIC PROPERTIES                                                  */
		/*============================================================================*/
		
		public static const EVENT_NAME:String = "waypointFound";
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		override public function clone():Event
		{
			var event:WaypointEvent = new WaypointEvent( name );
			return event;
		}
	}
}
