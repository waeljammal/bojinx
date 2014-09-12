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
	
	import mx.core.UIComponentGlobals;
	import mx.core.mx_internal;
	
	use namespace mx_internal;
	
	public class PlayExitEffectTask extends SortableTask
	{
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var controller:NavigationController;
		
		private var data:String;
		
		private var effectFactory:ViewEffectFactory;
		
		public function PlayExitEffectTask( data:String, controller:NavigationController )
		{
			super();
			
			this.data = data;
			this.controller = controller;
		}
		
		override protected function doCancel():void
		{
			if ( effectFactory )
				effectFactory.removeEventListener( "effectQueueComplete", onEffectQueueComplete );
			
			effectFactory = null;
			currentlyPlayingRoot = null;
		}
		
		/*============================================================================*/
		/*= STATIC PRIVATE PROPERTIES                                                 */
		/*============================================================================*/
		
		private static var currentlyPlayingRoot:String;
		
		private static const log:Logger = LoggingContext.getLogger( PlayExitEffectTask );
		
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		override protected function doStart():void
		{
			var first:String = NavUtil.getFirst( data );
			effectFactory = controller.registry.getEffectFactory( first );
			
			var inProgress:Boolean = StateModel.getEffectState(data);
			
			log.info("Effect " + data + " [In Progress]: " + inProgress);
			
			if ( effectFactory && first != currentlyPlayingRoot && !inProgress && !StateModel.exitInProgress && StateModel.pendingEffects > 0)
			{
				log.info( "Playing exit effect " + data );
				UIComponentGlobals.layoutManager.validateNow();
				StateModel.pendingEffects = 0;
				currentlyPlayingRoot = NavUtil.getFirst( data );
				StateModel.setEffectState(data, true);
				StateModel.exitInProgress = true;
				effectFactory.addEventListener( "effectQueueComplete", onEffectQueueComplete );
				effectFactory.effectPlay();
			}
			else
			{
				log.info("No Exit Effects to play");
				complete();
			}
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function onEffectQueueComplete( event:Event ):void
		{
			if(currentState != TaskState.CANCELED)
			{
				log.info( "Exit effect completed" );
				
				if ( effectFactory )
					effectFactory.removeEventListener( "effectQueueComplete", onEffectQueueComplete );
				
				StateModel.pendingEffects = 0;
				StateModel.setEffectState(data, false);
				effectFactory = null;
				currentlyPlayingRoot = null;
				complete();
			}
		}
	}
}
