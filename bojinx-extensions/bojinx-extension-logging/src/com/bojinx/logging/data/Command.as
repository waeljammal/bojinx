package com.bojinx.logging.data
{
	
	[Bindable]
	[RemoteClass( "com.bojinx.logging.data.Command" )]
	public class Command
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _command:String;
		
		public function get command():String
		{
			return _command;
		}
		
		public function set command( value:String ):void
		{
			_command = value;
		}
		
		public function Command()
		{
		}
		
		
		/*============================================================================*/
		/*= STATIC PUBLIC PROPERTIES                                                  */
		/*============================================================================*/
		
		public static const CLEAR:String = "clear";
	}
}
