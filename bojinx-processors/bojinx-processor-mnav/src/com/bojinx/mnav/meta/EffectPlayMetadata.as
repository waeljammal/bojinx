package com.bojinx.mnav.meta
{
	import com.bojinx.api.constants.ProcessorLifeCycleStage;
	import com.bojinx.api.processor.metadata.IMetaData;
	import com.bojinx.reflection.MetaDataDescriptor;
	
	public class EffectPlayMetadata implements IMetaData
	{
		public function EffectPlayMetadata()
		{
		}
		
		public function get stage():int
		{
			return ProcessorLifeCycleStage.AFTER_PRE_INIT;
		}
		
		public static function get config():MetaDataDescriptor
		{
			var conf:MetaDataDescriptor = new MetaDataDescriptor();
			conf.setMetaName( "EffectPlay" );
			conf.setSupportedMembers( MetaDataDescriptor.METHOD );
			
			return conf;
		}
	}
}