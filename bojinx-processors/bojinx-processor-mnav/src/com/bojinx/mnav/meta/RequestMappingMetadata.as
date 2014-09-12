package com.bojinx.mnav.meta
{
	import com.bojinx.api.constants.ProcessorLifeCycleStage;
	import com.bojinx.api.processor.metadata.IMetaData;
	import com.bojinx.reflection.MetaDataDescriptor;
	
	public class RequestMappingMetadata implements IMetaData
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		public var path:String;
		
		public function get stage():int
		{
			return ProcessorLifeCycleStage.AFTER_PRE_INIT;
		}
		
		public function RequestMappingMetadata()
		{
		}
		
		
		/*============================================================================*/
		/*= STATIC PUBLIC PROPERTIES                                                  */
		/*============================================================================*/
		
		public static function get config():MetaDataDescriptor
		{
			var conf:MetaDataDescriptor = new MetaDataDescriptor();
			conf.setMetaName( "RequestMapping" );
			conf.setDefaultProperty( "path" );
			conf.addRequiredProperty( "path" );
			conf.setSupportedMembers( MetaDataDescriptor.CLASS );
			
			return conf;
		}
	}
}
