package com.bojinx.logging.adapters
{
	import com.bojinx.logging.data.Command;
	import com.bojinx.logging.data.LogData;
	import com.bojinx.logging.data.LogDataType;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.Socket;
	import flash.system.Security;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	public class SharedSocketAdaptor
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _port:int = 8888;
		
		public function get port():int
		{
			return _port;
		}
		
		public function set port( value:int ):void
		{
			_port = value;
		}
		
		private var _server:String = "127.0.0.1";
		
		public function get server():String
		{
			return _server;
		}
		
		public function set server( value:String ):void
		{
			_server = value;
		}
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var connecting:Boolean = false;
		
		public function SharedSocketAdaptor()
		{
		
		}
		
		
		/*============================================================================*/
		/*= STATIC PRIVATE PROPERTIES                                                 */
		/*============================================================================*/
		
		private static var clearMessageSent:Boolean;
		
		private static var pendingBuffer:Array = [];
		
		private static var socket:Socket;
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function disconnect():void
		{
			if ( socket && socket.connected )
				socket.close();
		}
		
		public final function send( data:LogData ):void
		{
			if ( !socket || ( socket && !socket.connected ))
			{
				sendClearMessage();
				pendingBuffer.push( data );
				
				if ( !connecting )
					connentAndSend();
				
				return;
			}
			
			var bytes:ByteArray = new ByteArray();
			bytes.writeObject( data );
			
			var bytesData:ByteArray = new ByteArray();
			bytesData.writeUnsignedInt( bytes.length );
			bytesData.writeBytes( bytes );
			bytesData.position = 0;
			
			socket.writeUnsignedInt( bytesData.length );
			socket.writeBytes( bytesData );
			socket.flush();
		}
		
		public function sendClearMessage():void
		{
			if ( clearMessageSent )
				return;
			
			clearMessageSent = true;
			
			var data:LogData = new LogData();
			data.dataType = LogDataType.COMMAND;
			
			var command:Command = new Command();
			command.command = Command.CLEAR;
			
			data.message = command;
			
			pendingBuffer.push( data );
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function connect():void
		{
			socket.connect( this.server, Number( this.port ));
		}
		
		private function connentAndSend():void
		{
			if ( !socket )
			{
				Security.loadPolicyFile( 'xmlsocket://' + server + ':' + port );
				
				connecting = true;
				socket = new Socket();
				socket.addEventListener( Event.CONNECT, onConnect );
				socket.addEventListener( IOErrorEvent.IO_ERROR, onIoError );
				setTimeout( connect, 2000 );
			}
		}
		
		private function onConnect( event:Event ):void
		{
			while ( pendingBuffer.length > 0 )
			{
				send( pendingBuffer.shift());
			}
			
			connecting = false;
		}
		
		private function onIoError( event:IOErrorEvent ):void
		{
			connecting = false;
			setTimeout( connect, 500 );
		}
	}
}
