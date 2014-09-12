package com.bojinx.mnav.operation
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.mnav.config.SiteMap;
	import com.bojinx.mnav.core.adapter.IMnavAdapter;
	import com.bojinx.mnav.core.cache.MNavViewRegistry;
	import com.bojinx.mnav.core.cache.data.ViewEffect;
	import com.bojinx.mnav.core.cache.data.ViewEffectFactory;
	import com.bojinx.mnav.core.constants.MNavCacheID;
	import com.bojinx.mnav.core.constants.TaskPriority;
	import com.bojinx.mnav.core.manager.NavigationController;
	import com.bojinx.mnav.core.message.NavigationChangeMessage;
	import com.bojinx.mnav.core.tasks.DispatchFinalDestinationTask;
	import com.bojinx.mnav.core.tasks.PlayEnterEffectTask;
	import com.bojinx.mnav.core.tasks.StartNewEffectQueueTask;
	import com.bojinx.mnav.core.tasks.shared.StateModel;
	import com.bojinx.mnav.core.waypoint.IWaypoint;
	import com.bojinx.mnav.core.waypoint.WaypointHandler;
	import com.bojinx.mnav.meta.EffectFactoryMetadata;
	import com.bojinx.mnav.meta.EffectMetadata;
	import com.bojinx.mnav.meta.EffectPlayMetadata;
	import com.bojinx.mnav.meta.EffectQueueMetadata;
	import com.bojinx.mnav.meta.EnterMetadata;
	import com.bojinx.mnav.meta.ExitMetadata;
	import com.bojinx.mnav.meta.RequestMappingMetadata;
	import com.bojinx.mnav.meta.SiteMapMetadata;
	import com.bojinx.mnav.meta.WayPointMetadata;
	import com.bojinx.mnav.util.NavUtil;
	import com.bojinx.reflection.ClassInfo;
	import com.bojinx.reflection.Method;
	import com.bojinx.reflection.Parameter;
	import com.bojinx.reflection.Property;
	import com.bojinx.system.cache.definition.MergedMetaDefinition;
	import com.bojinx.system.cache.definition.MetaDefinition;
	import com.bojinx.system.processor.AbstractProcessor;
	import com.bojinx.utils.tasks.Task;
	import com.bojinx.utils.tasks.TaskGroup;
	import com.bojinx.utils.tasks.event.TaskEvent;
	
	import flash.display.DisplayObject;
	
	import mx.core.UIComponent;
	
	public class MNavProcessorOperation extends AbstractProcessor
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		public var adapters:Vector.<IMnavAdapter>;
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var controller:NavigationController;
		
		private var siteMap:SiteMap;
		
		private var viewRegistry:MNavViewRegistry;
		
		private var queue:TaskGroup;
		
		public function MNavProcessorOperation()
		{
			super();
		}
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function navigateToPath( destination:String ):void
		{
			if(queue && queue.size > 0)
				queue.cancel();
			
			destination = NavUtil.cleanPath( destination );
			
			var waypoint:WaypointHandler = controller.registry.getWaypoint(NavUtil.getFirst(destination));
			var factory:ViewEffectFactory = controller.registry.getEffectFactory( waypoint.waypoint.name );
			var task:Task;
			
			if ( factory && factory.effectQueue != null )
			{
				factory.newEffectQueue();
			}
			
			queue = new TaskGroup(true, "Navigate to " + destination);
			
			task = new StartNewEffectQueueTask(destination, controller);
			task.taskPriority = TaskPriority.CREATE_EXIT_EFFECT_QUEUE;
			queue.addTask(task);
			
			controller.navigateTo( destination, queue );
			
			task = new PlayEnterEffectTask(destination, controller);
			task.taskPriority = TaskPriority.ENTER_PLAY_EFFECT;
			queue.addTask(task);
			
			task = new DispatchFinalDestinationTask(destination, controller, false);
			task.taskPriority = TaskPriority.COMPLETE_DISPATCH;
			queue.addTask(task);
			
			queue.sortBy("taskPriority");
			queue.addEventListener(TaskEvent.COMPLETE, onComplete);
			queue.start();
		}

		private function onComplete(event:TaskEvent):void
		{
			trace("QUEUE COMPLETE");
			StateModel.exitInProgress = false;
		}
		
		override public function processMerged( value:MergedMetaDefinition ):void
		{
			if ( !viewRegistry )
				registerViewRegistry( value );
			
			if ( !siteMap )
				registerSiteMap( value );
			
			if ( !controller )
				controller = new NavigationController( value.context );
			
			// First parse any Waypoints or Request Mappings
			// because paths and effects will belong to those
			for each ( var md:MetaDefinition in value.data )
			{
				if ( md.meta is RequestMappingMetadata )
					updateRequestMapping( md );
				else if ( md.meta is WayPointMetadata )
					updateWaypointMapping( md );
				else if ( md.meta is EffectFactoryMetadata )
					updateEffectFactory( md );
				else if ( md.meta is EffectQueueMetadata )
					updateEffectQueue( md );
				else if ( md.meta is EffectPlayMetadata )
					updateEffectPlay( md );
				else if ( md.meta is SiteMapMetadata )
					injectSiteMap( md );
				else if ( md.meta is EffectMetadata )
					updateEffect( md );
				else if ( md.meta is EnterMetadata )
					updateEnterMeta( md );
				else if ( md.meta is ExitMetadata )
					updateExitMeta( md );
			}
			
//			if ( view.status == ViewProcessState.PENDING )
//				preProcessView( view, value );
//			
//			if ( view.status == ViewProcessState.PROCESSED )
//				postProcessView( view, value );
			
//			if(view && value.root.target is DisplayObject)
//				navigationManager.navigateToView(view.path);
			
//			if(view && value.root.target is DisplayObject)
//				navigationManager.navigateToView(view.path + "." + view.getCurrentState());
			
			complete( value );
		}
		
		override public function releaseMerged( value:MergedMetaDefinition ):void
		{
			var view:MetaDefinition = NavUtil.getWaypointDefFromMeta( value.data );
			var meta:WayPointMetadata = view.meta as WayPointMetadata;
			var parent:IWaypoint = findParentWaypoint( view );
			var parentName:String = ( parent ? parent.name + "." : null );
			var path:String = meta.path;
			
			// Dynamic update of an annotations info is allowed in bojinx
			if ( parentName )
				path = parentName + meta.path;
			
			if ( view )
				viewRegistry.remove( path );
			
			complete( value );
		}
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		protected function updateEffect( md:MetaDefinition ):void
		{
			var type:ClassInfo = md.owner.type;
			var meta:EffectMetadata = md.meta as EffectMetadata;
			var factoryMeta:EffectFactoryMetadata = type.getMetadata( EffectFactoryMetadata )[ 0 ];
			
			var handler:ViewEffectFactory = viewRegistry.getEffectFactory( factoryMeta.path );
			
			var member:Method = md.member as Method;
			var effect:ViewEffect = new ViewEffect();
			effect.kind = meta.kind;
			effect.type = Parameter( member.parameters[ 0 ]).paramterType.getClass();
			effect.typeName = Parameter( member.parameters[ 0 ]).paramterType.name;
			effect.methodName = member.name;
			effect.state = factoryMeta.path + "." + meta.state;
			
			handler.addEffect( effect );
		}
		
		protected function updateEffectFactory( md:MetaDefinition ):void
		{
			var type:ClassInfo = md.owner.type;
			var meta:EffectFactoryMetadata = md.meta as EffectFactoryMetadata;
			var path:String = meta.path;
			
			viewRegistry.registerEffectHandler( meta, md );
		}
		
		protected function updateEffectQueue( md:MetaDefinition ):void
		{
			var type:ClassInfo = md.owner.type;
			var meta:EffectMetadata = md.meta as EffectMetadata;
			var factoryMeta:EffectFactoryMetadata = type.getMetadata( EffectFactoryMetadata )[ 0 ];
			
			var handler:ViewEffectFactory = viewRegistry.getEffectFactory( factoryMeta.path );
			
			handler.effectQueue = md.owner.target[md.member.name];
		}
		
		protected function updateEffectPlay(md:MetaDefinition):void
		{
			var type:ClassInfo = md.owner.type;
			var meta:EffectPlayMetadata = md.meta as EffectPlayMetadata;
			var factoryMeta:EffectFactoryMetadata = type.getMetadata( EffectFactoryMetadata )[ 0 ];
			
			var handler:ViewEffectFactory = viewRegistry.getEffectFactory( factoryMeta.path );
			
			handler.effectPlay = md.owner.target[md.member.name];
		}
		
		protected function updateEnterMeta( md:MetaDefinition ):void
		{
			var requestMaps:Array = md.owner.type.getMetadata( RequestMappingMetadata );
			var enterMeta:EnterMetadata = md.meta as EnterMetadata;
			
			for each(var requestMap:RequestMappingMetadata in requestMaps)
			{
				var path:String = requestMap.path;
				
				if ( enterMeta.path )
					path += "." + enterMeta.path;
				
				if ( enterMeta.time )
					path += ":" + enterMeta.time;
				
				var method:Method = md.member as Method;
				var context:IApplicationContext = md.owner.context;
				
				context.messageBus.addListener( md.owner.target[ method.name ], NavigationChangeMessage, path, enterMeta.scope, enterMeta.priority );
			}
		}
		
		protected function updateExitMeta( md:MetaDefinition ):void
		{
			var requestMaps:Array = md.owner.type.getMetadata( RequestMappingMetadata );
			var enterMeta:ExitMetadata = md.meta as ExitMetadata;
			var exitType:String = ":exit";
			
			for each(var requestMap:RequestMappingMetadata in requestMaps)
			{
				var path:String = requestMap.path;
				
				if ( enterMeta.path )
					path += "." + enterMeta.path;
				
				path += exitType;
				
				var method:Method = md.member as Method;
				var name:String = requestMap.path + path;
				var context:IApplicationContext = md.owner.context;
				
				context.messageBus.addListener( md.owner.target[ method.name ], NavigationChangeMessage, path, enterMeta.scope, enterMeta.priority );
			}
		}
		
		protected function updateRequestMapping( md:MetaDefinition ):void
		{
			var path:String = NavUtil.cleanPath( RequestMappingMetadata( md.meta ).path );
//			var view:View = viewRegistry.get( path );
//			var wpMeta:WayPointMetadata = md.meta as WayPointMetadata;
//			
//			if ( !view )
//				view = viewRegistry.createView( path );
		}
		
		protected function updateWaypointMapping( md:MetaDefinition ):void
		{
			var path:String = NavUtil.cleanPath( WayPointMetadata( md.meta ).path );
			var wpMeta:WayPointMetadata = md.meta as WayPointMetadata;
			var parent:IWaypoint = findParentWaypoint( md );
			var parentName:String = ( parent ? parent.name + "." : null );
			var handler:WaypointHandler;
			
			// Dynamic update of an annotations info is allowed in bojinx
			if ( parentName )
				path = parentName + wpMeta.path;
			
			if ( viewRegistry.contains( path ))
				return;
			
			if ( !viewRegistry.contains( path ))
			{
				handler = new WaypointHandler( controller );
				handler.process( md, path );
				handler.waypoint.subscribeToViewChange( md.owner.target );
			}
			else
			{
				handler = viewRegistry.getWaypoint( path );
				handler.process( md, path );
				handler.waypoint.subscribeToViewChange( md.owner.target );
			}
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function findParentWaypoint( md:MetaDefinition ):IWaypoint
		{
			var target:UIComponent = md.owner.target;
			var context:IApplicationContext = md.owner.context;
			var cache:MNavViewRegistry = context.cache.getCache( MNavCacheID.VIEW_REGISTRY );
			var p:DisplayObject = target.parent;
			
			while ( p )
			{
				if ( cache.getByTarget( p ))
					return cache.getByTarget( p ).waypoint;
				
				p = p.parent;
			}
			
			return null;
		}
		
		private function injectSiteMap( md:MetaDefinition ):void
		{
			if ( md.member is Property )
				Property( md.member ).setValue( md.owner.target, siteMap );
			else if ( md.member is Method )
				Method( md.member ).invoke( md.owner.target, [ siteMap ]);
		}
		
		private function registerSiteMap( value:MergedMetaDefinition ):void
		{
			siteMap = value.root.context.cache.getCache( MNavCacheID.SITE_MAP );
		}
		
		private function registerViewRegistry( value:MergedMetaDefinition ):void
		{
			viewRegistry = value.root.context.cache.getCache( MNavCacheID.VIEW_REGISTRY );
		}
	}
}


