package com.bojinx.messaging
{
	import com.bojinx.api.constants.ProcessorLifeCycleStage;
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.api.processor.IProcessor;
	import com.bojinx.api.processor.IProcessorConfigurationFactory;
	import com.bojinx.messaging.meta.MessageDispatcherMetadata;
	import com.bojinx.messaging.meta.MessageInterceptorMetadata;
	import com.bojinx.messaging.meta.MessageMetadata;
	import com.bojinx.messaging.operation.MessageOperation;
	import com.bojinx.system.processor.config.AbstractProcessorConfigurationFactory;
	
	/**
	 * Messaging processor.
	 *
	 * @author Wael Jammal
	 * @Manifest
	 */
	public class MessageProcessor extends AbstractProcessorConfigurationFactory
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		/**
		 * @inheritDoc
		 */
		override public function get name():String
		{
			return "Bojinx Messaging Processor";
		}
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var instance:MessageOperation;
		
		/**
		 * @private
		 */
		public function MessageProcessor()
		{
		}
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		override public function getInstance( context:IApplicationContext ):IProcessor
		{
			if ( !instance )
				instance = new MessageOperation();
			
			return instance;
		}
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		override protected function configure( context:IApplicationContext ):void
		{
			registerMeta( MessageMetadata );
			registerMeta( MessageDispatcherMetadata );
			registerMeta( MessageInterceptorMetadata );
		}
	}
}
