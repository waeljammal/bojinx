package com.bojinx.command.util.error
{
	public class InvalidCommandError extends Error
	{
		public function InvalidCommandError(message:*="", id:*=0)
		{
			super(message, id);
		}
	}
}