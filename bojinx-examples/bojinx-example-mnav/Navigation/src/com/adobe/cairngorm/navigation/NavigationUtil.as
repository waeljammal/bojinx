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
	public class NavigationUtil
	{
		public static function hasParent(destination:String):Boolean
		{
			var lastDot:int=destination.lastIndexOf(".");
			return (lastDot > 0);
		}

		public static function getParent(destination:String):String
		{
			if (destination == null)
				return null;
			var lastDot:int=destination.lastIndexOf(".");
			if (lastDot == -1)
				return null;

			var parent:String=destination.substring(0, lastDot);
			
			var isParallelOnLastWaypoint:Boolean=parent.charAt(parent.length-1) == ".";
			if (isParallelOnLastWaypoint)
			{
				parent=parent.substring(0, parent.length-1);
			}
			return parent;
		}

		public static function getFirst(destination:String):String
		{
			if (destination == null)
				return null;

			var substrings:Array=destination.split(".");
			if (!substrings)
				return null;

			return substrings[0] as String;
		}

		public static function getLast(destination:String):String
		{
			if (destination == null)
				return null;
			var lastDot:int=destination.lastIndexOf(".");
			if (lastDot == -1)
				return destination;
			return destination.substring(lastDot + 1, destination.length);
		}

		public static function getLength(destination:String):int
		{
			var substrings:Array=destination.split(".");
			if (!substrings)
				return -1;

			return substrings.length;
		}

		public static function hasSameWaypoint(destination1:String, destination2:String):Boolean
		{
			return NavigationUtil.getParent(destination1) == NavigationUtil.getParent(destination2);
		}

		public static function hasSameWaypointAtAnyLevel(destination1:String, destination2:String):Boolean
		{
			var isTrue:Boolean;
			var first:Array=destination1.split(".");
			var second:Array=destination2.split(".");

			var length:int=Math.min(first.length, second.length);
			for (var i:int; i < length; i++)
			{
				if (first[i] == second[i])
				{
					isTrue=true;
					break;
				}
			}
			return isTrue;
		}

		public static function getDifference(destination1:String, destination2:String):String
		{
			var difference:String;
			var first:Array=destination1.split(".");
			var second:Array=destination2.split(".");

			var length:int=Math.min(first.length, second.length);
			for (var i:int; i < length; i++)
			{
				if (first[i] != second[i])
				{
					difference=first.slice(i).join(".");
					break;
				}
			}
			return difference;
		}

		public static function getCommonBase(destination1:String, destination2:String):String
		{
			var difference:String;

			var first:Array=destination1.split(".");
			var second:Array=destination2.split(".");

			var length:int=Math.min(first.length, second.length);
			for (var i:int; i < length; i++)
			{
				if(second[i] == "" && first[i+1] != second[i+1])
				{
					//found parallel
					return destination1;
				}
				if (first[i] != second[i])
				{
					difference=first.slice(0, i).join(".");
					break;
				}
			}
			if (difference == null)
				return first.join(".");
			if (difference == "")
				return null;
			
			if(difference.slice(difference.length-1) == ".")
			{
				difference = difference.slice(0, difference.length-1);
			}
			return difference;
		}

		public static function getEnterDispatchOrder(destinationParts:Array):Array
		{
			var destinations:Array=new Array();
			var length:int=destinationParts.length;
			for (var i:int=0; i < length; i++)
			{
				var current:Array=new Array();
				for (var j:int=0; j <= i; j++)
				{
					current.push(destinationParts[j]);
				}
				var currentDestination:String=current.join(".");
				if(currentDestination.charAt(currentDestination.length - 1) != ".")
				{
					destinations.push(currentDestination);
				}
			}
			
			return destinations;
		}

		public static function getExitDispatchOrder(destinationParts:Array):Array
		{
			var destinations:Array=new Array();
			var length:int=destinationParts.length;
			for (var i:int=length - 1; i >= 0; i--)
			{
				var current:Array=new Array();
				for (var j:int=0; j <= i; j++)
				{
					current.push(destinationParts[j]);
				}
				var currentDestination:String=current.join(".");
				if(currentDestination.charAt(currentDestination.length - 1) != ".")
				{
					destinations.push(currentDestination);
				}
			}
			return destinations;
		}
		
		public static function hasParallel(destination:String):Boolean
		{
			return destination && destination.indexOf("..") > -1;
		}		
	}
}