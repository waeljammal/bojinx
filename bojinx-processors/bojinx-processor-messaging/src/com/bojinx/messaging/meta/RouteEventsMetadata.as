package com.bojinx.messaging.meta
{
	import com.bojinx.api.constants.ProcessorLifeCycleStage;
	import com.bojinx.api.processor.metadata.IMetaData;
	import com.bojinx.reflection.MetaDataDescriptor;
	import com.bojinx.utils.type.StringUtils;
	
	public class RouteEventsMetadata implements IMetaData
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _events:String;
		
		public function get events():String
		{
			return _events;
		}
		
		public function set events( value:String ):void
		{
			_events = value;
		}
		
		private var _stage:int = ProcessorLifeCycleStage.POST_INIT;
		
		/**
		 * Lifecycle stage to run in
		 */
		public function get stage():int
		{
			return _stage;
		}
		
		public function RouteEventsMetadata()
		{
		}
		
		/*============================================================================*/
		/*= STATIC PUBLIC PROPERTIES                                                  */
		/*============================================================================*/
		
		public static function get config():MetaDataDescriptor
		{
			var conf:MetaDataDescriptor = new MetaDataDescriptor();
			conf.setMetaName( "RouteEvents" );
			conf.setSupportedMembers( MetaDataDescriptor.CLASS );
			conf.setDefaultProperty( "events" );
			
			return conf;
		}
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		/**
		 * <p>Returns the events as an array.</p>
		 *
		 * @return Array of Strings
		 */
		public function getEventsAsArray():Array
		{
			var result:Array;
			
			if ( !events )
			{
				return result;
			}
			
			for each ( var i:String in events.split( "," ))
			{
				if ( !result )
					result = [];
				
				result.push( StringUtils.removeExtraWhitespace( i ));
			}
			
			return result;
		}
	}
}
