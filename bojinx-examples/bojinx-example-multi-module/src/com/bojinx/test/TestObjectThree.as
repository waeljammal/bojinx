package com.bojinx.test
{
	[Bindable]
	public class TestObjectThree
	{
		[Inject]
		public var data:TestObjectOne;
		
		public function TestObjectThree()
		{
		}
		
		[Ready]
		public final function onRady():void
		{
			trace("TestObjectThree Ready");
		}
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function testMethod( value:TestCommandOne ):void
		{
		
		}
	}
}
