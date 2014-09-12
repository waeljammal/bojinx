package com.bojinx.mnav.core.manager
{
	import com.bojinx.mnav.core.cache.DestinationRegistry;
	import com.bojinx.mnav.core.cache.LastDestinationTracker;
	import com.bojinx.mnav.core.message.InternalDestinationMessage;
	import com.bojinx.mnav.util.NavUtil;
	import com.bojinx.utils.logging.Logger;
	import com.bojinx.utils.logging.LoggingContext;
	import com.bojinx.utils.tasks.TaskGroup;
	
	public class EnterAndExitInvoker
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _lastDestinationTracker:LastDestinationTracker;
		
		public function get lastDestinationTracker():LastDestinationTracker
		{
			return _lastDestinationTracker;
		}
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var controller:NavigationController;
		
		private var destinations:DestinationRegistry;
		
		private var dispatcher:NavigationTaskGenerationDispatcher;
		
		public function EnterAndExitInvoker( controller:NavigationController, destinations:DestinationRegistry )
		{
			this.controller = controller;
			this.destinations = destinations;
			
			_lastDestinationTracker = new LastDestinationTracker( destinations.destinations );
			dispatcher = new NavigationTaskGenerationDispatcher( controller, lastDestinationTracker, controller.context );
			
			controller.context.messageBus.addInterceptor(applyEnters, InternalDestinationMessage, "applyEnters");
			controller.context.messageBus.addInterceptor(applyExits, InternalDestinationMessage, "applyExits");
		}
		
		
		/*============================================================================*/
		/*= STATIC PRIVATE PROPERTIES                                                 */
		/*============================================================================*/
		
		private static const log:Logger = LoggingContext.getLogger( EnterAndExitInvoker );
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function applyEnters( newDestination:String, queue:TaskGroup ):void
		{
			var common:String = getCommonPathFromLastDestination( newDestination );
			
			var order:Array = NavUtil.generateEnterParts( newDestination.split( "." ), null );
			var length:int = order.length;
			
			for ( var i:int = 0; i < length; i++ )
			{
				var current:String = order[ i ];
				
				if ( common == current )
				{
					continue;
				}
				
				if ( current.charAt( current.length - 1 ) == "." )
				{
					continue;
				}
				
				var destinationItem:DestinationStateController = destinations.getDestination( current );
				
				if ( destinationItem == null || !destinationItem.isWaypointAvailable )
				{
					destinations.addPending( current );
					
					if ( destinationItem == null )
						continue;
				}
				
				dispatcher.performActionAndReturnIfIntercept( destinationItem, current, newDestination, queue );
				lastDestinationTracker.updateLastDestination( destinationItem );
			}
		}
		
		public function applyExits( newDestination:String, queue:TaskGroup ):String
		{
			var oldDestination:DestinationStateController = lastDestinationTracker.getLastDestination( newDestination );
			
			if ( !oldDestination )
			{
				return null;
			}
			
			var common:String = NavUtil.getFirstSharedDestination( oldDestination.destination, newDestination );
			
			var order:Array = NavUtil.generateExitParts( oldDestination.destination.split( "." ), null );
			var length:int = order.length;
			var lastDestination:String;
			
			for ( var i:int = 0; i < length; i++ )
			{
				var current:String = order[ i ];
				
				if ( hasCurrentReachedCommonWaypoint( common, current ))
				{
					continue;
				}
				
				var destinationItem:DestinationStateController = destinations.getDestination( current );
				
				if ( destinationItem == null )
				{
					continue;
				}
				
				destinationItem.lastDestination = lastDestinationTracker.getLastDestinationByWaypoint( destinationItem.destination );
				dispatcher.performActionAndReturnIfIntercept( destinationItem, newDestination, oldDestination.destination, queue );
				lastDestination = current;
			}
			
			return lastDestination;
		}
		
		public function getLastDestination():String
		{
			return lastDestinationTracker.lastDestination;
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function getCommonPathFromLastDestination( newDestination:String ):String
		{
			var common:String;
			var oldDestination:DestinationStateController = lastDestinationTracker.getLastDestination( newDestination );
			
			if ( oldDestination && oldDestination.destination != newDestination )
			{
				common = NavUtil.getFirstSharedDestination( oldDestination.destination, newDestination );
			}
			return common;
		}
		
		private function getMostNestedOrFinalDestination( newDestination:String, finalDestination:String ):String
		{
			var mostNested:DestinationStateController = lastDestinationTracker.getMostNested( newDestination );
			
			if ( mostNested && hasNoDifferentFinalDestination( mostNested.destination, finalDestination ))
			{
				newDestination = mostNested.destination;
			}
			return newDestination;
		}
		
		private function hasCurrentReachedCommonWaypoint( common:String, current:String ):Boolean
		{
			return common.indexOf( current ) > -1;
		}
		
		private function hasNoDifferentFinalDestination( destination:String, finalDestination:String ):Boolean
		{
			return ( finalDestination == null || destination == finalDestination );
		}
	}
}
