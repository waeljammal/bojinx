package com.bojinx.api.context.config.support
{
	
	/**
	 * Implementing this interface on a Meta Data descriptor
	 * will enable support for automatic detection of managed objects
	 * which then get passed on to your processor saving you the time / code
	 * required to fetch the object your self.
	 *
	 * @author Wael Jammal
	 */
	public interface IBeanReferenceSupport extends IAutoDetectBeans
	{
		
		/**
		 * The id of the referenced bean.
		 */
		function get id():String;
		
		/** @private */
		function set id( value:String ):void;
	}
}
