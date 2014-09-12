package com.bojinx.system.context.director
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.api.context.config.IBean;
	import com.bojinx.api.context.config.support.ILazySupport;
	import com.bojinx.api.context.config.support.ISingletonSupport;
	import com.bojinx.api.context.config.IResolvableBean;
	import com.bojinx.api.processor.IProcessorConfiguration;
	import com.bojinx.api.processor.IProcessorConfigurationFactory;
	import com.bojinx.api.processor.display.IStageProcessor;
	import com.bojinx.api.util.IDisposable;
	import com.bojinx.included.BuiltInFeatureProcessor;
	import com.bojinx.included.meta.FactoryMetadata;
	import com.bojinx.reflection.registry.MetaDataRegistry;
	import com.bojinx.system.cache.definition.ObjectDefinition;
	import com.bojinx.system.cache.store.ProcessorRegistry;
	import com.bojinx.system.processor.queue.ProcessorQueue;
	import com.bojinx.system.processor.queue.ProcessorQueueBuilder;
	import com.bojinx.utils.logging.Logger;
	import com.bojinx.utils.logging.LoggingContext;
	
	import flash.utils.Dictionary;
	
	public class BeanLoadingDirector implements IDisposable
	{
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var beans:Array = [];
		
		private var builder:ProcessorQueueBuilder;
		
		private var cache:ProcessorRegistry;
		
		private var context:IApplicationContext;
		
		private var processors:Array = [];
		
		private var singletons:Array = [];
		
		public function BeanLoadingDirector( context:IApplicationContext )
		{
			this.context = context;
			this.builder = context.processorQueueBuilder;
			this.cache = context.cache.processors;
		}
		
		
		/*============================================================================*/
		/*= STATIC PROTECTED PROPERTIES                                               */
		/*============================================================================*/
		
		CONFIG::log
		protected static var log:Logger = LoggingContext.getLogger( BeanLoadingDirector );
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function addBean( bean:IBean ):void
		{
			beans.push( bean );
		}
		
		public function addProcessorFactory( factory:IProcessorConfiguration ):void
		{
			processors.push( factory );
		}
		
		public function dispose():void
		{
			beans = null;
			singletons = null;
			context = null;
		}
		
		public function load():void
		{
			// Add in built in processors this was placed in here to give
			// developers the option to include or exclude the built in processors
			addProcessorFactory( new BuiltInFeatureProcessor());
			
			// Register Factory meta
			MetaDataRegistry.getInstance().registerMetaData(FactoryMetadata);
			
			doRegisterBeans();
			doLoadProcessors();
			doLoadBeans();
		}
		
		protected function doRegisterBeans():void
		{
			if(CONFIG::log)
			{
				log.debug("- Registering Beans");
			}
			
			const ids:Dictionary = new Dictionary();
			
			// First we store all the beans
			// so whenever we try to process
			// info we can convert interface
			// based dependencies into concrete classes
			for each ( var bean:IBean in beans )
			{
				if(CONFIG::log)
				{
					log.debug("-- Registering Bean [ID]: " + bean.id);
				}
				
				if(ids[bean.id])
					throw new Error("Duplicate Bean with the same id found [ID]: " + bean.id);
				
				if(ids[bean.id])
					ids[bean.id] = true;
				
				bean.register(context);
			}
		}
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		protected function doLoadBean( bean:IBean, force:Boolean = false ):ObjectDefinition
		{
			var definition:ObjectDefinition;
			var singleton:Boolean = bean is ISingletonSupport ? ISingletonSupport(bean).singleton : false;
			var source:* = bean is IResolvableBean ? IResolvableBean(bean).source : "Unknown";
			var lazy:Boolean = bean is ILazySupport ? ILazySupport(bean).lazy : false;
			
			if ( singleton && !lazy || force )
			{
				if(source)
					definition = IResolvableBean(bean).getInstance();
				
				singletons.push(definition);
			}
			
			return definition;
		}
		
		protected function doLoadBeans():void
		{
			// Sort the beans
			beans = beans.sortOn( "priority" );
			
			var i:IBean;
			
			if(CONFIG::log)
			{
				log.debug("- Loading Non Lazy Singleton Beans");
			}
			
			// Next we need to load the beans
			// into definition objects that
			// better describe the beans
			for each ( i in beans )
				doLoadBean( i );
				
				
			// Next we initialize the beans
			// loading in singletons only.
			for each ( var o:ObjectDefinition in singletons )
			{
				if(CONFIG::log)
				{
					log.debug("------------------ PROCESSING BEAN " + o.type.name + " STARTING ------------------");
				}
				
				initializeDefinition( o );
				
				if(CONFIG::log)
				{
					log.debug("------------------ PROCESSING BEAN " + o.type.name + "  FINISHED ------------------");
				}
			}
			
			// Process the pending queue
			processPendingItems();
		}
		
		protected function doLoadProcessors():void
		{
			var i:IProcessorConfiguration;
			
			if(CONFIG::log)
			{
				log.debug("- Registering Processors");
			}
			
			for each ( i in processors )
			{
				if ( i is IProcessorConfigurationFactory )
					registerAsFactory( i as IProcessorConfigurationFactory );
				else if ( i is IStageProcessor )
					registerAsStageProcessor( i as IStageProcessor );
			}
			
			for each ( i in processors )
			{
				if ( i is IProcessorConfigurationFactory )
					postInitializeAsFactory( i as IProcessorConfigurationFactory );
			}
		}
		
		protected function initializeDefinition( definition:ObjectDefinition ):void
		{
			if(definition.isPendingProcessing || definition.isProcessing || definition.isReady)
				return;
			
				context.processDefinition(definition, true);
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function postInitializeAsFactory( value:IProcessorConfigurationFactory ):void
		{
			value.postInitialize( context );
		}
		
		private function processPendingEntry( item:ObjectDefinition ):void
		{
			if ( item.isProcessing || item.isReady )
				return;
			
			var queue:ProcessorQueue = builder.generateQueueFromDefinition( item );
			
			if ( queue )
				queue.run();
		}
		
		private function processPendingItems():void
		{
			var pending:Array = context.cache.pendingProcessing.getAll();
			
			while ( pending.length > 0 )
				processPendingEntry( pending.pop() as ObjectDefinition );
		}
		
		private function registerAsFactory( value:IProcessorConfigurationFactory ):void
		{
			if ( CONFIG::log )
			{
				log.debug( "-- Registering Processor Factory " + value.name );
			}
			
			value.initialize( context );
			cache.registerFactory( value );
		}
		
		private function registerAsStageProcessor( value:IStageProcessor ):void
		{
			context.displayProcessor = value;
		}
	}
}
