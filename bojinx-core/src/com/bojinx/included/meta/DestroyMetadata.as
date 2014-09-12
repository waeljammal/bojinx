package com.bojinx.included.meta
{
	import com.bojinx.api.constants.ProcessorLifeCycleStage;
	import com.bojinx.api.processor.metadata.IMetaData;
	import com.bojinx.reflection.MetaDataDescriptor;
	
	/**
	 * <p>Defines the [Destroy] Annotation.</p>
	 * 
	 * Use on a method.
	 *
	 * @author Wael Jammal
	 */
	public class DestroyMetadata implements IMetaData, ILifeCyleMetadata
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _stage:int = ProcessorLifeCycleStage.AFTER_DESTROY;
		
		/**
		 * Lifecycle stage to run in
		 */
		public function get stage():int
		{
			return _stage;
		}
		
		public function DestroyMetadata()
		{
		}
		
		/*============================================================================*/
		/*= STATIC PUBLIC PROPERTIES                                                  */
		/*============================================================================*/
		
		public static function get config():MetaDataDescriptor
		{
			var conf:MetaDataDescriptor = new MetaDataDescriptor();
			conf.setMetaName( "Destroy" );
			conf.setSupportedMembers( MetaDataDescriptor.METHOD );
			
			return conf;
		}
	}
}
