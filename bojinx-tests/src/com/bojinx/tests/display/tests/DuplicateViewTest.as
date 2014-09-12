package com.bojinx.tests.display.tests
{
	import com.bojinx.test.flexunit4.BojinxFlexUnit4Runner;
	import com.bojinx.tests.display.support.DisplayComponent;
	import com.bojinx.tests.display.support.DisplayInjectionConfig;
	
	import org.flexunit.asserts.assertTrue;
	import org.fluint.uiImpersonation.UIImpersonator;

	[Config( "com.bojinx.tests.display.support.DisplayInjectionConfig" )]
	[RunWith( "com.bojinx.test.flexunit4.BojinxFlexUnit4Runner" )]
	public class DuplicateViewTest
	{		
		private var viewOne:DisplayComponent;
		private var viewTwo:DisplayComponent;
		
		[Before]
		public function setUp():void
		{
			DisplayInjectionConfig; 
			BojinxFlexUnit4Runner;
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		[Test]
		public function testDuplicateSameView():void
		{
			viewOne = new DisplayComponent();
			viewTwo = new DisplayComponent();
			
			UIImpersonator.addChild(viewOne);
			UIImpersonator.addChild(viewTwo);
			
			assertTrue(viewOne.obj != null);
			assertTrue(viewTwo.obj != null);
			assertTrue(viewTwo.obj == viewOne.obj);
			assertTrue(viewOne.isReady);
			assertTrue(viewTwo.isReady);
		}
	}
}