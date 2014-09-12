package com.bojinx.api.context.config.support
{
	/**
	 * Defines the contract for beans that can be initialized lazily.
	 * 
	 * @author Wael Jammal
	 */
	public interface ILazySupport
	{
		/**
		 * Setting this to true will cause the managed
		 * object to only initialize the first time it is requested.
		 * 
		 * <br /><br />
		 * 
		 * In the case of singletons, the singleton would be created
		 * the firt time it is requested and cached for every use there after.
		 * 
		 * @author Wael Jammal
		 */
		function get lazy():Boolean;
		
		/**
		 * @private
		 */
		function set lazy( value:Boolean ):void
	}
}
