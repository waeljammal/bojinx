package com.bojinx.command.config.factory
{
	[DefaultProperty("commands")]
	public class CommandFlowFactory
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _commands:Array;
		
		[ArrayElementType( "com.bojinx.command.config.factory.CommandFactory" )]
		public function get commands():Array
		{
			return _commands;
		}
		
		public function set commands( value:Array ):void
		{
			_commands = value;
		}
		
		[Inspectable(enumeration="sequential,concurrent")]
		public var mode:String = "sequential";
		
		public function CommandFlowFactory()
		{
		}
	}
}