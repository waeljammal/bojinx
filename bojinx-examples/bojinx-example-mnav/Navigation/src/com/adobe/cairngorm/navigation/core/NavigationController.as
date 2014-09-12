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
	
	import flash.events.EventDispatcher;

	[Event(name="lastEnterInterceptor", type="com.adobe.cairngorm.navigation.core.LastInterceptorEvent")]
	public class NavigationController extends EventDispatcher implements INavigationRegistry
	{
		public function get hasAnyDestinations():Boolean
		{
			return destinations.hasAnyDestinations;
		}

		public function get lastDestination():String
		{
			return enterAndExitInvoker.lastDestination;
		}

		public var destinations:DestinationRegistry;
		private var enterAndExitInvoker:EnterAndExitInvoker;

		public function NavigationController()
		{
			destinations=new DestinationRegistry(this);
			enterAndExitInvoker=new EnterAndExitInvoker(this, destinations);
			enterAndExitInvoker.addEventListener(LastInterceptorEvent.LAST_ENTER_INTERCEPTOR, dispatchEvent);
		}

		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			destinations.addEventListenerInterceptor(type);

			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		public function registerDestination(destination:String, action:String=null):Boolean
		{
			var hasRegistered:Boolean=destinations.registerDestination(destination);

			var isPending:Boolean=destinations.isPending(destination);
			var isFirstEnter:Boolean=action == NavigationActionName.FIRST_ENTER;
			if (isPending && isFirstEnter)
			{
				//for new (loaded) landmarks that were being called before (pending).
				navigateTo(destination);
			}
			return hasRegistered;
		}

		public function unregisterDestination(destination:String):void
		{
			destinations.unregisterDestination(destination);
		}

		public function hasDestination(destination:String):Boolean
		{
			return destinations.hasDestination(destination);
		}

		public function unblockEnter(destination:String):void
		{
			destinations.unblockEnter(destination);
		}

		public function unblockExit(destination:String):void
		{
			destinations.unblockExit(destination);
		}

		public function blockEnter(destination:String):void
		{
			destinations.blockEnter(destination);
		}

		public function blockExit(destination:String):void
		{
			destinations.blockExit(destination);
		}

		public function navigateTo(newDestination:String, finalDestination:String=null):Boolean
		{
			var success:Boolean;

			var item:DestinationStateController=destinations.getValidDestination(newDestination);
			if (item == null)
			{
				return false;
			}

			//find out what last destination interceptor is. If found, event is dispatched.
			enterAndExitInvoker.findLastInterceptor(newDestination, finalDestination);

			var hasExitIntercept:Boolean=enterAndExitInvoker.applyExits(newDestination);
			if (hasExitIntercept)
			{
				return false;
			}

			var hasEnterIntercept:Boolean=enterAndExitInvoker.applyEnters(newDestination, finalDestination);

			success=!hasEnterIntercept

			return success;
		}

		public function navigateAway(destination:String):Boolean
		{
			var success:Boolean;

			var hasExitIntercept:Boolean=enterAndExitInvoker.applyExit(destination);
			if (hasExitIntercept)
			{
				return false;
			}

			success=!hasExitIntercept

			return success;
		}

		public function reset(newDestination:String):void
		{
			enterAndExitInvoker.reset(newDestination);
		}
	}
}