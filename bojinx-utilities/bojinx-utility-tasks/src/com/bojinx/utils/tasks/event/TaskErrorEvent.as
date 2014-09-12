package com.bojinx.utils.tasks.event
{
	import com.bojinx.utils.tasks.api.ITask;
	import flash.events.Event;
	
	public class TaskErrorEvent extends Event
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _message:String;
		
		public function get message():String
		{
			return _message;
		}
		
		private var _task:ITask;
		
		public function get task():ITask
		{
			return _task;
		}
		
		public function TaskErrorEvent( message:String, task:ITask, bubbles:Boolean = false,
										cancelable:Boolean = false )
		{
			_message = message;
			_task = task;
			super( ERROR, bubbles, cancelable );
		}
		
		
		/*============================================================================*/
		/*= STATIC PUBLIC PROPERTIES                                                  */
		/*============================================================================*/
		
		public static const ERROR:String = "error";
		
		
		/*============================================================================*/
		/*= STATIC PUBLIC METHODS                                                     */
		/*============================================================================*/
		
		public static function createTaskErrorEvent( message:String, task:ITask ):TaskErrorEvent
		{
			return new TaskErrorEvent( message, task );
		}
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		override public function clone():Event
		{
			var e:TaskErrorEvent = new TaskErrorEvent( message, task );
			return e;
		}
	}
}
