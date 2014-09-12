package com.bojinx.api.context.ext
{
	import com.bojinx.utils.logging.Logger;
	import com.bojinx.api.context.config.IConfigItem;
	
	/**
	 * Defines the contract for an externall logger, you can
	 * use this interface to return a Logger if you do not
	 * wish to use the version supplied with Bojinx.
	 * 
	 * @author Wael Jammal
	 */
	public interface ILoggerExtension extends IConfigItem
	{
		/**
		 * Return a Logger
		 * 
		 * @param name The name of the logger
		 * @return A new Logger instance.
		 * 
		 * @see com.bojinx.utils.logging.Logger
		 */
		function getLogger( name:* ):Logger;
	}
}
