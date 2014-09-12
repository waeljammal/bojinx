package com.bojinx.test
{
	
	public class TestObjectOne
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		[Inject]
		public var testObjectTwo:TestObjectTwo;
		
		[Bindable]
		public var value:String = "TestObjectOne";
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var constructed:TestObjectTwo;
		
		private var testMethodValueOne:TestObjectTwo;
		
		public function TestObjectOne( test:TestObjectTwo )
		{
			constructed = test;
		}
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		[Ready]
		public final function onRady():void
		{
			trace( "TestObjectOne Ready" );
		}
		
		[Inject]
		public function testMethod( value:TestObjectTwo):void
		{
			testMethodValueOne = value;
		}
	}
}
