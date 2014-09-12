package com.bojinx.tests.tasks.tests
{
	import com.bojinx.tests.tasks.support.TimerTask;
	import com.bojinx.utils.tasks.event.TaskErrorEvent;
	import com.bojinx.utils.tasks.event.TaskEvent;
	import com.bojinx.utils.tasks.TaskGroup;
	import com.bojinx.utils.tasks.TaskState;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.async.Async;
	
	public class SequentialFaultTaskQueueTest
	{
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var taskGroup:TaskGroup;
		
		public function SequentialFaultTaskQueueTest()
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
			taskGroup.addTask( new TimerTask(false));
			taskGroup.addTask( new TimerTask());
			taskGroup.addTask( new TimerTask());
			
			Async.handleEvent( this, taskGroup, TaskErrorEvent.ERROR, onTasksComplete, 1000 );
			
			taskGroup.start();
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function onTasksComplete( ... rest ):void
		{
			assertEquals( taskGroup.current, 1 );
			assertEquals( taskGroup.currentState, TaskState.ERRORED );
			taskGroup.removeAllTasks();
			assertEquals( taskGroup.size, 0);
			assertEquals( taskGroup.currentState, TaskState.INACTIVE );
		}
	}
}
