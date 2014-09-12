package com.bojinx.utils.tasks
{
	import com.bojinx.utils.logging.Logger;
	import com.bojinx.utils.logging.LoggingContext;
	import com.bojinx.utils.tasks.api.ITask;
	import com.bojinx.utils.tasks.api.ITaskGroup;
	import com.bojinx.utils.tasks.event.TaskErrorEvent;
	import com.bojinx.utils.tasks.event.TaskEvent;
	import com.bojinx.utils.tasks.event.TaskProgressEvent;
	
	[Event( name = "canceled", type = "com.bojinx.utils.tasks.event.TaskEvent" )]
	[Event( name = "complete", type = "com.bojinx.utils.tasks.event.TaskEvent" )]
	[Event( name = "error", type = "com.bojinx.utils.tasks.event.TaskErrorEvent" )]
	[Event( name = "progress", type = "com.bojinx.utils.tasks.event.TaskEvent" )]
	[Event( name = "started", type = "com.bojinx.utils.tasks.event.TaskEvent" )]
	public class TaskGroup extends Task implements ITaskGroup
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _current:int = 0;
		
		/**
		 * The current index
		 */
		public function get current():int
		{
			return _current;
		}
		
		protected var _description:String;
		
		public function get description():String
		{
			return _description;
		}
		
		public function set description( value:String ):void
		{
			_description = value;
		}
		
		protected var _sequential:Boolean;
		
		public function get sequential():Boolean
		{
			return _sequential;
		}
		
		public function get size():uint
		{
			return countChildTasks( this );
		}
		
		private var _tasks:Array = [];
		
		[ArrayElementType( "com.bojinx.utils.tasks.api.ITask" )]
		public function get tasks():Array
		{
			return _tasks;
		}
		
		public function set tasks( value:Array ):void
		{
			_tasks = value;
		}
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var currentTasks:uint = 0;
		
		/**
		 * Constructor sets the sequential or concurrent state.
		 *
		 * @param sequential If false the group will run in concurrent mode
		 * @param description Optional description of the task group
		 */
		public function TaskGroup( sequential:Boolean = true, description:String = "" )
		{
			super();
			
			_description = description;
			_sequential = sequential;
		}
		
		public function getTaskAt(index:int):Task
		{
			return _tasks.length > index ? tasks[index] : null;
		}
		
		/*============================================================================*/
		/*= STATIC PRIVATE PROPERTIES                                                 */
		/*============================================================================*/
		
		/**
		 * @private
		 */
		private static const log:Logger = LoggingContext.getLogger( TaskGroup );
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		/**
		 * Adds a task to the group
		 */
		public function addTask( task:ITask ):void
		{
			if ( task == null )
				return;
			else if ( task == this )
				throw new Error( "Can not add a task to itself" );
			
			task.setParent( this );
			tasks.push( task );
		}
		
		public function addTaskAt( task:ITask, index:int ):void
		{
			task.setParent( this );
			tasks.splice( index, 0, task );
		}
		
		public function sortBy(property:String):void
		{
			tasks = tasks.sortOn(property, Array.NUMERIC);
		}
		
		public function sortByMultiple(properties:Array):void
		{
			tasks = tasks.sortOn(properties, Array.NUMERIC);
		}
		
		/**
		 * Removes all tasks from the group and it's children
		 */
		public function removeAllTasks():void
		{
			for each ( var child:ITask in tasks )
			{
				removeTaskListeners( child );
				
				if ( child is ITaskGroup )
				{
					ITaskGroup( child ).removeAllTasks();
				}
			}
			
			tasks.splice( 0, tasks.length );
			resetTask();
			_current = 0;
			currentTasks = 0;
		}
		
		/**
		 * Removes a task from the group
		 */
		public function removeTask( task:ITask ):void
		{
			if ( task == null )
				return;
			
			var index:int = tasks.indexOf( task );
			
			if ( index >= 0 )
				tasks.splice( index, 1 );
		}
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		override protected function complete():void
		{
			doAllComplete();
			super.complete();
		}
		
		protected function doAllComplete():void
		{
			// Override in group
		}
		
		override protected function doCancel():void
		{
			for each ( var child:ITask in tasks )
			{
				if ( child.currentState == TaskState.RUNNING )
					child.cancel();
			}
			
			dispatchEvent( TaskEvent.createCanceledEvent( this ));
		}
		
		override protected final function doStart():void
		{
			log.debug( "Starting " + ( sequential ? "Sequential" : "Concurrent" ) + " Task Group [Description]: " + description );
			
			if ( sequential )
				processSequential();
			else
				processConcurrent();
		}
		
		protected function preProcessTask( task:ITask ):void
		{
			// Override in group
		}
		
		/*============================================================================*/
		/*= INTERNAL METHODS                                                          */
		/*============================================================================*/
		
		override internal function dispatchTaskCompleteEvent():void
		{
			dispatchEvent( TaskEvent.createCompleteEvent( this ));
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function countChildTasks( taskgroup:ITaskGroup ):uint
		{
			var size:uint = taskgroup.tasks.length;
			
			for each ( var child:ITask in taskgroup.tasks )
			{
				if ( child is ITaskGroup )
					size += countChildTasks( ITaskGroup( child ));
			}
			
			return size;
		}
		
		private function dispatchNextProgressEvent():void
		{
			dispatchEvent( TaskProgressEvent.createProgressEvent( this as ITask, ++_current, size ));
		}
		
		private function getNextChild():ITask
		{
			return tasks[ currentTasks ] as ITask;
		}
		
		private function onCanceled( event:TaskEvent ):void
		{
			dispatchEvent( TaskEvent.createCanceledEvent( event.task ));
			cancel();
		}
		
		private function onComplete( event:TaskEvent ):void
		{
			dispatchNextProgressEvent();
			dispatchEvent( TaskEvent.createTaskCompleteEvent( event.task ));
			removeTaskListeners( event.currentTarget as ITask );
			
			currentTasks++;
			
			if ( sequential )
				processSequential();
			else if ( current == size )
				complete();
		}
		
		private function onStarted( event:TaskEvent ):void
		{
			dispatchEvent( TaskEvent.createStartedEvent( event.task ));
		}
		
		private function onTaskComplete( event:TaskEvent ):void
		{
			dispatchNextProgressEvent();
			
			var isTaskGroup:Boolean = ( event.currentTarget is ITaskGroup );
			var parentIsThis:Boolean = true;
			
			if ( !isTaskGroup )
			{
				parentIsThis = event.currentTarget.parent == this;
				removeTaskListeners( event.currentTarget as ITask );
			}
			
			dispatchEvent( event.clone());
			
			if ( sequential && !isTaskGroup && parentIsThis )
			{
				currentTasks++;
				processSequential();
			}
			else if ( current == size && !isTaskGroup && parentIsThis )
				complete();
		}
		
		private function onTaskError( event:TaskErrorEvent ):void
		{
			log.error( "Task [Label]: " + event.task.label + " Errored [Message]: " + event.message );
			removeTaskListeners( event.currentTarget as ITask );
			error( event.message );
		}
		
		private function processConcurrent():void
		{
			for each ( var t:ITask in tasks )
				processTask( t );
		}
		
		private function processSequential():void
		{
			if ( currentTasks < tasks.length )
				processTask( getNextChild());
			else
				complete();
		}
		
		private function processTask( t:ITask ):void
		{
			preProcessTask( t );
			t.addEventListener( TaskEvent.TASK_STARTED, dispatchEvent );
			t.addEventListener( TaskEvent.TASK_COMPLETE, onTaskComplete );
			t.addEventListener( TaskEvent.TASK_CANCELED, dispatchEvent );
			t.addEventListener( TaskEvent.CANCELED, onCanceled );
			t.addEventListener( TaskEvent.COMPLETE, onComplete );
			t.addEventListener( TaskEvent.STARTED, onStarted );
			t.addEventListener( TaskErrorEvent.ERROR, onTaskError );
			t.start();
		}
		
		private function removeTaskListeners( task:ITask ):void
		{
			task.removeEventListener( TaskEvent.CANCELED, onCanceled );
			task.removeEventListener( TaskEvent.COMPLETE, onComplete );
			task.removeEventListener( TaskEvent.STARTED, onStarted );
			task.removeEventListener( TaskEvent.TASK_STARTED, dispatchEvent );
			task.removeEventListener( TaskEvent.TASK_COMPLETE, onTaskComplete );
			task.removeEventListener( TaskEvent.TASK_CANCELED, dispatchEvent );
			task.removeEventListener( TaskErrorEvent.ERROR, onTaskError );
		}
	}
}
