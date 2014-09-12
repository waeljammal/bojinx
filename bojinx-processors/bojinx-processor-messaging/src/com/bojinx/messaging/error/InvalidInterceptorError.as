package com.bojinx.messaging.error
{
	public class InvalidInterceptorError extends Error
	{
		public function InvalidInterceptorError(message:*="", id:*=0)
		{
			super(message, id);
		}
	}
}