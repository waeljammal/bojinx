package com.bojinx.mnav.core.tasks
{
	import com.bojinx.mnav.core.manager.NavigationController;
	import com.bojinx.mnav.core.message.InternalDestinationMessage;
	import com.bojinx.mnav.core.message.NavigationChangeMessage;
	import com.bojinx.mnav.core.tasks.shared.SortableTask;
	import com.bojinx.utils.logging.Logger;
	import com.bojinx.utils.logging.LoggingContext;
	
	public class DispatchExitTask extends SortableTask
	{
		private static const log:Logger = LoggingContext.getLogger(DispatchExitTask);
		
		private var data:InternalDestinationMessage;
		private var controller:NavigationController;
		
		public function DispatchExitTask(data:InternalDestinationMessage, controller:NavigationController)
		{
			super();
			
			this.data = data;
			this.controller = controller;
		}
		
		override protected function doStart():void
		{
			var type:String = data.oldDestination + ":" + data.action;
			log.info( "Dispatching Exit State [Destination]: " + data.oldDestination + " [Action]: " + data.action );
			
			var eMsg:NavigationChangeMessage = new NavigationChangeMessage( data.oldDestination, data.newDestination );
			controller.context.messageBus.dispatch( eMsg, type );
			
			complete();
		}
	}
}