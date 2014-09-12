package com.bojinx.system.processor.config
{
	import com.bojinx.api.constants.ProcessorLifeCycleStage;
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.api.processor.IProcessor;
	import com.bojinx.api.processor.IProcessorConfigurationFactory;
	import com.bojinx.reflection.registry.MetaDataRegistry;
	
	/**
	 * <p>The abstract class used for defining a Processors configuration.</p>
	 *
	 * <p>You should extend this when creating a new processor and return your
	 * operation by overriding the <code>getInstance()</code> method.</p>
	 *
	 * @author Wael Jammal
	 */
	public class AbstractProcessorConfigurationFactory implements IProcessorConfigurationFactory
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _initialized:Boolean = false;
		
		/**
		 * Returns true if the factory has been initialized
		 */
		public function get initialized():Boolean
		{
			return _initialized;
		}
		
		
		private var _mode:String = "single";
		
		public function get mode():String
		{
			return _mode;
		}
		
		/**
		 * A descriptive name for this processor
		 */
		public function get name():String
		{
			throw new Error( "Abstract: You musy override get name():String in " + this );
			
			return null;
		}
		
		private var _phase:int = ProcessorLifeCycleStage.POST_INIT;
		
		public function get phase():int
		{
			return _phase;
		}
		
		private var _supportedMetadata:Array = [];
		
		/**
		 * An array of supported metadata annotations
		 */
		public function get supportedMetadata():Array
		{
			return _supportedMetadata;
		}
		
		public function AbstractProcessorConfigurationFactory()
		{
		}
		
		
		/*============================================================================*/
		/*= STATIC PRIVATE PROPERTIES                                                 */
		/*============================================================================*/
		
		private static var metaDataRegistry:MetaDataRegistry = MetaDataRegistry.getInstance();
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		/**
		 * Returns a new instance of the processing operation
		 *
		 * @return IProcessor
		 */
		public function getInstance( context:IApplicationContext ):IProcessor
		{
			throw new Error( "Abstract: getInstance must be overriden for processor factory " + this );
		}
		
		/**
		 * @private
		 */
		public final function initialize( context:IApplicationContext ):void
		{
			_initialized = true;
			configure( context );
		}
		
		/**
		 * @private
		 */
		public final function postInitialize( context:IApplicationContext ):void
		{
			_initialized = true;
			postConfigure( context );
		}
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		/**
		 * Override to apply your configuration settings
		 */
		protected function configure( context:IApplicationContext ):void
		{
		
		}
		
		/**
		 * Override to register any shared objects with the context
		 */
		protected function postConfigure( context:IApplicationContext ):void
		{
		
		}
		
		/**
		 * Call to register a supported metadata annotation
		 */
		protected final function registerMeta( value:Class ):void
		{
			_supportedMetadata.push( value );
			metaDataRegistry.registerMetaData( value );
		}
		
		protected final function setLifecyclePhase( value:int ):void
		{
			_phase = value;
		}
		
		protected final function setMode( merged:Boolean ):void
		{
			if ( merged )
				_mode = "merged";
			else
				_mode = "single";
		}
	}
}
