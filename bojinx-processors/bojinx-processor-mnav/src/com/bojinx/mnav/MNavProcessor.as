package com.bojinx.mnav
{
	import com.bojinx.api.constants.ProcessorLifeCycleStage;
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.api.processor.IProcessor;
	import com.bojinx.mnav.config.SiteMap;
	import com.bojinx.mnav.core.adapter.IMnavAdapter;
	import com.bojinx.mnav.core.cache.MNavViewRegistry;
	import com.bojinx.mnav.core.constants.MNavCacheID;
	import com.bojinx.mnav.meta.EffectFactoryMetadata;
	import com.bojinx.mnav.meta.EffectMetadata;
	import com.bojinx.mnav.meta.EffectPlayMetadata;
	import com.bojinx.mnav.meta.EffectQueueMetadata;
	import com.bojinx.mnav.meta.EnterMetadata;
	import com.bojinx.mnav.meta.ExitMetadata;
	import com.bojinx.mnav.meta.RequestMappingMetadata;
	import com.bojinx.mnav.meta.SiteMapMetadata;
	import com.bojinx.mnav.meta.WayPointMetadata;
	import com.bojinx.mnav.operation.MNavProcessorOperation;
	import com.bojinx.system.processor.config.AbstractProcessorConfigurationFactory;
	
	[DefaultProperty("siteMap")]
	/**
	 * @Manifest
	 */
	public class MNavProcessor extends AbstractProcessorConfigurationFactory
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		public var siteMap:SiteMap;
		
		public var autoSwitchLoadingState:Boolean = false;
		
		public var loadStateName:String = "loading";
		
		public var adapters:Vector.<IMnavAdapter>;
		
		override public function get name():String
		{
			return "Bojinx MNav Processor";
		}
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var instance:MNavProcessorOperation;
		
		public function MNavProcessor()
		{
			super();
		}
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		override public function getInstance( context:IApplicationContext ):IProcessor
		{
			if ( !instance )
			{
				instance = new MNavProcessorOperation();
				instance.adapters = adapters;
				
				for each(var i:IMnavAdapter in adapters)
				{
					i.setContext(context);
					i.setProcessor(instance);
					i.setSiteMap(siteMap);
				}
			}
			
			return instance;
		}
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		override protected function postConfigure(context:IApplicationContext):void
		{
			for each(var i:IMnavAdapter in adapters)
				context.processObject(i, true, true);
		}
		
		override protected function configure( context:IApplicationContext ):void
		{
			// Caching
			context.cache.register( new MNavViewRegistry(), MNavCacheID.VIEW_REGISTRY );
			context.cache.register( siteMap, MNavCacheID.SITE_MAP );
			
			// Merged Mode
			setMode( true );
			
			// Default Phase
			setLifecyclePhase( ProcessorLifeCycleStage.AFTER_POST_INIT );
			
			// Meta Support
			registerMeta( EnterMetadata );
			registerMeta( ExitMetadata );
			registerMeta( WayPointMetadata );
			registerMeta( EffectMetadata );
			registerMeta( SiteMapMetadata );
			registerMeta( RequestMappingMetadata );
			registerMeta( EffectFactoryMetadata );
			registerMeta( EffectPlayMetadata );
			registerMeta( EffectQueueMetadata );
		}
	}
}
