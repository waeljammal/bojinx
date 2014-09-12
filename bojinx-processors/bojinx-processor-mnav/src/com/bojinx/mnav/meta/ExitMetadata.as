package com.bojinx.mnav.meta
{
	import com.bojinx.api.constants.ProcessorLifeCycleStage;
	import com.bojinx.api.context.config.support.IPrioritySupport;
	import com.bojinx.api.processor.metadata.IMetaData;
	import com.bojinx.reflection.MetaDataDescriptor;
	import com.bojinx.system.message.support.Scope;
	
	/**
	 * Represents the [Enter] annotation
	 *
	 * @author Wael Jammal
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @productversion Flex 4
	 */
	public class ExitMetadata implements IMetaData, IPrioritySupport
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _id:String;
		
		public function get id():String
		{
			return _id;
		}
		
		public function set id( value:String ):void
		{
			_id = value;
		}
		
		private var _priority:int = 0;
		
		public function get priority():int
		{
			return _priority;
		}
		
		public function set priority( value:int ):void
		{
			_priority = value;
		}
		
		private var _stage:int = ProcessorLifeCycleStage.READY;
		
		public function get stage():int
		{
			return _stage;
		}
		
		public function set stage( value:int ):void
		{
			_stage = value;
		}
		
		private var _path:String;
		
		public function get path():String
		{
			return _path;
		}
		
		public function set path( value:String ):void
		{
			_path = value;
		}
		
		private var _scope:String = Scope.GLOBAL;
		
		public function get scope():String
		{
			return _scope;
		}
		
		public function set scope( value:String ):void
		{
			_scope = value;
		}
		
		public function ExitMetadata()
		{
		}
		
		/*============================================================================*/
		/*= STATIC PUBLIC PROPERTIES                                                  */
		/*============================================================================*/
		
		public static function get config():MetaDataDescriptor
		{
			var conf:MetaDataDescriptor = new MetaDataDescriptor();
			conf.setMetaName( "Exit" );
			conf.setDefaultProperty( "id" );
			conf.setSupportedMembers( MetaDataDescriptor.METHOD );
			
			return conf;
		}
	}
}
