package com.bojinx.mnav.core.cache.data
{
	import com.bojinx.mnav.core.cache.MNavViewRegistry;
	import com.bojinx.mnav.core.message.EffectInfo;
	import com.bojinx.mnav.core.message.InternalDestinationMessage;
	import com.bojinx.mnav.core.waypoint.WaypointHandler;
	import com.bojinx.mnav.util.NavUtil;
	import com.bojinx.reflection.Method;
	import com.bojinx.reflection.Parameter;
	import com.bojinx.system.cache.definition.ObjectDefinition;

	public class ViewEffect
	{
		public var kind:String;
		public var id:String;
		public var type:Class;
		public var typeName:String;
		public var methodName:String;
		public var state:String;
		
		public function ViewEffect()
		{
		}
		
		public function invoke(target:ObjectDefinition, registry:MNavViewRegistry, waypoint:WaypointHandler, info:EffectInfo):void
		{
			var method:Method = target.type.getMethod( methodName );
			var args:Array = [];
			
			args.push( info );
			
			for ( var i:int = 1; i < method.parameters.length; i++ )
			{
				var param:Parameter = method.parameters[ i ];
				var viewHandler:WaypointHandler = registry.getByType( param.paramterType.getClass(), NavUtil.getFirst(waypoint.waypoint.name) );
				
				if ( viewHandler )
					args.push( viewHandler.waypoint.view );
			}
			
			trace("Registering Effect " + method.name);
			
			method.invoke( target.target, args );
		}
	}
}