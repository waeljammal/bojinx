package com.bojinx.system.context.config
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.api.context.config.member.IMemberRegistrationSupport;
	
	[DefaultProperty( "parameters" )]
	/**
	 * <p>Defines a method invoker used within an ObjectEntry.</p>
	 *
	 * <p>Invokes a method when the object reaches the ready lifecycle stage,
	 * you can change the stage by setting the stage property on this object.</p>
	 *
	 * @see com.bojinx.system.context.config.ASObjectEntry
	 * @author Wael Jammal
	 * @Manifest
	 */
	public class MethodInvoker implements IMemberRegistrationSupport
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _name:String;
		
		/**
		 * The name of the method to invoke
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
		
		private var _parameters:Array;
		
		[ArrayElementType( "com.bojinx.system.context.config.MethodParameter" )]
		/**
		 * Optional method parameters to pass.
		 *
		 * @see com.bojinx.system.context.config.MethodParameter
		 */
		public function get parameters():Array
		{
			return _parameters;
		}
		
		/**
		 * @private
		 */
		public function set parameters( value:Array ):void
		{
			_parameters = value;
		}
		
		/**
		 * @private
		 */
		public function MethodInvoker()
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
