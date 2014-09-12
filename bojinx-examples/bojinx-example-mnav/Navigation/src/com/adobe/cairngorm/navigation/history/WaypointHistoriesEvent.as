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

    import flash.events.Event;

    public class WaypointHistoriesEvent extends Event
    {
        public static const ADD:String = "add";

        private var _event:NavigationEvent;

        public function get event():NavigationEvent
        {
            return _event;
        }

        public static function newAddEvent(
            event:NavigationEvent):WaypointHistoriesEvent
        {
            var waypointEvent:WaypointHistoriesEvent = new WaypointHistoriesEvent(ADD);
            waypointEvent._event = event;
            return waypointEvent;
        }

        public function WaypointHistoriesEvent(
            type:String,
            bubbles:Boolean = false,
            cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);
        }

        override public function clone():Event
        {
            var event:WaypointHistoriesEvent = new WaypointHistoriesEvent(type, bubbles,
                                                                          cancelable);
            return event;
        }
    }
}