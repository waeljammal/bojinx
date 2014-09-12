package com.bojinx.starling
{
	import com.bojinx.display.DisplayObjectProcessor;
	import com.bojinx.display.core.StageProcessor;
	import com.bojinx.starling.core.StarlingStageProcessor;
	import com.bojinx.starling.registry.StarlingStageObjectProcessorRegistry;
	
	import flash.display.DisplayObject;
	
	import org.as3commons.stageprocessing.IObjectSelector;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import starling.events.EventDispatcher;

	/**
	 * @Manifest
	 */
	public class StarlingDisplayObjectProcessor extends DisplayObjectProcessor
	{
		private var currentTarget:starling.display.DisplayObject;
		private var _mStarling:Starling;
		
		private static var _starlingRegistry:StarlingStageObjectProcessorRegistry = new StarlingStageObjectProcessorRegistry();
		
		public function StarlingDisplayObjectProcessor(mStarling:Starling, filter:IObjectSelector = null)
		{
			super(filter);
			_mStarling = mStarling;
			mStarling.addEventListener(Event.ROOT_CREATED, onRootCreated);
		}

		private function onRootCreated(event:Event):void
		{
			currentTarget = _mStarling.root;
			_starlingRegistry.stage = currentTarget;
			var child:StarlingStageProcessor = new StarlingStageProcessor( context.displayRouter, context );
			_starlingRegistry.registerStageObjectProcessor( child, filter, currentTarget );
			_starlingRegistry.enabled = true;
			_starlingRegistry.initialize();
		}
	}
}