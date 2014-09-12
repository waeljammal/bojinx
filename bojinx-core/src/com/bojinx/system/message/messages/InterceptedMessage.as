/*
   Copyright (c) 2007 Ultraweb Development

   This file is part of Bojinx.

   Bojinx is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   Bojinx is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with Bojinx.  If not, see <http://www.gnu.org/licenses/>.
 */
package com.bojinx.system.message.messages
{
	import com.bojinx.api.message.IInterceptedMessage;
	
	/**
	 * Message object used by message interceptor handlers which lets
	 * you cancel or resume a paused message. By default all intercepted messages
	 * are paused in a queue until you resume each one.
	 *
	 * @author Wael Jammal
	 */
	public class InterceptedMessage implements IInterceptedMessage
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _handler:Function;
		
		/**
		 * A reference to the handler for the interceptor.
		 */
		public function get handler():Function
		{
			return _handler;
		}
		
		private var _message:*;
		
		/**
		 * A reference to the original message that was sent.
		 */
		public function get message():*
		{
			return _message;
		}
		
		private var _topic:String;
		
		/**
		 * The topic
		 */
		public function get topic():String
		{
			return _topic;
		}
		
		private var _type:Class;
		
		/**
		 * The Class Type of the dispatched message
		 */
		public function get type():Class
		{
			return _type;
		}
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var _cancel:Function;
		
		private var _resume:Function;
		
		/**
		 * @private
		 */
		public function InterceptedMessage( message:*, resume:Function, cancel:Function,
											handler:Function, type:Class = null, topic:String = null )
		{
			_handler = handler;
			_message = message;
			_resume = resume;
			_cancel = cancel;
			_type = type;
			_topic = topic;
		}
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		/**
		 * Cancels the interceptor and also the queue
		 * so no other interceptors will be invoked.
		 */
		public function cancel():void
		{
			_cancel();
		}
		
		/**
		 * Resumes the queue and either invokes the next
		 * interceptor or completes the message queue.
		 */
		public function resume():void
		{
			_resume();
		}
	}
}
