package com.bojinx.tests.tasks.tests
{
	import com.bojinx.tests.tasks.support.TimerTask;
	import com.bojinx.utils.tasks.event.TaskEvent;
	import com.bojinx.utils.tasks.TaskGroup;
	import com.bojinx.utils.tasks.TaskState;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.async.Async;
	
	public class SequentialTaskQueueTest
	{
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var taskGroup:TaskGroup;
		
		public function SequentialTaskQueueTest()
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
			
			Async.handleEvent( this, taskGroup, TaskEvent.COMPLETE, onTasksComplete, 1000 );
			
			taskGroup.start();
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function onTasksComplete( ... rest ):void
		{
			assertEquals( taskGroup.size, taskGroup.current );
			assertEquals( taskGroup.currentState, TaskState.COMPLETED );
		}
	}
}
