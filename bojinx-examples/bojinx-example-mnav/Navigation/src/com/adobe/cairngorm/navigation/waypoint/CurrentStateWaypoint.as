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
	import com.adobe.cairngorm.navigation.NavigationUtil;
	
	import mx.core.UIComponent;
	import mx.events.StateChangeEvent;
	import mx.states.State;

	public class CurrentStateWaypoint extends AbstractWaypoint implements IWaypoint
	{
		public function CurrentStateWaypoint()
		{
			_registration = new StateDestinationRegistration();
		}
				
		public function getDefaultDestination():String
		{
			var defaultDestination:String;
			var currentState:String=view.currentState;
			if (currentState != null || currentState != "")
			{
				defaultDestination=buildFullDestination(currentState);
				_selectedIndex=getSelectedIndex(currentState);
			}
			return defaultDestination;
		}
				
		private function buildFullDestination(state:String):String
		{
			return _registration.waypointName + "." + state;
		}
				
		private function getSelectedIndex(state:String):int
		{
			var length:int=states.length;
			for (var i:int; i < length; i++)
			{
				var stateObject:State=states[i];
				if (stateObject.name == state)
				{
					return i;
				}
			}
			return -1
		}
		
		private function get states():Array
		{
			return view.states;
		}	

		public function subscribeToViewChange(view:UIComponent):void
		{
			this.view = view;
			view.addEventListener(StateChangeEvent.CURRENT_STATE_CHANGE, changeHandler, false, 0, true);
		}
		
		private function changeHandler(event:StateChangeEvent):void
		{
			var destination:String=buildFullDestination(event.newState);
			_selectedIndex=getSelectedIndex(event.newState);
			navigateTo(destination);
		}
				
		public function handleNavigationChange(event:NavigationEvent):void
		{
			view.currentState=NavigationUtil.getLast(event.destination);
		}	
	}
}