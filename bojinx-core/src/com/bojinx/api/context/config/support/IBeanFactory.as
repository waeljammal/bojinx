package com.bojinx.api.context.config.support
{
	/**
	 * Defines the contract for a bean that supports
	 * the factory API used to generate an instance
	 * from the bean instead of using the bean itself.
	 * 
	 * @author Wael Jammal
	 */
	public interface IBeanFactory
	{
		function get factoryMethod():String;
		function set factoryMethod(value:String):void;
	}
}