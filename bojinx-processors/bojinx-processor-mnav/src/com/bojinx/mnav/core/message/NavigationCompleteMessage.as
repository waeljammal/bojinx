package com.bojinx.mnav.core.message
{
	
	public class NavigationCompleteMessage
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _finalDestination:String;
		
		public function get finalDestination():String
		{
			return _finalDestination;
		}
		
		private var _isExit:Boolean;
		
		public function get isExit():Boolean
		{
			return _isExit;
		}
		
		public function NavigationCompleteMessage( finalDestination:String, isExit:Boolean )
		{
			_finalDestination = finalDestination;
			_isExit = isExit;
		}
	}
}