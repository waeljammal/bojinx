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

    public class AbstractHistory extends EventDispatcher
    {
        public static const HISTORY_CHANGE:String = "historyChange";

        protected var historyIndex:int = -1;

        protected var isHistory:Boolean;

        protected var hasMovedBackwards:Boolean;

        [ArrayElementType("Object")]
        protected var _history:Array = [];

        [Bindable("historyChange")]
        public function get history():Array
        {
            return _history;
        }

        //-------------------------------
        //  index
        //-------------------------------

        [Bindable("historyChange")]
        public function get currentIndex():int
        {
            return historyIndex;
        }

        [Bindable("historyChange")]
        public function get previousIndex():int
        {
            return hasPrevious ? currentIndex - 1 : 0;
        }

        [Bindable("historyChange")]
        public function get nextIndex():int
        {
            return hasNext ? currentIndex + 1 : history.length - 1;
        }

        //-------------------------------
        //  destinations
        //-------------------------------

        private function getDestination(index:int):String
        {
            var destination:String = NavigationEvent(history[index]).destination;
            return destination;
        }

        [Bindable("historyChange")]
        public function get currentDestination():String
        {
            return history && history.length > 0 ? getDestination(currentIndex) : "";
        }

        [Bindable("historyChange")]
        public function get previousDestination():String
        {
            return hasPrevious ? getDestination(currentIndex - 1) : "";
        }

        [Bindable("historyChange")]
        public function get nextDestination():String
        {
            return hasNext ? getDestination(currentIndex + 1) : "";
        }

        //------------------------------------------------------------------------
        //
        //  Implementation : IHistory
        //
        //------------------------------------------------------------------------

        [Bindable("historyChange")]
        public function get hasNext():Boolean
        {
            return history && history[historyIndex + 1] != null;
        }

        [Bindable("historyChange")]
        public function get hasPrevious():Boolean
        {
            return history && history[historyIndex - 1] != null;
        }

        public function next():void
        {
            if (hasNext)
            {
                hasMovedBackwards = false;
                navigateToNext(history[historyIndex + 1]);
            }
        }

        public function previous():void
        {
            if (hasPrevious)
            {
                hasMovedBackwards = true;
                navigateToPrevious(history[historyIndex - 1]);
            }
        }

        protected function navigateToNext(location:Object):void
        {
            throw new Error("Abstract");
        }

        protected function navigateToPrevious(location:Object):void
        {
            throw new Error("Abstract");
        }

        protected function historyChange():void
        {
            dispatchEvent(new Event(HISTORY_CHANGE));
        }

        protected function adjustWhenMovedOutOfHistory():void
        {
            if (hasMovedOutOfHistory())
            {
                history.splice(historyIndex + 1);
            }
        }

        private function hasMovedOutOfHistory():Boolean
        {
            return (historyIndex < history.length - 1);
        }
    }
}