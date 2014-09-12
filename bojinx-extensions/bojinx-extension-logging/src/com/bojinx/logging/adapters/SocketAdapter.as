package com.bojinx.logging.adapters
{
	import com.bojinx.logging.data.SocketData;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.net.Socket;
	import flash.system.Capabilities;
	import flash.system.Security;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	
	[Event(name="connect", type="flash.events.Event")]
	public class SocketAdapter extends EventDispatcher
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _address:String;
		
		
		/**
		 * @param value: The address to connect to
		 */
		public function set address( value:String ):void
		{
			_address = value;
		}
		
		
		/**
		 * Get connected status.
		 */
		public function get connected():Boolean
		{
			if ( _socket == null )
				return false;
			return _socket.connected;
		}
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		// Max queue length
		private const MAX_QUEUE_LENGTH:int = 500;
		
		private var _bytes:ByteArray;
		
		private var _connecting:Boolean;
		
		private var _length:uint;
		
		private var _package:ByteArray;
		
		private var _port:int;
		
		private var _process:Boolean;
		
		
		// Data buffer
		private var _queue:Array = [];
		
		private var _retry:Timer;
		
		
		// Properties
		private var _socket:Socket;
		
		private var _timeout:Timer;
		
		public function SocketAdapter()
		{
			// Create the socket
			_socket = new Socket();
			_socket.addEventListener( Event.CONNECT, connectHandler, false, 0, false );
			_socket.addEventListener( Event.CLOSE, closeHandler, false, 0, false );
			_socket.addEventListener( IOErrorEvent.IO_ERROR, closeHandler, false, 0, false );
			_socket.addEventListener( SecurityErrorEvent.SECURITY_ERROR, closeHandler, false, 0, false );
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, dataHandler, false, 0, false);
			
			// Set properties
			_connecting = false;
			_process = false;
			_address = "127.0.0.1";
			_port = 5840;
			_timeout = new Timer( 2000, 1 );
			_timeout.addEventListener( TimerEvent.TIMER, closeHandler, false, 0, false );
			_retry = new Timer( 1000, 1 );
			_retry.addEventListener( TimerEvent.TIMER, retryHandler, false, 0, false );
		}
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		/**
		 * Connect the socket.
		 */
		public function connect():void
		{
			if ( !_connecting )
			{
				try
				{
					// Load crossdomain
					Security.loadPolicyFile( 'xmlsocket://' + _address + ':' + _port );
					
					// Connect the socket
					_connecting = true;
					_socket.connect( _address, _port );
					
					// Start timeout
					_retry.stop();
					_timeout.reset();
					_timeout.start();
				}
				catch ( e:Error )
				{
					// MonsterDebugger.logger(["error"]);
					// MonsterDebugger.logger([e.message]);
					closeHandler();
				}
			}
		}
		
		
		/**
		 *  Start processing the queue.
		 */
		public function processQueue():void
		{
			if ( !_process )
			{
				_process = true;
				
				if ( _queue.length > 0 )
				{
					next();
				}
			}
		}
		
		
		/**
		 * Send data to the desktop application.
		 * @param id: The id of the plugin
		 * @param data: The data to send
		 * @param direct: Use the queue or send direct (handshake)
		 */
		public function send( data:Object, direct:Boolean = false ):void
		{
			
			// Send direct (in case of handshake)
			if ( direct && _socket.connected )
			{
				// Get the data
				var bytes:ByteArray = new SocketData( data ).bytes;
				
				// Write it to the socket
				_socket.writeUnsignedInt( bytes.length );
				_socket.writeBytes( bytes );
				_socket.flush();
				return;
			}
			
			// Add to normal queue
			_queue.push( new SocketData( data ));
			
			if ( _queue.length > MAX_QUEUE_LENGTH )
			{
				_queue.shift();
			}
			
			if ( _queue.length > 0 )
			{
				next();
			}
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		/**
		 * Connection closed.
		 * Due to a timeout or connection error.
		 */
		private function closeHandler( event:Event = null ):void
		{
			// Select a new address to connect
			if ( !_retry.running )
			{
				_connecting = false;
				_process = false;
				_timeout.stop();
				_retry.reset();
				_retry.start();
			}
		}
		
		
		/**
		 * Connection is made.
		 */
		private function connectHandler( event:Event ):void
		{
			_timeout.stop();
			_retry.stop();
			
			// Set the flags and clear the bytes
			_connecting = false;
			_bytes = new ByteArray();
			_package = new ByteArray();
			_length = 0;
			
			// Send hello and wait for handshake
			_socket.writeUTFBytes( "<hello/>" + "\n" );
			_socket.writeByte( 0 );
			_socket.flush();
			
			dispatchEvent(new Event(Event.CONNECT));
		}
		
		
		/**
		 * Process the next item in queue.
		 */
		private function next():void
		{
			// Check if we can process the queue
			if ( !_process )
			{
				return;
			}
			
			// Check if we should connect the socket
			if ( !_socket.connected )
			{
				connect();
				return;
			}
			
			if(_queue.length == 0)
				return;
			
			// Get the data
			var bytes:ByteArray = SocketData( _queue.shift()).bytes;
			
			trace("Sending Data");
			
			// Write it to the socket
			_socket.writeUnsignedInt( bytes.length );
			_socket.writeBytes( bytes );
			_socket.flush();
			
			// Clear the data
			// bytes.clear(); // FP10
			bytes = null;
			
			// Proceed queue
			if ( _queue.length > 0 )
			{
				next();
			}
		}
		
		
		/**
		 * Retry is done.
		 */
		private function retryHandler( event:TimerEvent ):void
		{
			// Just retry
			_retry.stop();
			connect();
		}
		
		/**
		 * Socket data is available.
		 */
		private function dataHandler(event:ProgressEvent):void
		{
			// Clear and read the bytes
			_bytes = new ByteArray();
			_socket.readBytes(_bytes, 0, _socket.bytesAvailable);
			
			// Reset position
			_bytes.position = 0;
			processPackage();
		}
		
		
		/**
		 * Process package.
		 */
		private function processPackage():void
		{
			// Return if null bytes available
			if (_bytes.bytesAvailable == 0) {
				return;
			}
			
			// Read the size
			if (_length == 0) {
				_length = _bytes.readUnsignedInt();
				_package = new ByteArray();
			}
			
			// Load the data
			if (_package.length < _length && _bytes.bytesAvailable > 0)
			{
				// Get the data
				var l:uint = _bytes.bytesAvailable;
				if (l > _length - _package.length) {
					l = _length - _package.length;
				}
				_bytes.readBytes(_package, _package.length, l);
			}
			
			// Check if we have all the data
			if (_length != 0 && _package.length == _length)
			{
				// Parse the bytes and send them for handeling to the core
				var item:SocketData = SocketData.read(_package);
				if (item != null) {
					// Handle
					if(item.data.command == "HELLO")
						sendInformation();
				}
				
				// Clear the old data
				_length = 0;
				_package = null;
			}
			
			// Check if there is another package
			if (_length == 0 && _bytes.bytesAvailable > 0) {
				processPackage();
			}
		}

		internal function sendInformation():void
		{
			// Get basic data
			var playerType:String = Capabilities.playerType;
			var playerVersion:String = Capabilities.version;
			var isDebugger:Boolean = Capabilities.isDebugger;
			var isFlex:Boolean = false;    
			var fileTitle:String = "";
			var fileLocation:String = "";
			
			// Check for Flex framework
			try{
				var UIComponentClass:* = getDefinitionByName("mx.core::UIComponent");
				if (UIComponentClass != null) isFlex = true;
			} catch (e1:Error) {}
			
			// Get the location
//			if (_base is DisplayObject && _base.hasOwnProperty("loaderInfo")) {
//				if (DisplayObject(_base).loaderInfo != null) {
//					fileLocation = unescape(DisplayObject(_base).loaderInfo.url);
//				}
//			}
//			if (_base.hasOwnProperty("stage")) {
//				if (_base["stage"] != null && _base["stage"] is Stage) {
//					fileLocation = unescape(Stage(_base["stage"]).loaderInfo.url);
//				}
//			}
			
			// Check for browser
			if (playerType == "ActiveX" || playerType == "PlugIn") {
				if (ExternalInterface.available) {
					try {
						var tmpLocation:String = ExternalInterface.call("window.location.href.toString");
						var tmpTitle:String = ExternalInterface.call("window.document.title.toString");
						if (tmpLocation != null) fileLocation = tmpLocation;
						if (tmpTitle != null) fileTitle = tmpTitle;
					} catch (e2:Error) {
						// External interface FAIL
					}
				}
			}
			
			// Check for Adobe AIR
			if (playerType == "Desktop") {
				try{
					var NativeApplicationClass:* = getDefinitionByName("flash.desktop::NativeApplication");
					if (NativeApplicationClass != null) {
						var descriptor:XML = NativeApplicationClass["nativeApplication"]["applicationDescriptor"];
						var ns:Namespace = descriptor.namespace();
						var filename:String = descriptor.ns::filename;
						var FileClass:* = getDefinitionByName("flash.filesystem::File");
						if (Capabilities.os.toLowerCase().indexOf("windows") != -1) {
							filename += ".exe";
							fileLocation = FileClass["applicationDirectory"]["resolvePath"](filename)["nativePath"];
						} else if (Capabilities.os.toLowerCase().indexOf("mac") != -1) {
							filename += ".app";
							fileLocation = FileClass["applicationDirectory"]["resolvePath"](filename)["nativePath"];
						}
					}
				} catch (e3:Error) {}
			}
			
			if (fileTitle == "" && fileLocation != "") {
				var slash:int = Math.max(fileLocation.lastIndexOf("\\"), fileLocation.lastIndexOf("/"));
				if (slash != -1) {
					fileTitle = fileLocation.substring(slash + 1, fileLocation.lastIndexOf("."));
				} else {
					fileTitle = fileLocation;
				}
			}
			
			// Default
			if (fileTitle == "") {
				fileTitle = "Application";
			}
			
			// Create the data
			var data:Object = {
				command:                    "INFO",
					debuggerVersion:        "1.0",
					playerType:              playerType,
					playerVersion:           playerVersion,
					isDebugger:              isDebugger,
					isFlex:                  isFlex,
					fileLocation:            fileLocation,
					fileTitle:               fileTitle
			};
			
			// Send the data direct
			send(data, true);
			
			// Start the queue after that
			processQueue();
		}

	}
}
