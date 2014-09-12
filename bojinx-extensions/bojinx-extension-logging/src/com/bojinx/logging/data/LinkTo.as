package com.bojinx.logging.data
{
	
	[Bindable]
	[RemoteClass( "com.bojinx.logging.data.LinkTo" )]
	public class LinkTo
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _arrowFrom:Boolean;
		
		public function get arrowFrom():Boolean
		{
			return _arrowFrom;
		}
		
		public function set arrowFrom( value:Boolean ):void
		{
			_arrowFrom = value;
		}
		
		private var _arrowTo:Boolean;
		
		public function get arrowTo():Boolean
		{
			return _arrowTo;
		}
		
		public function set arrowTo( value:Boolean ):void
		{
			_arrowTo = value;
		}
		
		private var _linkToId:String;
		
		public function get linkToId():String
		{
			return _linkToId;
		}
		
		public function set linkToId( value:String ):void
		{
			_linkToId = value;
		}
		
		public function LinkTo()
		{
		}
	}
}
