package com.bojinx.mnav.core.constants
{
	public class Action
	{
		public static var FIRST_ENTER:String = "first";
		public static var ENTER:String = "enter";
		public static var EXIT:String = "exit";
		public static var EVERY_ENTER:String = "every";
		
		public function Action()
		{
		}
		
		public static function getDestination(event:String):String
		{
			return event.split(":")[0] as String;
		}
		
		public static function getAction(event:String):String
		{
			return event.split(":")[1] as String;
		}
		
		public static function getEventName(destination:String, action:String):String
		{
			return destination + ":" + action;
		}
	}
}