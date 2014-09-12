package com.bojinx.mnav.core.adapter
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.mnav.config.SiteMap;
	import com.bojinx.mnav.operation.MNavProcessorOperation;

	public interface IMnavAdapter
	{
		function setContext( value:IApplicationContext ):void;
		function setSiteMap( value:SiteMap ):void;
		function setProcessor(value:MNavProcessorOperation):void;
	}
}