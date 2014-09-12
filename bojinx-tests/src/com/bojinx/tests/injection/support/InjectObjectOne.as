package com.bojinx.tests.injection.support
{
	import flash.events.EventDispatcher;
	
	public class InjectObjectOne extends EventDispatcher
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
		
		public function InjectObjectOne()
		{
		}
	}
}