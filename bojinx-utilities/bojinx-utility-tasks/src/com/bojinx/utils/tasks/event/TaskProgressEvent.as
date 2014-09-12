package com.bojinx.utils.tasks.event
{
	import com.bojinx.utils.tasks.api.ITask;
	import flash.events.Event;
	
	public class TaskProgressEvent extends Event
	{
		
		public function TaskProgressEvent( task:ITask, current:int, total:uint, bubbles:Boolean = false,
										   cancelable:Boolean = false )
		{
			super( PROGRESS, bubbles, cancelable );
		}
		
		
		/*============================================================================*/
		/*= STATIC PUBLIC PROPERTIES                                                  */
		/*============================================================================*/
		
		public static const PROGRESS:String = "progress";
		
		
		/*============================================================================*/
		/*= STATIC PUBLIC METHODS                                                     */
		/*============================================================================*/
		
		public static function createProgressEvent( task:ITask, current:int, total:uint ):TaskProgressEvent
		{
			return new TaskProgressEvent( task, current, total );
		}
	}
}