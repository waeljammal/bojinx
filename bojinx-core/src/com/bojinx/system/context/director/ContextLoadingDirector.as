package com.bojinx.system.context.director
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.api.context.config.IConfigItem;
	import com.bojinx.api.context.loader.IConfigLoader;
	import com.bojinx.system.context.ApplicationContext;
	import com.bojinx.utils.logging.Logger;
	import com.bojinx.utils.logging.LoggingContext;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	[Event( name = "complete", type = "flash.events.Event" )]
	/**
	 * Manages the loading process for configuration loaders.
	 *
	 * @author Wael Jammal
	 */
	public final class ContextLoadingDirector extends EventDispatcher
	{
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var context:IApplicationContext;
		
		private var pending:Array = [];
		
		public function ContextLoadingDirector( context:ApplicationContext )
		{
			this.context = context;
		}
		
		/*============================================================================*/
		/*= STATIC PROTECTED PROPERTIES                                               */
		/*============================================================================*/
		
		CONFIG::log
		protected static var log:Logger = LoggingContext.getLogger( ContextLoadingDirector );
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public final function append( config:IConfigItem ):void
		{
			pending.push( config );
		}
		
		public final function process():void
		{
			var entry:IConfigItem;
			
			var director:BeanLoadingDirector = new BeanLoadingDirector(context);
			
			CONFIG::log
			{
				log.debug( "------------------------- STARTING - LOADING BEANS -------------------------" );
			}
			
			while ( pending.length > 0 )
			{
				entry = pending.pop();
				
				if ( entry is IConfigLoader )
					processConfigEntry( entry as IConfigLoader, director );
			}
			
			director.load();
			
			CONFIG::log
			{
				log.debug( "------------------------- FINISHED - LOADING BEANS -------------------------" );
			}
			
			director.dispose();
			director = null;
			
			dispatchEvent( new Event( Event.COMPLETE ));
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private final function processConfigEntry( entry:IConfigLoader, director:BeanLoadingDirector ):void
		{
			if ( !entry.isLoaded && !entry.isLoading )
				entry.load( context, director );
		}
	}
}
