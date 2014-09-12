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
package com.bojinx.system.context.config
{
	import com.bojinx.api.context.config.IBean;
	import com.bojinx.api.processor.IProcessorFactory;
	
	[DefaultProperty( "objects" )]
	/**
	 * Base class for Embedded context, you can add to your context in order
	 * to load it's embeded configuration entries.
	 *
	 * @author Wael Jammal
	 * @Manifest
	 */
	public class Beans
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _objects:Array = [];
		
		[ArrayElementType( "com.bojinx.api.context.config.IBean" )]
		/**
		 * Array of Object Entries for the framework to manage.
		 *
		 * @see com.bojinx.api.context.config.IConfigEntry
		 */
		public function get objects():Array
		{
			return _objects;
		}
		
		/**
		 * @private
		 */
		public function set objects( value:Array ):void
		{
			_objects = value;
		}
		
		private var _processors:Array = [];
		
		[ArrayElementType( "com.bojinx.api.processor.IProcessorConfiguration" )]
		/**
		 * Array of processor factories to use.
		 *
		 * @see com.bojinx.api.processor.IProcessorFactory
		 */
		public function get processors():Array
		{
			return _processors;
		}
		
		/**
		 * @private
		 */
		public function set processors( value:Array ):void
		{
			_processors = value;
		}
		
		/**
		 * @private
		 */
		public function Beans()
		{
		}
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		/**
		 * Adds a processor factory
		 *
		 * @param value IProcessorFactory to add.
		 */
		public final function addProcessor( value:IProcessorFactory ):void
		{
			_processors.push( value );
		}
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		/**
		 * Adds an OjectEntry to the configuration.
		 *
		 * @param source The Class Type of the object to manage.
		 * @param objectId An optional Identifier can be used to seperate multiple instances of the same type.
		 * @param singleton False by default, set to true to ensure only a single instance of the object is every created.
		 */
		protected final function addObject( source:Class, objectId:String = null,
											singleton:Boolean = false ):Bean
		{
			if ( !_objects )
				_objects = [];
			
			var bean:Bean = new Bean( source, objectId, singleton );
			
			_objects.push( bean );
			return bean;
		}
		
		/**
		 * Add a prepared bean.
		 */
		protected final function addBean(bean:IBean):IBean
		{
			_objects.push(bean);
			return bean;
		}
	}
}
