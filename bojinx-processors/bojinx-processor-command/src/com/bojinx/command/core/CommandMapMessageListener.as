package com.bojinx.command.core
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.api.message.IInterceptedMessage;
	import com.bojinx.command.cache.CommandRegistry;
	import com.bojinx.command.config.factory.CommandMapFactory;
	import com.bojinx.system.message.MessageBus;
	import com.bojinx.utils.logging.Logger;
	import com.bojinx.utils.logging.LoggingContext;
	import com.bojinx.utils.tasks.event.TaskEvent;
	
	import flash.utils.Dictionary;
	
	public class CommandMapMessageListener
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		public var cache:CommandRegistry;
		
		public var context:IApplicationContext;
		
		public var map:CommandMapFactory;
		
		public var scope:String;
		
		public var topic:String;
		
		public var trigger:Class;
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var interceptorMap:Dictionary = new Dictionary();
		
		public function CommandMapMessageListener()
		{
		}
		
		/*============================================================================*/
		/*= STATIC PROTECTED PROPERTIES                                               */
		/*============================================================================*/
		
		CONFIG::log
		protected static var log:Logger = LoggingContext.getLogger( CommandMapMessageListener );
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function start():void
		{
			cache.registerListener( this );
			
			if ( CONFIG::log )
			{
				log.debug( "Command Listener started listening [Trigger]: " + trigger + " [Topic]: " + topic + " [Scope]: " + scope );
			}
			
			var bus:MessageBus = context.messageBus;
			bus.addInterceptor( onMessage, trigger, topic, scope );
		}
		
		public function stop():void
		{
			var bus:MessageBus = context.messageBus;
			bus.removeInterceptor( onMessage, trigger );
		}
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		protected function onAllComplete( event:TaskEvent ):void
		{
//			var map:CommandMap = event.currentTarget as CommandMap;
//			map.removeEventListener(TaskEvent.COMPLETE, onAllComplete);
//			
//			var interceptor:IInterceptedMessage = interceptorMap[map];
//			
//			delete(interceptorMap[map]);
//			
//			if ( CONFIG::log )
//			{
//				log.debug( "Command Queue Complete [Trigger]: " + trigger + " [Topic]: " + topic + " [Scope]: " + scope );
//			}
//			
//			if(interceptor)
//				interceptor.resume();
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function onMessage( m:*, i:IInterceptedMessage ):void
		{
//			if ( CONFIG::log )
//			{
//				log.debug( "Command Queue Running [Trigger]: " + trigger + " [Topic]: " + topic + " [Scope]: " + scope );
//			}
//			
//			var map:CommandMap = cache.factory.newInstanceFromMap(map);
//			map.addEventListener(TaskEvent.COMPLETE, onAllComplete);
//			
//			interceptorMap[map] = i;
//			
//			map.startWithMessage(m);
		}
	}
}
