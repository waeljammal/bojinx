package com.bojinx.tests.injection.support
{
	import flash.events.EventDispatcher;
	
	public class FactoryTestClass extends EventDispatcher
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _data:String;
		
		public function get data():String
		{
			return _data;
		}
		
		[Bindable]
		public function set data( value:String ):void
		{
			_data = value;
		}
		
		public function FactoryTestClass()
		{
		}
	}
}