package com.bojinx.tests.injection.tests
{
	import com.bojinx.test.flexunit4.BojinxFlexUnit4Runner;
	import com.bojinx.tests.injection.support.InjectionPrototypeConfig;
	import com.bojinx.tests.shared.BlankObject;
	
	import org.flexunit.asserts.assertTrue;

	[Config( "com.bojinx.tests.injection.support.InjectionPrototypeConfig" )]
	[RunWith( "com.bojinx.test.flexunit4.BojinxFlexUnit4Runner" )]
	public class InjectMultipleParametersTest
	{		
		private var arg2:BlankObject;
		private var arg1:BlankObject;
		private var arg3:BlankObject;
		private var arg4:BlankObject;
		
		[Before]
		public function setUp():void
		{
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
			InjectionPrototypeConfig;
			BojinxFlexUnit4Runner;
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		[Inject]
		public function autoWired(arg1:BlankObject, arg2:BlankObject):void
		{
			this.arg1 = arg1;
			this.arg2 = arg2;
		}
		
		[Inject(ids="b1,b2")]
		public function autoWiredById(arg1:BlankObject, arg2:BlankObject):void
		{
			this.arg3 = arg1;
			this.arg4 = arg2;
		}
		
		[Test]
		public function runTest():void
		{
			assertTrue(arg1 != null);
			assertTrue(arg2 != null);
			assertTrue(arg3 != null);
			assertTrue(arg4 != null);
		}
	}
}