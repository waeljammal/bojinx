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

    import flexunit.framework.Assert;

    import org.flexunit.assertThat;
    import org.hamcrest.object.equalTo;

    public class WaypointHistoryTest
    {
        private var eventsDispatched:int;

        private var lastDestinationDispatched:String;

        private var history:AbstractWaypointHistory;

        private var waypoint:String = "myHistory";

        private var stage1:String = "myHistory.stage1";

        private var stage2:String = "myHistory.stage2";

        private var stage3:String = "myHistory.stage3";

        [Before]
        public function givenHistory():void
        {
            history = new AbstractWaypointHistory();
            history.waypoint = "myHistory";
        }

        [After]
        public function resetEvents():void
        {
            eventsDispatched = 0;
            lastDestinationDispatched = null;
            history.removeEventListener(NavigationEvent.NAVIGATE_TO, handleNavigation);
        }

        [Test]
        public function whenNoNavigationThenCanNotMove():void
        {
            history = new AbstractWaypointHistory();
            history.addEventListener(NavigationEvent.NAVIGATE_TO, handleNavigation);

            assertThat(!history.hasNext);
            assertThat(!history.hasPrevious);
        }

        [Test]
        public function whenFirstNavigationThenCannotMove():void
        {
            history.addEventListener(NavigationEvent.NAVIGATE_TO, handleNavigation);

            history.onNavigateTo(NavigationEvent.createNavigateToEvent(stage1));

            assertThat("hasPrevious", !history.hasPrevious);
            assertThat("hasNext", !history.hasNext);
            history.previous();

            Assert.assertEquals(0, eventsDispatched);
        }

        [Test]
        public function whenSecondNavigationThenCanMoveBackward():void
        {
            history.addEventListener(NavigationEvent.NAVIGATE_TO, handleNavigation);

            history.onNavigateTo(NavigationEvent.createNavigateToEvent(stage1));
            history.onNavigateTo(NavigationEvent.createNavigateToEvent(stage2));

            assertThat("hasPrevious", history.hasPrevious);
            assertThat("hasNext", !history.hasNext);
            history.previous();

            Assert.assertEquals(1, eventsDispatched);
            Assert.assertEquals(stage1, lastDestinationDispatched);
        }


        [Test]
        public function whenReceivesEventsWithDifferentWaypointsThenIgnore():void
        {
            history.addEventListener(NavigationEvent.NAVIGATE_TO, handleNavigation);

            var waypoint:String = "differntWaypoint.stage1";

            history.onNavigateTo(NavigationEvent.createNavigateToEvent(stage1));
            history.onNavigateTo(NavigationEvent.createNavigateToEvent(waypoint));

            assertThat("wrong waypiont handled", !history.hasPrevious);
        }

        [Test]
        public function whenReceivesEventWithPreviousDestinationThenIgnore():void
        {
            history.addEventListener(NavigationEvent.NAVIGATE_TO, handleNavigation);

            history.onNavigateTo(NavigationEvent.createNavigateToEvent(stage1));
            history.onNavigateTo(NavigationEvent.createNavigateToEvent(stage1));

            assertThat("wrong waypoint handled", !history.hasPrevious);
        }

        [Test]
        public function whenSecondNavigationThenCanMoveBackwardAndForward():void
        {
            history.addEventListener(NavigationEvent.NAVIGATE_TO, handleNavigation);

            history.onNavigateTo(NavigationEvent.createNavigateToEvent(stage1));
            history.onNavigateTo(NavigationEvent.createNavigateToEvent(stage2));

            history.previous();

            assertThat("hasNext", history.hasNext);
            history.next();
            Assert.assertEquals(2, eventsDispatched);
            Assert.assertEquals(stage2, lastDestinationDispatched);
        }

        [Test]
        public function whenAtLastItemThenCannotMoveFurther():void
        {
            history.addEventListener(NavigationEvent.NAVIGATE_TO, handleNavigation);

            history.onNavigateTo(NavigationEvent.createNavigateToEvent(stage1));
            history.onNavigateTo(NavigationEvent.createNavigateToEvent(stage2));
            history.onNavigateTo(NavigationEvent.createNavigateToEvent(stage3));

            history.previous();
            history.previous();

            assertThat("hasPrevious", !history.hasPrevious);
            history.previous();

            Assert.assertEquals(2, eventsDispatched);
            Assert.assertEquals(stage1, lastDestinationDispatched);
        }

        [Test]
        public function whenAtLastItemThenCanMoveBackward():void
        {
            history.addEventListener(NavigationEvent.NAVIGATE_TO, handleNavigation);

            history.onNavigateTo(NavigationEvent.createNavigateToEvent(stage1));
            history.onNavigateTo(NavigationEvent.createNavigateToEvent(stage2));
            history.onNavigateTo(NavigationEvent.createNavigateToEvent(stage3));

            history.previous();
            history.previous();

            assertThat("hasNext", history.hasNext);
            history.next();

            Assert.assertEquals(3, eventsDispatched);
            Assert.assertEquals(stage2, lastDestinationDispatched);
        }

        [Test]
        public function whenNavigateToNewPathWithinHistoryThenClearFutureHistory():void
        {
            history.addEventListener(NavigationEvent.NAVIGATE_TO, handleNavigation);

            history.onNavigateTo(NavigationEvent.createNavigateToEvent(stage1));
            history.onNavigateTo(NavigationEvent.createNavigateToEvent(stage2));

            history.previous();
            assertThat("should have future history", history.hasNext);

            //new path
            history.onNavigateTo(NavigationEvent.createNavigateToEvent(stage3));

            assertThat("should clear future history", !history.hasNext);
        }

        [Test]
        public function whenNavigateToNewPathWithinHistoryThenAllowPastHistory():void
        {
            history.addEventListener(NavigationEvent.NAVIGATE_TO, handleNavigation);

            history.onNavigateTo(NavigationEvent.createNavigateToEvent(stage1));
            history.onNavigateTo(NavigationEvent.createNavigateToEvent(stage2));

            assertThat("should have past history", history.hasPrevious);
            history.previous();
            assertThat("should not have past history", !history.hasPrevious);

            //new path
            history.onNavigateTo(NavigationEvent.createNavigateToEvent(stage3));

            assertThat("should have past history 2", history.hasPrevious);
            history.previous();
            assertThat("should not have past history 2", !history.hasPrevious);
        }

        [Test]
        public function exitInterceptorDeniesNavigationThenRewind():void
        {
            history.onNavigateTo(NavigationEvent.createNavigateToEvent(stage1));
            history.onNavigateTo(NavigationEvent.createNavigateToEvent(stage2));

            history.previous();
            assertThat("expect to be able to move backwards", history.hasPrevious);
        }

        [Test]
        public function exitInterceptorAcceptsNavigationThenProceed():void
        {
            history.addEventListener(NavigationEvent.NAVIGATE_TO, handleNavigation);
            history.onNavigateTo(NavigationEvent.createNavigateToEvent(stage1));
            history.onNavigateTo(NavigationEvent.createNavigateToEvent(stage2));

            history.previous();
            assertThat("navigation approved, cannot move further", !history.hasPrevious);
            assertThat("navigation approved, can move forward", history.hasNext);
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