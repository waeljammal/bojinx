package com.bojinx.system.cache.store
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.api.processor.IProcessor;
	import com.bojinx.api.processor.IProcessorConfigurationFactory;
	import com.bojinx.api.processor.IProcessorFactory;
	import flash.utils.Dictionary;
	
	public class ProcessorRegistry
	{
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var context:IApplicationContext;
		
		private var factories:Dictionary;
		
		public function ProcessorRegistry( context:IApplicationContext )
		{
			this.context = context;
		}
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function dispose():void
		{
			factories = null;
		}
		
		public function getProcessorsByMetaName( name:String ):Array
		{
			if ( factories && factories[ name ])
				return factories[ name ];
			else if ( context.parent )
				return context.parent.cache.processors.getProcessorsByMetaName( name );
			
			return null;
		}
		
		public function registerFactory( factory:IProcessorConfigurationFactory ):void
		{
			initFactories();
			
			var meta:Array = factory.supportedMetadata;
			var name:String;
			var entry:Array;
			
			for each ( var m:Class in meta )
			{
				name = m[ "config" ].tagName;
				entry = factories[ name ];
				
				if ( !entry )
				{
					entry = [];
					factories[ name ] = entry;
				}
				
				entry.push( factory );
			}
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function initFactories():void
		{
			if ( !factories )
				factories = new Dictionary( false );
		}
	}
}
