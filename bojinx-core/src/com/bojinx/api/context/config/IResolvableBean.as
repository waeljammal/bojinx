package com.bojinx.api.context.config
{
	import com.bojinx.system.cache.definition.ObjectDefinition;
	import com.bojinx.system.context.config.MethodInvoker;
	
	/**
	 * Defines the contract for a bean that can resolve
	 * it's own dependencies. This is an extension of the
	 * basic Bean.
	 * 
	 * @see com.bojinx.api.context.config.IBean
	 * @see com.bojinx.system.context.config.ResolvableBean
	 * 
	 * @author Wael Jammal
	 */
	public interface IResolvableBean extends IBean
	{
		/**
		 * Specifies the source class of the configuration entry.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion Flex 4
		 */
		function get source():Class;
		
		/**
		 * @private
		 */
		function set source( value:Class ):void;
		
		/**
		 * Constructor Arguments
		 * 
		 * @see com.bojinx.system.context.config.ConstructorArg;
		 * @see com.bojinx.api.context.config.member.IMemberRegistrationSupport
		 */
		function get constructorArgs():Array;
		
		/** @private */
		function set constructorArgs( value:Array ):void;
		
		/**
		 * Properties
		 * 
		 * @see com.bojinx.system.context.config.Property;
		 * @see com.bojinx.api.context.config.member.IMemberRegistrationSupport
		 */
		function get properties():Array;
		
		/** @private */
		function set properties( value:Array ):void;
		
		/**
		 * Method Invokers
		 * 
		 * @see com.bojinx.system.context.config.MethodInvoker;
		 * @see com.bojinx.api.context.config.member.IMemberRegistrationSupport
		 */
		function get methodInvokers():Array;
		
		/** @private */
		function set methodInvokers( value:Array ):void;

		/**
		 * Returns an instance wrapped in an ObjectDefinition
		 * which you can use to access reflection data and general
		 * information about the bean.
		 * 
		 * @return ObjectDefinition wrapper for the instance.
		 */
		function getInstance():ObjectDefinition;
		
		/**
		 * Returns true if the bean implements an interface
		 * with the given name.
		 * 
		 * @param name The name of the interface (Fully Qualified)
		 * @return True if the interface is implemented
		 */
		function implementsInterface(name:String):Boolean;
		
		/**
		 * A helper method that can be used when MXML is not required to add a Constructor Argument
		 * 
		 * @see com.bojinx.system.context.config.ConstructorArg;
		 * @param value ContructorArg
		 */
		function addConstructorArg(value:com.bojinx.system.context.config.ConstructorArg):void;
		
		/**
		 * A helper method that can be used when MXML is not required to add a Property.
		 * 
		 * @see com.bojinx.system.context.config.Property;
		 * @param value Property
		 */
		function addProperty(value:com.bojinx.system.context.config.Property):void;
		
		/**
		 * A helper method that can be used when MXML is not required to add a Method Invoker.
		 * 
		 * @see com.bojinx.system.context.config.MethodInvoker;
		 * @param value MethodInvoker
		 */
		function addMethod(value:com.bojinx.system.context.config.MethodInvoker):MethodInvoker;
	}
}
