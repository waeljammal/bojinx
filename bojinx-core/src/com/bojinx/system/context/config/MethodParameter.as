package com.bojinx.system.context.config
{
	
	
	/**
	 * <p>Defines a method parameter used within a MethodInvoker.</p>
	 *
	 * @see com.bojinx.system.context.config.ASObjectEntry
	 * @see com.bojinx.system.context.config.MethodInvoker
	 * @author Wael Jammal
	 * @Manifest
	 */
	public class MethodParameter
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _ref:String;
		
		/**
		 * The id of another Object Entry
		 */
		public function get ref():String
		{
			return _ref;
		}
		
		/**
		 * @private
		 */
		public function set ref( value:String ):void
		{
			_ref = value;
		}
		
		private var _value:*;
		
		/**
		 * An optional value to assign, this
		 * can not be used in conjunction with
		 * a ref.
		 */
		public function get value():*
		{
			return _value;
		}
		
		/**
		 * @private
		 */
		public function set value( value:* ):void
		{
			_value = value;
		}
		
		/**
		 * @private
		 */
		public function MethodParameter()
		{
		}
	}
}
