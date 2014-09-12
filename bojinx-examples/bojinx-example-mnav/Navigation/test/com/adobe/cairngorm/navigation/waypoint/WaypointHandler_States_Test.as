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
	import com.adobe.cairngorm.navigation.NavigationEvent;
	import com.adobe.cairngorm.navigation.core.NavigationActionEvent;
	import com.adobe.cairngorm.navigation.core.NavigationController;
	
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	import mx.events.StateChangeEvent;
	
	import org.flexunit.Assert;
	import org.flexunit.assertThat;
	import org.flexunit.async.Async;
	import org.fluint.uiImpersonation.UIImpersonator;
	import org.hamcrest.object.equalTo;
	
	public class WaypointHandler_States_Test
	{
		private static var LONG_TIME:int = 2500;
		
		private var container:StatesContainer;
		
		private var controller:NavigationController;
		
		[Before(async,ui)]
		public function setUp():void
		{
			controller = new NavigationController();
			
			container = new StatesContainer();
			Async.proceedOnEvent(this, container, FlexEvent.CREATION_COMPLETE, LONG_TIME);
			UIImpersonator.addChild(container);
		}	
		
		[After(async,ui)]
		public function tearDown():void
		{
			UIImpersonator.removeChild(container);
			container = null;
		}

		private function createHandler():WaypointHandler
		{
			var handler:WaypointHandler = new WaypointHandler(controller, "content")
			return handler;
		}		
		
		[Test]
		public function shouldDispatchByDefault():void
		{
			var handler:WaypointHandler = createHandler();
			handler.addEventListener(NavigationEvent.NAVIGATE_TO, eventHandler);
			handler.createWaypoint(container, "states", null, isWaypointType);
			
			assertThat("eventHandlerCalledFromView", eventHandlerCalled);
			assertThat("eventHandlerCalledFromView calls", eventHandlerCalls, equalTo(1));
		}
		
		[Test(async)]
		public function whenViewNavigatesThenDispatchEvent():void
		{
			var handler:WaypointHandler = createHandler();
			handler.addEventListener(NavigationEvent.NAVIGATE_TO, eventHandler);	
			handler.createWaypoint(container, "states", null, isWaypointType);
			
			Async.handleEvent(this, container, StateChangeEvent.CURRENT_STATE_CHANGE, whenViewNavigatesThenDispatchEventHandler, LONG_TIME);
			container.currentState = "messages";
		}
		
		private function whenViewNavigatesThenDispatchEventHandler(event:Event, passThroughData:Object):void 
		{
			assertThat("eventHandlerCalled", eventHandlerCalled);
			assertThat("eventHandlerCalls", eventHandlerCalls, equalTo(2));			
		}
		
		[Test(async)]
		public function whenFrameworkNavigatesThenChangeView():void
		{
			var handler:WaypointHandler = createHandler();
			handler.createWaypoint(container, "states", null, isWaypointType);
			
			Async.handleEvent(this, container, StateChangeEvent.CURRENT_STATE_CHANGE, whenFrameworkNavigatesThenChangeViewHandler, LONG_TIME);
						
			var event:NavigationActionEvent = new NavigationActionEvent("content", ContentDestination.CONTACTS, ContentDestination.MESSAGES, ContentDestination.MESSAGES);
			controller.dispatchEvent(event);			
		}
		
		private function whenFrameworkNavigatesThenChangeViewHandler(event:Event, passThroughData:Object):void 
		{
			Assert.assertEquals("currentState", container.currentState, "messages");		
		}		
		
		private var eventHandlerCalled:Boolean;
		private var eventHandlerCalls:int;
		private function eventHandler(event:Event):void
		{
			eventHandlerCalled = true;
			eventHandlerCalls++;
		}	
		
		private function isWaypointType(waypointType:Class):Boolean
		{
			return true;
		}			
	}
}