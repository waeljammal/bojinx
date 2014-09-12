package com.bojinx.tests.messaging.tests
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.api.message.IInterceptedMessage;
	import com.bojinx.system.message.MessageBus;
	import com.bojinx.test.flexunit4.BojinxFlexUnit4Runner;
	import com.bojinx.test.util.AsyncUtil;
	import com.bojinx.tests.messaging.support.Message;
	import com.bojinx.tests.messaging.support.MessagingConfig;
	
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;
	
	[Config( "com.bojinx.tests.messaging.support.MessagingConfig" )]
	[RunWith( "com.bojinx.test.flexunit4.BojinxFlexUnit4Runner" )]
	public class MultipleInterceptorsAndListenerTest
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		[Context]
		public var context:IApplicationContext;
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var bus:MessageBus;
		
		private var messagesIntercepted:int = 0;
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		private var message:Message;
		
		[Before]
		public function setUp():void
		{
			MessagingConfig;
			BojinxFlexUnit4Runner;
			bus = context.messageBus;
		}
		
		[After]
		public function tearDown():void
		{
			// I added manual listeners so they have to be removed manually.
			bus.clearAll();
			
			context = null;
			bus = null;
		}
		
		[Test( async )]
		public function testListenerAndClassListener():void
		{
			message =  new Message();
			
			var asyncInterceptorHandler:Function = AsyncUtil.asyncHandler( this, handleInterceptor, null, 100 );
			var asyncSecondInterceptorHandler:Function = AsyncUtil.asyncHandler( this, handleSecondInterceptor, null, 100 );
			var asyncListenerHandler:Function = AsyncUtil.asyncHandler( this, handleListener, null, 100 );
			bus.addInterceptor(asyncInterceptorHandler, Message );
			bus.addInterceptor(asyncSecondInterceptorHandler, Message );
			bus.addListener( asyncListenerHandler, Message );
			bus.dispatch(message);
		}
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		protected function handleInterceptor( message:Message, interceptor:IInterceptedMessage ):void
		{
			assertNotNull( message );
			assertNotNull( interceptor.message );
			assertTrue( message == this.message );
			assertTrue( messagesIntercepted == 0 );
			
			messagesIntercepted++;
			
			interceptor.resume();
		}
		
		protected function handleListener( message:Message ):void
		{
			assertNotNull( message );
			assertTrue( message == this.message );
			assertTrue( messagesIntercepted == 2 );
		}
		
		protected function handleSecondInterceptor( message:Message, interceptor:IInterceptedMessage ):void
		{
			assertNotNull( message );
			assertNotNull( interceptor.message );
			assertTrue( message == this.message );
			assertTrue( messagesIntercepted == 1 );
			
			messagesIntercepted++;
			
			interceptor.resume();
		}
	}
}
