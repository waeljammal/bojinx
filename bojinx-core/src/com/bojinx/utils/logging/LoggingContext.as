package com.bojinx.utils.logging
{
	import com.bojinx.api.context.ext.ILoggerExtension;
	
	/**
	 * A Logging context that supports multiple loggers.
	 *
	 * @author Wael Jammal
	 */
	public class LoggingContext implements Logger
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _name:String;
		
		public function get name():String
		{
			return _name;
		}
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var activeLoggers:Array = [];
		
		public function LoggingContext( name:* )
		{
			_name = name;
			
			check();
		}
		
		/*============================================================================*/
		/*= STATIC PRIVATE PROPERTIES                                                 */
		/*============================================================================*/
		
		private static var loggers:Array;
		
		/*============================================================================*/
		/*= STATIC PUBLIC METHODS                                                     */
		/*============================================================================*/
		
		public static function getLogger( name:* ):Logger
		{
			return new LoggingContext( name );
		}
		
		public static function registerLogger( logger:ILoggerExtension ):void
		{
			if ( !loggers )
				loggers = [];
			
			if ( loggers.indexOf( logger ) == -1 )
				loggers.push( logger );
		}
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function debug( message:String, ... rest ):void
		{
			check();
			
			for each ( var l:Logger in activeLoggers )
				l.debug( message, rest );
		}
		
		public function error( message:String, ... rest ):void
		{
			check();
			
			for each ( var l:Logger in activeLoggers )
				l.error( message, rest );
		}
		
		public function fatal( message:String, ... rest ):void
		{
			check();
			
			for each ( var l:Logger in activeLoggers )
				l.fatal( message, rest );
		}
		
		public function info( message:String, ... rest ):void
		{
			check();
			
			for each ( var l:Logger in activeLoggers )
				l.info( message, rest );
		}
		
		public function trace( message:String, ... rest ):void
		{
			check();
			
			for each ( var l:Logger in activeLoggers )
				l.trace( message, rest );
		}
		
		public function warn( message:String, ... rest ):void
		{
			check();
			
			for each ( var l:Logger in activeLoggers )
				l.warn( message, rest );
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function check():void
		{
			var ext:ILoggerExtension;
			
			while ( loggers && loggers.length > activeLoggers.length )
			{
				ext = loggers[ activeLoggers.length ];
				activeLoggers.push( ext.getLogger( name ));
			}
		}
	}
}
