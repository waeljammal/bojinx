package com.bojinx.mnav.meta
{
	import com.bojinx.api.constants.ProcessorLifeCycleStage;
	import com.bojinx.api.processor.metadata.IMetaData;
	import com.bojinx.reflection.MetaDataDescriptor;
	
	public class WayPointMetadata implements IMetaData
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		public var mode:String;
		
		public var path:String;
		
		public function get stage():int
		{
			return ProcessorLifeCycleStage.READY;
		}
		
		public var target:String;
		
		public var factory:String;
		
		public var effectEndpoint:Boolean;
		
		public function WayPointMetadata()
		{
		}
		
		
		/*============================================================================*/
		/*= STATIC PUBLIC PROPERTIES                                                  */
		/*============================================================================*/
		
		public static function get config():MetaDataDescriptor
		{
			var conf:MetaDataDescriptor = new MetaDataDescriptor();
			conf.setMetaName( "WayPoint" );
			conf.setDefaultProperty( "name" );
			conf.setSupportedMembers( MetaDataDescriptor.CLASS );
			
			return conf;
		}
	}
}
