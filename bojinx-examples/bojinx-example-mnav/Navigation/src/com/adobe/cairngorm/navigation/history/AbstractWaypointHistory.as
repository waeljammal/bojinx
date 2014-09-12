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
    import flash.events.EventDispatcher;

    [DefaultProperty("waypoint")]

    public class AbstractWaypointHistory extends AbstractHistory implements IHistory
    {
        /**
         * The name of the waypoint tracked.
         */
        private var _waypoint:String;

        public function set waypoint(value:String):void
        {
            if (_waypoint == value)
                return;

            _waypoint = value;
        }

        override protected function navigateToNext(location:Object):void
        {
            navigateTo(NavigationEvent(location));
        }

        override protected function navigateToPrevious(location:Object):void
        {
            navigateTo(NavigationEvent(location));
        }

        //------------------------------------------------------------------------
        //
        //  Message Handlers
        //
        //------------------------------------------------------------------------

        public function onNavigateTo(event:NavigationEvent):void
        {
            if (!isWaypoint(event))
                return;

            if (!isHistory)
            {
                adjustWhenMovedOutOfHistory();
                if (isDuplicate(event))
                {
                    return;
                }
                if (history == null)
                {
                    _history = new Array();
                }

                history.push(event);
                historyIndex++;
                historyChange();
            }
            else if (isHistory)
            {
                isHistory = false;
                historyIndex += hasMovedBackwards ? -1 : 1;
                historyChange();
            }
        }

        private function isWaypoint(event:NavigationEvent):Boolean
        {
            return event.waypoint == _waypoint;
        }

        private function isDuplicate(event:NavigationEvent):Boolean
        {
            return (currentDestination == event.destination && NavigationEvent(history[currentIndex]).type == event.type);
        }

        private function navigateTo(event:NavigationEvent):void
        {
            isHistory = true;
            dispatch(event);
            historyChange();
        }

        protected function dispatch(event:NavigationEvent):void
        {
            dispatchEvent(event);
        }
    }
}