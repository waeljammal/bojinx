package com.bojinx.api.processor.display
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.api.processor.IProcessorConfiguration;
	
	public interface IStageProcessor extends IProcessorConfiguration
	{
		function get initialized():Boolean;
		function get name():String;
		
		function getViewManager():IViewManager;
		function addChild( context:IApplicationContext ):void;
		function initialize( context:IApplicationContext ):void;
		function processStartingAt( target:Object ):void;
		function registerStage( context:IApplicationContext ):void;
		function removeChild( context:IApplicationContext ):void;
	}
}
