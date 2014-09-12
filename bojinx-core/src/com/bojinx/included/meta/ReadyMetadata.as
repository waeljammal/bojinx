package com.bojinx.included.meta
{
	import com.bojinx.api.constants.ProcessorLifeCycleStage;
	import com.bojinx.api.context.config.support.IPrioritySupport;
	import com.bojinx.api.processor.metadata.IMetaData;
	import com.bojinx.reflection.MetaDataDescriptor;
	
	/**
	 * <p>Defines the [Ready] Annotation.</p>
	 * 
	 * Use on a method.
	 *
	 * @author Wael Jammal
	 */
	public class ReadyMetadata implements IMetaData, ILifeCyleMetadata, IPrioritySupport
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _priority:int = 0;
		
		/**
		 * The priority to call the method handler in.
		 * 
		 * @default 0
		 */
		public function get priority():int
		{
			return _priority;
		}
		
		public function set priority( value:int ):void
		{
			_priority = value;
		}
		
		private var _stage:int = ProcessorLifeCycleStage.AFTER_READY;
		
		/** @private */
		public function get stage():int
		{
			return _stage;
		}
		
		public function ReadyMetadata()
		{
		}
		
		/*============================================================================*/
		/*= STATIC PUBLIC PROPERTIES                                                  */
		/*============================================================================*/
		
		public static function get config():MetaDataDescriptor
		{
			var conf:MetaDataDescriptor = new MetaDataDescriptor();
			conf.setMetaName( "Ready" );
			conf.setSupportedMembers( MetaDataDescriptor.METHOD );
			
			return conf;
		}
	}
}
