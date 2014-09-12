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
	
	import org.flexunit.Assert;
	import org.flexunit.assertThat;

	public class NavigationController_ResetTest
	{
		private var controller:NavigationController;

		private var content:String="content";

		private var news:String="content.news";

		private var messages:String="content.messages";

		private var sidebar:String="sidebar.chat";

		[Before]
		public function create():void
		{
			reset();
			controller=new NavigationController();
		}

		private function reset():void
		{
			eventHandlerCalled=false;
			eventHandlerCalls=0;
		}

		private var eventHandlerCalled:Boolean;
		private var eventHandlerCalls:int;

		private function eventHandler(event:Event):void
		{
			eventHandlerCalled=true;
			eventHandlerCalls++;
		}

		[Test]
		public function whenNavigateToFirstDestinationThenResetAndHandleFirstEnterAgain():void
		{
			controller.registerDestination(news);
			controller.addEventListener(news + ":" + NavigationActionName.FIRST_ENTER, eventHandler);

			controller.navigateTo(news);

			assertThat("first eventHandlerCalled", eventHandlerCalled);
			Assert.assertEquals("first eventHandlerCalls", 1, eventHandlerCalls);
			reset();

			controller.reset(news);
			controller.navigateTo(news);

			assertThat("second eventHandlerCalled", eventHandlerCalled);
			Assert.assertEquals("second eventHandlerCalls", 1, eventHandlerCalls);
			reset();

			controller.reset(news);
			controller.navigateTo(news);

			assertThat("third eventHandlerCalled", eventHandlerCalled);
			Assert.assertEquals("third eventHandlerCalls", 1, eventHandlerCalls);
		}

		private function dummyHandler(event:Event):void
		{

		}
	}
}