package com.bojinx.api.processor
{
	import com.bojinx.api.context.IApplicationContext;
	
	public interface IProcessorFactory extends IProcessorConfiguration
	{
		function initialize( context:IApplicationContext ):void;
	}
}
