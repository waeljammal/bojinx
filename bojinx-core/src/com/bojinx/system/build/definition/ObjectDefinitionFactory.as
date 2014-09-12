package com.bojinx.system.build.definition
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.reflection.ClassInfoFactory;
	import com.bojinx.system.cache.definition.ObjectDefinition;
	import com.bojinx.utils.logging.Logger;
	import com.bojinx.utils.logging.LoggingContext;
	
	public class ObjectDefinitionFactory
	{
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var context:IApplicationContext;
		
		public function ObjectDefinitionFactory( context:IApplicationContext )
		{
			this.context = context;
		}
		
		
		/*============================================================================*/
		/*= STATIC PROTECTED PROPERTIES                                               */
		/*============================================================================*/
		
		CONFIG::log
		protected static var log:Logger = LoggingContext.getLogger( ObjectDefinitionFactory );
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function definitionFromInstance(object:Object, singleton:Boolean):ObjectDefinition
		{
			var definition:ObjectDefinition = context.cache.definitions.getDefinitionByInstance(object);
			
			if(!definition)
			{
				definition = new ObjectDefinition();
				definition.type = ClassInfoFactory.forInstance(object, context.applicationDomain);
				definition.target = object;
				definition.context = context;
				definition.isSingleton = singleton;
				
//				if(singleton)
					context.cache.definitions.registerDefinition(definition);
			}
			
			return definition;
		}
	}
}
