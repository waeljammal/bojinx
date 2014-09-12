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
	import flash.events.EventDispatcher;

	public class AbstractGlobalHistory extends AbstractHistory implements IHistory
	{
		private var waypointHistories:WaypointHistories;

		public function AbstractGlobalHistory()
		{
			waypointHistories=new WaypointHistories();
			waypointHistories.addEventListener(WaypointHistoriesEvent.ADD, addToHistoryHandler);
			waypointHistories.addEventListener(NavigationEvent.NAVIGATE_TO, handleWaypointHistory);
		}

		override protected function navigateToNext(location:Object):void
		{
			isHistory=true;
			waypointHistories.next(NavigationEvent(location));
			historyChange();
		}

		override protected function navigateToPrevious(location:Object):void
		{
			isHistory=true;
			waypointHistories.previous(NavigationEvent(location));
			historyChange();
		}

		//------------------------------------------------------------------------
		//
		//  Message Handlers
		//
		//------------------------------------------------------------------------

		public function onNavigateTo(event:NavigationEvent):void
		{
			if (!isHistory)
			{
				adjustWhenMovedOutOfHistory();
				if(isDuplicate(event))
				{
					return;
				}				
				try
				{
					waypointHistories.update(event);
				}
				catch (error:Error)
				{
					return;
				}
				historyChange();
			}
			else if (isHistory)
			{
				historyIndex+=hasMovedBackwards ? -1 : 1;

				waypointHistories.onNavigateTo(event);

				isHistory=false;
				historyChange();
			}
		}

		private function isDuplicate(event:NavigationEvent):Boolean
		{
			var lastEvent:NavigationEvent=NavigationEvent(history[history.length - 1]);
			return (lastEvent && lastEvent.destination == event.destination);
		}

		private function addToHistoryHandler(event:WaypointHistoriesEvent):void
		{
			addToHistory(event.event);
		}

		private function addToHistory(event:NavigationEvent):void
		{
			adjustWhenMovedOutOfHistory();

			history.push(event);
			historyIndex++;
		}

		private function handleWaypointHistory(event:NavigationEvent):void
		{
			adjustIndexWhenDestinationWasSkipped(event);
			dispatch(event);
		}

		protected function dispatch(event:NavigationEvent):void
		{
			dispatchEvent(event);
		}

		private function adjustIndexWhenDestinationWasSkipped(event:NavigationEvent):void
		{
			if (isHistory)
			{
				historyIndex+=hasMovedBackwards ? -1 : 1;

				var currentEvent:NavigationEvent=history[historyIndex];
				if (event.destination != currentEvent.destination)
				{
					adjustIndexDirection(event);
				}

				historyIndex+=hasMovedBackwards ? 1 : -1;
			}
		}

		private function adjustIndexDirection(event:NavigationEvent):void
		{
			var eventBefore:NavigationEvent=history[historyIndex - 1];
			historyIndex+=event.destination != eventBefore.destination ? 1 : -1;
		}
	}
}