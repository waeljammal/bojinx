package com.bojinx.test.meta
{
	import com.bojinx.api.constants.ProcessorLifeCycleStage;
	import com.bojinx.api.processor.metadata.IMetaData;
	import com.bojinx.reflection.MetaDataDescriptor;
	
	[DefaultProperty( "configFile" )]
	[Metadata( name = "Config", types = "class" )]
	public class ConfigMetadata implements IMetaData
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _configFile:String;
		
		public function get configFile():String
		{
			return _configFile;
		}
		
		public function set configFile( value:String ):void
		{
			_configFile = value;
		}
		
		private var _stage:int = ProcessorLifeCycleStage.BEFORE_PRE_INIT;
		
		public function get stage():int
		{
			return _stage;
		}
		
		public function set stage( value:int ):void
		{
			_stage = value;
		}
		
		public function ConfigMetadata()
		{
		}
		
		
		/*============================================================================*/
		/*= STATIC PUBLIC PROPERTIES                                                  */
		/*============================================================================*/
		
		public static function get config():MetaDataDescriptor
		{
			var conf:MetaDataDescriptor = new MetaDataDescriptor();
			conf.setMetaName( "Config" );
			conf.setDefaultProperty( "configFile" );
			conf.setSupportedMembers( MetaDataDescriptor.CLASS );
			
			return conf;
		}
	}
}
