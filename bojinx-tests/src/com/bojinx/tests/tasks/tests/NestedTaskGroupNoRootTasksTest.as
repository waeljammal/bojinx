package com.bojinx.tests.tasks.tests
{
	import com.bojinx.tests.tasks.support.TimerTask;
	import com.bojinx.utils.tasks.event.TaskEvent;
	import com.bojinx.utils.tasks.TaskGroup;
	import com.bojinx.utils.tasks.TaskState;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.async.Async;
	import com.bojinx.utils.tasks.api.ITaskGroup;
	
	public class NestedTaskGroupNoRootTasksTest
	{
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var taskGroup:TaskGroup;
		private var subGroup:TaskGroup;
		private var subSubGroup:TaskGroup;
		
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
			taskGroup = new TaskGroup(true, "rootGroup");
			
			subGroup = new TaskGroup(true, "subGroupConcurrent");
//			subGroup.addTask(new TimerTask());
			
			subSubGroup = new TaskGroup(false, "subSubGroupConcurrent");
			subSubGroup.addTask(new TimerTask());
			
			subGroup.addTask(subSubGroup);
			taskGroup.addTask(subGroup);
			
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
			assertEquals( subGroup.size, subGroup.current );
			assertEquals( subGroup.currentState, TaskState.COMPLETED );
			assertEquals( subSubGroup.size, subSubGroup.current );
			assertEquals( subSubGroup.currentState, TaskState.COMPLETED );
		}
	}
}
