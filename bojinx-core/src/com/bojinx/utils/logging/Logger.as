package com.bojinx.utils.logging
{
	
	public interface Logger
	{
		/**
		 * The name of the logger.
		 */
		function get name():String;
		
		/**
		 * Logs a message with the <code>DEBUG</code> log level.
		 *
		 * @param message the log message
		 * @param error an optional Error instance associated with the log message.
		 */
		function debug( message:String, ... rest ):void;
		
		/**
		 * Logs a message with the <code>ERROR</code> log level.
		 *
		 * @param message the log message
		 * @param error an optional Error instance associated with the log message.
		 */
		function error( message:String, ... rest ):void;
		
		/**
		 * Logs a message with the <code>FATAL</code> log level.
		 *
		 * @param message the log message
		 * @param error an optional Error instance associated with the log message.
		 */
		function fatal( message:String, ... rest ):void;
		
		/**
		 * Logs a message with the <code>INFO</code> log level.
		 *
		 * @param message the log message
		 * @param error an optional Error instance associated with the log message.
		 */
		function info( message:String, ... rest ):void;
		
		/**
		 * Logs a message with the <code>TRACE</code> log level.
		 *
		 * @param message the log message
		 * @param error an optional Error instance associated with the log message.
		 */
		function trace( message:String, ... rest ):void;
		
		/**
		 * Logs a message with the <code>WARN</code> log level.
		 *
		 * @param message the log message
		 * @param error an optional Error instance associated with the log message.
		 */
		function warn( message:String, ... rest ):void;
	}
}
