package com.bojinx.utils.tasks.event
{
	import flash.events.Event;
	import com.bojinx.utils.tasks.Task;
	
	public class TaskEvent extends Event
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _task:Task;
		
		public function get task():Task
		{
			return _task;
		}
		
		public function TaskEvent( type:String, task:Task, bubbles:Boolean = false,
								   cancelable:Boolean = false )
		{
			_task = task;
			super( type, bubbles, cancelable );
		}
		
		
		/*============================================================================*/
		/*= STATIC PUBLIC PROPERTIES                                                  */
		/*============================================================================*/
		
		public static const CANCELED:String = "canceled";
		
		public static const COMPLETE:String = "complete";
		
		public static const PROGRESS:String = "progress";
		
		public static const STARTED:String = "started";
		
		public static const TASK_CANCELED:String = "taskCanceled";
		
		public static const TASK_COMPLETE:String = "taskComplete";
		
		public static const TASK_STARTED:String = "taskStarted";
		
		
		/*============================================================================*/
		/*= STATIC PUBLIC METHODS                                                     */
		/*============================================================================*/
		
		public static function createCanceledEvent( task:Task ):flash.events.Event
		{
			return new TaskEvent( CANCELED, task, false, false );
		}
		
		public static function createCompleteEvent( task:Task ):flash.events.Event
		{
			return new TaskEvent( COMPLETE, task, false, false );
		}
		
		public static function createStartedEvent( task:Task ):TaskEvent
		{
			return new TaskEvent( STARTED, task, false, false );
		}
		
		public static function createTaskCanceledEvent( task:Task ):flash.events.Event
		{
			return new TaskEvent( TASK_CANCELED, task, false, false );
		}
		
		public static function createTaskCompleteEvent( task:Task ):flash.events.Event
		{
			return new TaskEvent( TASK_COMPLETE, task, false, false );
		}
		
		public static function createTaskStartedEvent( task:Task ):TaskEvent
		{
			return new TaskEvent( TASK_STARTED, task, false, false );
		}
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		override public function clone():Event
		{
			var e:TaskEvent = new TaskEvent( type, task, bubbles, cancelable );
			
			return e;
		}
	}
}
