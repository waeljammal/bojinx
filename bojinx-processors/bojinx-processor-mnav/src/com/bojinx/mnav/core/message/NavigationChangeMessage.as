package com.bojinx.mnav.core.message
{
	public class NavigationChangeMessage
	{
		private var _oldDestination:String
		private var _newDestination:String;
		
		public function get oldDestination():String
		{
			return _oldDestination;
		}

		public function get newDestination():String
		{
			return _newDestination;
		}

		public function NavigationChangeMessage(oldDestination:String, newDestination:String)
		{
			this._oldDestination = oldDestination;  
			this._newDestination = newDestination;  
			super();
		}
	}
}