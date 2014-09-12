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
	import flash.utils.Dictionary;
	
	import org.flexunit.assertThat;
	import org.hamcrest.object.equalTo;

	public class NavigationUtilTest
	{

		[Test]
		public function hasParent():void
		{
			var destination:String="parent.child";
			assertThat(NavigationUtil.hasParent(destination));
		}

		[Test]
		public function hasNoParent():void
		{
			var destination:String="parent";
			assertThat(!NavigationUtil.hasParent(destination));
		}

		[Test]
		public function getParent():void
		{
			var destination:String="parent.child";
			assertThat(NavigationUtil.getParent(destination), equalTo("parent"));
		}

		[Test]
		public function getParentOfParallel():void
		{
			var destination:String="parent..child";
			assertThat(NavigationUtil.getParent(destination), equalTo("parent"));
		}
		
		[Test]
		public function getParentWithParallelInFront():void
		{
			var destination:String="parent..child.child";
			assertThat(NavigationUtil.getParent(destination), equalTo("parent..child"));
		}
		
		[Test]
		public function getFirst():void
		{
			var destination:String="parent.child";
			assertThat(NavigationUtil.getFirst(destination), equalTo("parent"));
			var destination2:String="parent.child1.child2";
			assertThat(NavigationUtil.getFirst(destination2), equalTo("parent"));
		}

		[Test]
		public function getLast():void
		{
			var destination:String="parent.child";
			assertThat(NavigationUtil.getLast(destination), equalTo("child"));
			var destination2:String="parent.child1.child2";
			assertThat(NavigationUtil.getLast(destination2), equalTo("child2"));
			var destination3:String="parent";
			assertThat(NavigationUtil.getLast(destination3), equalTo("parent"));
		}

		[Test]
		public function getEnterDispatchOrderOneDestination():void
		{
			var destinations:Array="content".split(".");
			var order:Array=NavigationUtil.getEnterDispatchOrder(destinations);
			assertThat(order.length, equalTo(1));
			assertThat(order[0], equalTo("content"));
		}

		[Test]
		public function getEnterDispatchOrderTwoDestinations():void
		{
			var destinations:Array="content.task".split(".");
			var order:Array=NavigationUtil.getEnterDispatchOrder(destinations);
			assertThat(order.length, equalTo(2));
			assertThat(order[0], equalTo("content"));
			assertThat(order[1], equalTo("content.task"));
		}

		[Test]
		public function getEnterDispatchOrderThreeDestinations():void
		{
			var destinations:Array="content.task.expenses".split(".");
			var order:Array=NavigationUtil.getEnterDispatchOrder(destinations);
			assertThat(order.length, equalTo(3));
			assertThat(order[0], equalTo("content"));
			assertThat(order[1], equalTo("content.task"));
			assertThat(order[2], equalTo("content.task.expenses"));
		}
		
		[Test]
		public function getEnterDispatchOrderThreeDestinationsWithParallel():void
		{
			var destinations:Array="content.task..expenses".split(".");
			var order:Array=NavigationUtil.getEnterDispatchOrder(destinations);
			assertThat(order.length, equalTo(3));
			assertThat(order[0], equalTo("content"));
			assertThat(order[1], equalTo("content.task"));
			assertThat(order[2], equalTo("content.task..expenses"));
		}

		[Test]
		public function getExitDispatchOrderOneDestination():void
		{
			var destinations:Array="content".split(".");
			var order:Array=NavigationUtil.getExitDispatchOrder(destinations);
			assertThat(order.length, equalTo(1));
			assertThat(order[0], equalTo("content"));
		}

		[Test]
		public function getExitDispatchOrderTwoDestinations():void
		{
			var destinations:Array="content.task".split(".");
			var order:Array=NavigationUtil.getExitDispatchOrder(destinations);
			assertThat(order.length, equalTo(2));
			assertThat(order[0], equalTo("content.task"));
			assertThat(order[1], equalTo("content"));
		}

		[Test]
		public function getExitDispatchOrderThreeDestinations():void
		{
			var destinations:Array="content.task.expenses".split(".");
			var order:Array=NavigationUtil.getExitDispatchOrder(destinations);
			assertThat(order.length, equalTo(3));
			assertThat(order[0], equalTo("content.task.expenses"));
			assertThat(order[1], equalTo("content.task"));
			assertThat(order[2], equalTo("content"));
		}
		
		[Test]
		public function getExitDispatchOrderThreeDestinationsWithParallel():void
		{
			var destinations:Array="content.task..expenses".split(".");
			var order:Array=NavigationUtil.getExitDispatchOrder(destinations);
			assertThat(order.length, equalTo(3));
			assertThat(order[0], equalTo("content.task..expenses"));
			assertThat(order[1], equalTo("content.task"));
			assertThat(order[2], equalTo("content"));
		}

		[Test]
		public function shouldFindWaypointAtAnyLevelWhenRoot():void
		{
			var destination1:String="content.news";
			var destination2:String="content.task.expenses";
			assertThat(NavigationUtil.hasSameWaypointAtAnyLevel(destination1, destination2));
		}

		[Test]
		public function shouldFindWaypointAtAnyLevelSecond():void
		{
			var destination1:String="content.task.timesheet";
			var destination2:String="content.task.expenses";
			assertThat(NavigationUtil.hasSameWaypointAtAnyLevel(destination1, destination2));
		}

		[Test]
		public function shouldFindWaypointAtAnyLevelWhenNoCommonRoot():void
		{
			var destination1:String="content.task.timesheet";
			var destination2:String="sidebar.task";
			assertThat(NavigationUtil.hasSameWaypointAtAnyLevel(destination1, destination2));
		}

		[Test]
		public function shouldGetDifferenceWhenSecondWaypointIsDifferent():void
		{
			var destination1:String="content.task.expenses";
			var destination2:String="content.news";
			assertThat(NavigationUtil.getDifference(destination1, destination2), equalTo("task.expenses"));
		}

		[Test]
		public function shouldGetDifferenceWhenAllDifferent():void
		{
			var destination1:String="content.task.expenses";
			var destination2:String="sidebar.chat";
			assertThat(NavigationUtil.getDifference(destination1, destination2), equalTo("content.task.expenses"));
		}

		[Test]
		public function shouldNoGetDifferenceWhenNoDifference():void
		{
			var destination1:String="content.task";
			var destination2:String="content.task";
			assertThat(NavigationUtil.getDifference(destination1, destination2), equalTo(null));
		}

		[Test]
		public function shouldGetCommonBaseWhenSecondWaypointIsDifferent():void
		{
			var destination1:String="content.task.expenses";
			var destination2:String="content.news";
			assertThat(NavigationUtil.getCommonBase(destination1, destination2), equalTo("content"));
		}
		
		[Test]
		public function shouldGetCommonBaseWhenThirdWaypointIsDifferent():void
		{
			var destination1:String="content.search.task.expenses";
			var destination2:String="content.search.news";
			assertThat(NavigationUtil.getCommonBase(destination1, destination2), equalTo("content.search"));
		}
		
		[Test]
		public function shouldGetCommonBaseWhenParallel():void
		{
			var destination1:String="content.search..task";
			var destination2:String="content.search..news";
			assertThat(NavigationUtil.getCommonBase(destination1, destination2), equalTo("content.search..task"));
		}
		
		[Test]
		public function shouldGetCommonBaseWhenParallelAndNested():void
		{
			var destination1:String="content.search..task.expenses";
			var destination2:String="content.search..news";
			assertThat(NavigationUtil.getCommonBase(destination1, destination2), equalTo("content.search..task.expenses"));
		}
				
		[Test]
		public function shouldGetCommonBaseWhenParallelAndNested2():void
		{
			var destination1:String="content..search.task.expenses";
			var destination2:String="content..search.news";
			assertThat(NavigationUtil.getCommonBase(destination1, destination2), equalTo("content..search"));
		}
		
		[Test]
		public function shouldGetCommonBaseWhenExclusiveToParallel():void
		{
			var destination1:String="content.dashboard.nested.child1";
			var destination2:String="content.dashboard..footer.child2";
			assertThat(NavigationUtil.getCommonBase(destination1, destination2), equalTo("content.dashboard.nested.child1"));
		}
		
		[Test]
		public function shouldGetCommonBaseWhenExclusiveToParallel2():void
		{
			var destination1:String="content.search.nested.child1";
			var destination2:String="content.dashboard..footer.child2";
			assertThat(NavigationUtil.getCommonBase(destination1, destination2), equalTo("content"));
		}
		
		[Test]
		public function shouldGetCommonBaseWhenExclusiveAfterCommonParallel():void
		{
			var destination1:String="content.dashboard..footer.child2";
			var destination2:String="content.dashboard..footer.child3";
			assertThat(NavigationUtil.getCommonBase(destination1, destination2), equalTo("content.dashboard..footer"));
		}

		[Test]
		public function shouldGetNoCommonBaseWhenAllDifferent():void
		{
			var destination1:String="content.task.expenses";
			var destination2:String="sidebar.chat";
			assertThat(NavigationUtil.getCommonBase(destination1, destination2), equalTo(null));
		}

		[Test]
		public function shouldGetAllAsCommonBaseWhenNoDifference():void
		{
			var destination1:String="content.task";
			var destination2:String="content.task";
			assertThat(NavigationUtil.getCommonBase(destination1, destination2), equalTo("content.task"));
		}
	}
}