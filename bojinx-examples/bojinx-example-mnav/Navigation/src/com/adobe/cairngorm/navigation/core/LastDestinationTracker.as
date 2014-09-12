/**
 *  Copyright (c) 2007 - 2009 Adobe
 *  All rights reserved.
 *
 *  Permission is hereby granted, free of charge, to any person obtaining
 *  a copy of this software and associated documentation files (the "Software"),
 *  to deal in the Software without restriction, including without limitation
 *  the rights to use, copy, modify, merge, publish, distribute, sublicense,
 *  and/or sell copies of the Software, and to permit persons to whom the
 *  Software is furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included
 *  in all copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 *  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 *  IN THE SOFTWARE.
 */
package com.adobe.cairngorm.navigation.core
{
	import com.adobe.cairngorm.navigation.NavigationUtil;
	
	import flash.utils.Dictionary;

	public class LastDestinationTracker
	{
		private var lastDestinationByWaypoint:Dictionary=new Dictionary(true);
		private var parallelDestinations:Dictionary=new Dictionary(true);

		private var _lastDestination:String;

		public function get lastDestination():String
		{
			return _lastDestination;
		}

		private var destinations:Dictionary;

		public function LastDestinationTracker(destinations:Dictionary)
		{
			this.destinations=destinations;
		}

		public function updateLastDestination(destinationItem:DestinationStateController):void
		{
			var destination:String=destinationItem.destination;
			if (NavigationUtil.hasParallel(destination))
			{
				registerParallelWaypoint(destination);
			}
			
			registerExclusiveWaypoint(destination);
		}

		private function registerExclusiveWaypoint(destination:String):void
		{
			var waypoint:String=NavigationUtil.getParent(destination);
			if (waypoint == null)
				return;
			lastDestinationByWaypoint[waypoint]=destination;
			_lastDestination=destination;
		}

		private function registerParallelWaypoint(destination:String):void
		{
			var waypoint:String=NavigationUtil.getParent(destination);
			if (parallelDestinations[waypoint] == null)
			{
				parallelDestinations[waypoint]=new Array();
			}

			addAndPreventDuplicate(waypoint, destination);
		}
		
		private function addAndPreventDuplicate(waypoint:String, destination:String):void
		{
			var items:Array = parallelDestinations[waypoint];
			if(items.indexOf(destination) == -1)
			{
				items.push(destination);
			}			
		}

		public function unregisterParallelDestination(destination:String):void
		{
			var waypoint:String=NavigationUtil.getParent(destination);
			if (parallelDestinations[waypoint] != null)
			{
				var parallels:Array=getParallelDestinations(waypoint);
				var length:int=parallels.length;
				for (var i:int; i < length; i++)
				{
					var current:String=parallels[i];
					var currentWaypoint:String = NavigationUtil.getParent(current);
					delete parallelDestinations[currentWaypoint];
				}
			}
		}

		public function getParallelDestinations(waypoint:String):Array
		{
			var waypointParallels:Array = parallelDestinations[waypoint];
			if(waypointParallels == null)
			{
				return new Array();
			}
			var allParallels:Array = addNestedParallels(waypointParallels, waypointParallels.slice());
			return allParallels;
		}
		
		private function addNestedParallels(waypointParallels:Array, allParallels:Array):Array
		{
			for each(var item:String in waypointParallels)
			{
				var nestedParallels:Array = parallelDestinations[item];
				if(nestedParallels && nestedParallels.length > 0)
				{
					allParallels = allParallels.concat(nestedParallels);
				}
			}
			return allParallels;
		}

		public function getLastDestination(newDestination:String):DestinationStateController
		{
			var newWaypoint:String=NavigationUtil.getFirst(newDestination);
			if (newWaypoint == null)
				return null;
			var lastDestination:String=lastDestinationByWaypoint[newWaypoint];

			var mostNested:DestinationStateController=getMostNested(lastDestination);
			var lastDestinationItem:DestinationStateController;
			if (mostNested != null)
			{
				lastDestinationItem=mostNested;
			}
			else
			{
				lastDestinationItem=destinations[lastDestination];
			}
			return lastDestinationItem;
		}

		public function getNextNested(waypoint:String):DestinationStateController
		{
			var lastDestination:String=lastDestinationByWaypoint[waypoint];
			var lastDestinationItem:DestinationStateController=destinations[lastDestination];
			return lastDestinationItem;
		}

		public function getMostNested(destination:String):DestinationStateController
		{
			var current:DestinationStateController=destinations[destination];
			if (current == null)
				return null;
			var next:DestinationStateController=getNextNested(current.destination);
			while (next && next.destination != null && next.destination != "")
			{
				current=next;
				next=getNextNested(next.destination);
			}
			return current;
		}
	}
}