/*
 * Copyright 2007-2011 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.as3commons.stageprocessing.impl.selector
{
	import org.as3commons.stageprocessing.IObjectSelector;
	
	/**
	 * <code>IObjectSelector</code> approving or denying objects based on a <code>String</code>
	 * property (default property name: "name") to be matched against an array of Regexp (default
	 * behaviour approves objects whose name matches all passed regexp, approves all objects if
	 * no regexp is passed).
	 *
	 * @author Martino Piccinato
	 * @see String#match() String.match()
	 *
	 * Modified by Wael Jammal (Removed Logger)
	 * @Manifest
	 */
	public class NameBasedObjectSelector implements IObjectSelector
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _denyOnMatch:Boolean;
		
		/**
		 * @param value set <code>true</code to invert selection
		 * logic and DENY object whose name match the passed regexp array.
		 * @default <code>false</code>
		 */
		public function set denyOnMatch( value:Boolean ):void
		{
			this._denyOnMatch = value;
		}
		
		private var _nameRegexpArray:Array;
		
		/**
		 * @param regexpArray An array of <code>String</code> or <code>Regexp</code>
		 * to be used for object name pattern matching.
		 */
		public function set nameRegexpArray( regexpArray:Array ):void
		{
			this._nameRegexpArray = regexpArray;
		}
		
		private var _propertyName:String;
		
		/**
		 * @param name The property name to be used as the object "name"
		 * to be matched against the regexp array.
		 */
		public function set propertyName( name:String ):void
		{
			this._propertyName = name;
		}
		
		/**
		 * Create a new NameBasedObjectSelector.
		 *
		 * @param regexpArray An array of <code>String</code> or <code>Regexp</code>
		 * to be used for object name pattern matching.
		 * @param propertyName The property name to be used as the object "name"
		 * to be matched against the regexp array.
		 * @param value set <code>true</code> to invert selection
		 * logic and DENY object whose name match the passed regexp array.
		 * @default <code>false</code>
		 */
		public function NameBasedObjectSelector( regexpArray:Array = null, propertyName:String = DEFAULT_NAME_PROPERTY,
												 denyOnMatch:Boolean =
												 false )
		{
			super();
			this._nameRegexpArray = regexpArray;
			this._propertyName = propertyName;
			this._denyOnMatch = denyOnMatch;
		}
		
		
		/*============================================================================*/
		/*= STATIC PRIVATE PROPERTIES                                                 */
		/*============================================================================*/
		
		private static const DEFAULT_NAME_PROPERTY:String = "name";
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		/**
		 * <p></p>
		 * @inheritDoc
		 */
		public function approve( object:Object ):Boolean
		{
			
			if ( object.hasOwnProperty( this._propertyName ) &&
				object[ this._propertyName ] != undefined && object[ this._propertyName ] != null &&
				object[ this._propertyName ] is
				String )
			{
				
				var name:String = String( object[ this._propertyName ]);
				
				if ( this.nameMatchRegexps( name ))
				{
					return !_denyOnMatch;
				}
				
			}
			
			return _denyOnMatch;
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function nameMatchRegexps( name:String ):Boolean
		{
			
			if ( !this._nameRegexpArray || this._nameRegexpArray.length == 0 )
				return true;
			
			for ( var i:int = 0; i < this._nameRegexpArray.length; i++ )
			{
				if ( name.match( this._nameRegexpArray[ i ]))
				{
					return true;
				}
			}
			return false;
		
		}
	}
}
