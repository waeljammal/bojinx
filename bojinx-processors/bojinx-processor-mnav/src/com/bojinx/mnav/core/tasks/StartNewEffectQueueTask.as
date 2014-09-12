package com.bojinx.mnav.core.tasks
{
	import com.bojinx.mnav.core.cache.data.ViewEffectFactory;
	import com.bojinx.mnav.core.manager.NavigationController;
	import com.bojinx.mnav.core.tasks.shared.SortableTask;
	import com.bojinx.mnav.core.waypoint.WaypointHandler;
	import com.bojinx.mnav.util.NavUtil;
	import com.bojinx.utils.logging.Logger;
	import com.bojinx.utils.logging.LoggingContext;
	
	public class StartNewEffectQueueTask extends SortableTask
	{
		private static const log:Logger = LoggingContext.getLogger(StartNewEffectQueueTask);
		
		private var data:String;
		private var controller:NavigationController;
		
		public function StartNewEffectQueueTask(data:String, controller:NavigationController)
		{
			super();
			
			this.data = data;
			this.controller = controller;
		}
		
		override protected function doStart():void
		{
			var waypoint:WaypointHandler = controller.registry.getWaypoint(NavUtil.getFirst(data));
			var factory:ViewEffectFactory = controller.registry.getEffectFactory( waypoint.waypoint.name );
			
			if ( factory && factory.effectQueue != null )
			{
				log.info("Starting Effect Queue " + NavUtil.getFirst(data));
				factory.newEffectQueue();
			}
			
			complete();
		}
	}
}