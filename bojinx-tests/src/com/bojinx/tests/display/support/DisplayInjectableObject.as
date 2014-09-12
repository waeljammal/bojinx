package com.bojinx.tests.display.support
{
	import flash.events.EventDispatcher;
	
	public class DisplayInjectableObject extends EventDispatcher
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _data:String = "start"
		
		public function get data():String
		{
			return _data;
		}
		
		[Bindable]
		public function set data( value:String ):void
		{
			_data = value;
		}
		
		public function DisplayInjectableObject()
		{
		}
	}
}