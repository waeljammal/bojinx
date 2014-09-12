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

    public class NavigationActionName
    {
        public static const FIRST_ENTER:String = "firstEnter";

        public static const ENTER:String = "enter";
		
		public static const EVERY_ENTER:String = "everyEnter";

        public static const EXIT:String = "exit";

        public static const ENTER_INTERCEPT:String = "enterIntercept";

        public static const EXIT_INTERCEPT:String = "exitIntercept";

        public static function getDestination(event:String):String
        {
            return event.split(":")[0] as String;
        }

        public static function getAction(event:String):String
        {
            return event.split(":")[1] as String;
        }

        public static function getEventName(destination:String, action:String):String
        {
            return destination + ":" + action;
        }

        public static function isInterceptor(action:String):Boolean
        {
            return action == ENTER_INTERCEPT || action == EXIT_INTERCEPT;
        }
    }
}