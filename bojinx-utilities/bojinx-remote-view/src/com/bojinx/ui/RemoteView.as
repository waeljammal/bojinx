package com.bojinx.ui
{
	import mx.core.UIComponent;
	
	public class RemoteView extends UIComponent
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _configUrl:String;
		
		public function get configUrl():String
		{
			return _configUrl;
		}
		
		public function set configUrl( value:String ):void
		{
			_configUrl = value;
		}
		
		private var _resources:String;
		
		public function get resources():String
		{
			return _resources;
		}
		
		public function set resources( value:String ):void
		{
			_resources = value;
		}
		
		private var _url:String;
		
		public function get url():String
		{
			return _url;
		}
		
		public function set url( value:String ):void
		{
			_url = value;
		}
		
		public function RemoteView()
		{
			super();
		}
	}
}
