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
	import org.hamcrest.object.equalTo;

	public class NavigationController_InterceptorTest
	{
		private var controller : NavigationController;

		private var content : String = "content";

		private var news : String = "content.news";

		private var messages : String = "content.messages";

		private var tasks : String = "content.tasks";

		private var expenses : String = "content.tasks.expenses";

		private var timetracking : String = "content.tasks.timetracking";

		[Before]
		public function create() : void
		{
			eventHandlerCalled = false;
			eventHandlerCalls = 0;				
			controller = new NavigationController();
		}
		
		private var eventHandlerCalled:Boolean;
		private var eventHandlerCalls:int;
		private function eventHandler(event:Event):void
		{
			eventHandlerCalled = true;
			eventHandlerCalls++;
		}		

		[Test]
		public function whenNavigateToFirstDestinationThenInterceptEnterOnFirst() : void
		{
			controller.registerDestination( news );			
			controller.addEventListener(news + ":" + NavigationActionName.ENTER_INTERCEPT, eventHandler);
			
			controller.navigateTo( news );

			assertThat("eventHandlerCalled", eventHandlerCalled);
		}

		[Test]
		public function shouldEnterInterceptOnNestedDestinations() : void
		{
			controller.registerDestination( content );
			controller.registerDestination( news );

			controller.addEventListener(content + ":" + NavigationActionName.ENTER_INTERCEPT, eventHandler);
			controller.addEventListener(news + ":" + NavigationActionName.ENTER_INTERCEPT, eventHandler);
		
			controller.navigateTo( news );

			controller.unblockEnter( content );
			controller.navigateTo( news );
			controller.unblockEnter( news );
			controller.blockEnter( content );
			controller.blockEnter( news );

			assertThat("eventHandlerCalled", eventHandlerCalled);
			assertThat("calls", eventHandlerCalls, equalTo(2));
		}

		[Test]
		public function shouldExitInterceptOnNestedDestinations() : void
		{
			controller.registerDestination( content );
			controller.registerDestination( news );
			controller.registerDestination( tasks );
			controller.registerDestination( expenses );

			controller.navigateTo( expenses );

			controller.addEventListener(expenses + ":" + NavigationActionName.EXIT_INTERCEPT, eventHandler);
			controller.addEventListener(tasks + ":" + NavigationActionName.EXIT_INTERCEPT, eventHandler);
						

			controller.navigateTo( news );

			controller.unblockExit( expenses );
			controller.navigateTo( news );
			controller.unblockExit( tasks );
			controller.blockExit( expenses );
			controller.blockExit( tasks );

			assertThat("eventHandlerCalled", eventHandlerCalled);
			assertThat("calls", eventHandlerCalls, equalTo(2));
		}

		[Test]
		public function shouldKeepFinalDestinationInEnterInterceptorHierarchy() : void
		{
			controller.registerDestination( news );
			controller.registerDestination( tasks );
			controller.registerDestination( expenses );
			controller.registerDestination( timetracking );
			
			controller.navigateTo( news );

			controller.addEventListener(
				tasks + ":" + NavigationActionName.ENTER_INTERCEPT ,
				dummyHandler );
			controller.addEventListener(
				expenses + ":" + NavigationActionName.ENTER_INTERCEPT ,
				dummyHandler );

			controller.addEventListener(timetracking + ":" + NavigationActionName.ENTER_INTERCEPT, eventHandler);
			controller.addEventListener(timetracking + ":" + NavigationActionName.FIRST_ENTER, eventHandler);
			
			controller.navigateTo( expenses );
			controller.unblockEnter( tasks );
			controller.navigateTo( expenses );
			controller.blockEnter( tasks );

			controller.navigateTo( news );

			controller.navigateTo( timetracking );
			controller.unblockEnter( tasks );
			controller.navigateTo( timetracking , timetracking );
			controller.blockEnter( tasks );

			controller.navigateTo( timetracking );
			controller.unblockEnter( timetracking );
			controller.navigateTo( timetracking , timetracking );
			controller.blockEnter( timetracking );

			assertThat("eventHandlerCalled", eventHandlerCalled);
			assertThat("calls", eventHandlerCalls, equalTo(3));
		}

		[Test]
		public function whenNavigateToSecondDestinationThenInterceptEnterOnSecond() : void
		{
			controller.registerDestination( news );

			controller.addEventListener(
				news + ":" + NavigationActionName.FIRST_ENTER ,
				dummyHandler );

			controller.registerDestination( messages );
			controller.addEventListener(messages + ":" + NavigationActionName.ENTER_INTERCEPT, eventHandler);
				

			controller.registerDestination( messages );
			controller.addEventListener(
				messages + ":" + NavigationActionName.FIRST_ENTER ,
				dummyHandler );

			controller.navigateTo( news );
			controller.navigateTo( messages );

			assertThat("eventHandlerCalled", eventHandlerCalled);
		}

		[Test]
		public function whenNavigateToSecondDestinationThenInterceptExitOnFirst() : void
		{
			controller.registerDestination( news );

			controller.addEventListener(
				news + ":" + NavigationActionName.FIRST_ENTER ,
				dummyHandler );

			controller.registerDestination( news );
			controller.addEventListener(news + ":" + NavigationActionName.EXIT_INTERCEPT, eventHandler);
			
			controller.registerDestination( messages );
			controller.addEventListener(
				messages + ":" + NavigationActionName.FIRST_ENTER ,
				dummyHandler );

			controller.navigateTo( news );
			controller.navigateTo( messages );

			assertThat("eventHandlerCalled", eventHandlerCalled);
		}

		[Test]
		public function whenEnterIsRejectedThenStillAbleToNavigateToDifferentDestination() : void
		{
			controller.registerDestination( news );

			controller.addEventListener(
				news + ":" + NavigationActionName.FIRST_ENTER ,
				dummyHandler );

			controller.registerDestination( news );
			controller.addEventListener(news + ":" + NavigationActionName.ENTER_INTERCEPT, eventHandler);
			
			controller.registerDestination( news );
			controller.addEventListener(news + ":" + NavigationActionName.EXIT_INTERCEPT, eventHandler);
			
			controller.registerDestination( messages );
			controller.addEventListener(messages + ":" + NavigationActionName.FIRST_ENTER, eventHandler);
			
			var success : Boolean = controller.navigateTo( news );
			assertThat( "did not navigate to news" , !success );

			success = controller.navigateTo( messages );
			assertThat( "navigated to messages" , success );

			assertThat("eventHandlerCalled", eventHandlerCalled);
			assertThat("calls", eventHandlerCalls, equalTo(2));
			
			assertThat("eventHandlerCalled", eventHandlerCalled);
		}

		[Test]
		public function shouldHandleEnterAndExitInterceptorsOnOneDestination() : void
		{
			controller.registerDestination( news );

			controller.addEventListener(
				news + ":" + NavigationActionName.FIRST_ENTER ,
				dummyHandler );

			controller.registerDestination( news );
			controller.addEventListener(news + ":" + NavigationActionName.ENTER_INTERCEPT, eventHandler);
						

			controller.registerDestination( news );
			controller.addEventListener(news + ":" + NavigationActionName.EXIT_INTERCEPT, eventHandler);
			
			controller.registerDestination( messages );
			controller.addEventListener(
				messages + ":" + NavigationActionName.FIRST_ENTER ,
				dummyHandler );

			var success : Boolean = controller.navigateTo( news );
			assertThat( "did not navigate to news" , !success );

			//some later time, user proceeds enter navigation
			controller.unblockEnter( news );
			success = controller.navigateTo( news );
			assertThat( "navigated to news" , success );
			controller.blockEnter( news );

			controller.navigateTo( messages );

			assertThat("eventHandlerCalled", eventHandlerCalled);
			assertThat("calls", eventHandlerCalls, equalTo(2));
		}

		private function dummyHandler( event : Event ) : void
		{

		}
	}
}