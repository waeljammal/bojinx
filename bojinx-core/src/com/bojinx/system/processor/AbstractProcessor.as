package com.bojinx.system.processor
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.api.processor.IProcessor;
	import com.bojinx.api.processor.metadata.IMetaDefinition;
	import com.bojinx.system.cache.definition.MergedMetaDefinition;
	import com.bojinx.system.cache.definition.MetaDefinition;
	import com.bojinx.system.processor.event.ProcessorEvent;
	
	import flash.events.EventDispatcher;
	
	[Event( name = "complete", type = "com.bojinx.system.processor.event.ProcessorEvent" )]
	[Event( name = "error", type = "com.bojinx.system.processor.event.ProcessorEvent" )]
	public class AbstractProcessor extends EventDispatcher implements IProcessor
	{
		
		public function AbstractProcessor()
		{
		}
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function process( value:MetaDefinition ):void
		{
			complete( value );
		}
		
		public function processMerged( value:MergedMetaDefinition ):void
		{
			complete( value );
		}
		
		public function release( value:MetaDefinition ):void
		{
			complete( value );
		}
		
		public function releaseMerged( value:MergedMetaDefinition ):void
		{
			complete( value );
		}
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		protected final function complete( value:IMetaDefinition ):void
		{
			dispatchEvent( new ProcessorEvent( ProcessorEvent.COMPLETE, value, "Compelete" ));
		}
		
		protected final function error( value:IMetaDefinition, message:String ):void
		{
			dispatchEvent( new ProcessorEvent( ProcessorEvent.ERROR, value, message ));
		}
	}
}
