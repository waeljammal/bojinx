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
    import flash.utils.Dictionary;
    
    import org.flexunit.assertThat;
    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertNotNull;
    import org.flexunit.asserts.assertTrue;
    import org.hamcrest.object.equalTo;

    public class LastDestinationTrackerTest
    {
        [Test]
        public function shouldGetNextNested():void
        {
            var destinations:Dictionary = new Dictionary();
            destinations["content"] = new DestinationStateController("content");
            destinations["content.task"] = new DestinationStateController("content.task");
            
            var tracker:LastDestinationTracker = new LastDestinationTracker(destinations);
            
            tracker.updateLastDestination(destinations["content"]);
            tracker.updateLastDestination(destinations["content.task"]);
            
            assertThat(
                tracker.getNextNested("content").destination, 
                equalTo("content.task"));
        }
        
        [Test]
        public function shouldGetMostNextNestedWhenOneNestLevel():void
        {
            var destinations:Dictionary = new Dictionary();
            destinations["content"] = new DestinationStateController("content");
            destinations["content.task"] = new DestinationStateController("content.task");
            
            var tracker:LastDestinationTracker = new LastDestinationTracker(destinations);
            
            tracker.updateLastDestination(destinations["content"]);
            tracker.updateLastDestination(destinations["content.task"]);
            
            assertThat(
                tracker.getMostNested("content").destination, 
                equalTo("content.task"));
        }
        
        [Test]
        public function shouldGetMostNextNestedWhenTwoNestLevels():void
        {
            var destinations:Dictionary = new Dictionary();
            destinations["content"] = new DestinationStateController("content");
            destinations["content.task"] = new DestinationStateController("content.task");
            destinations["content.task.expenses"] = new DestinationStateController("content.task.expenses");
            
            var tracker:LastDestinationTracker = new LastDestinationTracker(destinations);
            
            tracker.updateLastDestination(destinations["content"]);
            tracker.updateLastDestination(destinations["content.task"]);
            tracker.updateLastDestination(destinations["content.task.expenses"]);
            
            assertThat(
                tracker.getMostNested("content").destination, 
                equalTo("content.task.expenses"));
        }
		
		[Test]
		public function shouldGetLastDestination():void
		{
			var destinations:Dictionary = new Dictionary();
			destinations["content"] = new DestinationStateController("content");
			destinations["content.task"] = new DestinationStateController("content.task");
			destinations["content.task.expenses"] = new DestinationStateController("content.task.expenses");
			
			var tracker:LastDestinationTracker = new LastDestinationTracker(destinations);
			
			tracker.updateLastDestination(destinations["content"]);
			tracker.updateLastDestination(destinations["content.task"]);
			tracker.updateLastDestination(destinations["content.task.expenses"]);

			assertThat(
				tracker.getLastDestination("content.task.expenses").destination, 
				equalTo("content.task.expenses"));			
		}
		
		[Test]
		public function shouldGetLastDestinationWhenParallelIsIncluded():void
		{
			var destinations:Dictionary = new Dictionary();
			var tracker:LastDestinationTracker = new LastDestinationTracker(destinations);
			
			tracker.updateLastDestination(new DestinationStateController("content"));
			tracker.updateLastDestination(new DestinationStateController("content.dashboard"));
			tracker.updateLastDestination(new DestinationStateController("content.dashboard..footer"));
			tracker.updateLastDestination(new DestinationStateController("content.dashboard..footer2"));
			tracker.updateLastDestination(new DestinationStateController("content.dashboard..footer.child1"));
			tracker.updateLastDestination(new DestinationStateController("content.dashboard..footer.child2"));
			
			assertThat(
				tracker.getLastDestination("content.dashboard..footer.child2"), 
				equalTo(null));	
		}		
		
		[Test]
		public function shouldRegisterParallelDestination():void
		{
			var destinations:Dictionary = new Dictionary();
			var tracker:LastDestinationTracker = new LastDestinationTracker(destinations);
			
			tracker.updateLastDestination(new DestinationStateController("content"));
			tracker.updateLastDestination(new DestinationStateController("content.dashboard"));
			tracker.updateLastDestination(new DestinationStateController("content.dashboard..footer"));
			tracker.updateLastDestination(new DestinationStateController("content.dashboard..footer.child"));
			
			var parallels:Array = tracker.getParallelDestinations("content.dashboard");
			
			assertNotNull("not null", parallels);			
			assertTrue("One element is not a String", parallels.every(checkForArray));
			assertEquals("parallels", 2, parallels.length);
		}
		
		[Test]
		public function shouldRegisterMultipleParallelDestination():void
		{
			var destinations:Dictionary = new Dictionary();
			var tracker:LastDestinationTracker = new LastDestinationTracker(destinations);
			
			tracker.updateLastDestination(new DestinationStateController("content"));
			tracker.updateLastDestination(new DestinationStateController("content.dashboard"));
			tracker.updateLastDestination(new DestinationStateController("content.dashboard..footer"));
			tracker.updateLastDestination(new DestinationStateController("content.dashboard..footer2"));
			tracker.updateLastDestination(new DestinationStateController("content.dashboard..footer.child1"));
			tracker.updateLastDestination(new DestinationStateController("content.dashboard..footer.child2"));
			
			var parallels:Array = tracker.getParallelDestinations("content.dashboard");
			
			assertNotNull("not null", parallels);			
			assertTrue("One element is not a String", parallels.every(checkForArray));
			assertEquals("parallels", 4, parallels.length);
		}
		
		private function checkForArray(element:*, index:int, arr:Array):Boolean
		{
			return element is String;
		}
    }
}