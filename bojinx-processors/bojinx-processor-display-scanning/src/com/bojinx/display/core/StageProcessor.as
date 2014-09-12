package com.bojinx.display.core
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.system.cache.store.ContextRegistry;
	import com.bojinx.system.display.DisplayObjectRouter;
	import com.bojinx.utils.logging.Logger;
	import com.bojinx.utils.logging.LoggingContext;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import org.as3commons.stageprocessing.impl.DisposableStageObjectDestroyer;
	
	[Event( name = "complete", type = "flash.events.Event" )]
	public class StageProcessor extends DisposableStageObjectDestroyer
	{
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var context:IApplicationContext;
		
		private var router:DisplayObjectRouter;
		
		private var stage:*;
		
		public function StageProcessor( router:DisplayObjectRouter, context:IApplicationContext ):void
		{
			super();
			this.router = router;
			this.context = context;
		}
		
		/*============================================================================*/
		/*= STATIC PROTECTED PROPERTIES                                               */
		/*============================================================================*/
		
		CONFIG::log
		protected static var log:Logger = LoggingContext.getLogger( StageProcessor );
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		override public function destroy( displayObject:DisplayObject ):DisplayObject
		{
			super.destroy( displayObject );
			
			if ( !context.isUnloading )
				context.displayRouter.destroy( displayObject );
			
			return displayObject;
		}
		
		override public function process( displayObject:DisplayObject ):DisplayObject
		{
			if ( !context.isUnloading )
				context.displayRouter.process( displayObject );
			
			return displayObject;
		}
	}
}
