package com.bojinx.tests.commands.support
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.setTimeout;
	
	import mx.core.mx_internal;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	
	use namespace mx_internal;
	
	public class AsyncTokenResultCommand extends EventDispatcher
	{
		public function AsyncTokenResultCommand()
		{
		}
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		[Command( name = "result" )]
		public final function execute( m:CommandMessage ):AsyncToken
		{
			var token:AsyncToken = createToken(new ResultLinkTestObject("result"));
			return token;
		}
		
		[CommandResult( name = "result" )]
		public final function result( m:CommandMessage, event:ResultEvent ):void
		{
			m.value = event.result as ResultLinkTestObject;
		}
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		protected function createToken( result:Object ):AsyncToken
		{
			var token:AsyncToken = new AsyncToken( null );
			setTimeout( applyResult, 500, token, result );
			return token;
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function applyResult( token:AsyncToken, result:Object ):void
		{
			mx_internal: token.setResult( result );
			var event:ResultEvent = new ResultEvent( ResultEvent.RESULT, false, true, result, token );
			mx_internal: token.applyResult( event );
		}
	}
}
