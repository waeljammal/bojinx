package com.bojinx.test
{
	import com.bojinx.message.TestMessageOne;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.setTimeout;
	
	import mx.core.mx_internal;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	use namespace mx_internal;
	
	public class TestCommandOne extends EventDispatcher
	{
		public function TestCommandOne()
		{
		}
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		[Command(name="filterCommand")]
		public function execute( m:TestMessageOne ):AsyncToken
		{
			var token:AsyncToken = new AsyncToken(null);
			setTimeout( applyResult, 2000, token, m );
			
			return token; 
		}
		
		[CommandFault]
		public function fault( m:TestMessageOne, event:FaultEvent ):void
		{
		
		}
		
		[CommandResult]
		public function result( m:TestMessageOne, event:ResultEvent ):void
		{
			dispatchEvent( new Event( Event.COMPLETE ));
		}
		
		private function applyResult(token:AsyncToken, result:Object):void
		{
			mx_internal:token.setResult(result);
			var event:ResultEvent = new ResultEvent(ResultEvent.RESULT, false, true, result, token);
			mx_internal:token.applyResult(event);
		}
	}
}
