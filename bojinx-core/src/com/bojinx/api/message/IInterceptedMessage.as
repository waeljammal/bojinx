package com.bojinx.api.message
{
	
	public interface IInterceptedMessage
	{
		function get handler():Function;
		
		function get message():*;
		
		function get topic():String;
		
		function get type():Class;
		
		function cancel():void;
		
		function resume():void;
	}
}
