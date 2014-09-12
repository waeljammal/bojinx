package com.bojinx.injection
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.api.processor.IProcessor;
	import com.bojinx.injection.meta.Inject;
	import com.bojinx.injection.operation.InjectionOperation;
	import com.bojinx.system.processor.config.AbstractProcessorConfigurationFactory;
	
	/**
	 * Injection Processor Configuration and Factory
	 *
	 * @author Wael Jammal
	 * @Manifest
	 */
	public class InjectionProcessor extends AbstractProcessorConfigurationFactory
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		/**
		 * @inheritDoc
		 */
		override public function get name():String
		{
			return "Bojinx Injection Processor";
		}
		
		public var autoNullProperties:Boolean = false;
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var instance:InjectionOperation;
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		override public function getInstance( context:IApplicationContext ):IProcessor
		{
			if ( !instance )
				instance = new InjectionOperation();
			
			instance.autoNullProperties = autoNullProperties;
			
			return instance;
		}
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		override protected function configure( context:IApplicationContext ):void
		{
			registerMeta( Inject );
		}
	}
}
