package com.bojinx.tests.commands.tests
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.system.message.MessageBus;
	import com.bojinx.test.flexunit4.BojinxFlexUnit4Runner;
	import com.bojinx.test.util.AsyncUtil;
	import com.bojinx.tests.commands.support.CommandMapResultLinkConfig;
	import com.bojinx.tests.commands.support.CommandMessage;
	import com.bojinx.tests.commands.support.ResultLinkTestObject;
	
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;

	[Config( "com.bojinx.tests.commands.support.CommandMapResultLinkConfig" )]
	[RunWith( "com.bojinx.test.flexunit4.BojinxFlexUnit4Runner" )]
	public class CommandMapResultLinkTest
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
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		private var message:CommandMessage;
		
		[Before]
		public function setUp():void
		{
			BojinxFlexUnit4Runner;
			CommandMapResultLinkConfig;
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
			
			message = new CommandMessage();
			
			var asyncListenerHandlerOne:Function = AsyncUtil.asyncHandler( this, handleListenerOne, null, 3000 );
			bus.addListener( asyncListenerHandlerOne, CommandMessage, CommandMessage.RESULT );
			
			bus.dispatch( message, CommandMessage.RESULT );
		}
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		protected function handleListenerOne( message:CommandMessage ):void
		{
			assertNotNull( message );
			assertTrue( message.value.result == "result_linked" );
		}
	}
}