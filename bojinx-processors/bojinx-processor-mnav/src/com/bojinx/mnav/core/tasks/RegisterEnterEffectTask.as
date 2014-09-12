package com.bojinx.mnav.core.tasks
{
	import com.bojinx.mnav.core.cache.data.ViewEffectFactory;
	import com.bojinx.mnav.core.manager.NavigationController;
	import com.bojinx.mnav.core.message.EffectInfo;
	import com.bojinx.mnav.core.message.InternalDestinationMessage;
	import com.bojinx.mnav.core.message.NavigationChangeMessage;
	import com.bojinx.mnav.core.tasks.shared.SortableTask;
	import com.bojinx.mnav.core.waypoint.WaypointHandler;
	import com.bojinx.mnav.util.NavUtil;
	import com.bojinx.utils.logging.Logger;
	import com.bojinx.utils.logging.LoggingContext;
	
	public class RegisterEnterEffectTask extends SortableTask
	{
		private static const log:Logger = LoggingContext.getLogger(DispatchEnterTask);
		
		private var data:InternalDestinationMessage;
		private var controller:NavigationController;
		
		public function RegisterEnterEffectTask(data:InternalDestinationMessage, controller:NavigationController)
		{
			super();
			
			this.data = data;
			this.controller = controller;
		}
		
		override protected function doStart():void
		{
			var eMsg:NavigationChangeMessage;
			
			log.info( "Queue Enter Effect [Destination]: " + data.newDestination);
			
			var waypoint:String = NavUtil.getParent( data.newDestination );
			var handler:WaypointHandler = controller.registry.getWaypoint(waypoint);
			
			if(handler)
			{
				var factory:ViewEffectFactory = controller.registry.getEffectFactory( handler.waypoint.name );
				
				if(factory)
				{
					var info:EffectInfo = new EffectInfo();
					info.destination = data.newDestination;
					info.fromState = NavUtil.getLast(data.oldDestination);
					info.toState = NavUtil.getLast(data.newDestination);
					info.action = data.action;
					 
					factory.registerEffect(data.newDestination + "_enter", controller.registry, handler, info); 
				}
			}
			
			complete();
		}
	}
}