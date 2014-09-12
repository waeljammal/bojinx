package com.bojinx.system.cache.definition
{
	import com.bojinx.api.constants.MetaKind;
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.api.processor.metadata.IMetaDefinition;
	
	public class MergedMetaDefinition implements IMetaDefinition
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _context:IApplicationContext;
		
		public function get context():IApplicationContext
		{
			return _context;
		}
		
		private var _data:Vector.<MetaDefinition>;
		
		public function get data():Vector.<MetaDefinition>
		{
			return _data;
		}
		
		public function get metaKind():String
		{
			return MetaKind.MERGED;
		}
		
		private var _root:ObjectDefinition;
		
		public function get root():ObjectDefinition
		{
			return _root;
		}
		
		public function MergedMetaDefinition( context:IApplicationContext, root:ObjectDefinition )
		{
			_context = context;
			_root = root;
		}
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function add( value:MetaDefinition ):void
		{
			if ( !_data )
				_data = new Vector.<MetaDefinition>();
			
			data.push( value );
		}
	}
}
