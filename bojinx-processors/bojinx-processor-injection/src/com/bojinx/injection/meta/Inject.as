package com.bojinx.injection.meta
{
	import com.bojinx.api.constants.ProcessorLifeCycleStage;
	import com.bojinx.api.context.config.support.IBeanReferenceSupport;
	import com.bojinx.api.context.config.support.IMultiBeanReferenceSupport;
	import com.bojinx.api.context.config.support.IPrioritySupport;
	import com.bojinx.api.processor.metadata.IMetaData;
	import com.bojinx.reflection.MetaDataDescriptor;
	
	public class Inject implements IMetaData, IPrioritySupport, IBeanReferenceSupport, IMultiBeanReferenceSupport
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
		
		private var _ids:String;
		
		public function get ids():String
		{
			return _ids;
		}
		
		public function set ids( value:String ):void
		{
			_ids = value;
		}
		
		private var _mode:String;
		
		public function get mode():String
		{
			return _mode;
		}
		
		public function set mode( value:String ):void
		{
			_mode = value;
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
		
		private var _property:String;
		
		public function get property():String
		{
			return _property;
		}
		
		public function set property( value:String ):void
		{
			_property = value;
		}
		
		private var _required:Boolean = true;
		
		public function get required():Boolean
		{
			return _required;
		}
		
		public function set required( value:Boolean ):void
		{
			_required = value;
		}
		
		private var _stage:int = ProcessorLifeCycleStage.POST_INIT;
		
		/**
		 * Lifecycle stage to run in
		 */
		public function get stage():int
		{
			return _stage;
		}
		
		public function set stage( value:int ):void
		{
			_stage = value;
		}
		
		public function Inject()
		{
		}
		
		
		/*============================================================================*/
		/*= STATIC PUBLIC PROPERTIES                                                  */
		/*============================================================================*/
		
		public static function get config():MetaDataDescriptor
		{
			var conf:MetaDataDescriptor = new MetaDataDescriptor();
			conf.setMetaName( "Inject" );
			conf.setDefaultProperty( "id" );
			conf.setSupportedMembers( MetaDataDescriptor.METHOD | MetaDataDescriptor.PROPERTY );
			
			return conf;
		}
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function getIds():Array
		{
			return ids ? ids.replace( " ", "" ).split( "," ) : null;
		}
	}
}
