package com.bojinx.system.cache.store
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.system.message.support.Scope;
	import flash.utils.Dictionary;
	
	public class MessageRegistry
	{
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var context:IApplicationContext;
		
		public function MessageRegistry( context:IApplicationContext )
		{
			this.context = context;
		}
		
		/*============================================================================*/
		/*= STATIC PRIVATE PROPERTIES                                                 */
		/*============================================================================*/
		
		private var interceptors:Dictionary = new Dictionary();
		
		private var listeners:Dictionary = new Dictionary();
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function clearAll():void
		{
			interceptors = new Dictionary( false );
			listeners = new Dictionary( false );
		}
		
		public function contains( handler:Function, type:Class, isInterceptor:Boolean ):Boolean
		{
			var allListeners:Array = isInterceptor ? interceptors[ type ] : listeners[ type ];
			var i:int;
			var entry:Object;
			
			if ( allListeners )
			{
				for ( i = 0; i < allListeners.length; i++ )
				{
					entry = allListeners[ i ];
					
					if ( entry.handler == handler && entry.type == type )
						return true
				}
			}
			
			return false;
		}
		
		public function get( type:Class, name:String, scope:String ):Array
		{
			var allListeners:Array = [];
			var result:Array = [];
			
			// Generic Interceptors
			if ( interceptors[ Object ])
				allListeners = allListeners.concat( interceptors[ Object ]);
			
			// Type specific Interceptors
			if ( interceptors[ type ])
				allListeners = allListeners.concat( interceptors[ type ]);
			
			// Because interceptors support generic types we need to resort
			doSort( allListeners );
			
			// Basic Listeners
			if ( listeners[ type ])
				allListeners = allListeners.concat( listeners[ type ]);
			
			if ( allListeners )
			{
				var i:int;
				var len:int = allListeners.length;
				var entry:Object;
				var allow:Boolean = false;
				
				for ( i = 0; i < len; i++ )
				{
					entry = allListeners[ i ];
					allow = false;
					
					if ( entry.type == type || entry.type == Object )
					{
						// Validate Name
						if ( name && entry.name && name == entry.name )
							allow = true;
						else if ( !name && !entry.name )
							allow = true;
						else if ( name && entry.name == "*" && entry.interceptor )
							allow = true;
						else if ( name && name == "*" && entry.interceptor )
							allow = true;
						else
							allow = false;
						
						// Validate Scope
						if ( allow && scope == Scope.GLOBAL && entry.scope == scope )
							allow = true;
						else if ( allow && scope == entry.scope && entry.interceptor && entry.name == null )
							allow = true;
						else if ( allow && scope == Scope.LOCAL && entry.context.id == context.id )
							allow = true;
						else if ( allow && scope != Scope.GLOBAL && scope != Scope.LOCAL && scope == entry.scope )
							allow = true;
						else
							allow = false;
						
						if ( allow )
							result.push( entry );
					}
				}
			}
			
			return result;
		}
		
		public function register( handler:Function, type:*, name:String,
								  scope:String, priority:int, isInterceptor:Boolean = false ):void
		{
			var allListeners:Array = isInterceptor ? interceptors[ type ] : listeners[ type ];
			var entry:Object;
			
			if ( !allListeners )
			{
				allListeners = [];
				
				if ( !isInterceptor )
					listeners[ type ] = allListeners;
				else
					interceptors[ type ] = allListeners;
			}
			
			entry = { handler: handler, name: name, scope: scope,
					priority: priority, context: context, type: type,
					interceptor: isInterceptor };
			
			allListeners.push( entry );
			
			doSort( allListeners );
		}
		
		public function remove( handler:Function, type:Class, isInterceptor:Boolean = false ):void
		{
			var allListeners:Array = isInterceptor ? interceptors[ type ] : listeners[ type ];
			var i:int;
			var entry:Object;
			
			if ( allListeners )
			{
				for ( i = 0; i < allListeners.length; i++ )
				{
					entry = allListeners[ i ];
					
					if ( entry.handler == handler && entry.type == type )
						allListeners.splice( i, 1 );
				}
			}
		}
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		/**
		 * Standard array sort re-aranges entries where the priority
		 * is 0 on both, because we want to sort based on depth of context
		 * as well as priority we use this optimized sort method instead.
		 */
		protected function doSort( allListeners:Array ):void
		{
			var temp:Object;
			var i:int, j:int;
			
			for ( i = 0; i < allListeners.length; i++ )
			{
				for ( j = allListeners.length - 1; j > i; j-- )
				{
					if ( allListeners[ j - 1 ].priority < allListeners[ j ].priority )
					{
						temp = allListeners[ j - 1 ];
						allListeners[ j - 1 ] = allListeners[ j ];
						allListeners[ j ] = temp;
					}
				}
			}
		}
	}
}
