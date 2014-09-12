package com.bojinx.mnav.core.tasks
{
	import com.bojinx.mnav.core.manager.NavigationController;
	import com.bojinx.mnav.core.message.NavigationCompleteMessage;
	import com.bojinx.mnav.core.tasks.shared.SortableTask;
	import com.bojinx.utils.logging.Logger;
	import com.bojinx.utils.logging.LoggingContext;
	
	public class DispatchFinalDestinationTask extends SortableTask
	{		
		private static const log:Logger = LoggingContext.getLogger(DispatchEnterTask);
		
		private var destination:String;
		private var controller:NavigationController;
		private var isExit:Boolean;
		
		public function DispatchFinalDestinationTask(destination:String, controller:NavigationController, isExit:Boolean)
		{
			super();
			
			this.isExit = isExit;
			this.destination = destination;
			this.controller = controller;
		}
		
		override protected function doStart():void
		{
			var eMsg:NavigationCompleteMessage;
			
			eMsg = new NavigationCompleteMessage( destination, isExit );
			controller.context.messageBus.dispatch( eMsg );
			
			complete();
		}
	}
}