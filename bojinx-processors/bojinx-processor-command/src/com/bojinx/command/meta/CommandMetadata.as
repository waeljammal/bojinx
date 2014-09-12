package com.bojinx.command.meta
{
	import com.bojinx.api.constants.ProcessorLifeCycleStage;
	import com.bojinx.api.processor.metadata.IMetaData;
	import com.bojinx.reflection.MetaDataDescriptor;
	import com.bojinx.system.message.support.Scope;
	
	/**
	 * <p>Represents the Command annotation.</p>
	 *
	 * author: Wael
	 * created: Dec 14, 2009
	 */
	public class CommandMetadata implements IMetaData
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _name:String;
		
		/**
		 * This is the group the message is targeted
		 * at.
		 */
		public function get name():String
		{
			return _name;
		}
		
		/**
		 * @private
		 */
		public function set name( value:String ):void
		{
			_name = value;
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
		
		private var _stage:int = ProcessorLifeCycleStage.POST_INIT;
		
		/**
		 * Lifecycle stage to run in
		 */
		public function get stage():int
		{
			return _stage;
		}
		
		private var _type:String;
		
		public function get type():String
		{
			return _type;
		}
		
		public function set type( value:String ):void
		{
			_type = value;
		}
		
		public function CommandMetadata()
		{
		
		}
		
		
		/*============================================================================*/
		/*= STATIC PUBLIC PROPERTIES                                                  */
		/*============================================================================*/
		
		public static function get config():MetaDataDescriptor
		{
			var conf:MetaDataDescriptor = new MetaDataDescriptor();
			conf.setMetaName( "Command" );
			conf.setDefaultProperty( "name" );
			conf.setSupportedMembers( MetaDataDescriptor.METHOD );
			
			return conf;
		}
	}
}
