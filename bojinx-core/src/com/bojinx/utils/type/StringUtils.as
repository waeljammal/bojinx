/*
* Copyright 2009-2010 the original author or authors.
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
package com.bojinx.utils.type
{
	
	/**
	 * <p>Methods in this class give sample code to explain their operation.
	 * including null.</p>
	 *
	 * @author Steffen Leistner
	 * @author Christophe Herreman
	 * @author James Ghandour
	 */
	public final class StringUtils
	{
		public function StringUtils()
		{
		}
		
		/*============================================================================*/
		/*= STATIC PRIVATE PROPERTIES                                                 */
		/*============================================================================*/
		
		/**
		 * The empty String ""
		 */
		private static const EMPTY:String = '';
		
		/*============================================================================*/
		/*= STATIC PUBLIC METHODS                                                     */
		/*============================================================================*/
		
		/**
		 *	Returns everything after the last occurence of the provided character in p_string.
		 *
		 *	@param p_string The string.
		 *
		 *	@param p_char The character or sub-string.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function afterLast( p_string:String, p_char:String ):String
		{
			if ( p_string == null )
			{
				return '';
			}
			var idx:int = p_string.lastIndexOf( p_char );
			
			if ( idx == -1 )
			{
				return '';
			}
			idx += p_char.length;
			return p_string.substr( idx );
		}
		
		/**
		 * Checks if the given string has actual text.
		 */
		public static function hasText( string:String ):Boolean
		{
			if ( !string )
				return false;
			return ( StringUtils.trim( string ).length > 0 );
		}
		
		/**
		 * <p>Checks if a String is whitespace, empty("") or null.</p>
		 *
		 * <pre>
		 * StringUtils.isBlank(null)      = true
		 * StringUtils.isBlank("")        = true
		 * StringUtils.isBlank(" ")       = true
		 * StringUtils.isBlank("bob")     = false
		 * StringUtils.isBlank("  bob  ") = false
		 * </pre>
		 *
		 * @param str  the String to check, may be null
		 * @return true if the String is null, empty or whitespace
		 */
		public static function isBlank( str:String ):Boolean
		{
			return isEmpty( trimToEmpty( str ));
		}
		
		/**
		 * <p>Checks if a String is empty("") or null.</p>
		 *
		 * <pre>
		 * StringUtils.isEmpty(null)      = true
		 * StringUtils.isEmpty("")        = true
		 * StringUtils.isEmpty(" ")       = false
		 * StringUtils.isEmpty("bob")     = false
		 * StringUtils.isEmpty("  bob  ") = false
		 * </pre>
		 *
		 * <p>NOTE: This method changed in Lang version 2.0.
		 * It no longer trims the String.
		 * That functionality is available in isBlank().</p>
		 *
		 * @param str  the String to check, may be null
		 * @return true if the String is empty or null
		 */
		public static function isEmpty( str:String ):Boolean
		{
			if ( str == null )
			{
				return true;
			}
			return str.length == 0;
		}
		
		/**
		 * <p>Removes all occurances of a substring from within the source string.</p>
		 *
		 * <p>A null source string will return null.
		 * An empty("") source string will return the empty string.
		 * A null remove string will return the source string.
		 * An empty("") remove string will return the source string.</p>
		 *
		 * <pre>
		 * StringUtils.remove(null, *)        = null
		 * StringUtils.remove("", *)          = ""
		 * StringUtils.remove(*, null)        = *
		 * StringUtils.remove(*, "")          = *
		 * StringUtils.remove("queued", "ue") = "qd"
		 * StringUtils.remove("queued", "zz") = "queued"
		 * </pre>
		 *
		 * @param str  the source String to search, may be null
		 * @param remove  the String to search for and remove, may be null
		 * @return the substring with the string removed if found,
		 *  null if null String input
		 */
		public static function remove( str:String, remove:String ):String
		{
			return safeRemove( str, new RegExp( remove, 'g' ));
		}
		
		/**
		 *	Removes extraneous whitespace (extra spaces, tabs, line breaks, etc) from the
		 *	specified string.
		 *
		 *	@param p_string The String whose extraneous whitespace will be removed.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function removeExtraWhitespace( p_string:String ):String
		{
			if ( p_string == null )
			{
				return '';
			}
			var str:String = trim( p_string );
			return str.replace( /\s+/g, ' ' );
		}
		
		/**
		 * <p>Checks if the String start characters match the given start string.</p>
		 *
		 * <p>null will return false.</p>
		 *
		 * <pre>
		 * StringUtils.startsWith(null, *)	 				= false
		 * StringUtils.startsWith(null, null) 				= false
		 * StringUtils.startsWith(*, null)	   				= false
		 * StringUtils.startsWith("www.domain.com", "www.")	= true
		 * </pre>
		 *
		 * @param str  the String to check, may be null
		 * @param start the string to compare
		 * @return true if only contains whitespace, and is non-null
		 */
		public static function startsWith( str:String, start:String ):Boolean
		{
			if (( str != null ) && ( start != null ) && ( str.length >= start.length ))
			{
				return ( str.substr( 0, start.length ) == start );
			}
			else
			{
				return false;
			}
		}
		
		
		/**
		 * <p>Removes control characters(char &lt;= 32) from both
		 * ends of this String, handling null by returning
		 * null.</p>
		 *
		 * <p>Trim removes start and end characters &lt;= 32.
		 * To strip whitespace use #strip(String).</p>
		 *
		 * <p>To trim your choice of characters, use the
		 * #strip(String, String) methods.</p>
		 *
		 * <pre>
		 * StringUtils.trim(null)          = null
		 * StringUtils.trim("")            = ""
		 * StringUtils.trim("     ")       = ""
		 * StringUtils.trim("abc")         = "abc"
		 * StringUtils.trim("    abc    ") = "abc"
		 * </pre>
		 *
		 * @param str  the String to be trimmed, may be null
		 * @return the trimmed string, null if null String input
		 */
		public static function trim( str:String ):String
		{
			if ( str == null )
			{
				return null;
			}
			return str.replace( /^\s*/, '' ).replace( /\s*$/, '' );
		}
		
		/**
		 * <p>Removes control characters (char &lt;= 32) from both
		 * ends of this String returning an empty String ("") if the String
		 * is empty ("") after the trim or if it is null.</p>
		 *
		 * <p>The String is trimmed using #trim().
		 * Trim removes start and end characters &lt;= 32.
		 * To strip whitespace use #stripToEmpty(String).</p>
		 *
		 * <pre>
		 * StringUtils.trimToEmpty(null)          = ""
		 * StringUtils.trimToEmpty("")            = ""
		 * StringUtils.trimToEmpty("     ")       = ""
		 * StringUtils.trimToEmpty("abc")         = "abc"
		 * StringUtils.trimToEmpty("    abc    ") = "abc"
		 * </pre>
		 *
		 * @param str  the String to be trimmed, may be null
		 * @return the trimmed String, or an empty String if null input
		 */
		public static function trimToEmpty( str:String ):String
		{
			return str == null ? EMPTY : trim( str );
		}
		
		/*============================================================================*/
		/*= STATIC PRIVATE METHODS                                                    */
		/*============================================================================*/
		
		private static function safeRemove( str:String, pattern:RegExp ):String
		{
			if ( isEmpty( str ))
			{
				return str;
			}
			return str.replace( pattern, '' );
		}
	}
}
