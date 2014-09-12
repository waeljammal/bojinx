package com.bojinx.api.context.config.support
{
	/**
	 * Defines the contract for Annotations
	 * that can be prioritized.
	 *
	 * <br /><br />
	 * 
	 * Higher number = Low Priority
	 * Lower number = High Priority
	 *
	 * @author Wael Jammal
	 */
	public interface IPrioritySupport
	{
		/**
		 * The priority value to be used
		 * for ordering.
		 */
		function get priority():int;
		
		/** @private */
		function set priority( value:int ):void;
	}
}
