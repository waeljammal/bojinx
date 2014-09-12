package com.bojinx.tests.commands.support
{
	import flash.utils.setTimeout;
	
	import mx.core.mx_internal;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	
	use namespace mx_internal;

	public class ResultLinkCommand
	{
		public function ResultLinkCommand()
		{
		}
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		[Command( name = "result" )]
		public final function execute( m:CommandMessage, resultLink:ResultLinkTestObject ):AsyncToken
		{
			var token:AsyncToken = createToken( "_linked" );
			return token;
		}
		
		[CommandResult( name = "result" )]
		public final function result( m:CommandMessage, event:ResultEvent ):void
		{
			m.value.result += event.result as String;
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