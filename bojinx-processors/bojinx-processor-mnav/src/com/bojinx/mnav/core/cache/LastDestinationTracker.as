package com.bojinx.mnav.core.cache
{
	import com.bojinx.mnav.core.manager.DestinationStateController;
	import com.bojinx.mnav.util.NavUtil;
	import com.bojinx.utils.data.HashMap;
	
	import flash.utils.Dictionary;
	
	/**
	 * From Adobe Navigation
	 */
	public class LastDestinationTracker
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _lastDestination:String;
		
		public function get lastDestination():String
		{
			return _lastDestination;
		}
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var destinations:HashMap;
		
		private var lastDestinationByWaypoint:Dictionary = new Dictionary( true );
		
		private var parallelDestinations:Dictionary = new Dictionary( true );
		
		public function LastDestinationTracker( destinations:HashMap )
		{
			this.destinations = destinations;
		}
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function getLastDestinationByWaypoint( waypoint:String ):String
		{
			return lastDestinationByWaypoint[ waypoint ];
		}
		
		public function getLastDestination( newDestination:String ):DestinationStateController
		{
			var newWaypoint:String = NavUtil.getFirst( newDestination );
			
			if ( newWaypoint == null )
				return null;
			var lastDestination:String = lastDestinationByWaypoint[ newWaypoint ];
			
			var mostNested:DestinationStateController = getMostNested( lastDestination );
			var lastDestinationItem:DestinationStateController;
			
			if ( mostNested != null )
			{
				lastDestinationItem = mostNested;
			}
			else
			{
				lastDestinationItem = destinations.getValue(lastDestination);
			}
			return lastDestinationItem;
		}
		
		public function getMostNested( destination:String ):DestinationStateController
		{
			var current:DestinationStateController = destinations.getValue(lastDestination);
			
			if ( current == null )
				return null;
			var next:DestinationStateController = getNextNested( current.destination );
			
			while ( next && next.destination != null && next.destination != "" )
			{
				current = next;
				next = getNextNested( next.destination );
			}
			return current;
		}
		
		public function getNextNested( waypoint:String ):DestinationStateController
		{
			var lastDestination:String = lastDestinationByWaypoint[ waypoint ];
			var lastDestinationItem:DestinationStateController = destinations.getValue(lastDestination);
			return lastDestinationItem;
		}
		
		public function getParallelDestinations( waypoint:String ):Array
		{
			var waypointParallels:Array = parallelDestinations[ waypoint ];
			
			if ( waypointParallels == null )
			{
				return new Array();
			}
			var allParallels:Array = addNestedParallels( waypointParallels, waypointParallels.slice());
			return allParallels;
		}
		
		public function unregisterParallelDestination( destination:String ):void
		{
			var waypoint:String = NavUtil.getParent( destination );
			
			if ( parallelDestinations[ waypoint ] != null )
			{
				var parallels:Array = getParallelDestinations( waypoint );
				var length:int = parallels.length;
				
				for ( var i:int; i < length; i++ )
				{
					var current:String = parallels[ i ];
					var currentWaypoint:String = NavUtil.getParent( current );
					delete parallelDestinations[ currentWaypoint ];
				}
			}
		}
		
		public function updateLastDestination( destinationItem:DestinationStateController ):void
		{
			var destination:String = destinationItem.destination;
			
			if ( NavUtil.hasParallel( destination ))
			{
				registerParallelWaypoint( destination );
			}
			
			registerExclusiveWaypoint( destination );
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function addAndPreventDuplicate( waypoint:String, destination:String ):void
		{
			var items:Array = parallelDestinations[ waypoint ];
			
			if ( items.indexOf( destination ) == -1 )
			{
				items.push( destination );
			}
		}
		
		private function addNestedParallels( waypointParallels:Array, allParallels:Array ):Array
		{
			for each ( var item:String in waypointParallels )
			{
				var nestedParallels:Array = parallelDestinations[ item ];
				
				if ( nestedParallels && nestedParallels.length > 0 )
				{
					allParallels = allParallels.concat( nestedParallels );
				}
			}
			return allParallels;
		}
		
		private function registerExclusiveWaypoint( destination:String ):void
		{
			var waypoint:String = NavUtil.getParent( destination );
			
			if ( waypoint == null )
				return;
			lastDestinationByWaypoint[ waypoint ] = destination;
			_lastDestination = destination;
		}
		
		private function registerParallelWaypoint( destination:String ):void
		{
			var waypoint:String = NavUtil.getParent( destination );
			
			if ( parallelDestinations[ waypoint ] == null )
			{
				parallelDestinations[ waypoint ] = new Array();
			}
			
			addAndPreventDuplicate( waypoint, destination );
		}
	}
}
