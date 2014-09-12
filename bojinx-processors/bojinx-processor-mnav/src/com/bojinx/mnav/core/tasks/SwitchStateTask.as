package com.bojinx.mnav.core.tasks
{
	import com.bojinx.mnav.core.constants.Action;
	import com.bojinx.mnav.core.manager.NavigationController;
	import com.bojinx.mnav.core.message.InternalDestinationMessage;
	import com.bojinx.mnav.core.message.NavigationMessage;
	import com.bojinx.mnav.core.tasks.shared.SortableTask;
	import com.bojinx.mnav.core.waypoint.WaypointHandler;
	import com.bojinx.mnav.util.NavUtil;
	import com.bojinx.utils.logging.Logger;
	import com.bojinx.utils.logging.LoggingContext;
	import com.bojinx.utils.tasks.TaskState;
	
	import mx.events.FlexEvent;
	
	public class SwitchStateTask extends SortableTask
	{
		private static const log:Logger = LoggingContext.getLogger(SwitchStateTask);
		
		private var data:InternalDestinationMessage;
		private var controller:NavigationController;
		private var currentPath:String;
		private var resumeFrom:int = 0;
		private var willResume:Boolean;
		
		public function SwitchStateTask(data:InternalDestinationMessage, controller:NavigationController)
		{
			super();
			
			this.data = data;
			this.controller = controller;
		}
		
		override protected function doStart():void
		{
			if(!data.finalDestination != data.newDestination)
			{
				log.info("Switching state and waiting for final destination " + data.finalDestination);
			}
			
			recursiveSwitch(complete);
		}
		
		private function recursiveSwitch(onComplete:Function = null):void
		{
			if(currentState == TaskState.COMPLETED)
				return;
			
			var pathArray:Array = data.finalDestination.split(".");
			var nextState:String;
			
			pathArray = NavUtil.cleanArray(pathArray);
			
			for(var i:int = resumeFrom; i < pathArray.length; i++)
			{
				var p:String = pathArray[i];
				
				if(!currentPath)
					currentPath = p;
				else
					currentPath += "." + p;
				
				var previousHandler:WaypointHandler;
				var handler:WaypointHandler = controller.registry.getWaypoint(currentPath);
				var isStateOfPrevious:Boolean = false;
				
				if(!handler)
				{
					// First check if p is a state of the previous handler before deciding
					// if it's a waypoint that we need to wait for.
					if(previousHandler)
						isStateOfPrevious = previousHandler.waypoint.hasState(p);
					
					if(!isStateOfPrevious && previousHandler)
					{
						log.info("Current Path 1 " + currentPath + " is not a waypoint - setting state to " + p + " on " + previousHandler.waypoint.name);
//						previousHandler.waypoint.handleNavigationChange(new NavigationMessage(p));
						controller.navigateTo(p, controller.currentQueue);
					}
					else if(!previousHandler)
					{
						handler = controller.registry.getWaypoint(NavUtil.getParent(currentPath));
						
						if(handler)
						{
							nextState = NavUtil.getLast(currentPath);
							
							if(nextState)
							{
								log.info("Current Path " + NavUtil.getParent(currentPath) + " is a waypoint - setting state to " + nextState + " on " + handler.waypoint.name);
								
								if(handler.waypoint.view.currentState != nextState)
								{
									resumeFrom = currentPath.split(".").length;
									willResume = true;
									previousHandler = handler;
									
									if(data.action == Action.FIRST_ENTER)
									{
										handler.waypoint.handleNavigationChange(new NavigationMessage(nextState));
										handler.waypoint.view.callLater(resumeOnNextFrame);
									}
									else
									{
										handler.waypoint.handleNavigationChange(new NavigationMessage(nextState));
										handler.waypoint.view.callLater(resumeOnNextFrame);
									}
								}
								else
								{
									resumeFrom = currentPath.split(".").length;
								}
							}
						}
					}
				}
				else
				{
					nextState = pathArray.length > i + 1 ? pathArray[i+1] : null;
					
					if(nextState)
					{
						log.info("Current Path " + currentPath + " is a waypoint - setting state to " + nextState + " on " + handler.waypoint.name);
						
						if(handler.waypoint.view.currentState != nextState)
						{
							currentPath += "." + nextState;
							resumeFrom = currentPath.split(".").length;
							willResume = true;
							previousHandler = handler;
							
							if(data.action == Action.FIRST_ENTER)
							{
								handler.waypoint.handleNavigationChange(new NavigationMessage(nextState));
								handler.waypoint.view.callLater(resumeOnNextFrame);
							}
							else
							{
								handler.waypoint.handleNavigationChange(new NavigationMessage(nextState));
								handler.waypoint.view.callLater(resumeOnNextFrame);
							}
						}
						else
						{
							resumeFrom = currentPath.split(".").length;
							previousHandler = controller.registry.getWaypoint(currentPath);
						}
					}
				}
				
				if(willResume)
					break;
			}
			
			if(!willResume)
			{
				controller.enterAndExitInvoker.applyExits( currentPath, null );
				controller.enterAndExitInvoker.applyEnters( currentPath, null );
				
				parent.sortByMultiple(["taskPriority", "lifecycleOrder"]);
				
				complete();
			}
		}
		
		private function resumeOnNextFrame():void
		{
			if(willResume)
			{
				willResume = false;
				recursiveSwitch();
			}
		}
		
		private function onCreationComplete(event:FlexEvent):void
		{
			event.currentTarget.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
			if(willResume)
			{
				willResume = false;
				recursiveSwitch();
			}
		}

		private function onStateChangeComplete(event:FlexEvent):void
		{
			event.currentTarget.removeEventListener(FlexEvent.STATE_CHANGE_COMPLETE, onStateChangeComplete);
			
			if(willResume)
			{
				willResume = false;
				recursiveSwitch();
			}
		}
	}
}