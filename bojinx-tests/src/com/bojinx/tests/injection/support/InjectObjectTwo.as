package com.bojinx.tests.injection.support
{
	public class InjectObjectTwo
	{
		private var _data:String = "start"
		
		public function get data():String
		{
			return _data;
		}
		
		
		[Bindable]
		public function set data(value:String):void
		{
			_data = value;
		}
		
		public function InjectObjectTwo()
		{
		}
	}
}