package com.bojinx.reflection
{
	/**
	 * Describes a Parameter of a Method.
	 * 
	 * @author Wael Jammal
	 */
	public class Parameter
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _paramterType:ClassInfo;
		
		/**
		 * Type info for the parameter
		 * 
		 * @return ClassInfo
		 * @default null
		 */
		public function get paramterType():ClassInfo
		{
			return _paramterType;
		}
		
		private var _required:Boolean;
		
		/**
		 * Returns true if the parameter is
		 * required
		 *
		 * @return true if required
		 */
		public function get required():Boolean
		{
			return _required;
		}
		
		/** @private */
		public function Parameter( info:Object, classInfo:ClassInfo )
		{
			_paramterType = classInfo;
			_required = info.optional == false;
		}
	}
}