package com.bojinx.api.context.loader
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.api.context.config.IBeans;
	import com.bojinx.system.context.director.BeanLoadingDirector;
	
	/**
	 * Defines the contract for a Configuration Loader
	 * 
	 * @author Wael Jammal
	 */
	public interface IConfigLoader extends IBeans
	{
		/**
		 * Returns true if the configuration has been loaded.
		 * 
		 * @default false
		 */
		function get isLoaded():Boolean;
		
		/** @private */
		function get isLoading():Boolean;
		
		/**
		 * Begin loading configuration files.
		 * 
		 * @param context IApplicationContext
		 * @param director BeanLoadingDirector
		 */
		function load( context:IApplicationContext, director:BeanLoadingDirector ):void;
	}
}
