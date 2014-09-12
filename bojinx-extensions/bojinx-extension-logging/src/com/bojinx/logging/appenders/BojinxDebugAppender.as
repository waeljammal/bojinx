package com.bojinx.logging.appenders
{
	import com.bojinx.logging.adapters.SharedSocketAdaptor;
	import com.bojinx.logging.adapters.SocketAdapter;
	import com.bojinx.logging.data.Command;
	import com.bojinx.logging.data.LogData;
	import com.bojinx.logging.data.LogDataType;
	import com.bojinx.logging.data.MemoryData;
	import com.bojinx.logging.data.SocketData;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.system.System;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import org.spicefactory.lib.flash.logging.FlashLogger;
	import org.spicefactory.lib.flash.logging.LogEvent;
	import org.spicefactory.lib.flash.logging.LogLevel;
	import org.spicefactory.lib.flash.logging.impl.AbstractAppender;
	
	public class BojinxDebugAppender extends AbstractAppender
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _socketAdaptor:SocketAdapter;
		
		public function get socketAdaptor():SocketAdapter
		{
			return _socketAdaptor;
		}
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var needsLineFeed:Boolean;
		
		private var pendingBuffer:Array = [];
		
		private var timer:Timer;
		
		/**
		 * Creates a new instance.
		 */
		public function BojinxDebugAppender()
		{
			super();
			needsLineFeed = true;
			
			if ( !socketAdaptor )
			{
				_socketAdaptor = new SocketAdapter();
				_socketAdaptor.connect();
			}
			
			timer = new Timer( 1000 );
			timer.addEventListener( TimerEvent.TIMER, onTimer );
			timer.start();
		}
		
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		/**
		 * @private
		 */
		override protected function handleLogEvent( event:LogEvent ):void
		{
			if ( isBelowThreshold( event.level ))
				return;
			
			var loggerName:String = FlashLogger( event.target ).name;
			var logMessage:String;
			
			if (( event.level.toValue() <= LogLevel.INFO.toValue()))
			{
				var levelString:String = ( event.level == LogLevel.DEBUG ) ? "DEBUG: " : "INFO:  ";
				loggerName = loggerName.replace( "::", "." );
				var index:int = loggerName.lastIndexOf( "." );
				
				if ( index != -1 )
					loggerName = loggerName.substring( index + 1 );
				
				logMessage = levelString + " [" + loggerName + "] " + event.message;
				needsLineFeed = true;
				
				trace( logMessage );
			}
			else
			{
				var lf:String = ( needsLineFeed ) ? "\n" : "";
				logMessage = lf + "  *** " + event.level + " *** " + loggerName + " ***\n" + event.message + "\n";
				needsLineFeed = false;
				
				trace( logMessage );
			}
			
			var data:LogData = new LogData();
			data.date = new Date();
			data.level = event.level.toString();
			data.message = event.message;
			data.className = loggerName;
			data.dataType = LogDataType.LOG;
			
			socketAdaptor.send( data );
		}
		
		protected function onTimer( event:TimerEvent ):void
		{
			sendPerformanceData();
		}
		
		private function sendPerformanceData():void
		{
			var data:MemoryData = new MemoryData();
			data.systemMemory = System.privateMemory;
			
			socketAdaptor.send(data);
		}
	}
}
