package com.bojinx.api.context.config.support
{
	
	/**
	 * Defines the contract for a bean that can references multiple
	 * beans, when this is used Bojinx will supply a list of dependencies
	 * that can be used in your processor, each dependency would relate to
	 * each of the id's provided through this contract.
	 *
	 * @author Wael Jammal
	 */
	public interface IMultiBeanReferenceSupport extends IAutoDetectBeans
	{
		/**
		 * Array of ID's which are
		 * other beans.
		 */
		function getIds():Array;
	}
}
