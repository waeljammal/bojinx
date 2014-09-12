package com.bojinx.test.util
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import org.flexunit.async.Async;
	
	public class AsyncUtil extends EventDispatcher
	{
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var _callback:Function;
		
		private var _callbackArgs:Array;
		
		private var _passThroughArgs:Array;
		
		private var _testCase:Object;
		
		public function AsyncUtil( testCase:Object, callback:Function, passThroughArgs:Array = null )
		{
			_testCase = testCase;
			_callback = callback;
			_passThroughArgs = passThroughArgs;
		}
		
		
		/*============================================================================*/
		/*= STATIC PUBLIC PROPERTIES                                                  */
		/*============================================================================*/
		
		public static const ASYNC_EVENT:String = "asyncEvent";
		
		
		/*============================================================================*/
		/*= STATIC PUBLIC METHODS                                                     */
		/*============================================================================*/
		
		public static function asyncHandler( testCase:Object, callback:Function, passThroughArgs:Array =
											 null, timeout:Number = 1500 ):Function
		{
			var asyncUtil:AsyncUtil = new AsyncUtil( testCase, callback, passThroughArgs );
			asyncUtil.addEventListener( ASYNC_EVENT, Async.asyncHandler( testCase, asyncUtil.asyncEventHandler, timeout ));
			return asyncUtil.asyncCallbackHandler;
		}
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function asyncCallbackHandler( ... args:Array ):void
		{
			_callbackArgs = args;
			dispatchEvent( new Event( ASYNC_EVENT ));
		}
		
		public function asyncEventHandler( ev:Event, flexUnitPassThroughArgs:Object = null ):void
		{
			if ( _passThroughArgs )
			{
				_callbackArgs = _callbackArgs.concat( _passThroughArgs );
			}
			_callback.apply( null, _callbackArgs );
		}
	}

}