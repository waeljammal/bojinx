package com.bojinx.system.message.queue
{
	
	[ExcludeClass]
	/**
	 * Represents a single message in the queue
	 *
	 * @author Wael Jammal
	 */
	public class MessageQueueItem
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _func:Function;
		
		public function get func():Function
		{
			return _func;
		}
		
		private var _message:Object;
		
		
		public function get message():Object
		{
			return _message;
		}
		
		private var _order:int;
		
		public function get order():int
		{
			return _order;
		}
		
		public function MessageQueueItem( message:Object, order:int, func:Function )
		{
			this._message = message;
			this._order = order;
			this._func = func;
			super();
		}
	}
}
