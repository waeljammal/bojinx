package com.bojinx.mnav.meta
{
	import com.bojinx.api.constants.ProcessorLifeCycleStage;
	import com.bojinx.api.processor.metadata.IMetaData;
	import com.bojinx.reflection.MetaDataDescriptor;
	
	public class SiteMapMetadata implements IMetaData
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		public function get stage():int
		{
			return ProcessorLifeCycleStage.AFTER_POST_INIT;
		}
		
		public function SiteMapMetadata()
		{
		}
		
		
		/*============================================================================*/
		/*= STATIC PUBLIC PROPERTIES                                                  */
		/*============================================================================*/
		
		public static function get config():MetaDataDescriptor
		{
			var conf:MetaDataDescriptor = new MetaDataDescriptor();
			conf.setMetaName( "SiteMap" );
			conf.setSupportedMembers( MetaDataDescriptor.PROPERTY | MetaDataDescriptor.METHOD );
			
			return conf;
		}
	}
}
