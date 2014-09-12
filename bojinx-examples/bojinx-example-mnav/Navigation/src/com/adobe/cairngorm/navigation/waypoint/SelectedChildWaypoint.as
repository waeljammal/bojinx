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
	
	import flash.display.DisplayObject;
	
	import mx.automation.IAutomationObject;
	import mx.core.UIComponent;
	import mx.events.IndexChangedEvent;

	public class SelectedChildWaypoint extends AbstractWaypoint implements IWaypoint
	{	
		public function SelectedChildWaypoint()
		{
			_registration = new ContainerDestinationRegistration();
		}
		
		public function getDefaultDestination():String
		{
			var child:IAutomationObject;
			if (view.hasOwnProperty("selectedChild"))
			{
				child=view["selectedChild"];
			}
			else
			{
				child=getChildAt(0);
			}
			
			var destination:String;
			if (child != null)
			{
				_selectedIndex=view.getChildIndex(DisplayObject(child));
				destination=getDestination(child);
			}
			return destination;
		}		
				
		private function getChildAt(index:int):IAutomationObject
		{
			return IAutomationObject(view.getChildAt(index));
		}
		
		private function getDestination(child:IAutomationObject):String
		{
			return child.automationName;
		}
		
		public function subscribeToViewChange(view:UIComponent):void
		{
			this.view = view;
			view.addEventListener(IndexChangedEvent.CHANGE, changeHandler, false, 0, true);
		}
		
		private function changeHandler(event:IndexChangedEvent):void
		{
			var child:IAutomationObject=getChildAt(event.newIndex);
			var destination:String=getDestination(child);
			_selectedIndex=event.newIndex;
			navigateTo(destination);
		}
		
		public function handleNavigationChange(event:NavigationEvent):void
		{
			var child:IAutomationObject=findChild(event.destination);
			
			if (child && view["selectedChild"] != child)
			{
				view["selectedChild"]=child;
			}			
		}
		
		private function findChild(destination:String):IAutomationObject
		{
			var length:int=view.numChildren;
			for (var i:int; i < length; i++)
			{
				var child:IAutomationObject=IAutomationObject(view.getChildAt(i));
				if (getDestination(child) == destination)
				{
					return child;
				}
			}
			return null;
		}
	}
}