package com.bojinx.system.context.loaders.extensions
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.api.context.ext.IExtension;
	import com.bojinx.api.context.ext.ILoggerExtension;
	import com.bojinx.api.util.IDisposable;
	import com.bojinx.system.context.loaders.settings.ViewSettings;
	import com.bojinx.utils.logging.Logger;
	import com.bojinx.utils.logging.LoggingContext;
	
	/**
	 * @Manifest
	 */
	public class ExtentionLoader implements IDisposable
	{
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var context:IApplicationContext;
		
		public function ExtentionLoader( context:IApplicationContext )
		{
			this.context = context;
		}
		
		/*============================================================================*/
		/*= STATIC PROTECTED PROPERTIES                                               */
		/*============================================================================*/
		
		CONFIG::log
		protected static var log:Logger = LoggingContext.getLogger( ExtentionLoader );
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function dispose():void
		{
			context = null;
		}
		
		public function load():void
		{
			for each ( var i:* in context.configFiles )
			{
				if ( i is ILoggerExtension )
					LoggingContext.registerLogger( i );
				else if(i is ViewSettings)
					context.viewSettings = i;
				else if(i is IExtension)
					IExtension(i).initialize(context);
			}	
		}
	}
}
