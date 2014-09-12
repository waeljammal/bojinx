package com.bojinx.system.context.config
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.api.context.config.member.IMemberRegistrationSupport;
	
	/**
	 * Defines a property used within an ObjectEntry.
	 *
	 * @see com.bojinx.system.context.config.ASObjectEntry
	 * @author Wael Jammal
	 * @Manifest
	 */
	public class Property implements IMemberRegistrationSupport
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _name:String;
		
		/**
		 * The name of the property
		 */
		public function get name():String
		{
			return _name;
		}
		
		/**
		 * @private
		 */
		public function set name( value:String ):void
		{
			_name = value;
		}
		
		private var _ref:String;
		
		/**
		 * Optional reference to another object entry ID.
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
		public function Property( name:String = null, value:* = null, ref:String = null )
		{
			_name = name;
			_value = value;
			_ref = ref;
		}
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function register( context:IApplicationContext ):void
		{
			
		}
	}
}
