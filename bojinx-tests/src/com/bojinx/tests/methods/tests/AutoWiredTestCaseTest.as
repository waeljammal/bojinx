package com.bojinx.tests.methods.tests
{
	import com.bojinx.test.flexunit4.AutoWiredTestCase;
	
	import flash.events.IEventDispatcher;
	
	public class AutoWiredTestCaseTest extends AutoWiredTestCase
	{
		public function AutoWiredTestCaseTest(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		[Before]
		public function before():void
		{
			
		}
		
		[After]
		public function after():void
		{
			
		}
		
		
		[BeforeClass]
		public static function beforeClass():void
		{
			
		}
		
		[AfterClass]
		public static function afterClass():void
		{
			
		}
		
		[Test]
		public function runTestA():void
		{
			
		}
		
		[Test]
		public function runTestB():void
		{
			
		}
	}
}