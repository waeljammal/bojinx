package com.bojinx.system.display
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.system.cache.store.ContextRegistry;
	import com.bojinx.system.context.event.ContextEvent;
	import com.bojinx.utils.logging.Logger;
	import com.bojinx.utils.logging.LoggingContext;
	import flash.utils.Dictionary;
	
	/**
	 * Handles the pausing of a context until
	 * the display chain is complete, this helps automate
	 * the context linkages without developer interaction.
	 */
	public class DisplayProcessingRegistry
	{
		public function DisplayProcessingRegistry()
		{
		}
		
		/*============================================================================*/
		/*= STATIC PROTECTED PROPERTIES                                               */
		/*============================================================================*/
		
		CONFIG::log
		protected static var log:Logger = LoggingContext.getLogger( DisplayProcessingRegistry );
		
		/*============================================================================*/
		/*= STATIC PRIVATE PROPERTIES                                                 */
		/*============================================================================*/
		
		private static var callbacks:Dictionary = new Dictionary();
		
		private static var contexts:Array = [];
		
		private static var pendingLoad:int = 0;
		
		private static var rootIsReady:Boolean = false;
		
		/*============================================================================*/
		/*= STATIC PUBLIC METHODS                                                     */
		/*============================================================================*/
		
		public static function notify( parent:IApplicationContext, load:Object ):void
		{
			callbacks[ parent ] = load;
		}
		
		public static function register( context:IApplicationContext ):void
		{
			contexts.push( context );
			
			if ( !rootIsReady )
				checkRoot( context );
			else
				context.addEventListener( ContextEvent.CONTEXT_LOADED, onChildContextLoaded );
		}
		
		public static function releaseContext( context:IApplicationContext ):void
		{
			var index:int = contexts.indexOf( context );
			
			if ( index > -1 )
				contexts.splice( index, 1 );
			
			delete( callbacks[ context ]);
		}
		
		/*============================================================================*/
		/*= STATIC PRIVATE METHODS                                                    */
		/*============================================================================*/
		
		private static function checkRoot( context:IApplicationContext ):void
		{
			var rootContext:IApplicationContext = ContextRegistry.rootContext;
			
			if ( rootContext &&
				rootContext == context &&
				!rootContext.isLoaded )
			{
				CONFIG::log
				{
					log.info( "Stage processing initialization delayed while child contexts are loaded" );
				}
				
				rootContext.addEventListener( ContextEvent.CONTEXT_LOADED, onRootConfigurationLoaded );
			}
		}
		
		private static function initializeRootStageProcessor( context:IApplicationContext, initialize:Boolean ):void
		{
			if(context.displayProcessor)
			{
				context.displayProcessor.addChild( context );
				context.displayProcessor.initialize( context );
			}
		}
		
		private static function onChildContextLoaded( event:ContextEvent ):void
		{
			event.currentTarget.removeEventListener( ContextEvent.CONTEXT_LOADED, onChildContextLoaded );
			
			var context:IApplicationContext = event.currentTarget as IApplicationContext;
			
			// If a root context exists then we add a child entry to that
			if ( ContextRegistry.rootContext.displayProcessor )
			{
				ContextRegistry.rootContext.displayProcessor.addChild( context );
				ContextRegistry.rootContext.displayProcessor.processStartingAt( context.owner );
			}
			// Otherwise check this context and it's parent's till we find a processor
			else
			{
				var parent:IApplicationContext = context;
				
				while ( parent )
				{
					if ( parent.displayProcessor )
					{
						parent.displayProcessor.addChild( context );
						
						if ( !parent.displayProcessor.initialized )
							parent.displayProcessor.initialize( context );
						
						break;
					}
					
					parent = parent.parent;
				}
			}
			
			if ( callbacks[ event.currentTarget ])
			{
				( callbacks[ event.currentTarget ] as Function ).call( event.currentTarget );
				delete( callbacks[ event.currentTarget ]);
			}
			
			contexts.splice( contexts.indexOf( context ), 1 );
		}
		
		private static function onRootConfigurationLoaded( event:ContextEvent ):void
		{
			var rootContext:IApplicationContext = ContextRegistry.rootContext;
			rootContext.removeEventListener( ContextEvent.CONTEXT_LOADED, onRootConfigurationLoaded );
			
			rootIsReady = true;
			
			pendingLoad = contexts.length - 1;
			
			if ( pendingLoad > 0 )
				initializeRootStageProcessor( rootContext, false );
			else
				initializeRootStageProcessor( rootContext, true );
			
			releaseContext( rootContext );
			
			while ( contexts.length > 0 )
			{
				rootContext = contexts.shift();
				rootContext.addEventListener( ContextEvent.CONTEXT_LOADED, onChildContextLoaded );
			}
		}
	}
}
