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
package com.adobe.cairngorm.navigation.wizard
{
    import com.adobe.cairngorm.navigation.NavigationEvent;

    import flash.events.Event;
    import flash.events.EventDispatcher;

    [DefaultProperty("stages")]
    public class AbstractWizard extends EventDispatcher implements IWizard
    {
        public static const WIZARD_CHANGE:String = "wizardChange";

        //------------------------------------------------------------------------
        //
        //  Properties
        //
        //------------------------------------------------------------------------

        //-------------------------------
        //  waypoint
        //-------------------------------

        private var _waypoint:String;

        /**
         * The name of the waypoint that controls the view for this wizard.
         */
        public function set waypoint(value:String):void
        {
            if (_waypoint == value)
                return;

            _waypoint = value;
        }

        //-------------------------------
        //  stages
        //-------------------------------

        [ArrayElementType("String")]
        private var _stages:Array;

        [Bindable("wizardChange")]
        public function get stages():Array
        {
            return _stages;
        }

        /**
         * The stages of the wizard.
         *
         * @param values
         *    an array of destination names
         */
        public function set stages(values:Array):void
        {
            if (_stages == values)
                return;

            _stages = values;

            if (_stages && _stages.length > 0)
            {
                _currentDestination = _stages[0];
            }

            wizardChange();
        }

        //-------------------------------
        //  index
        //-------------------------------

        [Bindable("wizardChange")]
        public function get currentIndex():int
        {
            return _stages ? _stages.indexOf(currentDestination) : -1;
        }

        [Bindable("wizardChange")]
        public function get previousIndex():int
        {
            return hasPrevious ? currentIndex - 1 : 0;
        }

        [Bindable("wizardChange")]
        public function get nextIndex():int
        {
            return hasNext ? currentIndex + 1 : stages.length - 1;
        }

        //-------------------------------
        //  destinations
        //-------------------------------

        private var _currentDestination:String;

        [Bindable("wizardChange")]
        public function get currentDestination():String
        {
            return _currentDestination;
        }

        [Bindable("wizardChange")]
        public function get previousDestination():String
        {
            return hasPrevious ? _stages[currentIndex - 1] : "";
        }

        [Bindable("wizardChange")]
        public function get nextDestination():String
        {
            return hasNext ? _stages[currentIndex + 1] : "";
        }

        //------------------------------------------------------------------------
        //
        //  Implementation : IWizard
        //
        //------------------------------------------------------------------------

        [Bindable("wizardChange")]
        public function get hasNext():Boolean
        {
            return _stages && _stages.indexOf(currentDestination) < (_stages.length - 1);
        }

        [Bindable("wizardChange")]
        public function get hasPrevious():Boolean
        {
            return _stages && _stages.indexOf(currentDestination) > 0;
        }

        public function next():void
        {
            if (hasNext)
            {
                navigateTo(_stages[currentIndex + 1]);
            }
        }

        public function previous():void
        {
            if (hasPrevious)
            {
                navigateTo(_stages[currentIndex - 1]);
            }
        }

        public function onNavigateTo(event:NavigationEvent):void
        {
            var qualifiedWaypoint:String = event.waypoint;

            var lastDot:int = qualifiedWaypoint.lastIndexOf(".");

            var unQualifiedWaypoint:String = qualifiedWaypoint.substring(lastDot + 1,
                                                                         qualifiedWaypoint.length);

            if (unQualifiedWaypoint == _waypoint)
            {
                _currentDestination = event.destination;
                wizardChange();
            }
        }

        private function navigateTo(destination:String):void
        {
            dispatch(NavigationEvent.createNavigateToEvent(destination));
        }

        protected function dispatch(event:NavigationEvent):void
        {
            dispatchEvent(event);
        }

        private function wizardChange():void
        {
            dispatchEvent(new Event(WIZARD_CHANGE));
        }
    }
}