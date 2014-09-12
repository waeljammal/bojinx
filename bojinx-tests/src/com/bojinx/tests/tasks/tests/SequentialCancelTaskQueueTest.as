package com.bojinx.tests.tasks.tests
{
	import com.bojinx.tests.tasks.support.TimerTask;
	import com.bojinx.utils.tasks.event.TaskEvent;
	import com.bojinx.utils.tasks.TaskGroup;
	import com.bojinx.utils.tasks.TaskState;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.async.Async;
	
	public class SequentialCancelTaskQueueTest
	{
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var taskGroup:TaskGroup;
		
		public function SequentialCancelTaskQueueTest()
		{
		}
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		[Before]
		public function setUp():void
		{
		
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[Test( async )]
		public function test():void
		{
			taskGroup = new TaskGroup();
			taskGroup.addTask( new TimerTask());
			taskGroup.addTask( new TimerTask());
			taskGroup.addTask( new TimerTask());
			taskGroup.addTask( new TimerTask());
			
			Async.handleEvent( this, taskGroup, TaskEvent.CANCELED, onTasksComplete, 1000 );
			
			taskGroup.addEventListener(TaskEvent.TASK_COMPLETE, onTaskComplete);
			taskGroup.start();
		}

		private function onTaskComplete(event:TaskEvent):void
		{
			taskGroup.cancel();
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function onTasksComplete( ... rest ):void
		{
			assertEquals( taskGroup.current, 1);
			assertEquals( taskGroup.size, 4 );
			assertEquals( taskGroup.currentState, TaskState.CANCELED );
		}
	}
}
