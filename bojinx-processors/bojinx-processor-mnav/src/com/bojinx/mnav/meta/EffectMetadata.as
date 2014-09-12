package com.bojinx.mnav.meta
{
	import com.bojinx.api.constants.ProcessorLifeCycleStage;
	import com.bojinx.api.processor.metadata.IMetaData;
	import com.bojinx.reflection.MetaDataDescriptor;
	
	public class EffectMetadata implements IMetaData
	{
		public function EffectMetadata()
		{
		}
		
		public function get stage():int
		{
			return ProcessorLifeCycleStage.AFTER_PRE_INIT;
		}
		
		public var kind:String;
		public var state:String;
		
		public static function get config():MetaDataDescriptor
		{
			var conf:MetaDataDescriptor = new MetaDataDescriptor();
			conf.setMetaName( "Effect" );
			conf.setDefaultProperty( "kind" );
			conf.addRequiredProperty("kind");
			conf.setSupportedMembers( MetaDataDescriptor.METHOD );
			
			return conf;
		}
	}
}