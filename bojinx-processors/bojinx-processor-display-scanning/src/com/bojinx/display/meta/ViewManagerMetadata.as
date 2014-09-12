package com.bojinx.display.meta
{
	import com.bojinx.api.constants.ProcessorLifeCycleStage;
	import com.bojinx.api.processor.metadata.IMetaData;
	import com.bojinx.reflection.MetaDataDescriptor;
	
	/**
	 * <p>Defines the [Context] Annotation.</p>
	 *
	 * author: Wael
	 * created: Dec 14, 2009
	 */
	public class ViewManagerMetadata implements IMetaData
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _stage:int = ProcessorLifeCycleStage.POST_INIT;
		
		/**
		 * Lifecycle stage to run in
		 */
		public function get stage():int
		{
			return _stage;
		}
		
		/**
		 * @private
		 */
		public function ViewManagerMetadata()
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
			conf.setMetaName( "ViewManager" );
			conf.setSupportedMembers( MetaDataDescriptor.METHOD | MetaDataDescriptor.PROPERTY );
			
			return conf;
		}
	}
}
