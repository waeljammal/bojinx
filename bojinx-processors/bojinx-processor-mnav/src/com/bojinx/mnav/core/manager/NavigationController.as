package com.bojinx.mnav.core.manager
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.mnav.core.cache.DestinationRegistry;
	import com.bojinx.mnav.core.cache.MNavViewRegistry;
	import com.bojinx.mnav.core.constants.MNavCacheID;
	import com.bojinx.mnav.core.constants.TaskPriority;
	import com.bojinx.mnav.core.tasks.DispatchFinalDestinationTask;
	import com.bojinx.mnav.core.tasks.PlayExitEffectTask;
	import com.bojinx.mnav.core.tasks.StartNewEffectQueueTask;
	import com.bojinx.system.message.queue.MessageQueue;
	import com.bojinx.system.message.support.Scope;
	import com.bojinx.utils.logging.Logger;
	import com.bojinx.utils.logging.LoggingContext;
	import com.bojinx.utils.tasks.Task;
	import com.bojinx.utils.tasks.TaskGroup;
	
	import flash.events.EventDispatcher;
	
	public class NavigationController extends EventDispatcher
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _context:IApplicationContext;
		
		public function get context():IApplicationContext
		{
			return _context;
		}
		
		private var _currentQueue:TaskGroup;
		
		public function get currentQueue():TaskGroup
		{
			return _currentQueue;
		}
		
		public var destinations:DestinationRegistry;
		
		private var _enterAndExitInvoker:EnterAndExitInvoker;
		
		public function get enterAndExitInvoker():EnterAndExitInvoker
		{
			return _enterAndExitInvoker;
		}
		
		private var _nextQueue:MessageQueue;
		
		public function get nextQueue():MessageQueue
		{
			return _nextQueue;
		}
		
		private var _registry:MNavViewRegistry;
		
		public function get registry():MNavViewRegistry
		{
			return _registry;
		}
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var lastDestination:String;
		
		public function NavigationController( context:IApplicationContext )
		{
			destinations = new DestinationRegistry( this );
			_context = context;
			_enterAndExitInvoker = new EnterAndExitInvoker( this, destinations );
			_registry = context.cache.getCache( MNavCacheID.VIEW_REGISTRY );
		}
		
		
		/*============================================================================*/
		/*= STATIC PRIVATE PROPERTIES                                                 */
		/*============================================================================*/
		
		private static const log:Logger = LoggingContext.getLogger( NavigationController );
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function addMessageToQueue( msg:*, name:String = null, interceptor:Boolean = true ):void
		{
			_nextQueue = context.messageBus.dispatch( msg, name, Scope.GLOBAL, false );
		}
		
		public function hasDestination( destination:String ):Boolean
		{
			return destinations.hasDestination( destination );
		}
		
		public function invalidateRunningQueue( context:IApplicationContext ):void
		{
			_nextQueue = context.messageBus.buildQueue( null, "*", Scope.GLOBAL, null, false );
		}
		
		public function navigateTo( destination:String, queue:TaskGroup ):void
		{
			_currentQueue = queue;
			
			var item:DestinationStateController = destinations.getValidDestination( destination );
			
			log.info( "Navigating To " + destination );
			
			lastDestination = enterAndExitInvoker.applyExits( destination, queue );
			
			if ( queue && lastDestination )
			{
				var task:Task = new PlayExitEffectTask( lastDestination, this );
				task.taskPriority = TaskPriority.EXIT_PLAY_EFFECT;
				queue.addTask( task );
				
				task = new DispatchFinalDestinationTask(lastDestination, this, true);
				task.taskPriority = TaskPriority.COMPLETE_DISPATCH_EXIT;
				queue.addTask(task);
				
				task = new StartNewEffectQueueTask( destination, this );
				task.taskPriority = TaskPriority.CREATE_ENTER_EFFECT_QUEUE;
				queue.addTask( task );
			}
			
			enterAndExitInvoker.applyEnters( destination, queue );
			
			if ( _nextQueue && !_nextQueue.running )
			{
				_nextQueue.run();
			}
			else if ( _nextQueue )
			{
				_nextQueue.onRunCompleteParams = [ item ];
			}
		}
		
		public function registerDestination( destination:String, isEffectEndpoint:Boolean ):Boolean
		{
			return destinations.registerDestination( destination, isEffectEndpoint );
		}
	}
}
