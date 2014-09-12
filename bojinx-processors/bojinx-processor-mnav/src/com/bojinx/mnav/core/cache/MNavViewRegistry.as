package com.bojinx.mnav.core.cache
{
	import com.bojinx.mnav.core.cache.data.ViewEffect;
	import com.bojinx.mnav.core.cache.data.ViewEffectFactory;
	import com.bojinx.mnav.core.waypoint.IWaypoint;
	import com.bojinx.mnav.core.waypoint.WaypointHandler;
	import com.bojinx.mnav.meta.EffectFactoryMetadata;
	import com.bojinx.mnav.meta.EffectMetadata;
	import com.bojinx.mnav.util.NavUtil;
	import com.bojinx.reflection.MetaDataAware;
	import com.bojinx.reflection.Method;
	import com.bojinx.reflection.Parameter;
	import com.bojinx.system.cache.definition.MetaDefinition;
	import com.bojinx.utils.data.HashMap;
	
	import flash.display.DisplayObject;
	
	import mx.core.UIComponent;
	
	public class MNavViewRegistry
	{
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var data:HashMap = new HashMap();
		private var effects:HashMap = new HashMap();
		
		public function MNavViewRegistry()
		{
		}
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function contains(path:String):Boolean
		{
			return data.containsKey(path);
		}
		
		public function registerHandler(handler:WaypointHandler):void
		{
			data.put(handler.waypoint.name, handler);
			data.put(handler.waypoint.target.target, handler);
		}
		
		public function getByTarget(value:DisplayObject):WaypointHandler
		{
			return data.getValue(value);
		}
		
		public function remove(view:String):void
		{
			var byName:WaypointHandler = data.getValue(view);
			
			if(byName)
			{
				data.remove(byName.waypoint.getRealTarget());
				byName.dispose();
				data.remove(view);
			}
		}
		
		public function getEffect(newDestination:String, kind:String):ViewEffectFactory
		{
			return effects.getValue(newDestination + "_" + kind);
		}
		
		public function getWaypoint(destination:String):WaypointHandler
		{
			return data.getValue(destination);
		}
		
		public function getByType(type:Class, rootName:String):WaypointHandler
		{
			var all:Array = data.getValues();
			
			for each(var i:WaypointHandler in all)
			{
				var root:String = NavUtil.getFirst(i.waypoint.name);
				var view:UIComponent = i.waypoint.view;
				
				if(root == rootName && view is type)
					return i;
			}
			
			return null;
		}
		
		public function registerEffectHandler(meta:EffectFactoryMetadata, md:MetaDefinition):void
		{
			var factory:ViewEffectFactory = new ViewEffectFactory();
			factory.factory = md.owner;
			
			effects.put(meta.path, factory);
		}
		
		public function getEffectFactory(path:String):ViewEffectFactory
		{
			return effects.getValue(path);
		}
	}
}