package com.bojinx.reflection
{
	
	public class Constructor extends MetaDataAware
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _parameters:Array;
		
		public function get parameters():Array
		{
			return _parameters;
		}
		
		public function Constructor( info:Object, parameters:Array, owner:ClassInfo )
		{
			super( info, -1, owner );
			_parameters = parameters;
		}
	}
}
