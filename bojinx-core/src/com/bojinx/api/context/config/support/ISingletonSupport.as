package com.bojinx.api.context.config.support
{
	/**
	 * Defines the contract for a bean that
	 * can be treated as a singleton.
	 * 
	 * @author Wael Jammal
	 */
	public interface ISingletonSupport
	{
		/**
		 * Specifies if the given object is a singleton or not.
		 * <br />
		 * If the object is a singleton it will be cached and no
		 * other instances of the same type will be allowed.
		 *
		 * @default false
		 * @return Boolean True if it's a singleton
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion Flex 4
		 */
		function get singleton():Boolean;
		
		/**
		 * @private
		 */
		function set singleton( value:Boolean ):void;
	}
}
