package com.bojinx.api.context.loader.impl
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.api.context.loader.IConfigLoader;
	import com.bojinx.system.context.director.BeanLoadingDirector;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	[Event( name = "complete", type = "flash.events.Event" )]
	/**
	 * A helper class to simplify the process of loading configurations.
	 * 
	 * @author Wael Jammal
	 */
	public class ConfigurationLoaderBase extends EventDispatcher implements IConfigLoader
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _isLoaded:Boolean = false;
		
		public function get isLoaded():Boolean
		{
			return _isLoaded;
		}
		
		private var _isLoading:Boolean = false;
		
		public function get isLoading():Boolean
		{
			return _isLoading;
		}
		
		public function ConfigurationLoaderBase()
		{
		}
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		/**
		 * Begin loading configuration files.
		 * 
		 * @param context IApplicationContext
		 * @param director BeanLoadingDirector
		 */
		public function load( context:IApplicationContext, director:BeanLoadingDirector ):void
		{
			_isLoading = true;
		}
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		/**
		 * Call this method once you have finished the loading process.
		 */
		protected function complete():void
		{
			_isLoading = false;
			_isLoaded = true;
			dispatchEvent( new Event( Event.COMPLETE ));
		}
	}
}
