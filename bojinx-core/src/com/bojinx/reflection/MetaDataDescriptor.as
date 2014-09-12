package com.bojinx.reflection
{
	import flash.utils.Dictionary;
	
	public class MetaDataDescriptor
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _defaultProperty:String;
		
		public function get defaultProperty():String
		{
			return _defaultProperty;
		}
		
		private var _numRequiredProperties:int = 0;
		
		public function get numRequiredProperties():int
		{
			return _numRequiredProperties;
		}
		
		private var _requiredProperties:Dictionary;
		
		public function get requiredProperties():Dictionary
		{
			return _requiredProperties;
		}
		
		private var _supportedMembers:int;
		
		public final function get supportedMembers():int
		{
			return _supportedMembers;
		}
		
		private var _tagName:String;
		
		public final function get tagName():String
		{
			return _tagName;
		}
		
		public function MetaDataDescriptor()
		{
		
		}
		
		
		/*============================================================================*/
		/*= STATIC PUBLIC PROPERTIES                                                  */
		/*============================================================================*/
		
		public static const CLASS:int = 1;
		
		public static const METHOD:int = 2;
		
		public static const PROPERTY:int = 4;
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public final function addRequiredProperty( name:String ):void
		{
			if ( !_requiredProperties )
				_requiredProperties = new Dictionary( false );
			
			_numRequiredProperties++;
			_requiredProperties[ name ] = true;
		}
		
		public final function setDefaultProperty( value:String ):void
		{
			_defaultProperty = value;
		}
		
		public final function setMetaName( value:String ):void
		{
			_tagName = value;
		}
		
		public final function setSupportedMembers( value:int ):void
		{
			_supportedMembers = value;
		}
	}
}
