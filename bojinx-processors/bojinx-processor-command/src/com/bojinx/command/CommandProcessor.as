package com.bojinx.command
{
	import com.bojinx.api.constants.ProcessorLifeCycleStage;
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.api.processor.IProcessor;
	import com.bojinx.command.cache.CommandCacheConstants;
	import com.bojinx.command.cache.CommandRegistry;
	import com.bojinx.command.config.factory.CommandFactory;
	import com.bojinx.command.core.CommandMapMessageListener;
	import com.bojinx.command.meta.CommandFaultMetadata;
	import com.bojinx.command.meta.CommandMetadata;
	import com.bojinx.command.meta.CommandResultMetadata;
	import com.bojinx.command.operation.CommandOperation;
	import com.bojinx.reflection.registry.MetaDataRegistry;
	import com.bojinx.system.message.support.Scope;
	import com.bojinx.system.processor.config.AbstractProcessorConfigurationFactory;
	
	/**
	 * Injection Processor Configuration and Factory
	 *
	 * @author Wael Jammal
	 * @Manifest
	 */
	public class CommandProcessor extends AbstractProcessorConfigurationFactory
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		/**
		 * @inheritDoc
		 */
		override public function get name():String
		{
			return "Bojinx Command Processor";
		}
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var instance:CommandOperation;
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		override public function getInstance( context:IApplicationContext ):IProcessor
		{
			return instance;
		}
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		override protected function postConfigure(context:IApplicationContext):void
		{		
			var commands:Array = context.cache.beans.getAllBeansByType(CommandFactory);
			
			// Registers interceptors for all the CommandFactory Beans.
			instance.registerBeanInterceptors(commands, context);
		}
		
		override protected function configure( context:IApplicationContext ):void
		{
			instance = new CommandOperation();
			
			var cache:CommandRegistry = new CommandRegistry(context);
			context.cache.register( cache, CommandCacheConstants.CACHE_ID );
			
			// Command operation will require that all metadata be
			// processed in one go
			setMode( true );
			
			// Allow but dont associate with an operation
			MetaDataRegistry.getInstance().registerMetaData(CommandMetadata);
			MetaDataRegistry.getInstance().registerMetaData(CommandResultMetadata);
			MetaDataRegistry.getInstance().registerMetaData(CommandFaultMetadata);
		}
	}
}
