package com.bojinx.mnav.core.manager
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.mnav.core.cache.LastDestinationTracker;
	import com.bojinx.mnav.core.constants.Action;
	import com.bojinx.mnav.core.constants.TaskPriority;
	import com.bojinx.mnav.core.event.NavigationActionEvent;
	import com.bojinx.mnav.core.message.InternalDestinationMessage;
	import com.bojinx.mnav.core.message.NavigationChangeMessage;
	import com.bojinx.mnav.core.tasks.DispatchEnterTask;
	import com.bojinx.mnav.core.tasks.DispatchExitTask;
	import com.bojinx.mnav.core.tasks.PlayExitEffectTask;
	import com.bojinx.mnav.core.tasks.RegisterEnterEffectTask;
	import com.bojinx.mnav.core.tasks.RegisterExitEffectTask;
	import com.bojinx.mnav.core.tasks.SwitchStateTask;
	import com.bojinx.mnav.core.tasks.shared.SortableTask;
	import com.bojinx.mnav.util.NavUtil;
	import com.bojinx.utils.logging.Logger;
	import com.bojinx.utils.logging.LoggingContext;
	import com.bojinx.utils.tasks.Task;
	import com.bojinx.utils.tasks.TaskGroup;
	
	import flash.events.IEventDispatcher;
	
	[Event( name = "waypointChange", type = "com.bojinx.mnav.core.event.NavigationActionEvent" )]
	public class NavigationTaskGenerationDispatcher
	{
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var context:IApplicationContext;
		
		private var dispatcher:NavigationController;
		
		private var lastDestinationTracker:LastDestinationTracker;
		
		public function NavigationTaskGenerationDispatcher( dispatcher:NavigationController, lastDestinationTracker:LastDestinationTracker,
											  context:IApplicationContext )
		{
			this.dispatcher = dispatcher;
			this.lastDestinationTracker = lastDestinationTracker;
			this.context = context;
		}
		
		
		/*============================================================================*/
		/*= STATIC PRIVATE PROPERTIES                                                 */
		/*============================================================================*/
		
		private static const log:Logger = LoggingContext.getLogger( NavigationTaskGenerationDispatcher );
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function performActionAndReturnIfIntercept( destinationItem:DestinationStateController,
														   destination:String, finalDestination:String, 
														   queue:TaskGroup):Boolean
		{
			var hadIntercepted:Boolean;
			var action:String = performAction( destinationItem, destination, finalDestination, queue );
			
			return hadIntercepted;
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function dispatchActionChange( type:String, oldDestination:String,
											   newDestination:String, action:String,
											   finalDestination:String, queue:TaskGroup ):void
		{
			var type:String = Action.getEventName( type, action );
			var event:NavigationActionEvent = new NavigationActionEvent( type, oldDestination,
																		 newDestination,
																		 finalDestination,
																		 action );
			
			var msg:InternalDestinationMessage = new InternalDestinationMessage();
			msg.oldDestination = oldDestination;
			msg.newDestination = newDestination;
			msg.finalDestination = finalDestination;
			msg.action = action;
			
			var appendMode:Boolean = !queue;
			var task:SortableTask;
			
			if(!queue && dispatcher.currentQueue)
				queue = dispatcher.currentQueue;
				
			if(action == Action.EXIT)
			{
				if(queue)
				{
//					log.info( "Creating Exit Task [New]: " + newDestination + " [Type]: " + type + " [Action]: " + action );
					
					task = new RegisterExitEffectTask(msg, dispatcher);
					task.taskPriority = TaskPriority.EXIT_REGISTER_EFFECT;
					
					queue.addTask(task);
					
					task = new DispatchExitTask(msg, dispatcher);
					task.taskPriority = TaskPriority.EXIT_DISPATCH;
					
					queue.addTask(task);
				}
			}
			else if(action == Action.ENTER || action == Action.EVERY_ENTER || action == Action.FIRST_ENTER)
			{
				if(queue)
				{
					log.info( "Creating Enter Task [New]: " + newDestination + " [Type]: " + type + " [Action]: " + action );
					
					if(!appendMode)
					{
						task = new RegisterEnterEffectTask(msg, dispatcher);
						task.taskPriority = TaskPriority.ENTER_REGISTER_EFFECT;
						queue.addTask(task);
					}
					else
					{
						task = new RegisterEnterEffectTask(msg, dispatcher);
						task.taskPriority = TaskPriority.ENTER_REGISTER_EFFECT;
						queue.addTaskAt(task , queue.size - 1);
					}
					
					task = new DispatchEnterTask(msg, dispatcher);
					task.taskPriority = TaskPriority.ENTER_DISPATCH;
					task.lifecycleOrder = msg.newDestination.split(".").length;
					
					queue.addTask(task);
				}
			}
			
			dispatcher.dispatchEvent( event );
			dispatcher.addMessageToQueue(msg, type);
		}
		
		private function dispatchDestinationChange( oldDestination:String, newDestination:String,
													finalDestination:String, action:String, queue:TaskGroup ):void
		{
			var oldWaypoint:String = NavUtil.getParent( oldDestination );
			
			if ( newDestination == null )
				return;
			
			var newWaypoint:String = NavUtil.getParent( newDestination );
			
			if ( newWaypoint == null )
				return;
			
			if ( isWithinWaypointOrFirstWaypoint( oldWaypoint, newWaypoint ) && oldDestination != newDestination )
			{
				var event:NavigationActionEvent = new NavigationActionEvent( newWaypoint,
																			 oldDestination,
																			 newDestination,
																			 finalDestination,
																			 action );
				
				var msg:InternalDestinationMessage = new InternalDestinationMessage();
				msg.oldDestination = oldDestination;
				msg.newDestination = newDestination;
				msg.finalDestination = finalDestination;
				msg.action = action;
				
				if(!queue && dispatcher.currentQueue)
					queue = dispatcher.currentQueue;
				
				if(queue)
				{
//					log.info( "Creating Switch State Task [New]: " + newDestination + " [Old]: " + oldDestination + " [Final]: " + finalDestination + " [Action]: " + action );
					var task:Task = new SwitchStateTask(msg, dispatcher);
					task.taskPriority = oldDestination ? TaskPriority.EXIT_SWITCH_STATE : TaskPriority.ENTER_SWITCH_STATE;
					queue.addTask(task);
				}
				
				dispatcher.dispatchEvent( event );
				dispatcher.addMessageToQueue(msg, newWaypoint);
			}
		}
		
		private function dispatchEvents( action:String, destinationItem:DestinationStateController,
										 destination:String, finalDestination:String, queue:TaskGroup ):void
		{
			var destinations:Array;
			
			if ( action == Action.FIRST_ENTER || action == Action.ENTER )
			{
				var oldDestination:String;
				var state:DestinationStateController = lastDestinationTracker.getLastDestination( destination );
				
				if ( state )
				{
					oldDestination = state.destination;
				}
				
				dispatchWaypointChange( oldDestination, destination, finalDestination, action, queue );
				
				var commonOld:String;
				
				if ( oldDestination != null )
				{
					commonOld = NavUtil.getFirstSharedDestination( oldDestination, destination );
					
					var last:String = oldDestination.split( "." )[ commonOld.split( "." ).length ];
					
					if ( last != null )
						commonOld += "." + last;
				}
				else
				{
					commonOld = oldDestination;
				}
				
				dispatchDestinationChange( commonOld, destination, finalDestination, action, queue );
				
				dispatchActionChange( destination, oldDestination, destination, action,
									  finalDestination, queue );
				
				dispatchEveryEnterAction( destination, oldDestination, destination,
										  finalDestination, action, queue );
			}
			else
			{
				
				dispatchActionChange( destinationItem.destination, destinationItem.destination,
									  destination, action, finalDestination, queue );
			}
		}
		
		private function dispatchEveryEnterAction( type:String, oldDestination:String,
												   newDestination:String, finalDestination:String,
												   action:String, queue:TaskGroup ):void
		{
			var type:String = Action.getEventName( type, Action.EVERY_ENTER );
			var event:NavigationActionEvent = new NavigationActionEvent( type, oldDestination,
																		 newDestination,
																		 finalDestination, action );
			
			var msg:InternalDestinationMessage = new InternalDestinationMessage();
			msg.oldDestination = oldDestination;
			msg.newDestination = newDestination;
			msg.finalDestination = finalDestination;
			msg.action = action;
			msg.isEvery = true;
			
//			log.info( "Dispatching Every Enter Event [New]: " + newDestination + " [Old]: " + oldDestination + " [Final]: " + finalDestination + " [Type]: " + type );
			dispatcher.dispatchEvent( event );
			dispatcher.addMessageToQueue(msg, type);
		}
		
		private function dispatchWaypointChange( oldDestination:String, newDestination:String,
												 finalDestination:String,
												 action:String, queue:TaskGroup ):void
		{
			var oldWaypoint:String = NavUtil.getParent( oldDestination );
			var newWaypoint:String = NavUtil.getParent( newDestination );
			
			if ( oldWaypoint != newWaypoint )
			{				
				var msg:InternalDestinationMessage = new InternalDestinationMessage();
				msg.oldDestination = oldDestination;
				msg.newDestination = newDestination;
				msg.finalDestination = finalDestination;
				msg.action = action;
				
//				log.info( "Dispatching Waypoint Changed Event [New]: " + newWaypoint + " [Old]: " + oldWaypoint + " [Action]: " + action );
				var event:NavigationActionEvent = new NavigationActionEvent( NavigationActionEvent.WAYPOINT_CHANGE,
																			 oldDestination,
																			 newDestination,
																			 finalDestination, action );
				
				dispatcher.dispatchEvent( event );
				dispatcher.addMessageToQueue(msg, NavigationActionEvent.WAYPOINT_CHANGE);
			}
		}
		
		private function isWithinWaypointOrFirstWaypoint( oldWaypoint:String, newWaypoint:String ):Boolean
		{
			return ( oldWaypoint == newWaypoint || oldWaypoint == null );
		}
		
		private function performAction( destinationItem:DestinationStateController,
										destination:String, finalDestination:String, queue:TaskGroup):String
		{
			var action:String = destinationItem.navigateTo( destination );
			
			if ( action != null )
			{
				dispatchEvents( action, destinationItem, destination, finalDestination, queue );
			}
			
			return action;
		}
	}
}
