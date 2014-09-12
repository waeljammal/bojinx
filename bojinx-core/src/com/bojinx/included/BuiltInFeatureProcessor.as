package com.bojinx.included
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.api.processor.IProcessor;
	import com.bojinx.included.meta.ContextMetadata;
	import com.bojinx.included.meta.DestroyMetadata;
	import com.bojinx.included.meta.PostInitMetadata;
	import com.bojinx.included.meta.PreInitMetadata;
	import com.bojinx.included.meta.ReadyMetadata;
	import com.bojinx.included.operation.BuiltInFeatureOperation;
	import com.bojinx.system.processor.config.AbstractProcessorConfigurationFactory;
	
	[ExcludeClass]
	/**
	 * @private
	 */
	public class BuiltInFeatureProcessor extends AbstractProcessorConfigurationFactory
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		override public function get name():String
		{
			return "Bojinx Built in Processors";
		}
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var instance:BuiltInFeatureOperation;
		
		public function BuiltInFeatureProcessor()
		{
			super();
		}
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		override public function getInstance( context:IApplicationContext ):IProcessor
		{
			if ( !instance )
				instance = new BuiltInFeatureOperation();
			
			return instance;
		}
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		override protected function configure( context:IApplicationContext ):void
		{
			registerMeta( DestroyMetadata );
			registerMeta( ReadyMetadata );
			registerMeta( PreInitMetadata );
			registerMeta( PostInitMetadata );
			registerMeta( ContextMetadata );
		}
	}
}
