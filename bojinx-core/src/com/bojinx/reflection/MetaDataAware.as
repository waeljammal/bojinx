package com.bojinx.reflection
{
	import com.bojinx.utils.type.StringUtils;
	
	public class MetaDataAware
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _memberType:int;
		
		
		public function get memberType():int
		{
			return _memberType;
		}
		
		private var _meta:Array;
		
		public function get meta():Array
		{
			return _meta;
		}
		
		private var _name:String;
		
		public function get name():String
		{
			return _name;
		}
		
		public function get simpleName():String
		{
			return _name ? StringUtils.afterLast("::", _name) : null;
		}
		
		public function MetaDataAware( info:Object, memberType:int, owner:ClassInfo, name:String = null )
		{
			if ( info )
			{
				_name = name ? name : info.name;
				_meta = owner.getMetaData( info.metadata, memberType, this );
			}
			
			_memberType = memberType;
		}
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function getMetadata( clazz:Class ):Array
		{
			var result:Array = [];
			
			for each ( var i:* in meta )
				if ( i is clazz )
					result.push( i );
			
			return result;
		}
	}
}
