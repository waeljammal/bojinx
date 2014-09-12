package com.bojinx.api.context
{
	import flash.system.ApplicationDomain;
	
	/**
	 * Defines the contract for a component that is aware
	 * of it's own domain, this is useful for pop-ups, windows etc.
	 */
	public interface IApplicationDomainAware
	{
		/**
		 * Return the domain this component should exist in.
		 *
		 * @return ApplicationDomain
		 */
		function get domain():ApplicationDomain;
		
		/** @private */
		function set domain( value:ApplicationDomain ):void;
	}
}