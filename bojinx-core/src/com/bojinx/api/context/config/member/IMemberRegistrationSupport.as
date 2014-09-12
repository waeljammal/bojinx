package com.bojinx.api.context.config.member
{
	import com.bojinx.api.context.IApplicationContext;
	
	/**
	 * Defines the contract for a configuration member that can be
	 * registered with the context. This is used for member's of a
	 * bean.
	 * 
	 * @author Wael Jammal
	 */
	public interface IMemberRegistrationSupport
	{
		/**
		 * Implement this method to register a configuration entry with the context or a resolver
		 *
		 * @param context The context the entry belongs to
		 * @param registry The resolver factory can be used to get or generate a resolver
		 * @param resolver The resolver for the class that owns the entry
		 */
		function register( context:IApplicationContext ):void;
	}
}
