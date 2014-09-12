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
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	[Event(name="lastEnterInterceptor", type="com.adobe.cairngorm.navigation.core.LastInterceptorEvent")]
	public class EnterAndExitInvoker extends EventDispatcher
	{
		private var destinations:DestinationRegistry;

		private var lastDestinationTracker:LastDestinationTracker;

		private var dispatcher:NavigationDispatcher;

		public function get lastDestination():String
		{
			return lastDestinationTracker.lastDestination;
		}

		public function EnterAndExitInvoker(dispatcher:IEventDispatcher, destinations:DestinationRegistry)
		{
			this.destinations=destinations;
			lastDestinationTracker=new LastDestinationTracker(destinations.destinations);
			this.dispatcher=new NavigationDispatcher(dispatcher, lastDestinationTracker);
		}

		public function findLastInterceptor(newDestination:String, finalDestination:String=null):void
		{
			if (!findLastEnterInterceptor(newDestination, finalDestination))
			{
				findLastExitInterceptor(newDestination);
			}
		}

		private function findLastEnterInterceptor(newDestination:String, finalDestination:String=null):Boolean
		{
			var common:String=getCommonPathFromLastDestination(newDestination);
			newDestination=getMostNestedOrFinalDestination(newDestination, finalDestination);
			var order:Array=NavigationUtil.getEnterDispatchOrder(newDestination.split("."));
			var length:int=order.length;
			for (var i:int=0; i < length; i++)
			{
				var current:String=order[i];

				if (common == current)
				{
					continue;
				}

				var destinationItem:DestinationStateController=destinations.getDestination(current);
				var isLast:Boolean=(i == length - 1);
				if (destinationItem && isLast && destinationItem.hasEnterInterceptor)
				{
					dispatchEvent(new LastInterceptorEvent(current));
					return true;
				}
			}
			return false;
		}

		private function findLastExitInterceptor(newDestination:String):Boolean
		{
			var oldDestination:DestinationStateController=lastDestinationTracker.getLastDestination(newDestination);
			if (!oldDestination)
				return false;
			var common:String=NavigationUtil.getCommonBase(oldDestination.destination, newDestination);

			var order:Array=NavigationUtil.getExitDispatchOrder(oldDestination.destination.split("."));
			var length:int=order.length;
			for (var i:int=0; i < length; i++)
			{
				var current:String=order[i];

				if (common.indexOf(current) > -1)
				{
					continue;
				}
				var destinationItem:DestinationStateController=destinations.getDestination(current);
				var isFirst:Boolean=(i == 0)
				if (destinationItem && isFirst && destinationItem.hasExitInterceptor)
				{
					dispatchEvent(new LastInterceptorEvent(current));
					return true;
				}
			}

			return false;
		}

		public function reset(newDestination:String):void
		{
			var destinationItem:DestinationStateController=destinations.getDestination(newDestination);
			if (destinationItem != null)
			{
				dispatcher.reset(destinationItem);
			}
		}

		public function applyExits(newDestination:String):Boolean
		{
			var hasExitIntercept:Boolean;

			var oldDestination:DestinationStateController=lastDestinationTracker.getLastDestination(newDestination);
			if (!oldDestination)
				return false;
			var common:String=NavigationUtil.getCommonBase(oldDestination.destination, newDestination);

			var order:Array=NavigationUtil.getExitDispatchOrder(oldDestination.destination.split("."));
			var length:int=order.length;
			for (var i:int=0; i < length; i++)
			{
				var current:String=order[i];

				if (hasCurrentReachedCommonWaypoint(common, current))
				{
					continue;
				}
				
				var destinationItem:DestinationStateController=destinations.getDestination(current);
				if (destinationItem == null)
				{
					continue;
				}

				if (!executeParallels(current, false))
				{
					return true;
				}

				hasExitIntercept=dispatcher.performActionAndReturnIfIntercept(destinationItem, newDestination, oldDestination.destination);

				if (hasExitIntercept)
					return true;
			}

			return hasExitIntercept;
		}
		
		private function hasCurrentReachedCommonWaypoint(common:String, current:String):Boolean
		{
			return common.indexOf(current) > -1;
		}

		public function applyEnters(newDestination:String, finalDestination:String=null):Boolean
		{
			var hasEnterIntercept:Boolean;

			var common:String=getCommonPathFromLastDestination(newDestination);
			newDestination=getMostNestedOrFinalDestination(newDestination, finalDestination);

			var order:Array=NavigationUtil.getEnterDispatchOrder(newDestination.split("."));
			var length:int=order.length;
			for (var i:int=0; i < length; i++)
			{
				var current:String=order[i];

				if (common == current)
				{
					continue;
				}

				if (current.charAt(current.length - 1) == ".")
				{
					continue;
				}

				var destinationItem:DestinationStateController=destinations.getDestination(current);
				if (destinationItem == null || !destinationItem.isWaypointAvailable)
				{
					destinations.addPending(current);
					
					if (destinationItem == null)
						continue;
				}

				hasEnterIntercept=dispatcher.performActionAndReturnIfIntercept(destinationItem, current, newDestination);

				if (!hasEnterIntercept)
				{
					lastDestinationTracker.updateLastDestination(destinationItem);
				}
				else
				{
					return true;
				}
			}

			return hasEnterIntercept;
		}

		private function executeParallels(current:String, isEnter:Boolean):Boolean
		{
			var hasIntercept:Boolean;
			var parallels:Array=lastDestinationTracker.getParallelDestinations(current);
			if (!isEnter)
			{
				parallels.reverse();
			}
			
			var length:int = parallels.length;			
			for (var i:int; i < length; i++)
			{
				var destination:String = parallels[i];
				if (destination == null)
				{
					continue;
				}
				var destinationItem:DestinationStateController=destinations.getDestination(destination);								
				if(destinationItem == null)
				{
					continue;
				}
				
				if (isEnter)
				{
					hasIntercept=dispatcher.performActionAndReturnIfIntercept(destinationItem, destination, destination);
				}
				else
				{
					hasIntercept=dispatcher.navigateAwayAndReturnIfIntercept(destinationItem);
				}
				if (hasIntercept)
				{
					return false;
				}
			}
			return true;
		}

		public function applyExit(destination:String):Boolean
		{
			var parallels:Array=lastDestinationTracker.getParallelDestinations(destination);			
			parallels.reverse();
			parallels.push(destination);
			var length:int = parallels.length;			
			for (var i:int; i < length; i++)
			{
				var current:String = parallels[i];
				var destinationItem:DestinationStateController=destinations.getDestination(current);
				if(destinationItem == null)
				{
					continue;
				}				
				var hasExitIntercept:Boolean=dispatcher.navigateAwayAndReturnIfIntercept(destinationItem);
				
				if (!hasExitIntercept)
				{
					lastDestinationTracker.unregisterParallelDestination(current);
				}
			}

			return hasExitIntercept;
		}

		private function getCommonPathFromLastDestination(newDestination:String):String
		{
			var common:String;
			var oldDestination:DestinationStateController=lastDestinationTracker.getLastDestination(newDestination);
			if (oldDestination && oldDestination.destination != newDestination)
			{
				common=NavigationUtil.getCommonBase(oldDestination.destination, newDestination);
			}
			return common;
		}

		private function getMostNestedOrFinalDestination(newDestination:String, finalDestination:String):String
		{
			var mostNested:DestinationStateController=lastDestinationTracker.getMostNested(newDestination);
			if (mostNested && hasNoDifferentFinalDestination(mostNested.destination, finalDestination))
			{
				newDestination=mostNested.destination;
			}
			return newDestination;
		}

		private function hasNoDifferentFinalDestination(destination:String, finalDestination:String):Boolean
		{
			return (finalDestination == null || destination == finalDestination);
		}
	}
}