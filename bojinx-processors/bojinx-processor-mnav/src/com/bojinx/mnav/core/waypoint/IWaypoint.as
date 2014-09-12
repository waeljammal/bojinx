package com.bojinx.mnav.core.waypoint
{
	import com.bojinx.mnav.core.manager.NavigationController;
	import com.bojinx.mnav.meta.WayPointMetadata;
	import com.bojinx.system.cache.definition.MetaDefinition;
	import com.bojinx.system.cache.definition.ObjectDefinition;
	
	import mx.core.UIComponent;

	public interface IWaypoint
	{
		
		function get controller():NavigationController;

		function get meta():WayPointMetadata;

		function get name():String;

		function get registry():StateDestination;

		function get statesTarget():String;

		function get target():ObjectDefinition;

		function get view():UIComponent;
		
		function initialize(md:MetaDefinition,controller:NavigationController, path:String):void;
	}
}