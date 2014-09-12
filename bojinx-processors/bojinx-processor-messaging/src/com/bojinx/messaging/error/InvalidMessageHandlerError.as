package com.bojinx.messaging.error
{
	public class InvalidMessageHandlerError extends Error
	{
		public function InvalidMessageHandlerError(message:*="", id:*=0)
		{
			super(message, id);
		}
	}
}