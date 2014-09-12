package com.bojinx.included.meta
{
	import com.bojinx.api.constants.ProcessorLifeCycleStage;
	import com.bojinx.api.processor.metadata.IMetaData;
	import com.bojinx.reflection.MetaDataDescriptor;
	
	/**
	 * <p>Defines the [Factory] Annotation.</p>
	 *
	 * Use on a method.
	 * 
	 * @author Wael Jammal
	 */
	public class FactoryMetadata implements IMetaData
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
		
		public function FactoryMetadata()
		{
		
		}
		
		/*============================================================================*/
		/*= STATIC PUBLIC PROPERTIES                                                  */
		/*============================================================================*/
		
		public static function get config():MetaDataDescriptor
		{
			var conf:MetaDataDescriptor = new MetaDataDescriptor();
			conf.setMetaName( "Factory" );
			conf.setSupportedMembers( MetaDataDescriptor.METHOD );
			
			return conf;
		}
	}
}