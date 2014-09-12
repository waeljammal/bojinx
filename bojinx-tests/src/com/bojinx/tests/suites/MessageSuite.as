package com.bojinx.tests.suites
{
	import com.bojinx.test.flexunit4.BojinxFlexUnit4Runner;
	import com.bojinx.tests.messaging.support.MessagingConfig;
	import com.bojinx.tests.messaging.tests.InterceptorAndListenerTest;
	import com.bojinx.tests.messaging.tests.MultipleInterceptorsAndListenerTest;
	import com.bojinx.tests.messaging.tests.QueuedListenersAndInterceptorsTest;
	import com.bojinx.tests.messaging.tests.RemoveListenerOnUnloadTest;
	
	[RunWith( "org.flexunit.runners.Suite" )]
	[Suite]
	public class MessageSuite
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		public var test1:InterceptorAndListenerTest;
		public var test2:MultipleInterceptorsAndListenerTest;
		public var test3:RemoveListenerOnUnloadTest;
		public var test4:QueuedListenersAndInterceptorsTest;
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var messagingConfig:MessagingConfig;
		
		private var testRunner:BojinxFlexUnit4Runner;
	}
}