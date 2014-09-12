package com.bojinx.system.context.config
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.api.context.config.member.IMemberRegistrationSupport;
	
	/**
	 * Defines a constructor argument used within an ObjectEntry.
	 *
	 * @see com.bojinx.system.context.config.ASObjectEntry
	 * @author Wael Jammal
	 * @Manifest
	 */
	public class ConstructorArg implements IMemberRegistrationSupport
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _ref:String;
		
		/**
		 * The id of another Object Entry.
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
		public function ConstructorArg()
		{
		}
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function register( context:IApplicationContext ):void
		{
			
		}
	}
}
