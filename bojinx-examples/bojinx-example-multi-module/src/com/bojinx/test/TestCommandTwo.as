package com.bojinx.test
{
	import com.bojinx.message.TestMessageOne;
	import com.bojinx.message.TestMessageTwo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.setTimeout;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	public class TestCommandTwo extends EventDispatcher
	{
		public function TestCommandTwo()
		{
		}
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		
		[Command]
		public function execute( m:TestMessageOne ):void
		{
			setTimeout( result, 2000, m, null );
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
		
		public function testMethod():void
		{
		
		}
	}
}
