package com.bojinx.mnav.core.waypoint
{
	import com.bojinx.mnav.core.cache.MNavViewRegistry;
	import com.bojinx.mnav.core.constants.MNavCacheID;
	import com.bojinx.mnav.core.event.NavigationActionEvent;
	import com.bojinx.mnav.core.event.WaypointEvent;
	import com.bojinx.mnav.core.manager.NavigationController;
	import com.bojinx.mnav.core.message.NavigationMessage;
	import com.bojinx.system.cache.definition.MetaDefinition;
	import com.bojinx.system.cache.definition.ObjectDefinition;
	import com.bojinx.utils.logging.Logger;
	import com.bojinx.utils.logging.LoggingContext;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class WaypointHandler extends EventDispatcher
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		public var effectFactory:ObjectDefinition;
		
		private var _waypoint:CurrentStateWaypoint;
		
		public function get waypoint():CurrentStateWaypoint
		{
			return _waypoint;
		}
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var controller:NavigationController;
		
		private var eventName:String;
		
		private var pendingState:String;
		
		private var registry:MNavViewRegistry;
		
		public function WaypointHandler( controller:NavigationController )
		{
			this.controller = controller;
		}
		
		/*============================================================================*/
		/*= STATIC PRIVATE PROPERTIES                                                 */
		/*============================================================================*/
		
		private static var ignoreNextNonMatchingInterceptor:Boolean;
		
		private static const log:Logger = LoggingContext.getLogger( WaypointHandler );
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function dispose():void
		{
			log.info("DISPOSING");
			waypoint.registry.removeEventListener( WaypointEvent.EVENT_NAME, onWaypointFound );
			waypoint.dispose();
			controller.removeEventListener( eventName, convertEvent );
//			controller.destinations.remove(waypoint.name);
			
//			controller.context.messageBus.removeInterceptor( destinationChangeInterceptor, InternalDestinationMessage );
//			controller.context.messageBus.removeInterceptor( exitInterceptor, InternalDestinationMessage );
//			controller.context.messageBus.removeInterceptor( enterInterceptor, InternalDestinationMessage );
//			
//			for each ( var i:String in waypoint.registry.destinations )
//			{
//				controller.context.messageBus.removeInterceptor( stateExitInterceptor, InternalDestinationMessage );
//				controller.context.messageBus.removeInterceptor( stateEveryEnterInterceptor, InternalDestinationMessage );
//			}
		}

		public function process( md:MetaDefinition, path:String ):void
		{
			if ( !registry )
				registry = md.owner.context.cache.getCache( MNavCacheID.VIEW_REGISTRY );
			
			if ( !_waypoint )
			{
				log.info("New Waypoint Added " + path);
				_waypoint = new CurrentStateWaypoint();
				waypoint.initialize( md, controller, path );
				registry.registerHandler( this );
				waypoint.registry.addEventListener( WaypointEvent.EVENT_NAME, onWaypointFound );
				waypoint.registry.process( waypoint );
			}
		}
		
		public function processPending():void
		{
			if ( pendingState )
			{
				log.info( "Processing Pending State [Name]: " + pendingState + " [Waypoint]: " + waypoint.name );
//				processNavigation(pendingState, null);
				destinationChangeHandler( new NavigationMessage( pendingState ));
//				waypoint.target.context.messageBus.dispatch( new NavigationMessage( pendingState ));
//				controller.navigateTo( pendingState, true );
				pendingState = null;
			}
		
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function convertEvent( event:NavigationActionEvent ):void
		{
			destinationChangeHandler( new NavigationMessage( event.newDestination ));
		}
		
		private function destinationChangeHandler( message:NavigationMessage ):void
		{
			waypoint.handleNavigationChange( message );
		}
		
		private function initializeDefaultDestination():void
		{
			var destination:String = waypoint.getDefaultDestination();
			
			if ( destination != "" && destination != null )
			{
//				waypoint.target.context.messageBus.dispatch( new NavigationMessage( destination ));
				
//				log.info("Navigate to Default Destination " + destination);
//				pendingState = destination;
				
//				destinationChangeHandler( new NavigationMessage( destination ));
//				controller.navigateTo( destination );
//				controller.enterAndExitInvoker.applyExits( destination );
//				controller.enterAndExitInvoker.applyEnters( destination );
			}
		
//			setState(waypoint.selectedIndex, destination);
		}
		
		private function invokePendingOrDefaultDestinations():void
		{
//			if ( waypoint.registry.hasRegisteredChildren )
//			{
//				var pending:String = controller.destinations.getNextPending( waypoint.registry.name );
//				
//				if ( pending != null )
//				{
//					log.info( "Delegating Pending [State]: " + pending + ":" + Action.FIRST_ENTER + " [Waypoint]: " + waypoint.name );
//					
//					ignoreNextNonMatchingInterceptor = true;
//					pendingState = pending;
////					waypoint.handleNavigationChange(new NavigationMessage(pendingState));
//					controller.destinations.removePending( pending );
////					controller.navigateTo(pending);
////					controller.enterAndExitInvoker.applyExits( pending );
////					controller.enterAndExitInvoker.applyEnters( pending );
//				}
//				else
//				{
//					initializeDefaultDestination();
//				}
//			}
		}
		
		private function onWaypointFound( event:WaypointEvent ):void
		{
			eventName = event.name;
//			controller.addEventListener( eventName, convertEvent );
			
			invokePendingOrDefaultDestinations();
		}
	}
}
