package com.bojinx.mnav.core.tasks.shared
{
	import com.bojinx.utils.tasks.Task;
	
	public class SortableTask extends Task
	{
		public var lifecycleOrder:int = 0;
		
		public function SortableTask()
		{
			super();
		}
	}
}