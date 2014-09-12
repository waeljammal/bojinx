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
	
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	public class DestinationRegistry
	{
		public function get hasAnyDestinations():Boolean
		{
			var hasAny:Boolean;
			for each (var destination:String in destinations)
			{
				if(destination != null)
				{
					hasAny=true;
					break;
				}
			}
			return hasAny;
		}

		private var _destinations:Dictionary;

		public function get destinations():Dictionary
		{
			return _destinations;
		}

		private var dispatcher:IEventDispatcher;

		private var pendingDestinations:Dictionary=new Dictionary(true);

		public function DestinationRegistry(dispatcher:IEventDispatcher)
		{
			this.dispatcher=dispatcher;
			_destinations=new Dictionary(true);
		}

		public function getNextPending(base:String):String
		{
			return getAnyNext(base, pendingDestinations);
		}
		
		private function getAnyNext(destination:String, destinations:Dictionary):String
		{
			for (var name:String in destinations)
			{
				var base:String = NavigationUtil.getCommonBase(destination, name);
				if(base != null && name != destination 
					&& base == NavigationUtil.getParent(name)
					&& NavigationUtil.getLength(name) > NavigationUtil.getLength(base)
					&& NavigationUtil.getLength(name) > NavigationUtil.getLength(destination))
				{
					return name;
				}
			}
			return null;
		}

		public function addPending(destination:String):void
		{
			pendingDestinations[destination]=true;
		}

		public function removePending(destination:String):void
		{
			if (isPending(destination))
			{
				delete pendingDestinations[destination];
			}
		}

		public function isPending(destination:String):Boolean
		{
			return pendingDestinations[destination] != null;
		}

		public function getDestination(destination:String):DestinationStateController
		{
			return destinations[destination];
		}

		public function getValidDestination(destination:String):DestinationStateController
		{
			var item:DestinationStateController=destinations[destination];
			while (!item)
			{
				var parentDestination:String=NavigationUtil.getParent(destination)
				if (parentDestination == null)
					return null;
				destination=parentDestination;
				item=destinations[parentDestination];
			}
			return item;
		}

		public function addEventListenerInterceptor(type:String):void
		{
			var destination:String=NavigationActionName.getDestination(type);
			var destinationItem:DestinationStateController=destinations[destination];
			if (destinationItem != null)
			{
				var action:String=NavigationActionName.getAction(type);
				if (action == NavigationActionName.ENTER_INTERCEPT)
				{
					destinationItem.hasEnterInterceptor=true;
				}
				if (action == NavigationActionName.EXIT_INTERCEPT)
				{
					destinationItem.hasExitInterceptor=true;
				}
			}
		}

		public function registerDestination(destination:String):Boolean
		{
			var hasRegistered:Boolean;
			var destinationItem:DestinationStateController=destinations[destination];
			if (destinationItem == null)
			{
				var parent:String=NavigationUtil.getParent(destination);
				if (!hasDestination(parent) && parent != null)
				{
					registerDestination(parent);
				}

				destinationItem=new DestinationStateController(destination);

				if (hasAction(destination, NavigationActionName.ENTER_INTERCEPT))
				{
					destinationItem.hasEnterInterceptor=true;
				}
				if (hasAction(destination, NavigationActionName.EXIT_INTERCEPT))
				{
					destinationItem.hasExitInterceptor=true;
				}

				destinations[destination]=destinationItem;
				hasRegistered=true;
			}
			return hasRegistered;
		}

		public function unregisterDestination(destination:String):void
		{
			delete destinations[destination];
		}

		public function hasDestination(destination:String):Boolean
		{
			return destinations[destination] != null;
		}

		public function unblockEnter(destination:String):void
		{
			var destinationItem:DestinationStateController=destinations[destination];
			destinationItem.hasEnterInterceptor=false;
		}

		public function unblockExit(destination:String):void
		{
			var destinationItem:DestinationStateController=destinations[destination];
			destinationItem.hasExitInterceptor=false;
		}

		public function blockEnter(destination:String):void
		{
			var destinationItem:DestinationStateController=destinations[destination];
			destinationItem.hasEnterInterceptor=true;
		}

		public function blockExit(destination:String):void
		{
			var destinationItem:DestinationStateController=destinations[destination];
			destinationItem.hasExitInterceptor=true;
		}

		private function hasAction(destination:String, action:String):Boolean
		{
			var type:String=NavigationActionName.getEventName(destination, action);
			return dispatcher.hasEventListener(type);
		}
	}
}