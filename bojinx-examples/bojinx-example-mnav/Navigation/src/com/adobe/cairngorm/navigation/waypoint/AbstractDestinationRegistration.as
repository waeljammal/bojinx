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
    import com.adobe.cairngorm.navigation.core.INavigationRegistry;
    
    import flash.events.EventDispatcher;
    
    import mx.core.UIComponent;

    [Event(name="waypointFound", type="com.adobe.cairngorm.navigation.waypoint.WaypointEvent")]
    public class AbstractDestinationRegistration extends EventDispatcher
    {
        public static const WAYPOINT_FOUND:String = "waypointFound";

		public function initialize(controller:INavigationRegistry, name:String=null):void
		{
			this.controller = controller;
			_waypointName = name;
		}
				
		protected var controller:INavigationRegistry;
		
		
		protected var _waypointName:String;		
		public function get waypointName():String
		{
			return _waypointName;
		}		
		
		
		public function registerDestinations(view:UIComponent):void
		{
			_view = view;
			onRegisterDestinations();
		}
		
		private var _view:UIComponent;		
		protected function get view():UIComponent
		{
			return _view;
		}
		
		public function onRegisterDestinations():void
		{
			throw new Error("Abstract");
		}
		
		
		public function unregisterDestinations():void
		{
			for each (var destination:String in destinations)
			{
				controller.unregisterDestination(destination);
			}
			destinations = null;
		}
		
        [ArrayElementType("String")]
        protected var destinations:Array = new Array();
		
		protected var _hasRegisteredChildren:Boolean;
        public function get hasRegisteredChildren():Boolean
        {
            return _hasRegisteredChildren;
        }		

    }
}