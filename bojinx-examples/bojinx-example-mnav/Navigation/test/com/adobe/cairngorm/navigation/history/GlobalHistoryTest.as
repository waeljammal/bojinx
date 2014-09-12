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
package com.adobe.cairngorm.navigation.history
{
    import com.adobe.cairngorm.navigation.NavigationEvent;

    import flash.events.Event;

    import flexunit.framework.Assert;

    import org.flexunit.assertThat;

    public class GlobalHistoryTest
    {
        private var eventsDispatched:int;

        private var historyEventsDispatched:int;

        private var lastDestinationDispatched:String;

        private var history:AbstractGlobalHistory;

        private var waypoint1:String = "content";

        private var waypoint2:String = "sidebar";

        private var contentStage1:String = "content.stage1";

        private var contentStage2:String = "content.stage2";

        private var contentStage3:String = "content.stage3";

        private var sidebarStage1:String = "sidebar.stage1";

        private var sidebarStage2:String = "sidebar.stage2";

        private var sidebarStage3:String = "sidebar.stage3";

        [Before]
        public function givenHistoryWithTwoWaypoints():void
        {
            history = new AbstractGlobalHistory();
            history.addEventListener(NavigationEvent.NAVIGATE_TO, handleNavigation);
        }

        [After]
        public function resetEvents():void
        {
            eventsDispatched = 0;
            lastDestinationDispatched = null;
            history.removeEventListener(NavigationEvent.NAVIGATE_TO, handleNavigation);
            history.removeEventListener(AbstractHistory.HISTORY_CHANGE, handleHistoryChange);
        }

        [Test]
        public function whenOnlyOneWaypointInitializesThenCannotUseHistory():void
        {
            history.onNavigateTo(NavigationEvent.createNavigateToEvent(contentStage1));

            assertThat("hasPrevious", !history.hasPrevious);
            assertThat("hasNext", !history.hasNext);
        }

        [Test]
        public function whenOnlyTwoWaypointsInitializeButNoneMovesThenCannotUseHistory():void
        {
            history.onNavigateTo(NavigationEvent.createNavigateToEvent(contentStage1));
            history.onNavigateTo(NavigationEvent.createNavigateToEvent(sidebarStage1));

            assertThat("hasPrevious", !history.hasPrevious);
            assertThat("hasNext", !history.hasNext);
        }

        [Test]
        public function whenBothWaypointsThenCanMoveBackward():void
        {
            history.onNavigateTo(NavigationEvent.createNavigateToEvent(contentStage1));
            history.onNavigateTo(NavigationEvent.createNavigateToEvent(sidebarStage1));

            history.onNavigateTo(NavigationEvent.createNavigateToEvent(contentStage2));

            assertThat("hasPrevious", history.hasPrevious);
            assertThat("hasNext", !history.hasNext);

            history.previous();
            Assert.assertEquals(1, eventsDispatched);
            Assert.assertEquals(contentStage1, lastDestinationDispatched);
        }

        [Test]
        public function whenBothWaypointsThenCanMoveBackwardAndForward():void
        {
            history.onNavigateTo(NavigationEvent.createNavigateToEvent(contentStage1));
            history.onNavigateTo(NavigationEvent.createNavigateToEvent(sidebarStage1));

            history.onNavigateTo(NavigationEvent.createNavigateToEvent(contentStage2));

            history.previous();
            assertThat("hasNext", history.hasNext);

            history.next();
            assertThat("hasPrevious", history.hasPrevious);
            Assert.assertEquals(2, eventsDispatched);
            Assert.assertEquals(contentStage2, lastDestinationDispatched);
        }

        [Test]
        public function whenNavigatingBackwardSkipViewThatIsAlreadyShown():void
        {
            history.onNavigateTo(NavigationEvent.createNavigateToEvent(contentStage1));
            history.onNavigateTo(NavigationEvent.createNavigateToEvent(contentStage2));
            history.onNavigateTo(NavigationEvent.createNavigateToEvent(sidebarStage1));
            history.onNavigateTo(NavigationEvent.createNavigateToEvent(sidebarStage2));

            history.previous();
            Assert.assertEquals(sidebarStage1, lastDestinationDispatched);

            //note this call skips contentStage2 because it is 
            //assumed that it is already shown (keeps state)
            history.previous();
            Assert.assertEquals(contentStage1, lastDestinationDispatched);
            assertThat("hasPrevious", !history.hasPrevious);
        }

        [Test]
        public function whenNavigatingForwardSkipViewThatIsAlreadyShown():void
        {
            history.onNavigateTo(NavigationEvent.createNavigateToEvent(contentStage1));
            history.onNavigateTo(NavigationEvent.createNavigateToEvent(contentStage2));
            history.onNavigateTo(NavigationEvent.createNavigateToEvent(sidebarStage1));
            history.onNavigateTo(NavigationEvent.createNavigateToEvent(sidebarStage2));

            history.previous();
            history.previous();
            history.next();
            Assert.assertEquals(contentStage2, lastDestinationDispatched);

            //note this call skips sidebarStage1 because it is 
            //assumed that it is already shown (keeps state)
            history.next();
            Assert.assertEquals(sidebarStage2, lastDestinationDispatched);
            assertThat("hasNext", !history.hasNext);
        }

        [Test]
        public function whenReceivesInitialEventDuplicateThenIgnore():void
        {
            history.addEventListener(AbstractHistory.HISTORY_CHANGE, handleHistoryChange);

            history.onNavigateTo(NavigationEvent.createNavigateToEvent(contentStage1));
            history.onNavigateTo(NavigationEvent.createNavigateToEvent(sidebarStage1));

            history.onNavigateTo(NavigationEvent.createNavigateToEvent(contentStage1));

            assertThat("destination duplicate", !history.hasPrevious);
            Assert.assertEquals("historyEventsDispatched",
                                2, historyEventsDispatched);
        }

        [Test]
        public function whenReceivesEventDuplicateThenIgnore():void
        {
            history.addEventListener(AbstractHistory.HISTORY_CHANGE, handleHistoryChange);

            history.onNavigateTo(NavigationEvent.createNavigateToEvent(contentStage1));
            history.onNavigateTo(NavigationEvent.createNavigateToEvent(sidebarStage1));

            history.onNavigateTo(NavigationEvent.createNavigateToEvent(contentStage2));
            history.onNavigateTo(NavigationEvent.createNavigateToEvent(contentStage2));

            Assert.assertEquals("destination duplicate",
                                3, historyEventsDispatched);
        }

        [Test]
        public function whenNavigateToNewPathWithinHistoryThenClearFutureHistory():void
        {
            history.onNavigateTo(NavigationEvent.createNavigateToEvent(contentStage1));
            history.onNavigateTo(NavigationEvent.createNavigateToEvent(contentStage2));

            history.previous();
            assertThat("should have future history", history.hasNext);

            //new path
            history.onNavigateTo(NavigationEvent.createNavigateToEvent(contentStage3));

            assertThat("should clear future history", !history.hasNext);
        }

        [Test]
        public function exitInterceptorDeniesNavigationThenRewind():void
        {
            history.removeEventListener(NavigationEvent.NAVIGATE_TO, handleNavigation);

            history.onNavigateTo(NavigationEvent.createNavigateToEvent(contentStage1));
            history.onNavigateTo(NavigationEvent.createNavigateToEvent(contentStage2));

            history.previous();
            assertThat("expect to be able to move backwards", history.hasPrevious);
        }

        [Test]
        public function exitInterceptorAcceptsNavigationThenProceed():void
        {
            history.onNavigateTo(NavigationEvent.createNavigateToEvent(contentStage1));
            history.onNavigateTo(NavigationEvent.createNavigateToEvent(contentStage2));

            history.previous();
            assertThat("navigation approved, cannot move further", !history.hasPrevious);
            assertThat("navigation approved, can move forward", history.hasNext);
        }

        private function handleHistoryChange(event:Event):void
        {
            if (event.type == AbstractHistory.HISTORY_CHANGE)
            {
                historyEventsDispatched++;
            }
        }

        private function handleNavigation(event:NavigationEvent):void
        {
            if (event.type == NavigationEvent.NAVIGATE_TO)
            {
                eventsDispatched++;
                lastDestinationDispatched = event.destination;
                history.onNavigateTo(event);
            }
        }
    }
}