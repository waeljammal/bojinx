package com.bojinx.system.cache.store
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.system.context.ApplicationContext;
	
	import flash.utils.Dictionary;
	
	public class ContextRegistry
	{
		public function ContextRegistry()
		{
		}
		
		
		/*============================================================================*/
		/*= STATIC PUBLIC PROPERTIES                                                  */
		/*============================================================================*/
		
		private static var _rootContext:IApplicationContext;
		
		public static function get rootContext():IApplicationContext
		{
			return _rootContext;
		}
		
		/*============================================================================*/
		/*= STATIC PRIVATE PROPERTIES                                                 */
		/*============================================================================*/
		
		private static var contexts:Dictionary = new Dictionary();
		
		private static var contextsByOwner:Dictionary = new Dictionary();
		
		
		/*============================================================================*/
		/*= STATIC PUBLIC METHODS                                                     */
		/*============================================================================*/
		
		public static function getContextByOwner(owner:Object):IApplicationContext
		{
			return contextsByOwner[owner];
		}
		
		public static function getContextForChild( child:Object ):IApplicationContext
		{
			var p:Object = child;
			
			while ( p )
			{
				if ( contextsByOwner[ p ])
					return contextsByOwner[ p ];
				
				if ( p.hasOwnProperty( "parent" ))
					p = p.parent;
				else
					p = null;
			}
			
			return null;
		}
		
		public static function getParentForContext( context:IApplicationContext ):IApplicationContext
		{
			if ( context.viewSettings.inheritFromParentContext )
			{
				var parent:Object = context.owner.parent;
				
				while ( parent )
				{
					if ( contextsByOwner[ parent ])
						return contextsByOwner[ parent ];
					
					parent = parent.parent;
				}
			}
			
			return null;
		}
		
		public static function register( context:IApplicationContext ):void
		{
			if ( contexts[ context.id ])
				throw new Error( "A context with ID " + context.id + " in " + context.owner +
								 " is already registered, please use a unique name for each context" );
			
			contexts[ context.id ] = context;
			contextsByOwner[ context.owner ] = context;
			
			if ( !rootContext )
				_rootContext = context;
		}
		
		public static function release( context:ApplicationContext ):void
		{
			if ( contexts[ context.id ])
			{
				delete( contextsByOwner[ context.owner ]);
				delete( contexts[ context.id ])
			}
		}
	}
}
