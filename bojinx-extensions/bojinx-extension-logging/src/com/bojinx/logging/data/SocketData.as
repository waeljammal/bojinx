package com.bojinx.logging.data
{
	import flash.utils.ByteArray;
	
	public class SocketData
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		/**
		 * Get the raw bytes.
		 */
		public function get bytes():ByteArray
		{
			// Create the holders
			var bytesId:ByteArray = new ByteArray();
			var bytesData:ByteArray = new ByteArray();
			
			// Save the objects
			bytesId.writeObject( _id );
			bytesData.writeObject( _data );
			
			// Write in one object
			var item:ByteArray = new ByteArray();
			item.writeUnsignedInt( bytesId.length );
			item.writeBytes( bytesId );
			item.writeUnsignedInt( bytesData.length );
			item.writeBytes( bytesData );
			item.position = 0;
			
			// Clear the old objects
			bytesId = null;
			bytesData = null;
			
			// Return the object
			return item;
		}
		
		
		/**
		 * Convert raw bytes.
		 */
		public function set bytes( value:ByteArray ):void
		{
			// Create the holders
			var bytesId:ByteArray = new ByteArray();
			var bytesData:ByteArray = new ByteArray();
			
			// Decompress the value and read bytes
			try
			{
				value.readBytes( bytesId, 0, value.readUnsignedInt());
				value.readBytes( bytesData, 0, value.readUnsignedInt());
				
				// Save vars
				_id = bytesId.readObject() as String;
				_data = bytesData.readObject() as Object;
			}
			catch ( e:Error )
			{
				_id = null;
				_data = null;
			}
			
			// Clear the old objects
			bytesId = null;
			bytesData = null;
		}
		
		private var _data:Object;
		
		
		/**
		 * Get the data object.
		 */
		public function get data():Object
		{
			return _data;
		}
		
		private var _id:String;
		
		/**
		 * Get the plugin id.
		 */
		public function get id():String
		{
			return _id;
		}
		
		/*============================================================================*/
		/*= STATIC PUBLIC METHODS                                                     */
		/*============================================================================*/
		
		/**
		 * Convert raw bytes to a MonsterDebuggerData object.
		 * @param bytes: The raw bytes to convert
		 */
		public static function read( bytes:ByteArray ):SocketData
		{
			var item:SocketData = new SocketData( null );
			item.bytes = bytes;
			return item;
		}
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		/**
		 * Shared data class between the client and desktop application.
		 * @param id: The plugin id
		 * @param data: The data to send over the socket connection
		 */
		public function SocketData( data:Object )
		{
			// Save data
			_data = data;
		}
	}

}
