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
	import com.adobe.cairngorm.navigation.NavigationEvent;
	import com.adobe.cairngorm.navigation.core.NavigationActionEvent;
	import com.adobe.cairngorm.navigation.core.NavigationController;
	import com.adobe.cairngorm.navigation.state.SelectedStates;
	import com.adobe.cairngorm.navigation.state.SelectedStatesFactory;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.core.UIComponent;

	[Event(name="navigateTo", type="com.adobe.cairngorm.navigation.NavigationEvent")]
	public class WaypointHandler extends EventDispatcher
	{
		private var _name:String;
		
		public function get name():String
		{
			return _name;
		}		

		private var _waypoint:IWaypoint;
		
		public function get waypoint():IWaypoint
		{
			return _waypoint;
		}

		public function get registration():IDestinationRegistration
		{
			return _waypoint.registration;
		}

		private var states:SelectedStates;
		
		private var controller:NavigationController;

		public function WaypointHandler(controller:NavigationController, name:String)
		{
			this.controller = controller;
			_name = name;
		}
		
		public function createWaypoint(container:UIComponent, mode:String, waypointType:Class, isWaypointType:Function):void
		{
			_waypoint=createConcreteWaypoint(mode, waypointType, name, isWaypointType);
			_waypoint.addEventListener(NavigationEvent.NAVIGATE_TO, handleNavigateTo);
			_waypoint.subscribeToViewChange(container);
			
			registration.addEventListener(AbstractDestinationRegistration.WAYPOINT_FOUND, waypointFoundHandler);	
			registration.registerDestinations(container);			
		}
		
		private function waypointFoundHandler(event:WaypointEvent):void
		{
			_name = event.name;
			
			states=SelectedStatesFactory.getInstance(name);
			controller.addEventListener(name, convertEvent);
			
			invokePendingOrDefaultDestinations();
		}
		
		private function convertEvent(event:NavigationActionEvent):void
		{
			landmarkChangeHandler(NavigationEvent.createNavigateToEvent(event.newDestination));
		}
		
		private function landmarkChangeHandler(event:NavigationEvent):void
		{
			waypoint.handleNavigationChange(event);
		}		
		
		private function createConcreteWaypoint(mode:String, waypointType:Class, name:String, isWaypointType:Function):IWaypoint
		{
			var waypoint:IWaypoint;
			if (waypointType == null && mode == null)
			{
				waypoint = new SelectedChildWaypoint();
				waypoint.registration.initialize(controller);
			}
			else if (mode == "states")
			{
				if (name == null || name == "")
				{
					throw new Error("When using view states, you must specify a the name property for the waypoint.");
				}
				waypoint = new CurrentStateWaypoint();
				waypoint.registration.initialize(controller, name);
			}
			else if (waypointType && isWaypointType(waypointType))
			{
				waypoint = new waypointType();
				waypoint.registration.initialize(controller, name);
			}			
			else
			{
				throw new Error("Unexpected type: " + waypointType);
			}
			
			return waypoint;
		}

		private function invokePendingOrDefaultDestinations():void
		{
			if (registration.hasRegisteredChildren)
			{
				var pending:String=controller.destinations.getNextPending(registration.waypointName);
				if (pending != null)
				{
					var navigationEvent:NavigationEvent=NavigationEvent.createNavigateToEvent(pending);
					landmarkChangeHandler(navigationEvent);
					controller.destinations.removePending(pending);
				}
				else
				{
					initializeDefaultDestination();
				}
			}
		}

		private function initializeDefaultDestination():void
		{
			var destination:String=waypoint.getDefaultDestination();
			if (destination != "" && destination != null)
			{
				dispatchEvent(NavigationEvent.createNavigateToEvent(destination));
			}

			setState(waypoint.selectedIndex, destination);
		}

		private function handleNavigateTo(event:NavigationEvent):void
		{
			setState(waypoint.selectedIndex, event.destination);
			dispatchEvent(event);
		}
		
		private function setState(selectedIndex:int, destination:String):void
		{
			if (states)
			{
				states.selectedIndex=selectedIndex;
			}
		}
				
		public function destroy():void
		{
			controller.removeEventListener(name, convertEvent);
			registration.unregisterDestinations();			
		}	
	}
}