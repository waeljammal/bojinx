package com.bojinx.api.processor
{
	import com.bojinx.api.context.IApplicationContext;
	
	public interface IProcessorConfigurationFactory extends IProcessorFactory
	{
		function get mode():String;
		function get initialized():Boolean;
		function get name():String;
		function get supportedMetadata():Array;
		function get phase():int;

		function postInitialize( context:IApplicationContext ):void;
		function getInstance( context:IApplicationContext ):IProcessor;
	}
}
