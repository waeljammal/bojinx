package com.bojinx.mnav.core.tasks
{
	import com.bojinx.mnav.core.cache.data.ViewEffectFactory;
	import com.bojinx.mnav.core.manager.NavigationController;
	import com.bojinx.mnav.core.tasks.shared.SortableTask;
	import com.bojinx.mnav.core.tasks.shared.StateModel;
	import com.bojinx.mnav.util.NavUtil;
	import com.bojinx.utils.logging.Logger;
	import com.bojinx.utils.logging.LoggingContext;
	import com.bojinx.utils.tasks.TaskState;
	
	import flash.events.Event;
	
	import mx.core.mx_internal;
	
	use namespace mx_internal;
	
	public class PlayEnterEffectTask extends SortableTask
	{
		private static const log:Logger = LoggingContext.getLogger(PlayEnterEffectTask);
		
		private var data:String;
		private var controller:NavigationController;
		
		private static var currentlyPlayingRoot:String;
		private var effectFactory:ViewEffectFactory;
		
		override protected function doCancel():void
		{
			if ( effectFactory )
				effectFactory.removeEventListener( "effectQueueComplete", onEffectQueueComplete );
			
			effectFactory = null;
			currentlyPlayingRoot = null;
		}
		
		public function PlayEnterEffectTask(data:String, controller:NavigationController)
		{
			super();
			
			this.data = data;
			this.controller = controller;
		}
		
		override protected function doStart():void
		{
			var first:String = NavUtil.getFirst(data);
			effectFactory = controller.registry.getEffectFactory(first);
			
			if(effectFactory && first != currentlyPlayingRoot && StateModel.pendingEffects > 0)
			{
//				UIComponentGlobals.layoutManager.validateNow();
				log.info("Playing enter effect " + data);
				currentlyPlayingRoot = NavUtil.getFirst(data);
				effectFactory.addEventListener("effectQueueComplete", onEffectQueueComplete);
				effectFactory.effectPlay();
			}
			else
			{
				log.info("No Enter effects to play");
				StateModel.exitInProgress = false;
				StateModel.resetEffectStates();
				complete();
			}
		}
		
		private function onEffectQueueComplete(event:Event):void
		{
			if(currentState != TaskState.CANCELED)
			{
				log.info( "Enter effect completed" );
				
				if ( effectFactory )
					effectFactory.removeEventListener( "effectQueueComplete", onEffectQueueComplete );
				
				StateModel.pendingEffects = 0;
				
				StateModel.resetEffectStates();
				effectFactory = null;
				currentlyPlayingRoot = null;
				StateModel.exitInProgress = false;
				complete();
			}
		}
	}
}