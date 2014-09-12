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
package com.bojinx.messaging.meta
{
	import com.bojinx.api.constants.ProcessorLifeCycleStage;
	import com.bojinx.api.context.config.support.IPrioritySupport;
	import com.bojinx.api.processor.metadata.IMetaData;
	import com.bojinx.reflection.MetaDataDescriptor;
	import com.bojinx.system.message.support.Scope;
	
	/**
	 * Represents a Message annotation
	 *
	 * @author Wael
	 * @since Feb 27, 2010
	 */
	public class MessageInterceptorMetadata implements IMetaData, IPrioritySupport
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _stage:int = ProcessorLifeCycleStage.POST_INIT;
		
		/**
		 * Lifecycle stage to run in
		 */
		public function get stage():int
		{
			return _stage;
		}
		
		private var _scope:String = Scope.GLOBAL;
		
		/**
		 * The scope to listen in.
		 *
		 * @default Scope.GLOBAL
		 */
		public function get scope():String
		{
			return _scope;
		}
		
		/**
		 * @private
		 */
		public function set scope( value:String ):void
		{
			_scope = value;
		}
		
		private var _name:String;
		
		/**
		 * This is the group the message is targeted
		 * at.
		 */
		public function get name():String
		{
			return _name;
		}
		
		/**
		 * @private
		 */
		public function set name( value:String ):void
		{
			_name = value;
		}
		
		private var _priority:int = 0;
		
		public function get priority():int
		{
			return _priority;
		}
		
		public function set priority( value:int ):void
		{
			_priority = value;
		}
		
		
		private var _type:String;
		
		public function get type():String
		{
			return _type;
		}
		
		public function set type( value:String ):void
		{
			_type = value;
		}
		
		public function MessageInterceptorMetadata():void
		{
		
		}
		
		/*============================================================================*/
		/*= STATIC PUBLIC PROPERTIES                                                  */
		/*============================================================================*/
		
		public static function get config():MetaDataDescriptor
		{
			var conf:MetaDataDescriptor = new MetaDataDescriptor();
			conf.setMetaName( "MessageInterceptor" );
			conf.setSupportedMembers( MetaDataDescriptor.METHOD );
			conf.setDefaultProperty( "name" );
			
			return conf;
		}
	}
}
