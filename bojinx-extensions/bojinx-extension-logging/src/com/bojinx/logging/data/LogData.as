package com.bojinx.logging.data
{
	import com.bojinx.logging.utils.StringUtils;
	import mx.utils.UIDUtil;
	
	[Bindable]
	[RemoteClass( "com.bojinx.logging.data.LogData" )]
	public class LogData
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _className:String;
		
		public function get className():String
		{
			return _className;
		}
		
		public function set className( value:String ):void
		{
			if ( value )
			{
				_className = StringUtils.remove( value, "[class " );
				_className = StringUtils.remove( _className, "]" );
			}
			else
				_className = value;
		}
		
		public var dataType:String;
		
		public var date:Date;
		
		[Transient]
		public var hasErrorOrWarning:Boolean;
		
		public var id:String = UIDUtil.createUID();
		
		public var level:String;
		
		public var message:*;
		
		[Transient]
		public var selected:Boolean;
		
		public function get time():String
		{
			return date ? date.getHours() + ":" + date.getMinutes() + ":" + date.getSeconds() : "NA";
		}
		
		public function LogData()
		{
		}
	}
}
