package com.bojinx.tests.suites
{
	import com.bojinx.tests.tasks.tests.ConcurrentTaskQueueTest;
	import com.bojinx.tests.tasks.tests.NestedCancelTaskQueueTest;
	import com.bojinx.tests.tasks.tests.NestedTaskGroupNoRootTasksTest;
	import com.bojinx.tests.tasks.tests.NestedTaskQueueTest;
	import com.bojinx.tests.tasks.tests.ParallelCancelTaskQueueTest;
	import com.bojinx.tests.tasks.tests.SequentialCancelTaskQueueTest;
	import com.bojinx.tests.tasks.tests.SequentialFaultTaskQueueTest;
	import com.bojinx.tests.tasks.tests.SequentialTaskQueueTest;

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class TasksSuite
	{
		public var test1:SequentialTaskQueueTest;
		public var test2:ConcurrentTaskQueueTest;
		public var test3:NestedTaskQueueTest;
		public var test4:NestedCancelTaskQueueTest;
		public var test5:SequentialCancelTaskQueueTest;
		public var test6:ParallelCancelTaskQueueTest;
		public var test7:SequentialFaultTaskQueueTest;
		public var test8:NestedTaskGroupNoRootTasksTest;
	}
}