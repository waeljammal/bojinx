package com.bojinx.system.display
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.api.processor.display.IViewManager;
	import com.bojinx.system.cache.store.ContextRegistry;
	import com.bojinx.utils.logging.Logger;
	import com.bojinx.utils.logging.LoggingContext;
	import flash.events.EventDispatcher;
	
	public class DisplayObjectRouter extends EventDispatcher
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _viewManager:IViewManager;
		
		public function get viewManager():IViewManager
		{
			return _viewManager;
		}
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var context:IApplicationContext;
		
		private var pending:Array = [];
		
		public function DisplayObjectRouter( context:IApplicationContext )
		{
			super( context );
			
			this.context = context;
		}
		
		
		/*============================================================================*/
		/*= STATIC PROTECTED PROPERTIES                                               */
		/*============================================================================*/
		
		CONFIG::log
		protected static var log:Logger = LoggingContext.getLogger( DisplayObjectRouter );
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public final function destroy( value:Object ):void
		{
			if ( !_viewManager )
				_viewManager = context.displayProcessor.getViewManager();
			
			if ( context.owner == value && context.viewSettings.autoReleaseContexts )
			{
				CONFIG::log
				{
					log.debug( "Detected Context Owner Display Object Removal " + value + " owned by [Context] " + context.id );
				}
				
				var allViews:Array = viewManager.getAll();
				var view:*;
				
				while ( allViews.length > 0 )
				{
					view = allViews.pop();
					context.releaseObject( view.view );
					viewManager.remove( view.view );
				}
				
				context.unload();
			}
			else if(context && context.viewSettings.autoReleaseComponents)
			{
				CONFIG::log
				{
					log.debug( "Detected Display Object Removal " + value + " owned by [Context] " + context.id );
				}
				
				viewManager.remove( value );
				context.releaseObject( value );
			}
		}
		
		public function dispose():void
		{
			context = null;
		}
		
		public final function process( value:Object ):void
		{
			var isContextOwner:IApplicationContext = ContextRegistry.getContextForChild( value );
			
			if ( isContextOwner && !isContextOwner.isLoaded && isContextOwner != context )
			{
				isContextOwner.attachDisplayProcessor( context );
				return;
			}
			
			if ( !_viewManager )
				_viewManager = context.displayProcessor.getViewManager();
			
			if ( viewManager.contains( value ))
				return;
			
			CONFIG::log
			{
				log.debug( "Detected Display Object " + value + " [Context] " + context.id );
			}
			
			if ( context.isLoaded )
			{
				viewManager.add( value );
				context.processObject( value );
			}
			else
			{
				pending.push( value );
			}
		}
	}
}
