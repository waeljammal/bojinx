package com.bojinx.tests.injection.tests
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.test.flexunit4.BojinxFlexUnit4Runner;
	import com.bojinx.tests.injection.support.FactoryTestClass;
	import com.bojinx.tests.injection.support.InjectionFactoryConfig;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;
	
	[Config( "com.bojinx.tests.injection.support.InjectionFactoryConfig" )]
	[RunWith( "com.bojinx.test.flexunit4.BojinxFlexUnit4Runner" )]
	public class FactoryAnnotationTest
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		[Inject( id = "testFactoryA", priority = 0 )]
		public var data1:FactoryTestClass;
		
		/*============================================================================*/
		/*= STATIC PUBLIC METHODS                                                     */
		/*============================================================================*/
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		[Before]
		public function setUp():void
		{
			BojinxFlexUnit4Runner;
			InjectionFactoryConfig;
		}
		
		[After]
		public function tearDown():void
		{
			
		}
		
		[Test]
		public function testFactoryObject():void
		{
			assertNotNull( data1 );
			assertNotNull( data1.data );
			assertEquals( "start", data1.data );
		}
	}
}
