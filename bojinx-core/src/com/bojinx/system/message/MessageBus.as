package com.bojinx.system.message
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.system.cache.store.Cache;
	import com.bojinx.system.cache.store.MessageRegistry;
	import com.bojinx.system.message.queue.MessageQueue;
	
	import flash.utils.Dictionary;
	
	public class MessageBus
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _parent:MessageBus;
		
		public function get parent():MessageBus
		{
			return _parent;
		}
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var activeQueues:Dictionary = new Dictionary();
		
		private var children:Vector.<MessageBus>;
		
		private var context:IApplicationContext;
		
		private var cache:Cache;
		
		public function MessageBus( context:IApplicationContext )
		{
			this.context = context;
			this.cache = context.cache;
		}
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public final function addChild( bus:MessageBus ):void
		{
			if ( !children )
				children = new Vector.<MessageBus>();
			
			children.push( bus );
		}
		
		public function addInterceptor( handler:Function, type:Class, name:String = null,
										scope:String = "global", priority:int = 0 ):void
		{
			cache.messages.register( handler, type, name, scope, priority, true );
		}
		
		public function addListener( handler:Function, type:Class, name:String = null,
									 scope:String = "global", priority:int = 0 ):void
		{
			cache.messages.register( handler, type, name, scope, priority );
		}
		
		public function clearAll():void
		{
			if ( cache.messages )
				cache.messages.clearAll();
		}
		
		public function buildQueue(message:Object = null, name:String = null, scope:String= "global", mergeInto:MessageQueue = null, autoDispose:Boolean = true):MessageQueue
		{
			var entries:Array = message ? cache.messages.get( message.constructor, name, scope ) : [];
			var i:int;
			var len:int = entries.length;
			var entry:Object;
			var queue:MessageQueue = mergeInto;
			
			if ( !queue )
			{
				queue = new MessageQueue( onQueueComplete, null, message ? message.constructor : null );
				queue.setCallBackData([ queue, entries, message, autoDispose ]);
			}
			
			for ( i = 0; i < len; i++ )
			{
				entry = entries[ i ];
				
				if ( entry.interceptor )
				{
					queue.add( message, entry.handler, entry.name );
				}
			}
			
			return queue;
		}
		
		public function getInterceptorQueue(type:Class):MessageQueue
		{
			return activeQueues[type];
		}
		
		public function dispatch( message:Object, name:String = null, scope:String = "global", autorunQueue:Boolean = true ):MessageQueue
		{
			var entries:Array = cache.messages.get( message.constructor, name, scope );
			var i:int;
			var len:int = entries.length;
			var entry:Object;
			var queue:MessageQueue;
			
			for ( i = 0; i < len; i++ )
			{
				entry = entries[ i ];
				
				if ( entry.interceptor )
				{
					if ( !queue )
					{
						if(activeQueues[ message.constructor ])
						{
							queue = activeQueues[ message.constructor ];
							queue.setCallBackData([ queue, entries, message ]);
						}
						else
						{
							queue = new MessageQueue( onQueueComplete, null, message.constructor );
							queue.setCallBackData([ queue, entries, message ]);
							activeQueues[ message.constructor ] = queue;
						}
					}
					
					queue.add( message, entry.handler, entry.name );
				}
			}
			
			if ( queue && !queue.running && autorunQueue)
				queue.run();
			else if(!queue)
				executeMessageHandlers( entries, message );
			
			return queue;
		}
		
		public function dispose():void
		{
			_parent = null;
		}
		
		public function hasInterceptor( handler:Function, type:Class ):Boolean
		{
			return cache.messages.contains( handler, type, true );
		}
		
		public function hasListener( handler:Function, type:Class ):Boolean
		{
			return cache.messages.contains( handler, type, false );
		}
		
		public function removeInterceptor( handler:Function, type:Class ):void
		{
			cache.messages.remove( handler, type, true );
		}
		
		public function removeListener( handler:Function, type:Class ):void
		{
			cache.messages.remove( handler, type, false );
		}
		
		public final function setParent( parent:MessageBus ):void
		{
			_parent = parent;
		}
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		protected function onQueueComplete( queue:MessageQueue, entries:Array, message:*, autoDispose:Boolean = true ):void
		{
//			delete( activeQueues[ queue.type ]);
			
			executeMessageHandlers( entries, message );
			
//			if(autoDispose)
//				queue.dispose();
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function executeMessageHandlers( entries:Array, message:* ):void
		{
			var entry:Object;
			
			for each ( entry in entries )
				if ( !entry.interceptor )
					( entry.handler as Function ).call( this, message );
		}
	}
}
