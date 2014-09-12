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
	
	import mx.states.State;

	public class StateDestinationRegistration extends AbstractDestinationRegistration implements IDestinationRegistration
	{		
		override public function onRegisterDestinations():void
		{
			var states:Array=view.states;
			var length:int=states.length;
			for (var i:int; i < length; i++)
			{
				var state:State=states[i];
				var destination:String=waypointName + "." + state.name;
				controller.registerDestination(destination);
				
				setWaypointAvailable(destination);
			}
			_hasRegisteredChildren=true;
			dispatchEvent(new WaypointEvent(waypointName));
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
	}
}