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
    import flash.events.Event;

    public class NavigationActionEvent extends Event
    {
        public static const WAYPOINT_CHANGE:String = "waypointChange";

        private var _oldDestination:String;

        public function get oldDestination():String
        {
            return _oldDestination;
        }

        private var _newDestination:String;

        public function get newDestination():String
        {
            return _newDestination;
        }
        
        private var _finalDestination:String;
        
        public function get finalDestination():String
        {
            return _finalDestination;
        }    

        public function NavigationActionEvent(type:String,
                                              oldDestination:String,
                                              newDestination:String, 
                                              finalDestination:String)
        {
            super(type);
            _oldDestination = oldDestination;
            _newDestination = newDestination;
            _finalDestination = finalDestination;
        }

        override public function clone():Event
        {
            return new NavigationActionEvent(type, oldDestination, newDestination, finalDestination);
        }
    }
}