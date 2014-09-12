package com.bojinx.api.context.ext
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.api.context.config.IConfigItem;

	/**
	 * Defines the contract for a Bojinx extension. Extensions
	 * simple have their <code>initialize()</code> method called
	 * once before any processors are ready and before context
	 * has dispatched it's ready event. 
	 * 
	 * <br /><br />
	 * 
	 * You can use this to add advanced features to the
	 * Context as well as many other uses.
	 */
	public interface IExtension extends IConfigItem
	{
		/**
		 * Initialize your extension.
		 * 
		 * @param context IApplication context that owns this extension.
		 */
		function initialize(context:IApplicationContext):void;
	}
}