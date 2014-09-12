package com.bojinx.tests.commands.support
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.setTimeout;
	
	import mx.core.mx_internal;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.Fault;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	use namespace mx_internal;
	
	public class AsyncTokenFaultCommand extends EventDispatcher
	{
		public function AsyncTokenFaultCommand()
		{
		}
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		[Command( name = "fault" )]
		public final function executeOne( m:CommandMessage ):AsyncToken
		{
			var token:AsyncToken = createToken( "fault" );
			return token;
		}
		
		[CommandFault( name = "fault" )]
		public final function resultOne( m:CommandMessage, event:FaultEvent ):void
		{
			m.value = new ResultLinkTestObject(event.fault.faultString);
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
			var fault:Fault = new Fault("0", result as String);
			var event:FaultEvent = new FaultEvent( FaultEvent.FAULT, false, true, fault, token );
			mx_internal: token.applyFault( event );
		}
	}
}
