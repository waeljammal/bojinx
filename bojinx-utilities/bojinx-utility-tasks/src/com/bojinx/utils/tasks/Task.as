package com.bojinx.utils.tasks
{
	import com.bojinx.utils.logging.Logger;
	import com.bojinx.utils.logging.LoggingContext;
	import com.bojinx.utils.tasks.api.ITask;
	import com.bojinx.utils.tasks.api.ITaskGroup;
	import com.bojinx.utils.tasks.event.TaskErrorEvent;
	import com.bojinx.utils.tasks.event.TaskEvent;
	import com.bojinx.utils.tasks.event.TaskStateChangeEvent;
	
	import flash.events.EventDispatcher;
	
	[Event(name="taskCanceled", type="com.bojinx.utils.tasks.event.TaskEvent")]
	[Event(name="taskComplete", type="com.bojinx.utils.tasks.event.TaskEvent")]
	[Event(name="taskStarted", type="com.bojinx.utils.tasks.event.TaskEvent")]
	[Event(name="error", type="com.bojinx.utils.tasks.event.TaskErrorEvent")]
	/**
	 * @Manifest
	 */
	public class Task extends EventDispatcher implements ITask
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _currentState:TaskState = TaskState.INACTIVE;
		
		[Bindable( "currentStateChange" )]
		public function get currentState():TaskState
		{
			return _currentState;
		}
		
		public function set currentState( value:TaskState ):void
		{
			_currentState = value;
		}
		
		private var _label:String;
		
		public function get label():String
		{
			return _label;
		}
		
		public function set label( value:String ):void
		{
			_label = value;
		}
		
		private var _parent:ITaskGroup;
		
		public function get parent():ITaskGroup
		{
			return _parent;
		}
		
		public var taskPriority:int = 0;
		
		/*============================================================================*/
		/*= STATIC PRIVATE PROPERTIES                                                 */
		/*============================================================================*/
		
		/**
		 * @private
		 */
		private static const log:Logger = LoggingContext.getLogger( Task );
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function cancel():void
		{
			if ( currentState == TaskState.CANCELED || currentState == TaskState.INACTIVE )
				return;
			
			if(label)
				log.debug( "Canceled task " + label );
			
			setState( TaskState.CANCELED );
			doCancel();
			dispatchEvent( TaskEvent.createTaskCanceledEvent( this ));
		}
		
		public function setParent( parent:ITaskGroup ):void
		{
			_parent = parent;
		}
		
		public function start():void
		{
			if ( currentState == TaskState.CANCELED || currentState == TaskState.RUNNING )
				return;
			
			if(label)
				log.debug( "Started task " + label );
			
			setState( TaskState.RUNNING );
			dispatchEvent( TaskEvent.createTaskStartedEvent( this ));
			doStart();
		}
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		protected function complete():void
		{
			if ( _currentState != TaskState.RUNNING )
				return;
			
			if(label)
				log.debug( "Completed Task " + label );
			
			setState( TaskState.COMPLETED );
			dispatchTaskCompleteEvent();
		}
		
		protected function doCancel():void
		{
		
		}
		
		protected function doStart():void
		{
			throw new Error( "Abstract function call, doStart must be overriden." );
		}
		
		protected function error( message:String ):void
		{
			if ( _currentState != TaskState.RUNNING )
				return;
			
			log.debug( "Error in Task " + label + " [Message]: " + message );
			setState( TaskState.ERRORED );
			dispatchEvent( TaskErrorEvent.createTaskErrorEvent( message, this ));
		}
		
		/*============================================================================*/
		/*= INTERNAL METHODS                                                          */
		/*============================================================================*/
		
		internal function dispatchTaskCompleteEvent():void
		{
			dispatchEvent( TaskEvent.createTaskCompleteEvent( this ));
		}
		
		internal function resetTask():void
		{
			setState( TaskState.INACTIVE );
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function setState( state:TaskState ):void
		{
			var event:TaskStateChangeEvent = new TaskStateChangeEvent(
				TaskStateChangeEvent.CURRENT_STATE_CHANGE, false, false, _currentState, state
				);
			
			_currentState = state;
			dispatchEvent( event );
		}
	}
}
