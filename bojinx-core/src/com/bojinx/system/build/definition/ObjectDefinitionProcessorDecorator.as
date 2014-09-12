package com.bojinx.system.build.definition
{
	import avmplus.getQualifiedClassName;
	
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.api.context.config.support.IPrioritySupport;
	import com.bojinx.api.processor.metadata.IMetaData;
	import com.bojinx.reflection.ClassInfo;
	import com.bojinx.reflection.MetaDataAware;
	import com.bojinx.system.cache.definition.MemberProcessors;
	import com.bojinx.system.cache.definition.ObjectDefinition;
	import com.bojinx.utils.logging.Logger;
	import com.bojinx.utils.logging.LoggingContext;
	import com.bojinx.utils.type.ClassUtils;
	
	public class ObjectDefinitionProcessorDecorator
	{
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var context:IApplicationContext;
		
		public function ObjectDefinitionProcessorDecorator( context:IApplicationContext )
		{
			this.context = context;
		}
		
		/*============================================================================*/
		/*= STATIC PROTECTED PROPERTIES                                               */
		/*============================================================================*/
		
		CONFIG::log
		protected static var log:Logger = LoggingContext.getLogger( ObjectDefinitionProcessorDecorator );
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function decorate( definition:ObjectDefinition ):void
		{
			definition.isDecorated = true;
			
			if(!definition.type)
				definition.generateTypeInfo();
			
			var typeInfo:ClassInfo = definition.type;
			
			// Filtered Members
			var properties:Array = typeInfo.getProperties();
			var methods:Array = typeInfo.getMethods();
			var combined:Array = properties.concat( methods );
			var factories:Array;
			var type:Class;
			var name:String;
			var numProcessors:int = 0;
			var meta:IMetaData;
			
			// Inlined for performance
			function generateInfo(m:MetaDataAware, meta:IMetaData):void {
				type = ClassUtils.forName( getQualifiedClassName( meta ), context.applicationDomain );
				name = type[ "config" ][ "tagName" ];
				
				factories = getProcessorForMeta( name );
				
				var memberInfo:MemberProcessors = new MemberProcessors();
				memberInfo.name = m.name;
				memberInfo.member = m;
				memberInfo.meta = meta;
				memberInfo.processors = factories;
				memberInfo.stage = meta.stage;
				memberInfo.priority = meta is IPrioritySupport ? IPrioritySupport(meta).priority : 0;
				
				numProcessors += factories ? factories.length : 0;
				
				definition.addMember( memberInfo );	
			}

			// Properties & Methods
			for each ( var m:MetaDataAware in combined )
			{
				for each ( meta in m.meta )
				{
					generateInfo(m, meta);
				}
			}
			
			// Class
			for each ( meta in typeInfo.meta )
			{
				generateInfo(typeInfo, meta);
			}
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function getProcessorForMeta( name:String ):Array
		{
			return context.cache.processors.getProcessorsByMetaName( name );
		}
	}
}
