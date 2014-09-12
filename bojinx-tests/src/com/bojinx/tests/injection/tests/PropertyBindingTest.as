package com.bojinx.tests.injection.tests
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.test.flexunit4.BojinxFlexUnit4Runner;
	import com.bojinx.tests.injection.support.InjectObjectOne;
	import com.bojinx.tests.injection.support.InjectionConfig;
	
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;
	
	[Config( "com.bojinx.tests.injection.support.InjectionConfig" )]
	[RunWith( "com.bojinx.test.flexunit4.BojinxFlexUnit4Runner" )]
	public class PropertyBindingTest
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		[Context]
		public var context:IApplicationContext;
		
		[Inject]
		public var one:InjectObjectOne;
		
		[Bindable]
		[Inject( id = "one", property = "data", mode = "twoWay" )]
		public var oneValue:String;
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		public function PropertyBindingTest()
		{
			BojinxFlexUnit4Runner;
			InjectionConfig;
		}
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		[After]
		public function tearDown():void
		{
			
		}
		
		[Test]
		public function testTwoWayBinding():void
		{
			assertNotNull( oneValue );
			assertTrue( oneValue == "start" );
			assertTrue( one.data == "start" );
			
			one.data = "finish";
			
			assertNotNull( oneValue );
			assertTrue( oneValue == "finish" );
			
			oneValue = "start";
			
			assertNotNull( one.data );
			assertTrue( one.data == "start" );
			
			one.data = "finish";
			assertTrue( one.data == "finish" );
			assertTrue( oneValue == "finish" );
		}
	}
}
