package com.bojinx.system.context
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.api.context.config.IBean;
	import com.bojinx.api.context.config.IConfigItem;
	import com.bojinx.api.context.config.IResolvableBean;
	import com.bojinx.api.processor.display.IStageProcessor;
	import com.bojinx.reflection.ClassInfoFactory;
	import com.bojinx.system.build.definition.ObjectDefinitionFactory;
	import com.bojinx.system.build.definition.ObjectDefinitionProcessorDecorator;
	import com.bojinx.system.cache.definition.ObjectDefinition;
	import com.bojinx.system.cache.store.Cache;
	import com.bojinx.system.cache.store.ContextRegistry;
	import com.bojinx.system.context.director.ContextLoadingDirector;
	import com.bojinx.system.context.event.ContextEvent;
	import com.bojinx.system.context.loaders.extensions.ExtentionLoader;
	import com.bojinx.system.context.loaders.settings.ViewSettings;
	import com.bojinx.system.display.DisplayObjectRouter;
	import com.bojinx.system.display.DisplayProcessingRegistry;
	import com.bojinx.system.message.MessageBus;
	import com.bojinx.system.processor.event.ProcessorQueueEvent;
	import com.bojinx.system.processor.queue.ProcessorQueue;
	import com.bojinx.system.processor.queue.ProcessorQueueBuilder;
	import com.bojinx.utils.GUID;
	import com.bojinx.utils.application.AppUtil;
	import com.bojinx.utils.logging.Logger;
	import com.bojinx.utils.logging.LoggingContext;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.getTimer;
	
	/**
	 * Dispatched after the configuration has been parsed
	 */
	[Event( name = "configurationLoaded", type = "com.bojinx.system.context.event.ContextEvent" )]
	/**
	 * Dispatched when the context is fully loaded
	 */
	[Event( name = "contextLoaded", type = "com.bojinx.system.context.event.ContextEvent" )]
	/**
	 * Dispatched when the configuration has started loading
	 */
	[Event( name = "contextLoading", type = "com.bojinx.system.context.event.ContextEvent" )]
	/**
	 * Dispatched when the context has been unloaded
	 */
	[Event( name = "contextUnloaded", type = "com.bojinx.system.context.event.ContextEvent" )]
	/**
	 * Dispatched when an object has been processed
	 */
	[Event( name = "objectProcessed", type = "com.bojinx.system.context.event.ContextEvent" )]
	/**
	 * Dispatched when an object has been released
	 */
	[Event( name = "objectReleased", type = "com.bojinx.system.context.event.ContextEvent" )]
	
	public class ApplicationContext extends EventDispatcher implements IApplicationContext
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _applicationDomain:ApplicationDomain;
		
		public function get applicationDomain():ApplicationDomain
		{
			return _applicationDomain;
		}
		
		private var _cache:Cache;
		
		public function get cache():Cache
		{
			return _cache;
		}
		
		protected var _configFiles:Array;
		
		/**
		 * Provides a list of Context Configuration objects
		 */
		public function get configFiles():Array
		{
			return _configFiles;
		}
		
		[ArrayElementType( "com.bojinx.api.context.config.IConfigItem" )]
		/**
		 * Configuration files, use <code>addConfig()</code> to register new configuration
		 * entries.
		 *
		 * @com.bojinx.api.context.config.IConfigObject
		 */
		public function set configFiles( value:Array ):void
		{
			_configFiles = value;
		}
		
		private var _definitionFactory:ObjectDefinitionFactory;
		
		public function get definitionFactory():ObjectDefinitionFactory
		{
			return _definitionFactory;
		}
		
		private var _displayProcessor:IStageProcessor;
		
		/**
		 * Each context can have a single display processor registered.
		 *
		 * This is optional.
		 */
		public function get displayProcessor():IStageProcessor
		{
			if(!_displayProcessor)
			{
				var p:IApplicationContext = parent;
				
				while(p)
				{
					if(p.displayProcessor)
					{
						_displayProcessor = p.displayProcessor;
						break;
					}
					
					p = p.parent;
				}
			}
			
			return _displayProcessor;
		}
		
		/**
		 * @private
		 */
		public function set displayProcessor( value:IStageProcessor ):void
		{
			_displayProcessor = value;
		}
		
		private var _displayRouter:DisplayObjectRouter;
		
		public function get displayRouter():DisplayObjectRouter
		{
			return _displayRouter;
		}
		
		protected var _id:String;
		
		public function get id():String
		{
			return _id;
		}
		
		private var _initializationTime:int = 0;
		
		public function get initializationTime():int
		{
			return _initializationTime;
		}
		
		protected var _isInitialized:Boolean = false;
		
		public function get isInitialized():Boolean
		{
			return _isInitialized;
		}
		
		private var _isLoaded:Boolean;
		
		public function get isLoaded():Boolean
		{
			return _isLoaded;
		}
		
		private var _isLoading:Boolean = false;
		
		public function get isLoading():Boolean
		{
			return _isLoading;
		}
		
		private var _isReadyForLoad:Boolean;
		
		public function get isReadyForLoad():Boolean
		{
			return _isReadyForLoad;
		}
		
		private var _isUnloading:Boolean;
		
		public function get isUnloading():Boolean
		{
			return _isUnloading;
		}
		
		private var _messageBus:MessageBus;
		
		public function get messageBus():MessageBus
		{
			return _messageBus;
		}
		
		public function set messageBus( value:MessageBus ):void
		{
			_messageBus = value;
		}
		
		protected var _owner:Object;
		
		public function get owner():Object
		{
			return _owner;
		}
		
		private var _parent:IApplicationContext;
		
		public function get parent():IApplicationContext
		{
			return _parent;
		}
		
		private var _processorQueueBuilder:ProcessorQueueBuilder;
		
		public function get processorQueueBuilder():ProcessorQueueBuilder
		{
			return _processorQueueBuilder;
		}
		
		private var _typeFactory:ClassInfoFactory;
		
		public function get typeFactory():ClassInfoFactory
		{
			return _typeFactory;
		}
		
		private var _viewSettings:ViewSettings;
		
		public function get viewSettings():ViewSettings
		{
			return _viewSettings;
		}
		
		public function set viewSettings( value:ViewSettings ):void
		{
			_viewSettings = value;
		}
		
		public function ApplicationContext( owner:Object, id:String, configuration:Array = null )
		{
			super();
			
			if ( owner )
				initialize( id, owner, configuration );
		}

		/*============================================================================*/
		/*= STATIC PROTECTED PROPERTIES                                               */
		/*============================================================================*/
		
		CONFIG::log
		protected static var log:Logger = LoggingContext.getLogger( ApplicationContext );
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function useDomain(domain:ApplicationDomain):void
		{
			_applicationDomain = domain;
		}
		
		public function addConfig( config:IConfigItem ):void
		{
			if ( !_configFiles )
				_configFiles = [];
			
			_configFiles.push( config );
		}
		
		public function getDefinitionById( id:String ):ObjectDefinition
		{
			var bean:IBean = cache.beans.getBeanById(id);
			
			if(!bean)
				throw new Error("No Bean is registered for ID " + id);
			else if(!(bean is IResolvableBean))
				throw new Error("Bean is not resolvable " + bean.id);
			
			return IResolvableBean(bean).getInstance();
		}
		
		public function getDefinitionByType( clazz:Class ):ObjectDefinition
		{
			var bean:IBean = cache.beans.getBeanByType(clazz);
			
			if(!bean)
				throw new Error("No Bean is registered for type " + clazz);
			else if(!(bean is IResolvableBean))
				throw new Error("Bean is not resolvable " + bean.id);
			
			return IResolvableBean(bean).getInstance();
		}
		
		public function load():void
		{
			_isReadyForLoad = true;
			
			if(!viewSettings)
				viewSettings = new ViewSettings();
			
			// Set Parent Context
			_parent = ContextRegistry.getParentForContext( this );
			
			if ( _parent && !_parent.isLoaded )
			{
				CONFIG::log
				{
					log.debug( "Context " + id + " is waiting for " + _parent.id + " to be ready" );
				}
				
				DisplayProcessingRegistry.notify( parent, load );
				
				return;
			}
			
			_isLoading = true;
			
			_applicationDomain = AppUtil.getApplicationDomain( owner );
			
			_initializationTime = getTimer();
			
			if ( _parent )
			{
				_messageBus.setParent( _parent.messageBus );
				_parent.messageBus.addChild( _messageBus );
				_cache.setInheritedMessageRegistry( _parent.cache.messages );
			}
			
			CONFIG::log
			{
				if ( _parent )
					log.debug( "Context " + id + " parent has been set to " + _parent.id );
			}
			
			dispatch( ContextEvent.CONTEXT_LOADING );
			
			// Load other configurations
			loadConfiguration();
		}
		
		public function processDefinition( definition:ObjectDefinition, autoRun:Boolean = true,
										   destroy:Boolean = false, queue:ProcessorQueue = null,
										   data:* = null ):ProcessorQueue
		{
			if(!definition.isReady && !definition.isProcessing && !definition.isDecorated)
			{
				var decorator:ObjectDefinitionProcessorDecorator  = new ObjectDefinitionProcessorDecorator(this);
				decorator.decorate(definition);
			}
			
			definition.markedForDestruction = destroy;
			
			var queue:ProcessorQueue = processorQueueBuilder.generateQueueFromDefinition( definition, queue, destroy, data );
			
			if(queue)
			{
				queue.addEventListener( ProcessorQueueEvent.COMPLETE, onProcessQueueComplete, false, int.MAX_VALUE );
				
				if ( autoRun )
				{
					definition.isProcessing = true;
					queue.run();
				}
			}
			else if(destroy && !queue)
				cache.definitions.removeDefinition(definition)
			
			return queue;
		}
		
		public function processObject( object:Object, singleton:Boolean = false, autoRun:Boolean = true, queue:ProcessorQueue = null ):ProcessorQueue
		{
			var definition:ObjectDefinition = definitionFactory.definitionFromInstance( object, singleton );
			
			return processDefinition(definition, autoRun, false, queue);
		}
		
		public function releaseObject( object:Object, autoRun:Boolean = true ):ProcessorQueue
		{
			var definition:ObjectDefinition = cache.definitions.getDefinitionByInstance( object );
			
			if(definition)
			{
				CONFIG::log
				{
					log.debug( "------------------------------ RELEASING " + object + " STARTED -----------------------------" );
				}
				
				var queue:ProcessorQueue = processDefinition( definition, false, true );
				
				if ( autoRun && queue )
					queue.run();
				else
					queue.addEventListener(ProcessorQueueEvent.ALL_COMPLETE, onObjectReleased);
				
				cache.definitions.removeDefinitionForInstance( object );
				
				CONFIG::log
				{
					if(autoRun)
						log.debug( "------------------------------ RELEASING " + object + " COMPLETED ---------------------------" );
				}
				
				return queue;
			}
			
			return null;
		}

		private function onObjectReleased(event:ProcessorQueueEvent):void
		{
			event.currentTarget.removeEventListener(ProcessorQueueEvent.ALL_COMPLETE, onObjectReleased);
			
			CONFIG::log
			{
				log.debug( "------------------------------ RELEASING " + event.owner.target + " COMPLETED ---------------------------" );
			}
		}
		
		public function unload():void
		{
			CONFIG::log
			{
				log.debug( "Unloading Context " + id );
			}
			
			_isUnloading = true;
			
			_displayProcessor.removeChild( this );
			cache.dispose();
			_messageBus.dispose();
			_displayRouter.dispose();
			
			ContextRegistry.release( this );
			DisplayProcessingRegistry.releaseContext( this );
			
			_cache = null;
			_typeFactory = null;
			_owner = null;
			_displayRouter = null;
			_definitionFactory = null;
			_messageBus = null;
			_configFiles = null;
			_displayProcessor = null;
			_applicationDomain = null;
			_parent = null;
		}
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		protected function dispatch( type:String ):void
		{
			dispatchEvent( new ContextEvent( type ));
		}
		
		protected function initialize( id:String, owner:Object, configuration:Array = null ):void
		{
			if ( !isInitialized )
			{
				_isInitialized = true;
				
				if ( !id )
					_id = GUID.create();
				else
					_id = id;
				
				if ( !_configFiles )
					_configFiles = configuration;
				else if ( configuration )
					_configFiles = _configFiles.concat( configuration );
				
				// Load known extensions
				loadExtensions();
				
				CONFIG::log
				{
					log.info( "Initializing [Context] " + id );
				}
				
				_owner = owner;
				
				// Register with cache
				ContextRegistry.register( this );
				
				_processorQueueBuilder = new ProcessorQueueBuilder( this );
				_cache = new Cache( this );
				_typeFactory = new ClassInfoFactory();
				_displayRouter = new DisplayObjectRouter( this );
				_definitionFactory = new ObjectDefinitionFactory( this );
				
				if ( !_messageBus )
					_messageBus = new MessageBus( this );
				
				// Register with the display management handler
				DisplayProcessingRegistry.register( this );
			}
		}
		
		public function attachDisplayProcessor(parent:IApplicationContext):void
		{
			if(displayProcessor && parent)
			{
				_parent = parent;
				
				if(parent.displayProcessor)
					parent.displayProcessor.addChild( this );
			}
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function loadConfiguration():void
		{
			CONFIG::log
			{
				log.info( "Loading Configuration [Context] " + id );
			}
			
			// Early load of managed objects, processor factories and definitions
			// the processors are not initialized until load is called
			var director:ContextLoadingDirector = new ContextLoadingDirector( this );
			director.addEventListener( Event.COMPLETE, onConfigurationLoadingComplete );
			
			while ( configFiles && configFiles.length > 0 )
				director.append( configFiles.shift());
			
			director.process();
		}
		
		private function loadExtensions():void
		{
			var extLoader:ExtentionLoader = new ExtentionLoader( this );
			extLoader.load();
			extLoader.dispose();
			extLoader = null;
		}
		
		private function onConfigurationLoadingComplete( event:Event ):void
		{
			event.currentTarget.removeEventListener( Event.COMPLETE, onConfigurationLoadingComplete );
			_initializationTime = getTimer() - _initializationTime;
			
			_isLoading = false;
			_isLoaded = true;
			
			CONFIG::log
			{
				log.info( "Finished loading [Context] " + id + " [Time] " + _initializationTime + " ms" );
			}
			
			dispatch( ContextEvent.CONFIGURATION_LOADED );
			dispatch( ContextEvent.CONTEXT_LOADED );
			
//			if(displayProcessor)
//			{
//				displayProcessor.addChild( this );
//				displayProcessor.initialize( this );
//				ContextRegistry.rootContext.displayProcessor.processStartingAt( owner );
//			}
		}
		
		private function onParentContextLoaded( event:ContextEvent ):void
		{
			event.currentTarget.removeEventListener( ContextEvent.CONTEXT_LOADED, onParentContextLoaded );
			load();
		}
		
		private function onProcessQueueAllComplete(event:ProcessorQueueEvent):void
		{
			
			event.currentTarget.removeEventListener( ProcessorQueueEvent.COMPLETE, onProcessQueueComplete );
			event.currentTarget.removeEventListener( ProcessorQueueEvent.ALL_COMPLETE, onProcessQueueAllComplete );
			
			CONFIG::log
			{
				log.debug( "------------------------------ PROCESSING " + event.owner.target + " COMPLETED ---------------------------" );
			}
		}
		
		private function onProcessQueueComplete( event:ProcessorQueueEvent ):void
		{
			if ( event.meta )
			{
				for each ( var i:ObjectDefinition in event.meta.dependencies )
				{	
					i.isReady = true; 
					i.isProcessing = false;
				}
				
				event.meta.owner.isReady = true;
				event.meta.owner.isProcessing = false;
			}
			
			if(event.owner)
			{
				event.owner.isProcessing = false; 
				event.owner.isReady = true;
			}
		}
	}
}
