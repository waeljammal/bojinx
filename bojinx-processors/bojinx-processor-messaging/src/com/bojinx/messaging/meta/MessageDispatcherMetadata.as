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
	import com.bojinx.api.processor.metadata.IMetaData;
	import com.bojinx.reflection.MetaDataDescriptor;
	
	/**
	 * Represents a Message annotation
	 *
	 * @author Wael
	 * @since Feb 27, 2010
	 */
	public class MessageDispatcherMetadata implements IMetaData
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
		
		/*============================================================================*/
		/*= STATIC PUBLIC PROPERTIES                                                  */
		/*============================================================================*/
		
		public static function get config():MetaDataDescriptor
		{
			var conf:MetaDataDescriptor = new MetaDataDescriptor();
			conf.setMetaName( "MessageDispatcher" );
			conf.setSupportedMembers( MetaDataDescriptor.PROPERTY );
			
			return conf;
		}
	}
}
