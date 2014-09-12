package com.bojinx.tests.tasks.tests
{
	import com.bojinx.tests.tasks.support.TimerTask;
	import com.bojinx.utils.tasks.event.TaskEvent;
	import com.bojinx.utils.tasks.TaskGroup;
	import com.bojinx.utils.tasks.TaskState;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.async.Async;
	import com.bojinx.utils.tasks.api.ITaskGroup;
	
	public class NestedCancelTaskQueueTest
	{
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var taskGroup:TaskGroup;
		private var subGroup:TaskGroup;
		private var subSubGroup:TaskGroup;
		
		public function NestedCancelTaskQueueTest()
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
			
			subGroup = new TaskGroup(false, "subGroupConcurrent");
			subGroup.addTask(new TimerTask());
			subGroup.addTask(new TimerTask());
			subGroup.addTask(new TimerTask());
			subGroup.addTask(new TimerTask());
			
			subSubGroup = new TaskGroup(false, "subSubGroupConcurrent");
			subSubGroup.addTask(new TimerTask());
			subSubGroup.addTask(new TimerTask());
			subSubGroup.addTask(new TimerTask());
			subSubGroup.addTask(new TimerTask());
			
			subGroup.addTask(subSubGroup);
			taskGroup.addTask(subGroup);
			
			Async.handleEvent( this, taskGroup, TaskEvent.CANCELED, onTasksCanceled, 1000 );
			
			taskGroup.start();
			taskGroup.cancel();
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function onTasksCanceled( ... rest ):void
		{
			assertEquals( 0, taskGroup.current );
			assertEquals( TaskState.CANCELED, taskGroup.currentState );
			assertEquals( 0, subGroup.current );
			assertEquals( TaskState.INACTIVE, subGroup.currentState );
			assertEquals( 0, subSubGroup.current );
			assertEquals( TaskState.INACTIVE, subSubGroup.currentState );
		}
	}
}
