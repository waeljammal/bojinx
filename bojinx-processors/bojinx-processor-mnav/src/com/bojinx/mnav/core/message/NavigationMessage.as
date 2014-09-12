package com.bojinx.mnav.core.message
{
	
	public class NavigationMessage
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _destination:String;
		
		public function get destination():String
		{
			return _destination;
		}
		
		public function NavigationMessage( cur:String)
		{
			_destination = cur;
		}
	}
}