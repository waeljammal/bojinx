package com.bojinx.mnav.meta
{
	import com.bojinx.api.constants.ProcessorLifeCycleStage;
	import com.bojinx.api.processor.metadata.IMetaData;
	import com.bojinx.reflection.MetaDataDescriptor;
	
	public class EffectQueueMetadata implements IMetaData
	{
		public function EffectQueueMetadata()
		{
		}
		
		public function get stage():int
		{
			return ProcessorLifeCycleStage.AFTER_PRE_INIT;
		}
		
		public static function get config():MetaDataDescriptor
		{
			var conf:MetaDataDescriptor = new MetaDataDescriptor();
			conf.setMetaName( "EffectQueue" );
			conf.setSupportedMembers( MetaDataDescriptor.METHOD );
			
			return conf;
		}
	}
}