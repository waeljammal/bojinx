package com.bojinx.system.message.queue
{
	import com.bojinx.api.message.IInterceptedMessage;
	import com.bojinx.api.util.IDisposable;
	import com.bojinx.system.message.messages.InterceptedMessage;
	
	/**
	 * Handles the queueing of messages and interceptors in sequential order.
	 *
	 * @author Wael Jammal
	 */
	public class MessageQueue implements IDisposable
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _running:Boolean = false;
		
		public function get canceled():Boolean
		{
			return _canceled;
		}

		public function get onCompleteData():Array
		{
			return _onCompleteData;
		}

		public function get running():Boolean
		{
			return _running;
		}
		
		private var _onCompleteData:Array;
		
		private var _type:Class;
		 
		public function get type():Class
		{
			return _type;
		}
		
		public function get size():int
		{
			return queue.length;
		}
		
		public var onRunComplete:Function;
		public var onRunCompleteParams:Array;
		
		/*============================================================================*/
		/*= INTERNAL PROPERTIES                                                       */
		/*============================================================================*/
		
		internal var queue:Array = [];
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var _canceled:Boolean = false;
		
		private var children:Array = [];
		
		private var onComplete:Function;
		
		public function MessageQueue( onComplete:Function, onCompleteData:Array = null, type:Class = null )
		{
			this.onComplete = onComplete;
			_onCompleteData = onCompleteData;
			_type = type;
		}
		
		public function setCallBackData(data:Array):void
		{
			_onCompleteData = data;
		}
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function add( message:*, handler:Function, topic:String ):void
		{
			queue.push( new InterceptedMessage( message, resume, cancel, handler, type, topic ));
		}
		
		public function addQueue( queue:MessageQueue ):void
		{
			children.push( queue );
		}
		
		public function cancel(destroy:Boolean = true):void
		{
			if(destroy)
				_canceled = true;
			
			queue.splice( 0, queue.length );
			
			for each ( var i:MessageQueue in children )
				i.cancel();
			
			children.splice( 0, children.length );
			
			_running = false;
		}
		
		public function dispose():void
		{
			_type = null;
			_running = false;
			children = null;
			onComplete = null;
			_onCompleteData = null;
			onRunComplete = null;
			queue = null;
		}
		
		public function run( onRunComplete:Function = null, onCompleteParams:Array = null ):Boolean
		{
			this.onRunComplete = onRunComplete;
			this.onRunCompleteParams = onCompleteParams;
			_running = true;
			next();
			return true;
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function next():void
		{
			if ( canceled || !queue)
			{
				return;
			}
			
			var item:IInterceptedMessage = queue.shift();
			
			if ( item )
				process( item );
			else if ( children.length > 0 )
				MessageQueue(children.shift()).run(onChildQueueComplete);
			else 
			{
				_running = false;
				onComplete.apply( this, onCompleteData );
				( onRunComplete is Function ) ? onRunComplete.apply( this, onRunCompleteParams ) : void;
				onRunComplete = null;
				onRunCompleteParams = null;
			}
		}
		
		private function onChildQueueComplete():void
		{
			next();
		}
		
		private function process( item:IInterceptedMessage ):void
		{
			if ( canceled )
				return;
			
			item.handler.apply( null, [ item.message, item ]);
		}
		
		private function resume():void
		{
			next();
		}
	}
}
