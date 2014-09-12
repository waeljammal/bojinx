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
	public class MethodBindingTest
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		[Context]
		public var context:IApplicationContext;
		
		[Inject]
		public var one:InjectObjectOne;
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var methodValue:String;
		
		public function MethodBindingTest()
		{
			BojinxFlexUnit4Runner;
			InjectionConfig;
		}
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		[Inject( id = "one", property = "data", mode = "oneWay" )]
		public final function injectMethod( value:String ):void
		{
			methodValue = value;
		}
		
		[After]
		public function tearDown():void
		{
			
		}
		
		[Test]
		public function testTwoWayBinding():void
		{
			assertNotNull( methodValue );
			assertTrue( methodValue == "start" );
			
			one.data = "finish";
			
			assertNotNull( methodValue );
			assertTrue( methodValue == "finish" );
		}
	}
}
