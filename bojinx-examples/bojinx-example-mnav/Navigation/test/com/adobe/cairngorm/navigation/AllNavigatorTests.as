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
	import com.adobe.cairngorm.navigation.core.DestinationRegistryTest;
	import com.adobe.cairngorm.navigation.core.DestinationStateController_EnterInterceptorTest;
	import com.adobe.cairngorm.navigation.core.DestinationStateController_EnterTest;
	import com.adobe.cairngorm.navigation.core.DestinationStateController_ExitInterceptorTest;
	import com.adobe.cairngorm.navigation.core.DestinationStateController_ExitTest;
	import com.adobe.cairngorm.navigation.core.DestinationStateController_FirstEnterTest;
	import com.adobe.cairngorm.navigation.core.LastDestinationTrackerTest;
	import com.adobe.cairngorm.navigation.core.NavigationController_DestinationChangeTest;
	import com.adobe.cairngorm.navigation.core.NavigationController_EnterAndExitTest;
	import com.adobe.cairngorm.navigation.core.NavigationController_EveryEnterTest;
	import com.adobe.cairngorm.navigation.core.NavigationController_InterceptorTest;
	import com.adobe.cairngorm.navigation.core.NavigationController_NavigateAwayTest;
	import com.adobe.cairngorm.navigation.core.NavigationController_NestedEnterAndExitTest;
	import com.adobe.cairngorm.navigation.core.NavigationController_ResetTest;
	import com.adobe.cairngorm.navigation.core.NavigationController_WaypointChangeTest;
	import com.adobe.cairngorm.navigation.history.GlobalHistoryTest;
	import com.adobe.cairngorm.navigation.history.WaypointHistoryTest;
	import com.adobe.cairngorm.navigation.state.SelectedStatesFactoryTest;
	import com.adobe.cairngorm.navigation.state.SelectedStatesTest;
	import com.adobe.cairngorm.navigation.waypoint.WaypointHandler_SelectedChild_Test;
	import com.adobe.cairngorm.navigation.waypoint.WaypointHandler_States_Test;
	import com.adobe.cairngorm.navigation.wizard.WizardTest;

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class AllNavigatorTests
	{
		//waypoint
		public var waypointHandler_SelectedChild_Test:WaypointHandler_SelectedChild_Test;		
		public var waypointHandler_States_Test:WaypointHandler_States_Test;		
		
		public var navigationUtilTest:NavigationUtilTest;

		public var waypointHistoryTest:WaypointHistoryTest;
		public var globalHistoryTest:GlobalHistoryTest;

		public var wizard:WizardTest;
		
		//Core		
		public var destinationRegistryTest:DestinationRegistryTest;
		public var lastDestinationTrackerTest:LastDestinationTrackerTest;
		public var waypointChangeTest:NavigationController_WaypointChangeTest;
		public var destinationChangeTest:NavigationController_DestinationChangeTest;
		public var navigationControllerEnterAndExit:NavigationController_EnterAndExitTest;
		public var navigationController_NavigateAwayTest:NavigationController_NavigateAwayTest;
		public var navigationController_ResetTest:NavigationController_ResetTest;
		public var navigationController_EveryEnterTest:NavigationController_EveryEnterTest;
		public var navigationControllerNestedEnterAndExit:NavigationController_NestedEnterAndExitTest
		public var navigationControllerInterceptor:NavigationController_InterceptorTest;
		public var firstEnter:DestinationStateController_FirstEnterTest;
		public var enter:DestinationStateController_EnterTest;
		public var exit:DestinationStateController_ExitTest;
		public var enterInterceptor:DestinationStateController_EnterInterceptorTest;
		public var exitInterceptor:DestinationStateController_ExitInterceptorTest;
		
		//state
		public var waypointStatesFactory:SelectedStatesFactoryTest;
		public var waypointStatesTest:SelectedStatesTest;
	}
}