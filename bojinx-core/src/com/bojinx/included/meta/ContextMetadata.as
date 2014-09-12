package com.bojinx.included.meta
{
	import com.bojinx.api.constants.ProcessorLifeCycleStage;
	import com.bojinx.api.processor.metadata.IMetaData;
	import com.bojinx.reflection.MetaDataDescriptor;
	
	/**
	 * <p>Defines the [Context] Annotation.</p>
	 * 
	 * Use on a property or method.
	 *
	 * @author Wael Jammal
	 */
	public class ContextMetadata implements IMetaData
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _stage:int = ProcessorLifeCycleStage.POST_INIT;
		
		/** @private */
		public function get stage():int
		{
			return _stage;
		}
		
		/**
		 * @private
		 */
		public function ContextMetadata()
		{
		}
		
		/*============================================================================*/
		/*= STATIC PUBLIC PROPERTIES                                                  */
		/*============================================================================*/
		
		/**
		 * Returns the configuration for this metadata.
		 */
		public static function get config():MetaDataDescriptor
		{
			var conf:MetaDataDescriptor = new MetaDataDescriptor();
			conf.setMetaName( "Context" );
			conf.setSupportedMembers( MetaDataDescriptor.METHOD | MetaDataDescriptor.PROPERTY );
			
			return conf;
		}
	}
}
