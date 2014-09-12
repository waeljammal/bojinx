package com.bojinx.tests.injection.tests
{
	import com.bojinx.test.flexunit4.BojinxFlexUnit4Runner;
	import com.bojinx.tests.injection.support.InjectionCircularConfig;
	import com.bojinx.tests.injection.support.TargetOne;
	import com.bojinx.tests.injection.support.TargetTwo;
	
	import org.flexunit.asserts.assertNotNull;

	[Config( "com.bojinx.tests.injection.support.InjectionCircularConfig" )]
	[RunWith( "com.bojinx.test.flexunit4.BojinxFlexUnit4Runner" )]
	public class CircularInjection
	{
		[Inject]
		public var one:TargetOne;
		
		[Inject]
		public var two:TargetTwo;
		
		public function CircularInjection()
		{
		}
		
		[Before]
		public function setUp():void
		{
			BojinxFlexUnit4Runner;
			InjectionCircularConfig;
		}
		
		[After]
		public function tearDown():void
		{
			
		}
		
		[Test]
		public function testFactoryObject():void
		{
			assertNotNull( one );
			assertNotNull( two );
		}
	}
}