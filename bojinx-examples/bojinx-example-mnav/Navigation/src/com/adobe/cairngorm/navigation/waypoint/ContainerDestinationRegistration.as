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
package com.adobe.cairngorm.navigation.waypoint
{
	import com.adobe.cairngorm.navigation.NavigationUtil;
	import com.adobe.cairngorm.navigation.core.DestinationRegistry;
	import com.adobe.cairngorm.navigation.core.DestinationStateController;
	import com.adobe.cairngorm.navigation.core.NavigationController;
	
	import flash.events.Event;
	
	import mx.core.UIComponent;
	import mx.events.ChildExistenceChangedEvent;
	import mx.events.FlexEvent;

	public class ContainerDestinationRegistration extends AbstractDestinationRegistration implements IDestinationRegistration
	{
		override public function onRegisterDestinations():void
		{
			var length:int=view.numChildren;
			if (length < 1)
			{
				listenForInitialize(view);				
				return;
			}

			registerDestinationFromChildren(view, length);			
			listenForChildChange(view);
		}
		
		override public function unregisterDestinations():void
		{
			super.unregisterDestinations();
			view.removeEventListener(ChildExistenceChangedEvent.CHILD_ADD, handleChildAdd);
			view.removeEventListener(ChildExistenceChangedEvent.CHILD_REMOVE, handleChildRemove);
			view.removeEventListener(FlexEvent.INITIALIZE, handleInitialize);
		}

		private function registerDestinationFromChildren(view:UIComponent, length:int):void
		{
			for (var i:int; i < length; i++)
			{
				try
				{
					var child:UIComponent=UIComponent(view.getChildAt(i));
					_hasRegisteredChildren=true;
					registerChild(child);
				}
				catch (e:RangeError)
				{
					listenForInitialize(view);
				}
			}
		}

		private function listenForInitialize(view:UIComponent):void
		{
			view.addEventListener(FlexEvent.INITIALIZE, handleInitialize, false, 0, true);
		}
		
		private function handleInitialize(event:Event):void
		{
			var view:UIComponent = UIComponent(event.currentTarget);
			registerDestinations(view);
			
			view.removeEventListener(FlexEvent.INITIALIZE, handleInitialize);
		}
		
		private function listenForChildChange(view:UIComponent):void
		{
			view.addEventListener(ChildExistenceChangedEvent.CHILD_ADD, handleChildAdd, false, 0, true);
			view.addEventListener(ChildExistenceChangedEvent.CHILD_REMOVE, handleChildRemove, false, 0, true);
		}
		
		private function handleChildAdd(event:ChildExistenceChangedEvent):void
		{
			var child:UIComponent = event.relatedObject as UIComponent;
			if(child)
			{
				registerChild(child);
			}
		}
		
		private function handleChildRemove(event:ChildExistenceChangedEvent):void
		{
			var child:UIComponent = event.relatedObject as UIComponent;			
			if(child)
			{
				unregisterChild(child);
			}
		}

		private function registerChild(child:UIComponent):void
		{
			var destination:String=child.automationName;
			if (destination == null || destination == "")
			{
				throw new Error("Cannot find a destination from automationName on: " + child);
			}
			else if (NavigationUtil.getParent(destination) == null)
			{
				throw new Error("The destination " + destination + " on view: " + child + " doesn't have a parent (waypoint).");
			}

			controller.registerDestination(destination);
			
			setWaypointAvailable(destination);
			
			destinations.push(destination);

			if (waypointName == null)
			{
				_waypointName=NavigationUtil.getParent(destination);
				if (waypointName == null)
				{
					throw new Error("A waypoint cannot be found on destination: " + destination);
				}
				dispatchEvent(new WaypointEvent(waypointName));
			}
		}
		
		private function setWaypointAvailable(destination:String):void
		{
			var registry:DestinationRegistry = NavigationController(controller).destinations;
			var dest:DestinationStateController = registry.getDestination(destination);
			while (dest && dest.destination != null && dest.destination != "")
			{
				dest.isWaypointAvailable = true;
				var parentDestination:String = NavigationUtil.getParent(dest.destination);
				dest = registry.getDestination(parentDestination);
			}		
		}
		
		private function unregisterChild(child:UIComponent):void
		{
			var destination:String=child.automationName;
			if (destination == null || destination == "")
			{
				throw new Error("Cannot find a destination from automationName on: " + child);
			}
			else if (NavigationUtil.getParent(destination) == null)
			{
				throw new Error("The destination " + destination + " on view: " + child + " doesn't have a parent (waypoint).");
			}
						
			var registry:DestinationRegistry = NavigationController(controller).destinations;
			registry.getDestination(destination).isWaypointAvailable = false;
			
			controller.unregisterDestination(destination);
			var index:int = destinations.indexOf(destination);
			destinations.splice(index, 1);
		}		
	}
}