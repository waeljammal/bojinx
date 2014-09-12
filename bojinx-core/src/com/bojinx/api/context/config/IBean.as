package com.bojinx.api.context.config
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.api.context.config.support.IPrioritySupport;
	
	/**
	 * Defines the contract for a basic Bean with support
	 * for prioritization.
	 * 
	 * @author Wael Jammal
	 */
	public interface IBean extends IPrioritySupport
	{
		/**
		 * Identifies the object using an string ID.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion Flex 4
		 */
		function get id():String;
		
		/**
		 * @private
		 */
		function set id( value:String ):void;
		
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
