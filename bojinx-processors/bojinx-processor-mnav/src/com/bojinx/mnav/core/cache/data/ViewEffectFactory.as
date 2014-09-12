package com.bojinx.mnav.core.cache.data
{
	import com.bojinx.mnav.core.cache.MNavViewRegistry;
	import com.bojinx.mnav.core.message.EffectInfo;
	import com.bojinx.mnav.core.message.InternalDestinationMessage;
	import com.bojinx.mnav.core.tasks.shared.StateModel;
	import com.bojinx.mnav.core.waypoint.WaypointHandler;
	import com.bojinx.system.cache.definition.ObjectDefinition;
	import com.bojinx.utils.data.HashMap;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	[Event(name="effectQueueComplete", type="flash.events.Event")]
	public class ViewEffectFactory extends EventDispatcher
	{
		public var factory:ObjectDefinition;
		public var effects:HashMap = new HashMap();
		public var effectPlay:Function;
		public var effectQueue:Function;
		
		public function ViewEffectFactory()
		{
		}
		
		public function getEffect(path:String):ViewEffect
		{
			return effects.getValue(path);
		}
		
		public function addEffect(effect:ViewEffect):void
		{
			effects.put(effect.state + "_" + effect.kind, effect);
		}
		
		public function registerEffect(name:String, registry:MNavViewRegistry, waypoint:WaypointHandler, info:EffectInfo):void
		{
			var effect:ViewEffect = getEffect(name);
			
			if(effect)
			{
				StateModel.pendingEffects++;
				effect.invoke(factory, registry, waypoint, info);
			}
		}
		
		public function newEffectQueue():void
		{
			effectQueue(onEffectQueueComplete);
		}
		
		private function onEffectQueueComplete():void
		{
			dispatchEvent(new Event("effectQueueComplete"));
		}
	}
}