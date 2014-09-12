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
package com.adobe.cairngorm.navigation
{
	import flash.events.Event;

	public class NavigationEvent extends Event
	{
		//------------------------------------------------------------------------
		//
		//  Constants
		//
		//------------------------------------------------------------------------

		public static const NAVIGATE_TO:String="navigateTo";
		public static const NAVIGATE_AWAY:String="navigateAway";

		//------------------------------------------------------------------------
		//
		//  Static Factory Methods
		//
		//------------------------------------------------------------------------

		[Deprecated(replacement="com.adobe.cairngorm.navigation.NavigationEvent.createNavigateToEvent()", since="1.0")]	
		public static function newNavigateToEvent(destination:String):NavigationEvent
		{
			return createNavigateToEvent(destination);
		}

		[Deprecated(replacement="com.adobe.cairngorm.navigation.NavigationEvent.createNavigateAwayEvent()", since="1.0")]	
		public static function newNavigateAwayEvent(destination:String):NavigationEvent
		{
			return createNavigateAwayEvent(destination);
		}
				
		public static function createNavigateToEvent(destination:String):NavigationEvent
		{
			var event:NavigationEvent=new NavigationEvent(NAVIGATE_TO, destination);
			return event;
		}
		
		public static function createNavigateAwayEvent(destination:String):NavigationEvent
		{
			var event:NavigationEvent=new NavigationEvent(NAVIGATE_AWAY, destination);
			return event;
		}		

		//------------------------------------------------------------------------
		//
		//  Constructor
		//
		//------------------------------------------------------------------------

		public function NavigationEvent(type:String, destination:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_destination=destination;
		}

		//------------------------------------------------------------------------
		//
		//  Properties
		//
		//------------------------------------------------------------------------

		//-------------------------------
		//  destination
		//-------------------------------

		private var _destination:String;

		/**
		 * The destination to navigate to. This is a compound string with the
		 * following form "waypoint.direction", where waypoint is a named and
		 * registered waypoint, and direction is one of the available directions
		 * for that waypoint.
		 */
		[ModuleId]
		public function get destination():String
		{
			return _destination;
		}

		//-------------------------------
		//  waypoint
		//-------------------------------

		public function get waypoint():String
		{
			return NavigationUtil.getParent(_destination);
		}

		//------------------------------------------------------------------------
		//
		//  Overrides : Event
		//
		//------------------------------------------------------------------------

		override public function clone():Event
		{
			var event:NavigationEvent=new NavigationEvent(type, destination, bubbles, cancelable);
			return event;
		}
	}
}