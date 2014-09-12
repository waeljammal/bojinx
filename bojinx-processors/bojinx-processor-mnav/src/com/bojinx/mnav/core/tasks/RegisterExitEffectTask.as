package com.bojinx.mnav.core.tasks
{
	import com.bojinx.mnav.core.cache.data.ViewEffectFactory;
	import com.bojinx.mnav.core.manager.NavigationController;
	import com.bojinx.mnav.core.message.EffectInfo;
	import com.bojinx.mnav.core.message.InternalDestinationMessage;
	import com.bojinx.mnav.core.tasks.shared.SortableTask;
	import com.bojinx.mnav.core.waypoint.WaypointHandler;
	import com.bojinx.mnav.util.NavUtil;
	import com.bojinx.utils.logging.Logger;
	import com.bojinx.utils.logging.LoggingContext;
	
	public class RegisterExitEffectTask extends SortableTask
	{
		private static const log:Logger = LoggingContext.getLogger(DispatchExitTask);
		
		private var data:InternalDestinationMessage;
		private var controller:NavigationController;
		
		public function RegisterExitEffectTask(data:InternalDestinationMessage, controller:NavigationController)
		{
			super();
			
			this.data = data;
			this.controller = controller;
		}
		
		override protected function doStart():void
		{
			var type:String = data.oldDestination + ":" + data.action;
			log.info( "Queue Exit Effect [Destination]: " + data.oldDestination + " [Action]: " + data.action );
			
			var oldWaypoint:String = NavUtil.getParent( data.oldDestination );
			var handler:WaypointHandler = controller.registry.getWaypoint(oldWaypoint);
			
			if(handler)
			{
				var factory:ViewEffectFactory = controller.registry.getEffectFactory( handler.waypoint.name );
				
				if(factory)
				{
					var info:EffectInfo = new EffectInfo();
					info.destination = data.oldDestination;
					info.fromState = NavUtil.getLast(data.oldDestination);
					info.toState = NavUtil.getLast(data.newDestination);
					info.action = data.action;
					
					factory.registerEffect(data.oldDestination + "_exit", controller.registry, handler, info);
				} 
			}
			
			complete();
		}
	}
}