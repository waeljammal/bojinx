package com.bojinx.reflection
{
	/**
	 * Describes a property
	 * 
	 * @author Wael Jammal
	 */
	public class Property extends MetaDataAware
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _declaredBy:ClassInfo;
		
		/**
		 * The owner of this property
		 * 
		 * @return ClassInfo
		 */
		public function get declaredBy():ClassInfo
		{
			return _declaredBy;
		}
		
		private var _isReadable:Boolean;
		
		/**
		 * True if the property can be read
		 *
		 * @default false
		 * @return True if readable
		 */
		public function get isReadable():Boolean
		{
			return _isReadable;
		}
		
		private var _isStatic:Boolean;
		
		/**
		 * True if the property is static.
		 * 
		 * @default false
		 * @return true if Static
		 */
		public function get isStatic():Boolean
		{
			return _isStatic;
		}
		
		private var _isWritable:Boolean;
		
		/**
		 * True if the property is writeable.
		 * 
		 * @default false
		 * @return true if not read only
		 */
		public function get isWriteable():Boolean
		{
			return _isWritable;
		}
		
		private var _namespaceURI:Object;
		
		/**
		 * Returns the name space of the object
		 * 
		 * @default null
		 * @return Object
		 */
		public function get namespaceURI():Object
		{
			return _namespaceURI;
		}
		
		private var _returnType:ClassInfo;
		
		/**
		 * Returns ClassInfo for the properties return type.
		 * 
		 * @default null
		 * @return ClassInfo
		 */
		public function get returnType():ClassInfo
		{
			if ( !_returnType )
				_returnType = declaredBy.getReturnType( info.type );
			
			return _returnType;
		}
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var info:Object;
		
		/** @private */
		public function Property( info:Object, owner:ClassInfo, isStatic:Boolean )
		{
			super( info, MetaDataDescriptor.PROPERTY, owner );
			this.info = info;
			_declaredBy = owner;
			_isWritable = info.access != "readonly";
			_isReadable = info.access != "writeonly";
			_isStatic = isStatic;
		}
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		/**
		 * Gets the value of the property
		 * 
		 * @param instance The instance to get the value from
		 * @return The value of the property
		 */
		public function getValue( instance:Object ):*
		{
			if ( !isReadable )
				throw new Error( "" + this + " is write-only" );
			
			checkParameter( instance );
			var qname:Object = ( namespaceURI ) ? new QName( namespaceURI, name ) : name;
			return ( _isStatic ) ? _declaredBy.getClass()[ qname ] : instance[ qname ];
		}
		
		/**
		 * Sets the value of the property
		 * 
		 * @param instance The instance to set the value on
		 * @param value The value to set
		 * @return The value
		 */
		public function setValue( instance:Object, value:* ):*
		{
			if ( !_isWritable )
				throw new Error( "" + this + " is read-only" );
			
			checkParameter( instance );
			
			var qname:Object = ( namespaceURI ) ? new QName( namespaceURI, name ) : name;
			
			if ( _isStatic )
			{
				declaredBy.getClass()[ qname ] = value;
			}
			else
			{
				try
				{
					instance[ qname ] = value;
				}
				catch ( e:Error )
				{
					if ( e.errorID == 1034 )
						throw new Error( "Type Coercion Failed while assigning value to " + qname + " with owner " +
										 declaredBy.name + " class " + value + " does not exist in domain owned by " + declaredBy.name +
										 " Either inherit the domain or add the class to your context" );
					else
						throw new Error( e.message );
				}
			}
			
			return value;
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function checkParameter( instance:Object ):void
		{
			if ( _isStatic )
			{
				if ( instance != null && !( instance is declaredBy.getClass()))
					throw new Error( "Instance parameter must be of type Class or null for static properties" );
			}
			else
			{
				if ( instance == null )
					throw new Error( "Parameter must not be null for non-static properties" );
				else if ( !( instance is declaredBy.getClass()))
					throw new Error( "Wrong instance type, should be " + declaredBy.name );
			}
		}
	}
}
