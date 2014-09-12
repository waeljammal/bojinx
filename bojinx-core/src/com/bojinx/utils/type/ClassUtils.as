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
	import flash.system.ApplicationDomain;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	/**
	 * Provides utilities for working with <code>Class</code> objects.
	 *
	 * @author Christophe Herreman
	 * @author Erik Westra
	 */
	public final class ClassUtils
	{
		/*============================================================================*/
		/*= STATIC PRIVATE PROPERTIES                                                 */
		/*============================================================================*/
		
		private static const AS3VEC_SUFFIX:String = '__AS3__.vec';
		
		private static const LESS_THAN:String = '<';
		
		private static const PACKAGE_CLASS_SEPARATOR:String = "::";
		
		/*============================================================================*/
		/*= STATIC PUBLIC METHODS                                                     */
		/*============================================================================*/
		
		/**
		 * Converts the double colon (::) in a fully qualified class name to a dot (.)
		 */
		public static function convertFullyQualifiedName( className:String ):String
		{
			return className.replace( PACKAGE_CLASS_SEPARATOR, "." );
		}
		
		/**
		 * Returns a <code>Class</code> object that corresponds with the given
		 * instance. If no correspoding class was found, a
		 * <code>ClassNotFoundError</code> will be thrown.
		 *
		 * @param instance the instance from which to return the class
		 * @param applicationDomain the optional applicationdomain where the instance's class resides
		 *
		 * @return the <code>Class</code> that corresponds with the given instance
		 *
		 * @see org.springextensions.actionscript.errors.ClassNotFoundError
		 */
		public static function forInstance( instance:*, applicationDomain:ApplicationDomain = null ):Class
		{
			applicationDomain = ( applicationDomain == null ) ? ApplicationDomain.currentDomain : applicationDomain;
			var className:String = getQualifiedClassName( instance );
			return forName( className, applicationDomain );
		}
		
		/**
		 * Returns a <code>Class</code> object that corresponds with the given
		 * name. If no correspoding class was found in the applicationdomain tree, a
		 * <code>ClassNotFoundError</code> will be thrown.
		 *
		 * @param name the name from which to return the class
		 * @param applicationDomain the optional applicationdomain where the instance's class resides
		 *
		 * @return the <code>Class</code> that corresponds with the given name
		 *
		 * @see org.springextensions.actionscript.errors.ClassNotFoundError
		 */
		public static function forName( name:String, applicationDomain:ApplicationDomain = null ):Class
		{
			applicationDomain = ( applicationDomain == null ) ? ApplicationDomain.currentDomain : applicationDomain;
			var result:Class;
			
			if ( !applicationDomain )
			{
				applicationDomain = ApplicationDomain.currentDomain;
			}
			
			while ( !applicationDomain.hasDefinition( name ))
			{
				if ( applicationDomain.parentDomain )
				{
					applicationDomain = applicationDomain.parentDomain;
				}
				else
				{
					break;
				}
			}
			
			try
			{
				result = applicationDomain.getDefinition( name ) as Class;
			}
			catch ( e:ReferenceError )
			{
				throw new ClassNotFoundError( "A class with the name '" + name + "' could not be found." );
			}
			return result;
		}
		
		/**
		 *
		 * @param fullName
		 * @param applicationDomain
		 * @return
		 */
		public static function getClassParameterFromFullyQualifiedName( fullName:String, applicationDomain:ApplicationDomain =
																		null ):Class
		{
			applicationDomain = ( applicationDomain != null ) ? applicationDomain : ApplicationDomain.
				currentDomain;
			
			if ( StringUtils.startsWith( fullName, AS3VEC_SUFFIX ))
			{
				var startIdx:int = fullName.indexOf( LESS_THAN ) + 1;
				var len:int = ( fullName.length - startIdx ) - 1;
				var className:String = fullName.substr( startIdx, len );
				return forName( className, applicationDomain );
			}
			else
			{
				return null;
			}
		}
		
		/**
		 * Returns the fully qualified name of the given class.
		 *
		 * @param clazz the class to get the name from
		 * @param replaceColons whether the double colons "::" should be replaced by a dot "."
		 *             the default is false
		 *
		 * @return the fully qualified name of the class
		 */
		public static function getFullyQualifiedName( clazz:Class, replaceColons:Boolean = false ):String
		{
			var result:String = getQualifiedClassName( clazz );
			
			if ( replaceColons )
			{
				result = convertFullyQualifiedName( result );
			}
			return result;
		}
		
		/**
		 * Returns the fully qualified name of the given class' superclass.
		 *
		 * @param clazz the class to get its superclass' name from
		 * @param replaceColons whether the double colons "::" should be replaced by a dot "."
		 *             the default is false
		 *
		 * @return the fully qualified name of the class' superclass
		 */
		public static function getFullyQualifiedSuperClassName( clazz:Class, replaceColons:Boolean =
																false ):String
		{
			var result:String = getQualifiedSuperclassName( clazz );
			
			if ( replaceColons )
			{
				result = convertFullyQualifiedName( result );
			}
			return result;
		}
		
		/**
		 * Returns the name of the given class.
		 *
		 * @param clazz the class to get the name from
		 *
		 * @return the name of the class
		 */
		public static function getName( clazz:Class ):String
		{
			return getNameFromFullyQualifiedName( getFullyQualifiedName( clazz ));
		}
		
		/**
		 * Returns the name of the class or interface, based on the given fully
		 * qualified class or interface name.
		 *
		 * @param fullyQualifiedName the fully qualified name of the class or interface
		 *
		 * @return the name of the class or interface
		 */
		public static function getNameFromFullyQualifiedName( fullyQualifiedName:String ):String
		{
			var result:String = "";
			var startIndex:int = fullyQualifiedName.indexOf( PACKAGE_CLASS_SEPARATOR );
			
			if ( startIndex == -1 )
			{
				result = fullyQualifiedName;
			}
			else
			{
				result = fullyQualifiedName.substring( startIndex + PACKAGE_CLASS_SEPARATOR.length, fullyQualifiedName.length );
			}
			return result;
		}
		
		/**
		 * Returns the name of the given class' superclass.
		 *
		 * @param clazz the class to get the name of its superclass' from
		 *
		 * @return the name of the class' superclass
		 */
		public static function getSuperClassName( clazz:Class ):String
		{
			var fullyQualifiedName:String = getFullyQualifiedSuperClassName( clazz );
			var index:int = fullyQualifiedName.indexOf( PACKAGE_CLASS_SEPARATOR ) + PACKAGE_CLASS_SEPARATOR.
				length;
			return fullyQualifiedName.substring( index, fullyQualifiedName.length );
		}
		
		/**
		 * Determines if the namespace of the class is private.
		 *
		 * @return A boolean value indicating the visibility of the class.
		 */
		public static function isPrivateClass( object:* ):Boolean
		{
			var ns:String;
			var className:String;
			
			if ( object is Class )
			{
				className = getQualifiedClassName( object );
				ns = className.substr( 0, className.indexOf( "::" ));
			}
			else if ( object is String )
			{
				className = object.toString();
				var index:int = className.indexOf( "::" );
				
				if ( index > 0 )
				{
					ns = className.substr( 0, index );
				}
				else
				{
					ns = className;
				}
			}
			
			return ( ns.indexOf( ".as$" ) > -1 );
		}
		
		/**
		 * Creates an instance of the given class and passes the arguments to
		 * the constructor.
		 *
		 * TODO find a generic solution for this. Currently we support constructors
		 * with a maximum of 10 arguments.
		 *
		 * @param clazz the class from which an instance will be created
		 * @param args the arguments that need to be passed to the constructor
		 */
		public static function newInstance( clazz:Class, args:Array = null ):*
		{
			var result:*;
			var a:Array = ( args == null ) ? [] : args;
			
			switch ( a.length )
			{
				case 1:
					result = new clazz( a[ 0 ]);
					break;
				case 2:
					result = new clazz( a[ 0 ], a[ 1 ]);
					break;
				case 3:
					result = new clazz( a[ 0 ], a[ 1 ], a[ 2 ]);
					break;
				case 4:
					result = new clazz( a[ 0 ], a[ 1 ], a[ 2 ], a[ 3 ]);
					break;
				case 5:
					result = new clazz( a[ 0 ], a[ 1 ], a[ 2 ], a[ 3 ], a[ 4 ]);
					break;
				case 6:
					result = new clazz( a[ 0 ], a[ 1 ], a[ 2 ], a[ 3 ], a[ 4 ], a[ 5 ]);
					break;
				case 7:
					result = new clazz( a[ 0 ], a[ 1 ], a[ 2 ], a[ 3 ], a[ 4 ], a[ 5 ], a[ 6 ]);
					break;
				case 8:
					result = new clazz( a[ 0 ], a[ 1 ], a[ 2 ], a[ 3 ], a[ 4 ], a[ 5 ], a[ 6 ], a[ 7 ]);
					break;
				case 9:
					result = new clazz( a[ 0 ], a[ 1 ], a[ 2 ], a[ 3 ], a[ 4 ], a[ 5 ], a[ 6 ], a[ 7 ], a[ 8 ]);
					break;
				case 10:
					result = new clazz( a[ 0 ], a[ 1 ], a[ 2 ], a[ 3 ], a[ 4 ], a[ 5 ], a[ 6 ], a[ 7 ], a[ 8 ], a[ 9 ]);
					break;
				default:
					result = new clazz();
			}
			
			return result;
		}
	}
}
