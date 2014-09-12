package com.bojinx.tests.injection.support
{
	
	public class FactoryUsingBean
	{
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var _data:InjectObjectOne;
		
		public function get data():InjectObjectOne
		{
			return _data;
		}
		
		[Bindable]
		[Inject]
		public function set data( value:InjectObjectOne ):void
		{
			_data = value;
		}
		
		private var cnt:int = 0;
		
		public function FactoryUsingBean()
		{
		}
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function createInstance():FactoryTestClass
		{
			var instance:FactoryTestClass = new FactoryTestClass();
			instance.data = data.data;
			
			cnt++;
			
			return instance;
		}
	}
}