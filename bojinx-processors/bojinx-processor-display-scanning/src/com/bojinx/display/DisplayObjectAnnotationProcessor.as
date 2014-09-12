package com.bojinx.display
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.api.processor.IProcessor;
	import com.bojinx.display.meta.ViewManagerMetadata;
	import com.bojinx.display.operation.DisplayProcessingOperation;
	import com.bojinx.system.processor.config.AbstractProcessorConfigurationFactory;
	
	/**
	 * @Manifest
	 */
	public class DisplayObjectAnnotationProcessor extends AbstractProcessorConfigurationFactory
	{
		public function DisplayObjectAnnotationProcessor()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get name():String
		{
			return "Bojinx Display Processing Annotation Support";
		}
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var instance:DisplayProcessingOperation;
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		override public function getInstance( context:IApplicationContext ):IProcessor
		{
			if(!instance)
				instance = new DisplayProcessingOperation();
			
			return instance;
		}
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		override protected function configure( context:IApplicationContext ):void
		{
			// Process one tag at a time
			setMode( false );
			
			registerMeta( ViewManagerMetadata );
		}
	}
}