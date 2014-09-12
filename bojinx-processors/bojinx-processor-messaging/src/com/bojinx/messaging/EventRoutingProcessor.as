package com.bojinx.messaging
{
	import com.bojinx.api.constants.ProcessorLifeCycleStage;
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.api.processor.IProcessor;
	import com.bojinx.messaging.meta.EventMetadata;
	import com.bojinx.messaging.meta.RouteEventsMetadata;
	import com.bojinx.messaging.operation.EventRoutingOperation;
	import com.bojinx.reflection.registry.MetaDataRegistry;
	import com.bojinx.system.processor.config.AbstractProcessorConfigurationFactory;
	
	/**
	 * @Manifest
	 */
	public class EventRoutingProcessor extends AbstractProcessorConfigurationFactory
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		override public function get name():String
		{
			return "Bojinx Event Routing Processor";
		}
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var instance:EventRoutingOperation;
		
		public function EventRoutingProcessor()
		{
			super();
		}
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		override public function getInstance( context:IApplicationContext ):IProcessor
		{
			if ( !instance )
				instance = new EventRoutingOperation();
			
			return instance;
		}
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		override protected function configure( context:IApplicationContext ):void
		{
			MetaDataRegistry.getInstance().registerMetaData(EventMetadata);
			registerMeta( RouteEventsMetadata );
		}
	}
}
