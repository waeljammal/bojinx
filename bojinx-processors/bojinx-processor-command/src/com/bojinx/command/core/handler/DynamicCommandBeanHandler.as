package com.bojinx.command.core.handler
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.api.message.IInterceptedMessage;
	import com.bojinx.command.config.factory.CommandFactory;
	import com.bojinx.command.config.task.CommandTask;
	import com.bojinx.reflection.Method;
	import com.bojinx.utils.tasks.Task;
	import com.bojinx.utils.tasks.event.TaskErrorEvent;
	import com.bojinx.utils.tasks.event.TaskEvent;
	
	import flash.utils.Dictionary;
	
	public class DynamicCommandBeanHandler
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		public var contex:IApplicationContext;
		
		public var executor:Method;
		
		public var factory:CommandFactory;
		
		public var fault:Method;
		
		public var id:String;
		
		public var messageType:Class;
		
		public var name:String;
		
		public var result:Method;
		
		public var scope:String;
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var context:IApplicationContext;
		
		private var pending:Dictionary = new Dictionary();
		
		public function DynamicCommandBeanHandler()
		{
		}
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function registerListener( context:IApplicationContext ):void
		{
			this.context = context;
			context.messageBus.addInterceptor( handleRequest, messageType, name, scope, 0 );
		}
		
		public function unregisterListener( context:IApplicationContext ):void
		{
			context.messageBus.removeInterceptor( handleRequest, messageType );
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function addListeners( task:Task ):void
		{
			task.addEventListener( TaskEvent.TASK_COMPLETE, onTaskComplete );
			task.addEventListener( TaskErrorEvent.ERROR, onError );
		}
		
		private function handleRequest( m:*, im:IInterceptedMessage ):void
		{
			var task:CommandTask = new CommandTask( factory, m );
			task.resultMethod = result ? result.name : null;
			task.faultMethod = fault ? fault.name : null;
			task.executeMethod = executor.name;
			
			addListeners( task );
			
			pending[ task ] = im;
			
			task.start();
		}
		
		private function onError( event:TaskErrorEvent ):void
		{
			removeListeners( event.task as Task );
			
			var interceptor:IInterceptedMessage = pending[ event.currentTarget ];
			
			delete( pending[ event.currentTarget ]);
			
			if ( interceptor )
				interceptor.cancel();
		}
		
		private function onTaskComplete( event:TaskEvent ):void
		{
			removeListeners( event.task as Task );
			
			var interceptor:IInterceptedMessage = pending[ event.currentTarget ];
			
			delete( pending[ event.currentTarget ]);
			
			if ( interceptor )
				interceptor.resume();
		}
		
		private function removeListeners( task:Task ):void
		{
			task.removeEventListener( TaskEvent.TASK_COMPLETE, onTaskComplete );
			task.removeEventListener( TaskErrorEvent.ERROR, onError );
		}
	}
}
