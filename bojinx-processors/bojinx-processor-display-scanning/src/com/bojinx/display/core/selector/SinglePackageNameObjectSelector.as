package com.bojinx.display.core.selector
{
	import flash.utils.getQualifiedClassName;
	import org.as3commons.stageprocessing.IObjectSelector;
	
	/**
	 * @Manifest
	 */
	public class SinglePackageNameObjectSelector implements IObjectSelector
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _approveOnMatch:Boolean;
		
		/**
		 * @param value if <code>true</code> will revert the selector logic and
		 * approve the object in case the fully qualified name MATCHES all passed regexps.
		 * @default <code>false</code>
		 */
		public function set approveOnMatch( value:Boolean ):void
		{
			_approveOnMatch = value;
		}
		
		private var _packageName:String;
		
		public function get packageName():String
		{
			return _packageName;
		}
		
		public function set packageName( value:String ):void
		{
			_packageName = value;
		}
		
		/**
		 * Creates a new ClassBasedObjectSelector.
		 *
		 * @param regexpArray The array of <code>Regexp</code> to match the object fully qualified
		 * class name against.
		 * @param approveOnMatch if <code>true</code> will revert the selector logic and
		 * approve the object in case the fully qualified name MATCHES all passed regexps.
		 *
		 */
		public function SinglePackageNameObjectSelector( approveOnMatch:Boolean = false,
														 packageName:String = null ):void
		{
			_packageName = packageName;
			
			init( approveOnMatch );
		}
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		/**
		 * @inheritDoc
		 */
		public function approve( object:Object ):Boolean
		{
			if ( objectMatchRegexps( object ))
			{
				return _approveOnMatch;
			}
			else
			{
				return !_approveOnMatch;
			}
		}
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		protected function init( approveOnMatch:Boolean ):void
		{
			
			this.approveOnMatch = approveOnMatch;
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		/**
		 * Returns true if the qualified class name of the given object matches any of the regular expressions in
		 * this selector.
		 * @param object
		 * @return true if a match, false if not
		 */
		private function objectMatchRegexps( object:Object ):Boolean
		{
			if ( !packageName )
				return true;
			
			var className:String = getQualifiedClassName( object );
			
			if ( className.search( packageName ) > -1 )
			{
				return true;
			}
			
			return false;
		}
	}
}