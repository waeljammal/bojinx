package com.bojinx.command.operation
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.api.processor.metadata.IMetaData;
	import com.bojinx.command.cache.CommandCacheConstants;
	import com.bojinx.command.cache.CommandRegistry;
	import com.bojinx.command.config.factory.CommandFactory;
	import com.bojinx.command.core.handler.DynamicCommandBeanHandler;
	import com.bojinx.command.meta.CommandFaultMetadata;
	import com.bojinx.command.meta.CommandMetadata;
	import com.bojinx.command.meta.CommandResultMetadata;
	import com.bojinx.reflection.ClassInfo;
	import com.bojinx.reflection.ClassInfoFactory;
	import com.bojinx.reflection.Method;
	import com.bojinx.reflection.Parameter;
	import com.bojinx.system.cache.definition.MergedMetaDefinition;
	import com.bojinx.system.cache.definition.MetaDefinition;
	import com.bojinx.system.processor.AbstractProcessor;
	import com.bojinx.utils.logging.Logger;
	import com.bojinx.utils.logging.LoggingContext;
	
	public class CommandOperation extends AbstractProcessor
	{
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var definitions:MergedMetaDefinition;
		
		private var executor:MetaDefinition;
		
		private var faultHandler:MetaDefinition;
		
		private var resultHandler:MetaDefinition;
		
		private var cache:CommandRegistry;
		
		public function CommandOperation()
		{
		}
		
		
		/*============================================================================*/
		/*= STATIC PROTECTED PROPERTIES                                               */
		/*============================================================================*/
		
		CONFIG::log
		protected static var log:Logger = LoggingContext.getLogger( CommandOperation );
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		override public function processMerged( value:MergedMetaDefinition ):void
		{
			definitions = value;
			
//			for each ( var md:MetaDefinition in value.data )
//			{
//				if ( md.meta is CommandResultMetadata )
//					processResultHandler( md );
//				else if ( md.meta is CommandFaultMetadata )
//					processFaultHandler( md );
//				else if ( md.meta is CommandMetadata )
//					processorCommandHandler( md );
//			}
			
//			if ( executor )
//				execute();
//			else
				complete( value );
		}
		
		/**
		 * Registers command factories that are not part of a command map
		 * so they can be triggered using messaging, command maps handle their own
		 * invocations so they do not need to be registered here.
		 */
		public function registerBeanInterceptors(commands:Array, context:IApplicationContext):void
		{
			cache = context.cache.getCache(CommandCacheConstants.CACHE_ID);
			
			for each(var i:CommandFactory in commands)
			{
				var type:ClassInfo = ClassInfoFactory.forClass(i.source);
				var executor:Method, result:Method, fault:Method;
				var entry:DynamicCommandBeanHandler = new DynamicCommandBeanHandler();
				var messageType:Class;
				var name:String;
				
				for each(var m:Method in type.getMethods())
				{
					for each(var j:IMetaData in m.meta)
					{
						if(j is CommandMetadata && !executor)
						{
							if(!m.parameters || m.parameters.length == 0)
								throw new Error("Message driven command must have atleast 1 argument which should be the message type [Class]: " + type.name + " [Method]:" + m.name);
							
							name = CommandMetadata(j).name;
							
							var param:Parameter = m.parameters[0];
							messageType = param.paramterType.getClass();
							
							executor = m;
						}
						else if(j is CommandResultMetadata)
							result = m;
						else if(j is CommandFaultMetadata)
							fault = m;
					}
				}
				
				entry.id = i.id;
				entry.contex = context;
				entry.executor = executor;
				entry.result = result;
				entry.fault = fault;
				entry.factory = i;
				entry.messageType = messageType;
				entry.scope = i.scope;
				entry.name = name;
				entry.registerListener(context);
				
				cache.addDynamicCommand(entry);
			}
		}
	}
}
