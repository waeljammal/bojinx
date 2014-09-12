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

	public class NavigationController_NestedEnterAndExitTest
	{
		private var controller : NavigationController;

		private var content : String = "content";

		private var tasks : String = "content.tasks";

		private var expenses : String = "content.tasks.expenses";

		private var privateexpenses : String = "content.tasks.expenses.private";

		private var timetracking : String = "content.tasks.timetracking";

		private var news : String = "content.news";

		private var sidebar : String = "sidebar.chat";

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
		public function whenChildFirstEnterThenTriggerParentFirst() : void
		{
			//enter destinations in reading order
			controller.registerDestination( content );
			controller.addEventListener(content + ":" + NavigationActionName.FIRST_ENTER, eventHandler);

			controller.registerDestination( tasks );
			controller.addEventListener(tasks + ":" + NavigationActionName.FIRST_ENTER, eventHandler);

			controller.registerDestination( expenses );
			controller.addEventListener(expenses + ":" + NavigationActionName.FIRST_ENTER, eventHandler);

			controller.navigateTo( expenses );

			assertThat("eventHandlerCalled", eventHandlerCalled);
			assertThat("calls", eventHandlerCalls, equalTo(3));			
		}

		[Test]
		public function whenChildEnterThenTriggerParentFirst() : void
		{
			//enter destinations in reading order
			controller.registerDestination( content );
			controller.addEventListener(content + ":" + NavigationActionName.FIRST_ENTER, eventHandler);
			
			controller.registerDestination( tasks );

			controller.addEventListener(tasks + ":" + NavigationActionName.FIRST_ENTER, eventHandler);
			
			controller.registerDestination( expenses );
			controller.addEventListener(expenses + ":" + NavigationActionName.FIRST_ENTER, eventHandler);

			controller.registerDestination( news );
			controller.addEventListener(news + ":" + NavigationActionName.FIRST_ENTER, eventHandler);
			
			controller.navigateTo( expenses );
			controller.navigateTo( news );

			assertThat("eventHandlerCalled", eventHandlerCalled);
			assertThat("calls", eventHandlerCalls, equalTo(4));
		}

		[Test]
		public function whenANestedDestinationIsReenteredOnAWaypointTriggerNestedLandmarks() : void
		{
			controller.registerDestination( content );
			controller.addEventListener( content + ":" + NavigationActionName.FIRST_ENTER , dummyHandler );
			controller.addEventListener(content + ":" + NavigationActionName.ENTER, eventHandler);
			
			controller.registerDestination( tasks );
			controller.addEventListener( tasks + ":" + NavigationActionName.FIRST_ENTER , dummyHandler );
			controller.addEventListener(tasks + ":" + NavigationActionName.ENTER, eventHandler);

			controller.registerDestination( expenses );
			controller.addEventListener( expenses + ":" + NavigationActionName.FIRST_ENTER , dummyHandler );
			controller.addEventListener(expenses + ":" + NavigationActionName.ENTER, eventHandler);

			controller.registerDestination( news );
			controller.addEventListener( news + ":" + NavigationActionName.FIRST_ENTER , dummyHandler );

			controller.navigateTo( expenses );
			controller.navigateTo( news );

			//now navigate back to waypoint and expect nested landmarks to receive enter events
			controller.navigateTo( tasks );

			assertThat("eventHandlerCalled", eventHandlerCalled);
			assertThat("calls", eventHandlerCalls, equalTo(2));
		}

		[Test]
		public function shouldPreventDuplicateEvents() : void
		{
			controller.registerDestination( content );
			controller.addEventListener( content + ":" + NavigationActionName.FIRST_ENTER , dummyHandler );
			controller.addEventListener(content + ":" + NavigationActionName.EXIT, eventHandler);
			controller.addEventListener(content + ":" + NavigationActionName.ENTER, eventHandler);
			
			
			controller.registerDestination( tasks );
			controller.addEventListener( tasks + ":" + NavigationActionName.FIRST_ENTER , dummyHandler );
			controller.addEventListener(tasks + ":" + NavigationActionName.EXIT, eventHandler);
			controller.addEventListener(tasks + ":" + NavigationActionName.ENTER, eventHandler);

			controller.registerDestination( expenses );
			controller.addEventListener( expenses + ":" + NavigationActionName.FIRST_ENTER , dummyHandler );
			controller.addEventListener(expenses + ":" + NavigationActionName.EXIT, eventHandler);
			controller.addEventListener(expenses + ":" + NavigationActionName.ENTER, eventHandler);

			controller.navigateTo( expenses );
			controller.navigateTo( expenses );

			assertThat("eventHandlerCalled", !eventHandlerCalled);
		}

		[Test]
		public function whenNavigateToSiblingLandmarkThenOnlyEnterSubsetLandmark() : void
		{
			controller.registerDestination( content );
			controller.addEventListener( content + ":" + NavigationActionName.FIRST_ENTER , dummyHandler );
			controller.addEventListener(content + ":" + NavigationActionName.EXIT, eventHandler);
			controller.addEventListener(content + ":" + NavigationActionName.ENTER, eventHandler);

			controller.registerDestination( tasks );
			controller.addEventListener( tasks + ":" + NavigationActionName.FIRST_ENTER , dummyHandler );
			controller.addEventListener(tasks + ":" + NavigationActionName.EXIT, eventHandler);
			controller.addEventListener(tasks + ":" + NavigationActionName.ENTER, eventHandler);			

			controller.registerDestination( expenses );
			controller.addEventListener( expenses + ":" + NavigationActionName.FIRST_ENTER , dummyHandler );
			controller.addEventListener(expenses + ":" + NavigationActionName.EXIT, eventHandler);
			controller.addEventListener(expenses + ":" + NavigationActionName.ENTER, eventHandler);			

			controller.registerDestination( timetracking );
			controller.addEventListener( timetracking + ":" + NavigationActionName.FIRST_ENTER , dummyHandler );
			controller.addEventListener(expenses + ":" + NavigationActionName.ENTER, eventHandler);	
			
			controller.navigateTo( expenses );
			controller.navigateTo( timetracking );

			assertThat("eventHandlerCalled", eventHandlerCalled);
			assertThat("calls", eventHandlerCalls, equalTo(1));
		}

		[Test]
		public function whenChildExitThenTriggerChildFirst() : void
		{
			//exit destinations in reverse order
			controller.registerDestination( expenses );
			controller.addEventListener(expenses + ":" + NavigationActionName.EXIT, eventHandler);	

			controller.registerDestination( tasks );
			controller.addEventListener(tasks + ":" + NavigationActionName.EXIT, eventHandler);	

			controller.registerDestination( content );
			controller.addEventListener(content + ":" + NavigationActionName.EXIT, eventHandler);	

			controller.registerDestination( news );
			controller.addEventListener(news + ":" + NavigationActionName.FIRST_ENTER, eventHandler);	

			controller.navigateTo( expenses );
			controller.navigateTo( news );

			assertThat("eventHandlerCalled", eventHandlerCalled);
			assertThat("calls", eventHandlerCalls, equalTo(3));
		}

		[Test]
		public function whenNavigateToUnkownDestinationThenExit() : void
		{
			controller.registerDestination( tasks );
			controller.addEventListener( tasks + ":" + NavigationActionName.FIRST_ENTER , dummyHandler );

			controller.registerDestination( news );
			controller.addEventListener(news + ":" + NavigationActionName.EXIT, eventHandler);	

			controller.navigateTo( news );
			controller.navigateTo( expenses );

			assertThat("eventHandlerCalled", eventHandlerCalled);
		}

		[Test]
		public function whenNavigateToUnkownDestinationWith2NestLevelsThenExit() : void
		{
			controller.registerDestination( tasks );
			controller.addEventListener( tasks + ":" + NavigationActionName.FIRST_ENTER , dummyHandler );

			controller.registerDestination( news );
			controller.addEventListener(news + ":" + NavigationActionName.EXIT, eventHandler);	

			controller.navigateTo( news );
			controller.navigateTo( privateexpenses );

			assertThat("eventHandlerCalled", eventHandlerCalled);
		}

		[Test]
		public function shouldNavigateBackAndFourth() : void
		{
			controller.registerDestination( news );
			controller.addEventListener(news + ":" + NavigationActionName.ENTER, eventHandler);	
			controller.addEventListener(news + ":" + NavigationActionName.ENTER, eventHandler);	

			controller.registerDestination( expenses );
			controller.addEventListener( expenses + ":" + NavigationActionName.ENTER , dummyHandler );

			controller.navigateTo( news );
			controller.navigateTo( expenses );
			controller.navigateTo( news );
			controller.navigateTo( expenses );
			controller.navigateTo( news );

			assertThat("eventHandlerCalled", eventHandlerCalled);
			assertThat("calls", eventHandlerCalls, equalTo(2));
		}

		private function dummyHandler( event : Event ) : void
		{

		}
	}
}