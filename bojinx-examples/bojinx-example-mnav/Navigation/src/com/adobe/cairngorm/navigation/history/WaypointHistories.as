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
package com.adobe.cairngorm.navigation.history
{
    import com.adobe.cairngorm.navigation.NavigationEvent;

    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;

    [Event(name="add", type="com.adobe.cairngorm.navigation.history.WaypointHistoriesEvent")]
    [Event(name="navigateTo", type="com.adobe.cairngorm.navigation.NavigationEvent")]
	[Event(name="navigateAway", type="com.adobe.cairngorm.navigation.NavigationEvent")]
    public class WaypointHistories extends EventDispatcher
    {
        private var waypointHistories:Dictionary = new Dictionary();

        //need to store initial position of waypoint for history.
        private var firstWaypointEvents:Dictionary = new Dictionary();

        public function onNavigateTo(event:NavigationEvent):void
        {
            var waypointHistory:AbstractWaypointHistory = waypointHistories[event.waypoint];
            waypointHistory.onNavigateTo(event);
        }

        public function next(event:NavigationEvent):void
        {
            var waypointHistory:AbstractWaypointHistory = waypointHistories[event.waypoint];
            waypointHistory.next();
        }

        public function previous(event:NavigationEvent):void
        {
            var waypointHistory:AbstractWaypointHistory = waypointHistories[event.waypoint];
            waypointHistory.previous();
        }

        public function update(event:NavigationEvent):void
        {
            var waypointHistory:AbstractWaypointHistory = waypointHistories[event.waypoint];
            if (waypointHistory)
            {
                updateWaypointHistory(event);
            }
            else
            {
                waypointHistory = createWaypointHistory(event);
            }

            waypointHistory.onNavigateTo(event);
        }

        private function createWaypointHistory(event:NavigationEvent):AbstractWaypointHistory
        {
            var waypointHistory:AbstractWaypointHistory = new AbstractWaypointHistory();
            waypointHistory.addEventListener(NavigationEvent.NAVIGATE_TO, dispatchEvent, false, 0, true);
			waypointHistory.addEventListener(NavigationEvent.NAVIGATE_AWAY, dispatchEvent, false, 0, true);
            waypointHistory.waypoint = event.waypoint;
            waypointHistories[event.waypoint] = waypointHistory;

            firstWaypointEvents[event.waypoint] = event;
            return waypointHistory;
        }

        private function updateWaypointHistory(event:NavigationEvent):void
        {
            var firstEvent:NavigationEvent = firstWaypointEvents[event.waypoint];
            if (firstEvent && firstEvent.destination == event.destination && firstEvent.type == event.type)
                throw new Error("Duplicate destination");

            if (firstEvent != null)
            {
                dispatchEvent(WaypointHistoriesEvent.newAddEvent(firstEvent));
                firstWaypointEvents[event.waypoint] = null;
            }
            dispatchEvent(WaypointHistoriesEvent.newAddEvent(event));
        }
    }
}