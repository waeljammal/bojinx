package com.bojinx.tests.commands.tests
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.system.message.MessageBus;
	import com.bojinx.test.flexunit4.BojinxFlexUnit4Runner;
	import com.bojinx.test.util.AsyncUtil;
	import com.bojinx.tests.commands.support.AsyncTokenCommandConfig;
	import com.bojinx.tests.commands.support.CommandMessage;
	
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;
	
	[Config( "com.bojinx.tests.commands.support.AsyncTokenCommandConfig" )]
	[RunWith( "com.bojinx.test.flexunit4.BojinxFlexUnit4Runner" )]
	public class SingleAsyncCommandResultTest
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
		
		public function SingleAsyncCommandResultTest()
		{
		}
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		[Before]
		public function setUp():void
		{
			BojinxFlexUnit4Runner;
			AsyncTokenCommandConfig;
			bus = context.messageBus;
		}
		
		[After]
		public function tearDown():void
		{
			
		}
		
		[Test( async, description = "Single command using AsyncToken and message filter" )]
		public function testCombinedCommands():void
		{
			assertTrue( context != null );
			
			var asyncListenerHandlerOne:Function = AsyncUtil.asyncHandler( this, handleListenerOne, null, 1000 );
			bus.addListener( asyncListenerHandlerOne, CommandMessage, CommandMessage.RESULT );
			
			bus.dispatch( new CommandMessage(), CommandMessage.RESULT );
		}
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		protected function handleListenerOne( message:CommandMessage ):void
		{
			assertNotNull( message );
			assertTrue( message.value.result == "result" );
		}
	}
}
