package com.bojinx.reflection
{
	
	public class Method extends MetaDataAware
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _declaredBy:ClassInfo;
		
		public function get declaredBy():ClassInfo
		{
			return _declaredBy;
		}
		
		private var _isStatic:Boolean;
		
		public function get isStatic():Boolean
		{
			return _isStatic;
		}
		
		private var _namespaceURI:Object;
		
		public function get namespaceURI():Object
		{
			return _namespaceURI;
		}
		
		public function set namespaceURI( value:Object ):void
		{
			_namespaceURI = value;
		}
		
		private var _parameters:Array;
		
		public function get parameters():Array
		{
			if ( !_parameters )
				_parameters = declaredBy.getMethodParameters( info.parameters );
			
			return _parameters;
		}
		
		private var _returnType:ClassInfo;
		
		public function get returnType():ClassInfo
		{
			if ( !_returnType )
				_returnType = declaredBy.getReturnType( info.returnType );
			
			return _returnType;
		}
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var info:Object;
		
		public function Method( info:Object, owner:ClassInfo, isStatic:Boolean )
		{
			super( info, MetaDataDescriptor.METHOD, owner );
			this.info = info;
			_declaredBy = owner;
			_isStatic = isStatic;
		}
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		/**
		 * Invokes the method using the given parameters.
		 *
		 * @param instance Object
		 * @param params The parameters to pass
		 */
		public function invoke( instance:Object, params:Array = null ):*
		{
			// Borowed from SpiceLib
			checkInstanceParameter( instance );
			var qname:Object = ( namespaceURI ) ? new QName( namespaceURI, name ) : name;
			var f:Function = ( isStatic ) ? _declaredBy.getClass()[ qname ] : instance[ qname ];
			
			try
			{
				return f.apply( instance, params );
			}
			catch ( e:ArgumentError )
			{
				throw new Error( instance + ": " + e.message + " in function " + qname, e );
			}
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		/**
		 * Borowed from SpiceLib :)
		 */
		private function checkInstanceParameter( instance:Object ):void
		{
			if ( _isStatic )
			{
				if ( instance != null )
					throw new Error( "Parameter must be null for static methods" );
			}
			else
			{
				if ( instance == null )
					throw new Error( "Parameter must not be null for non-static methods" );
				else if ( !( instance is declaredBy.getClass()))
					throw new Error( "Wrong parameter type, should be " + declaredBy.name );
			}
		}
	}
}
