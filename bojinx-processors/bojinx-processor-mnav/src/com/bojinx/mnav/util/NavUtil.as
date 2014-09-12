package com.bojinx.mnav.util
{
	import com.bojinx.mnav.core.cache.MNavViewRegistry;
	import com.bojinx.mnav.core.waypoint.CurrentStateWaypoint;
	import com.bojinx.mnav.core.waypoint.IWaypoint;
	import com.bojinx.mnav.meta.WayPointMetadata;
	import com.bojinx.system.cache.definition.MetaDefinition;
	
	import mx.core.UIComponent;

	public final class NavUtil
	{
		public function NavUtil()
		{
			throw new Error("Static Class");
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
		
		public static function getViewNameFromMeta(data:Vector.<MetaDefinition>):String
		{
			for each(var i:MetaDefinition in data)
			{
				if(i.meta is WayPointMetadata)
					return WayPointMetadata(i.meta).path;
			}
			
			return null;
		}
		
		public static function getWaypointDefFromMeta(data:Vector.<MetaDefinition>):MetaDefinition
		{
			for each(var i:MetaDefinition in data)
			{
				if(i.meta is WayPointMetadata)
					return i;
			}
			
			return null;
		}
		
		public static function getLength(destination:String):int
		{
			var substrings:Array=destination.split(".");
			if (!substrings)
				return -1;
			
			return substrings.length;
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
		
		public static function getFirstSharedDestination(destination1:String, destination2:String):String
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
		
		public static function cleanPath(path:String):String
		{
			if(path == ".")
				return path;
			
			var hasEndingSlash:Boolean = StringUtils.endsWith(path, ".");
			var hasStartingSlash:Boolean = StringUtils.beginsWith(path, ".");
			
			if(hasEndingSlash)
				path = StringUtils.beforeLast(path, ".");
			
			if(hasStartingSlash)
				path = StringUtils.afterFirst(path, ".");
			
			return path;
		}
		
		public static function cleanArray(value:Array):Array
		{
			for(var i:int = 0; i < value.length; i++)
			{
				if(value[i] == "" || value[i] == ".")
					value.splice(i, 1);
			}
			
			return value;
		}
		
		public static function generateExitParts(destinationParts:Array, viewRegistry:MNavViewRegistry):Array
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
		
		public static function generateEnterParts(destinationParts:Array, viewRegistry:MNavViewRegistry):Array
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
		
		public static function getTarget(waypoint:IWaypoint):UIComponent
		{
			if(waypoint.meta.target == "skin")
				return waypoint.target.target.skin;
			else
				return waypoint.target.target;
			
			return null;
		}
		
		public static function getStatesOfTarget(waypoint:IWaypoint):Array
		{
			if(waypoint.meta.target == "skin")
			{
				if(!waypoint.target.target.skin)
					UIComponent(waypoint.target.target).validateNow();
				
				return waypoint.target.target.skin.states;
			}
			else
				return waypoint.target.target.states;
			
			return null;
		}
		
		public static function hasParallel(destination:String):Boolean
		{
			return destination && destination.indexOf("..") > -1;
		}		
		
		public static function getCurrentState(waypoint:CurrentStateWaypoint):String
		{
			if(waypoint.meta.target == "skin")
				return waypoint.target.target.skin.currentState;
			else
				return waypoint.target.target.currentState;
			
			return null;
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
		
		public static function setState(waypoint:CurrentStateWaypoint, state:String):void
		{
			if(waypoint.meta.target == "skin")
				waypoint.target.target.skin.currentState = state;
			else
				waypoint.target.target.currentState = state;
		}
	}
}