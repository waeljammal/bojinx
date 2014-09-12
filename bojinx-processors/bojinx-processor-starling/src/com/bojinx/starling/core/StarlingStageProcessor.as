package com.bojinx.starling.core
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.starling.registry.DisposableStageObjectDestroyer;
	import com.bojinx.system.display.DisplayObjectRouter;
	import com.bojinx.utils.logging.Logger;
	import com.bojinx.utils.logging.LoggingContext;
	
	import flash.events.Event;
	
	import starling.display.DisplayObject;
	
	[Event( name = "complete", type = "flash.events.Event" )]
	public class StarlingStageProcessor extends DisposableStageObjectDestroyer
	{
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var context:IApplicationContext;
		
		private var router:DisplayObjectRouter;
		
		private var stage:*;
		
		public function StarlingStageProcessor( router:DisplayObjectRouter, context:IApplicationContext ):void
		{
			super();
			this.router = router;
			this.context = context;
		}
		
		/*============================================================================*/
		/*= STATIC PROTECTED PROPERTIES                                               */
		/*============================================================================*/
		
		CONFIG::log
		protected static var log:Logger = LoggingContext.getLogger( StarlingStageProcessor );
		
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
