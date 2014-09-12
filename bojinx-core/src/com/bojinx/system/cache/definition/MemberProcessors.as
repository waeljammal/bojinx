package com.bojinx.system.cache.definition
{
	import com.bojinx.api.processor.metadata.IMetaData;
	import com.bojinx.reflection.MetaDataAware;
	
	public class MemberProcessors
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		public var member:MetaDataAware;
		
		public var meta:IMetaData;
		
		public var name:String;
		
		public var priority:int;
		
		public var processors:Array;
		
		public var stage:int;
		
		public function MemberProcessors()
		{
		}
	}
}
