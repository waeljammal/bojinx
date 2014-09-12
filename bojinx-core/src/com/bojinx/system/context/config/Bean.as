package com.bojinx.system.context.config
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.api.context.config.support.ILazySupport;
	import com.bojinx.api.context.config.support.ISingletonSupport;
	
	[DefaultProperty( "elements" )]
	[Exclude( kind = "property", name = "id" )]
	/**
	 * Object entry for a Context Configuration wrapper.
	 *
	 * @author Wael Jammal
	 */
	public class Bean extends ResolvableBean implements ISingletonSupport, ILazySupport
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _lazy:Boolean = false;
		
		/**
		 * Setting this to true will cause the managed
		 * object to only initialize the first time it is requested.
		 */
		public function get lazy():Boolean
		{
			return _lazy;
		}
		
		/**
		 * @private
		 */
		public function set lazy( value:Boolean ):void
		{
			_lazy = value;
		}
		
		private var _singleton:Boolean;
		
		/**
		 * False by default, set to true if you want
		 * only one instance of the managed object to
		 * ever exist.
		 *
		 * @default false
		 */
		public function get singleton():Boolean
		{
			return _singleton;
		}
		
		/**
		 * @private
		 */
		public function set singleton( value:Boolean ):void
		{
			_singleton = value;
		}
		
		/**
		 * Constructor takes arguments to simplify AS3 creation.
		 *
		 * @param source The source class type to be managed.
		 * @param id Optional identifier can be used to manage multiple instances of the same type.
		 * @param singleton false by default, set to true to only have a single instance shared accross all dependants.
		 */
		public function Bean( source:Class = null, id:String = null, singleton:Boolean = false )
		{
			super(source, id);
			
			this._singleton = singleton;
		}
		
		override protected function isSingleton():Boolean
		{
			return singleton;
		}
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		override public function register( context:IApplicationContext ):void
		{
			super.register(context);
		}
	}
}
