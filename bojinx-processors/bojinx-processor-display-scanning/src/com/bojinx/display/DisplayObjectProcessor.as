package com.bojinx.display
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.api.processor.display.IStageProcessor;
	import com.bojinx.api.processor.display.IViewManager;
	import com.bojinx.display.core.StageProcessor;
	import com.bojinx.display.core.ViewManager;
	import flash.display.DisplayObject;
	import org.as3commons.stageprocessing.IObjectSelector;
	import org.as3commons.stageprocessing.IStageObjectProcessor;
	import org.as3commons.stageprocessing.impl.StageObjectProcessor;
	
	[DefaultProperty( "filter" )]
	/**
	 * @Manifest
	 */
	public class DisplayObjectProcessor implements IStageProcessor
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _filter:IObjectSelector;
		
		public function get filter():IObjectSelector
		{
			return _filter;
		}
		
		public function set filter( value:IObjectSelector ):void
		{
			_filter = value;
		}
		
		private var _initialized:Boolean;
		
		public function get initialized():Boolean
		{
			return _initialized;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get name():String
		{
			return "as3_commons_display_object_scanner";
		}
		
		private var _viewManager:ViewManager;
		
		public function get viewManager():ViewManager
		{
			return _viewManager;
		}
		
		/*============================================================================*/
		/*= PROTECTED PROPERTIES                                                      */
		/*============================================================================*/
		
		private var _context:IApplicationContext;
		
		protected function get context():IApplicationContext
		{
			return _context;
		}
		
		/**
		 * @private
		 */
		public function DisplayObjectProcessor( filter:IObjectSelector = null )
		{
			if ( filter )
				_filter = filter;
		}
		
		
		/*============================================================================*/
		/*= STATIC PUBLIC PROPERTIES                                                  */
		/*============================================================================*/
		
		private static var _registry:StageObjectProcessor = new StageObjectProcessor();
		
		public static function get registry():StageObjectProcessor
		{
			return _registry;
		}
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function addChild( context:IApplicationContext ):void
		{
			var child:StageProcessor = new StageProcessor( context.displayRouter, context );
			var filter:IObjectSelector = context.displayProcessor ? context.displayProcessor[ "filter" ] : filter;
			registry.registerStageObjectProcessor( child, filter, context.owner as DisplayObject );
		}
		
		public function getViewManager():IViewManager
		{
			if(!_viewManager)
				_viewManager = new ViewManager();
			
			return viewManager;
		}
		
		public function initialize( context:IApplicationContext ):void
		{
			// One Registry
			registerStage( context );
			_context = context;
			_initialized = true;
		}
		
		public function processStartingAt( target:Object ):void
		{
			registry.processStage( target as DisplayObject );
		}
		
		public function registerStage( context:IApplicationContext ):void
		{
			if ( registry && !registry.stage )
			{
				registry.stage = context.owner.stage;
				
				if ( !registry.initialized && registry.stage )
				{
					registry.initialize();
					registry.enabled = true;
				}
			}
		}
		
		public function removeChild( context:IApplicationContext ):void
		{
			var processors:Vector.<IStageObjectProcessor> = registry.getStageProcessorsByRootView( context.owner );
			
			for each ( var i:IStageObjectProcessor in processors )
				registry.unregisterStageObjectProcessor( i );
		}
	}
}
