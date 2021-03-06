package com.bojinx.included.meta
{
	import com.bojinx.api.constants.ProcessorLifeCycleStage;
	import com.bojinx.api.processor.metadata.IMetaData;
	import com.bojinx.reflection.MetaDataDescriptor;
	
	/**
	 * <p>Defines the [PreInit] Annotation.</p>
	 * 
	 * Use on a method.
	 *
	 * @author Wael Jammal
	 */
	public class PreInitMetadata implements IMetaData, ILifeCyleMetadata
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _stage:int = ProcessorLifeCycleStage.AFTER_PRE_INIT;
		
		/** @private */
		public function get stage():int
		{
			return _stage;
		}
		
		public function PreInitMetadata()
		{
		}
		
		/*============================================================================*/
		/*= STATIC PUBLIC PROPERTIES                                                  */
		/*============================================================================*/
		
		public static function get config():MetaDataDescriptor
		{
			var conf:MetaDataDescriptor = new MetaDataDescriptor();
			conf.setMetaName( "PreInit" );
			conf.setSupportedMembers( MetaDataDescriptor.METHOD );
			
			return conf;
		}
	}
}
