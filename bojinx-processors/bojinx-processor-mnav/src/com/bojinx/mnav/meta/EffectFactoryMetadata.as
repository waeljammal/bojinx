package com.bojinx.mnav.meta
{
	import com.bojinx.api.constants.ProcessorLifeCycleStage;
	import com.bojinx.api.processor.metadata.IMetaData;
	import com.bojinx.reflection.MetaDataDescriptor;
	
	public class EffectFactoryMetadata implements IMetaData
	{
		public function EffectFactoryMetadata()
		{
		}
		
		public function get stage():int
		{
			return ProcessorLifeCycleStage.BEFORE_PRE_INIT;
		}
		
		public var path:String;
		
		public static function get config():MetaDataDescriptor
		{
			var conf:MetaDataDescriptor = new MetaDataDescriptor();
			conf.setMetaName( "EffectFactory" );
			conf.setDefaultProperty( "path" );
			conf.addRequiredProperty("path");
			conf.setSupportedMembers( MetaDataDescriptor.CLASS );
			
			return conf;
		}
	}
}