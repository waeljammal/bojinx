package com.bojinx.tests.suites
{
	import com.bojinx.test.flexunit4.BojinxFlexUnit4Runner;
	import com.bojinx.tests.injection.support.InjectionConfig;
	import com.bojinx.tests.injection.support.InjectionFactoryBeanConfig;
	import com.bojinx.tests.injection.support.InjectionFactoryConfig;
	import com.bojinx.tests.injection.support.InjectionPrototypeConfig;
	import com.bojinx.tests.injection.tests.FactoryAnnotationTest;
	import com.bojinx.tests.injection.tests.FactoryBeanTest;
	import com.bojinx.tests.injection.tests.InjectMultipleParametersTest;
	import com.bojinx.tests.injection.tests.MethodBindingTest;
	import com.bojinx.tests.injection.tests.PropertyBindingTest;
	
	[RunWith( "org.flexunit.runners.Suite" )]
	[Suite]
	public class InjectionSuite
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		public var test1:com.bojinx.tests.injection.tests.FactoryAnnotationTest;
		
		public var test2:com.bojinx.tests.injection.tests.FactoryBeanTest;
		
		public var test3:com.bojinx.tests.injection.tests.InjectMultipleParametersTest;
		
		public var test4:com.bojinx.tests.injection.tests.MethodBindingTest;
		
		public var test5:com.bojinx.tests.injection.tests.PropertyBindingTest;
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var dependencies:Array = [ InjectionConfig, InjectionFactoryBeanConfig,
										   InjectionFactoryConfig, InjectionPrototypeConfig,
										   BojinxFlexUnit4Runner ];
	}
}
