package com.bojinx.tests.messaging.tests
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.api.message.IInterceptedMessage;
	import com.bojinx.system.message.MessageBus;
	import com.bojinx.test.flexunit4.BojinxFlexUnit4Runner;
	import com.bojinx.tests.messaging.support.Message;
	import com.bojinx.tests.messaging.support.MessagingConfig;
	import com.bojinx.utils.tasks.MessageTaskGroup;
	import com.bojinx.utils.tasks.event.TaskEvent;
	
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;
	
	[Config( "com.bojinx.tests.messaging.support.MessagingConfig" )]
	[RunWith( "com.bojinx.test.flexunit4.BojinxFlexUnit4Runner" )]
	public class QueuedListenersAndInterceptorsTest
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
		
		private var counter:int = 0;
		
		private var messageIntercepted:Boolean = false;
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		[MessageInterceptor( type = "com.bojinx.tests.messaging.support.Message", name = "test1" )]
		public final function handleInterceptor1( message:Message, interceptor:IInterceptedMessage ):void
		{
			assertTrue( counter == 0 );
			
			counter++;
			
			interceptor.resume();
		}
		
		[MessageInterceptor( type = "com.bojinx.tests.messaging.support.Message", name = "test2" )]
		public final function handleInterceptor2( message:Message, interceptor:IInterceptedMessage ):void
		{
			assertTrue( counter == 2 );
			
			counter++;
			
			interceptor.resume();
		}
		
		[MessageInterceptor( type = "com.bojinx.tests.messaging.support.Message", name = "test3" )]
		public final function handleInterceptor3( message:Message, interceptor:IInterceptedMessage ):void
		{
			assertTrue( counter == 4 );
			
			counter++;
			
			interceptor.resume();
		}
		
		[MessageInterceptor( type = "com.bojinx.tests.messaging.support.Message", name = "test4" )]
		public final function handleInterceptor4( message:Message, interceptor:IInterceptedMessage ):void
		{
			assertTrue( counter == 6 );
			
			counter++;
			
			interceptor.resume();
		}
		
		[MessageInterceptor( type = "com.bojinx.tests.messaging.support.Message", name = "test5" )]
		public final function handleInterceptor5( message:Message, interceptor:IInterceptedMessage ):void
		{
			// Should fail!
			assertNull( message );
		}
		
		[Message( name = "test1" )]
		public final function handleListener1( message:Message ):void
		{
			assertTrue( counter == 1 );
			
			counter++;
		}
		
		[Message( name = "test2" )]
		public final function handleListener2( message:Message ):void
		{
			assertTrue( counter == 3 );
			
			counter++;
		}
		
		[Message( name = "test3" )]
		public final function handleListener3( message:Message ):void
		{
			assertTrue( counter == 5 );
			
			counter++;
		}
		
		[Message( name = "test4" )]
		public final function handleListener4( message:Message ):void
		{
			assertTrue( counter == 7 );
			
			counter = 0;
		}
		
		[Before]
		public function setUp():void
		{
			BojinxFlexUnit4Runner;
			MessagingConfig;
			bus = context.messageBus;
		}
		
		[After]
		public function tearDown():void
		{
			context = null;
			bus = null;
		}
		
		[Test( async, order = 1 )]
		public function testUsingTasks():void
		{
			var queue:MessageTaskGroup = new MessageTaskGroup( context );
			queue.addMessage( new Message(), "test1" );
			queue.addMessage( new Message(), "test2" );
			queue.addMessage( new Message(), "test3" );
			queue.addMessage( new Message(), "test4" );
			
			Async.proceedOnEvent( this, queue, TaskEvent.COMPLETE, 500, onTimeOut );
			
			queue.start();
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function onComplete():void
		{
		
		}
		
		private function onTimeOut():void
		{
			assertTrue( counter == 3 );
		}
	}
}
