package com.bojinx.system.context.loaders.config
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.api.context.loader.impl.ConfigurationLoaderBase;
	import com.bojinx.system.context.config.Beans;
	import com.bojinx.system.context.director.BeanLoadingDirector;
	import com.bojinx.utils.logging.Logger;
	import com.bojinx.utils.logging.LoggingContext;
	
	[DefaultProperty( "source" )]
	/**
	 * <p>An embeded configuration entry to be supplied to a context for loading.</p>
	 * <p><b>Warning: </b>The source has to be a type of Class.</p>
	 * <p>Note: You can create your own config and processor to parse it.</p>
	 *
	 * @Manifest
	 */
	public class EmbeddedConfig extends ConfigurationLoaderBase
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _source:*;
		
		/**
		 * The Class Type of the objects configuration entry
		 */
		public function get source():*
		{
			return _source;
		}
		
		/**
		 * @private
		 */
		public function set source( value:* ):void
		{
			_source = value;
		}
		
		/**
		 * Constructor takes arguments for AS3 usage.
		 *
		 * @param source Class Type of the objects configuration entry.
		 */
		public function EmbeddedConfig( source:* = null )
		{
			_source = source;
		}
		
		/*============================================================================*/
		/*= STATIC PROTECTED PROPERTIES                                               */
		/*============================================================================*/
		
		CONFIG::log
		protected static var log:Logger = LoggingContext.getLogger( EmbeddedConfig );
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		override public final function load( context:IApplicationContext, director:BeanLoadingDirector ):void
		{
			super.load( context, director );
			
			// Objects container
			var objects:Beans = getObjects( context );
			loadProcessorFactories( objects, context, director );
			loadManagedObjects( objects, context, director );
			complete();
		}
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		[Inline]
		protected function loadManagedObjects( objects:Beans, context:IApplicationContext, director:BeanLoadingDirector ):void
		{
			var i:int;
			var entries:Array = objects.objects;
			var len:int = entries.length;
			
			for ( i = 0; i < len; i++ )
				director.addBean( entries[ i ]);
		}
		
		[Inline]
		protected function loadProcessorFactories( objects:Beans, context:IApplicationContext, director:BeanLoadingDirector ):void
		{
			var i:int;
			var entries:Array = objects.processors;
			var len:int = entries.length;
			
			for ( i = 0; i < len; i++ )
				director.addProcessorFactory( entries[ i ]);
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function getObjects( context:IApplicationContext ):Beans
		{
			var objects:Beans;
			
			try
			{
				objects = new ( source as Class )() as Beans;
			}
			catch ( e:Error )
			{
				throw new Error( "Invalid Objects Configuration Container " + source +
								 " in Application Context " + context.id + " Error: " + e.message );
			}
			
			return objects;
		}
	}
}
