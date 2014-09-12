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
    import com.adobe.cairngorm.navigation.NavigationUtil;

    public class DestinationStateController
    {
        private var _destination:String;

        public function get destination():String
        {
            return _destination;
        }

        public var hasFirstEntered:Boolean;

        public var isSelected:Boolean;

        public var lastDestination:String;

        public var hasEnterInterceptor:Boolean;

        public var hasExitInterceptor:Boolean;
		
		public var isWaypointAvailable:Boolean;

        public function DestinationStateController(destination:String)
        {
            _destination = destination;
        }

        public function reset():void
        {
            hasFirstEntered = false;
            isSelected = false;
            lastDestination = null;
        }

        public function navigateTo(newDestination:String):String
        {
            var action:String;

            if (!isNoDuplicate(newDestination))
            {
                return null;
            }

            if (isFirstEnter(newDestination))
            {
                if (hasEnterInterceptor)
                {
                    action = NavigationActionName.ENTER_INTERCEPT;
                }
                else
                {
                    hasFirstEntered = true;
                    isSelected = true;
                    action = NavigationActionName.FIRST_ENTER;
                }
            }
            else if (isEnter(newDestination))
            {
                if (hasEnterInterceptor)
                {
                    action = NavigationActionName.ENTER_INTERCEPT;
                }
                else
                {
                    isSelected = true;
                    action = NavigationActionName.ENTER;
                }
            }
            else if (isExit(newDestination))
            {
                if (hasExitInterceptor)
                {
                    action = NavigationActionName.EXIT_INTERCEPT;
                }
                else
                {
                    isSelected = false;
                    action = NavigationActionName.EXIT;
                }
            }
            return action;
        }

        public function navigateAway():String
        {
            var action:String;

            if (hasExitInterceptor)
            {
                action = NavigationActionName.EXIT_INTERCEPT;
            }
            else if (isSelected)
            {
                isSelected = false;
                action = NavigationActionName.EXIT;
            }
            else
            {
                action = null;
            }
            return action;
        }

        private function isNoDuplicate(newDestination:String):Boolean
        {
            return (newDestination != lastDestination)
        }

        private function isFirstEnter(newDestination:String):Boolean
        {
            return (!hasFirstEntered && !isSelected && newDestination == destination);
        }

        private function isEnter(newDestination:String):Boolean
        {
            return (hasFirstEntered && !isSelected && newDestination == destination);
        }

        private function isExit(newDestination:String):Boolean
        {
            return (isSelected && newDestination != destination && NavigationUtil.hasSameWaypointAtAnyLevel(newDestination,
                                                                                                            destination));
        }
    }
}