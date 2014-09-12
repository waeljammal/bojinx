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

	import org.flexunit.assertThat;
	import org.hamcrest.object.IsEqualMatcher;
	import org.hamcrest.object.equalTo;

	public class NavigationController_DestinationChangeTest
	{
		private var controller:NavigationController;

		private var news:String="content.news";

		private var messages:String="content.messages";

		private var sidebar:String="sidebar.chat";

		[Before]
		public function create():void
		{
			eventHandlerCalled=false;
			eventHandlerCalls=0;
			controller=new NavigationController();
		}

		private var eventHandlerCalled:Boolean;
		private var eventHandlerCalls:int;

		private function eventHandler(event:Event):void
		{
			eventHandlerCalled=true;
			eventHandlerCalls++;
		}

		[Test]
		public function whenNavigateToFirstDestinationThenExpectDestinationChange():void
		{
			controller.registerDestination(news);
			controller.addEventListener("content", eventHandler);

			controller.navigateTo(news);

			assertThat("eventHandlerCalled", eventHandlerCalled);
		}

		[Test]
		public function whenNavigateToSecondDestinationThenHandleDestinationChange():void
		{
			controller.registerDestination(news);
			controller.registerDestination(messages);

			controller.addEventListener("content", eventHandler);

			controller.navigateTo(news);
			controller.navigateTo(messages);

			assertThat("eventHandlerCalled", eventHandlerCalled);
			assertThat("calls", eventHandlerCalls, equalTo(2));
		}

		[Test]
		public function whenNavigateToNewWaypointThenDoNotExpectDestinationChange():void
		{
			controller.registerDestination(news);
			controller.addEventListener("content", eventHandler);

			controller.registerDestination(sidebar);
			controller.addEventListener("sidebar", eventHandler);

			controller.navigateTo(news);
			controller.navigateTo(sidebar);

			assertThat("eventHandlerCalled", eventHandlerCalled);
			assertThat("calls", eventHandlerCalls, equalTo(2));
		}

		private function dummyHandler(event:Event):void
		{

		}
	}
}