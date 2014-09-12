package com.bojinx.system.cache.definition
{
	import com.bojinx.api.constants.MetaKind;
	import com.bojinx.api.processor.metadata.IMetaData;
	import com.bojinx.api.processor.metadata.IMetaDefinition;
	import com.bojinx.reflection.MetaDataAware;
	
	public class MetaDefinition implements IMetaDefinition
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		public var dependencies:Array;
		
		public var owner:ObjectDefinition;
		
		public var member:MetaDataAware;
		
		public var meta:IMetaData;
		
		public var data:*;
		
		public function get metaKind():String
		{
			return MetaKind.SINGLE;
		}
		
		public function MetaDefinition()
		{
		}
		
		public function reset():void
		{
			// TODO Auto Generated method stub
			
		}
	}
}
