package com.bojinx.mnav.core.waypoint
{
	import com.bojinx.mnav.core.cache.DestinationRegistry;
	import com.bojinx.mnav.core.event.WaypointEvent;
	import com.bojinx.mnav.core.manager.DestinationStateController;
	import com.bojinx.mnav.core.manager.NavigationController;
	import com.bojinx.mnav.util.NavUtil;
	
	import flash.events.EventDispatcher;
	
	import mx.core.UIComponent;
	import mx.states.State;
	
	[Event( name = "waypointFound", type = "com.bojinx.mnav.core.event.WaypointEvent" )]
	public class StateDestination extends EventDispatcher
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _controller:NavigationController;
		
		public function get controller():NavigationController
		{
			return _controller;
		}
		
		private var _destinations:Array = [];
		
		public function get destinations():Array
		{
			return _destinations;
		}
		
		private var _hasRegisteredChildren:Boolean;
		
		public function get hasRegisteredChildren():Boolean
		{
			return _hasRegisteredChildren;
		}
		
		private var _name:String;
		
		public function get name():String
		{
			return _name;
		}
		
		private var _waypoint:IWaypoint;
		
		public function get waypoint():IWaypoint
		{
			return _waypoint;
		}
		
		public function StateDestination( waypoint:IWaypoint )
		{
			_waypoint = waypoint;
		}
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function initialize( name:String, controller:NavigationController ):void
		{
			_name = name;
			_controller = controller;
		}
		
		public function process( waypoint:CurrentStateWaypoint ):void
		{
			var target:UIComponent = waypoint.target.target;
			var states:Array = NavUtil.getStatesOfTarget( waypoint );
			var length:int = states.length;
			
			for ( var i:int; i < length; i++ )
			{
				var state:State = states[ i ];
				var destination:String = name + "." + state.name;
				controller.registerDestination( destination, waypoint._endpoint );
				_destinations.push(destination);
				setWaypointAvailable( destination );
			}
			
			_hasRegisteredChildren = true;
			dispatchEvent( new WaypointEvent( name ));
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function setWaypointAvailable( destination:String ):void
		{
			var registry:DestinationRegistry = NavigationController( controller ).destinations;
			var dest:DestinationStateController = registry.getDestination( destination );
			
			while ( dest && dest.destination != null && dest.destination != "" )
			{
				dest.isWaypointAvailable = true;
				var parentDestination:String = NavUtil.getParent( dest.destination );
				dest = registry.getDestination( parentDestination );
			}
		}
		
		public function hasState(name:String):Boolean
		{
			var states:Array = NavUtil.getStatesOfTarget( waypoint );
			var length:int = states.length;
			
			for ( var i:int; i < length; i++ )
			{
				var state:State = states[ i ];
				
				if(state.name == name)
					return true;
			}
			
			return false;
		}
	}
}