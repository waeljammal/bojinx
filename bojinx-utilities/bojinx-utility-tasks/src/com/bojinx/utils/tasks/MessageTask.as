package com.bojinx.utils.tasks
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.system.message.messages.InterceptedMessage;
	
	public class MessageTask extends Task
	{
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var canceled:Boolean = false;
		
		private var clazz:Class;
		
		private var context:IApplicationContext;
		
		private var message:*;
		
		private var name:String;
		
		public function MessageTask( context:IApplicationContext, message:*, name:String = null )
		{
			super();
			this.message = message;
			this.name = name;
			this.context = context;
		}
		
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		override protected function doCancel():void
		{
			canceled = true;
			cleanUp();
		}
		
		override protected function doStart():void
		{
			clazz = Object( message ).constructor as Class;
			context.messageBus.addListener( onMessage, clazz, name );
			context.messageBus.addInterceptor( onMessageIntercepted, clazz, name );
			context.messageBus.dispatch( message, name );
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function cleanUp():void
		{
			context.messageBus.removeListener( onMessage, clazz );
			context.messageBus.removeInterceptor( onMessageIntercepted, clazz );
		}
		
		private function onMessage( message:* ):void
		{
			if ( !canceled )
			{
				cleanUp();
				complete();
			}
		}
		
		private function onMessageIntercepted( message:Object, interceptor:InterceptedMessage ):void
		{
			if ( canceled )
			{
				interceptor.cancel();
				cleanUp();
				cancel();
			}
			else
			{
				interceptor.resume();
			}
		}
	}
}
