package com.bojinx.test
{
	import com.bojinx.message.TestMessageOne;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.setTimeout;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	public class TestObjectTwo extends EventDispatcher
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
//		private var _test:TestObjectThree;
//		
//		[Inject]
//		public function get test():TestObjectThree
//		{
//			return _test;
//		}
//		
//		public function set test( value:TestObjectThree ):void
//		{
//			_test = value;
//		}
		
		[Inject]
		public var testOne:TestObjectOne;
		
		[Ready]
		public final function onRady():void
		{
			trace("TestObjectTwo Ready");
		}
		
		public function TestObjectTwo()
		{
		
		}
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		
		public function testMethod( value:TestCommandOne ):void
		{
		}
	}
}
