package com.bojinx.included.meta
{
	import com.bojinx.api.constants.ProcessorLifeCycleStage;
	import com.bojinx.api.processor.metadata.IMetaData;
	import com.bojinx.reflection.MetaDataDescriptor;
	
	/**
	 * <p>Defines the [PostInit] Annotation.</p>
	 *
	 * @author Wael Jammal
	 */
	public class PostInitMetadata implements IMetaData, ILifeCyleMetadata
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _stage:int = ProcessorLifeCycleStage.AFTER_POST_INIT;
		
		/** @private */
		public function get stage():int
		{
			return _stage;
		}
		
		public function PostInitMetadata()
		{
		}
		
		/*============================================================================*/
		/*= STATIC PUBLIC PROPERTIES                                                  */
		/*============================================================================*/
		
		public static function get config():MetaDataDescriptor
		{
			var conf:MetaDataDescriptor = new MetaDataDescriptor();
			conf.setMetaName( "PostInit" );
			conf.setSupportedMembers( MetaDataDescriptor.METHOD );
			
			return conf;
		}
	}
}
