package com.bojinx.logging
{
	import com.bojinx.api.context.ext.ILoggerExtension;
	import com.bojinx.utils.logging.Logger;
	import org.spicefactory.lib.flash.logging.Appender;
	import org.spicefactory.lib.flash.logging.FlashLogFactory;
	import org.spicefactory.lib.flash.logging.LogLevel;
	import org.spicefactory.lib.flash.logging.impl.DefaultLogFactory;
	import org.spicefactory.lib.logging.LogContext;
	
	[DefaultProperty( "appenders" )]
	/**
	 * Logging extension for the spice lib logging utility.
	 *
	 * @author Wael Jammal
	 */
	public class LoggingExtension implements ILoggerExtension
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _appenders:Array;
		
		[ArrayElementType( "org.spicefactory.lib.flash.logging.Appender" )]
		public function get appenders():Array
		{
			return _appenders;
		}
		
		public function set appenders( value:Array ):void
		{
			_appenders = value;
			
			check();
		}
		
		private var _logLevel:String;
		
		[Inspectable( enumeration = "off,info,warn,debug,error,fatal" )]
		public function set logLevel( value:String ):void
		{
			_logLevel = value.toLowerCase();
			
			updateLogLevel();
		}
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var currentLogLevel:String;
		
		private var factory:FlashLogFactory;
		
		private var initialized:Boolean = false;
		
		public function LoggingExtension()
		{
			initDebug();
		}
		
		
		/*============================================================================*/
		/*= STATIC PUBLIC PROPERTIES                                                  */
		/*============================================================================*/
		
		public static const DEBUG:String = "debug";
		
		public static const ERROR:String = "error";
		
		public static const FATAL:String = "fatal";
		
		public static const INFO:String = "info";
		
		public static const OFF:String = "off";
		
		public static const WARN:String = "warn";
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function getLogger( name:* ):Logger
		{
			return LogContext.getLogger( name );
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function check():void
		{
			if ( factory && appenders && !initialized )
			{
				initialized = true;
				
				for each ( var i:Appender in appenders )
				{
					var app:Appender = i;
					factory.addAppender( app );
				}
				
				LogContext.factory = factory;
				factory.addLogLevel( "org.spicefactory", LogLevel.WARN );
				updateLogLevel();
			}
		}
		
		private function initDebug():void
		{
			factory = new DefaultLogFactory();
			
			check();
		}
		
		private function updateLogLevel():void
		{
			if ( !initialized || currentLogLevel == _logLevel )
				return;
			
			currentLogLevel = _logLevel;
			
			switch ( _logLevel )
			{
				case OFF:
					factory.setRootLogLevel( LogLevel.OFF );
					break;
				case INFO:
					factory.setRootLogLevel( LogLevel.INFO );
					break;
				case WARN:
					factory.setRootLogLevel( LogLevel.WARN );
					break;
				case DEBUG:
					factory.setRootLogLevel( LogLevel.DEBUG );
					break;
				case ERROR:
					factory.setRootLogLevel( LogLevel.ERROR );
					break;
				case FATAL:
					factory.setRootLogLevel( LogLevel.FATAL );
					break;
				default:
					factory.setRootLogLevel( LogLevel.WARN );
			}
		}
	}
}
