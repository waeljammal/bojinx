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
package com.adobe.cairngorm.navigation.wizard
{
    import com.adobe.cairngorm.navigation.NavigationEvent;

    import org.flexunit.assertThat;
    import org.hamcrest.object.equalTo;

    public class WizardTest
    {
        private var wizard:AbstractWizard;

        private var eventDispatched:Boolean;

        private var eventsDispatched:int;

        [Before]
        public function given3Stages():void
        {
            wizard = new AbstractWizard();
            wizard.stages = [ "myWizard.stage1", "myWizard.stage2", "myWizard.stage3" ];
            wizard.waypoint = "myWizard";
        }

        [After]
        public function resetEvents():void
        {
            eventDispatched = false;
            eventsDispatched = 0;
            wizard.removeEventListener(NavigationEvent.NAVIGATE_TO, handleNavigation);
        }

        [Test]
        public function whenNoStagesAreSetThenCanNotMove():void
        {
            wizard = new AbstractWizard();
            wizard.waypoint = "myWizard";

            assertThat(!wizard.hasNext);
            assertThat(!wizard.hasPrevious);
        }

        [Test]
        public function whenAtFirstItemThenCannotMoveBack():void
        {
            wizard.addEventListener(NavigationEvent.NAVIGATE_TO, handleNavigation);

            assertThat("hasPrevious", !wizard.hasPrevious);
            wizard.previous();
            assertThat("eventDispatched", !eventDispatched);
        }

        [Test]
        public function whenAtFirstItemThenCanMoveForward():void
        {
            wizard.addEventListener(NavigationEvent.NAVIGATE_TO, handleNavigation);

            assertThat("hasNext", wizard.hasNext);
            wizard.next();
            assertThat("eventDispatched", eventDispatched);
        }

        [Test]
        public function whenAtLastItemThenCannotMoveForward():void
        {
            wizard.addEventListener(NavigationEvent.NAVIGATE_TO, handleNavigation);

            wizard.next();
            wizard.next();
            assertThat("hasNext", !wizard.hasNext);
            wizard.next();
            assertThat(equalTo(eventsDispatched), 2);
        }

        [Test]
        public function whenAtLastItemThenCanMoveBackward():void
        {
            wizard.addEventListener(NavigationEvent.NAVIGATE_TO, handleNavigation);

            wizard.next();
            wizard.next();
            assertThat("hasPrevious", wizard.hasPrevious);
            wizard.previous();
            assertThat(equalTo(eventsDispatched), 3);
        }

        [Test]
        public function whenAtSecondItemThenCanMoveForwardAndBackward():void
        {
            wizard.addEventListener(NavigationEvent.NAVIGATE_TO, handleNavigation);

            wizard.next();
            assertThat("hasPrevious", wizard.hasPrevious);
            assertThat("hasNext", wizard.hasNext);
        }
        
        [Test]
        public function whenQualifiedWaypointThenMoveForwardAndBackward():void
        {
            wizard = new AbstractWizard();
            wizard.stages = [ "level1.myWizard.stage1", "level1.myWizard.stage2", "level1.myWizard.stage3" ];
            wizard.waypoint = "myWizard";
            
            wizard.addEventListener(NavigationEvent.NAVIGATE_TO, handleNavigation);
            
            wizard.next();
            assertThat("hasPrevious 1", wizard.hasPrevious);
            assertThat("hasNext 1", wizard.hasNext); 
            
            wizard.next();
            assertThat("hasPrevious 2", wizard.hasPrevious);
            assertThat("hasNext 2", !wizard.hasNext); 
            
            wizard.previous();
            wizard.previous(); 
            assertThat("hasPrevious 3", !wizard.hasPrevious);
            assertThat("hasNext 3", wizard.hasNext);             
        }

        private function handleNavigation(event:NavigationEvent):void
        {
            if (event.type == NavigationEvent.NAVIGATE_TO)
            {
                eventDispatched = true;
                eventsDispatched++;
                wizard.onNavigateTo(event);
            }
        }
    }
}