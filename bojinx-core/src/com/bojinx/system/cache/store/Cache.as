package com.bojinx.system.cache.store
{
	import com.bojinx.api.context.IApplicationContext;
	
	import flash.utils.Dictionary;
	
	public final class Cache
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _beans:BeanRegistry;
		
		public function get beans():BeanRegistry
		{
			if(!_beans)
				_beans = new BeanRegistry(context);
			
			return _beans;
		}
		
		private var _definitions:DefinitionRegistry;
		
		public function get definitions():DefinitionRegistry
		{
			if ( !_definitions )
				_definitions = new DefinitionRegistry( context );
			
			return _definitions;
		}
		
		private var _messages:MessageRegistry;
		
		public function get messages():MessageRegistry
		{
			if ( !_messages )
				_messages = new MessageRegistry( context );
			
			return _messages;
		}
		
		private var _pendingProcessing:PendingProcessingRegistry = new PendingProcessingRegistry();
		
		public function get pendingProcessing():PendingProcessingRegistry
		{
			return _pendingProcessing;
		}
		
		private var _processors:ProcessorRegistry;
		
		public function get processors():ProcessorRegistry
		{
			if ( !_processors )
				_processors = new ProcessorRegistry( context );
			
			return _processors;
		}
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var context:IApplicationContext;
		
		private var externalCaches:Dictionary;
		
		public function Cache( context:IApplicationContext )
		{
			this.context = context;
		}
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function dispose():void
		{
			if ( _definitions )
				_definitions.dispose();
			
			if ( _pendingProcessing )
				_pendingProcessing.dispose();
			
			if ( _processors )
				_processors.dispose();
			
			_definitions = null;
			_pendingProcessing = null;
			_processors = null;
			context = null;
		}
		
		public function getCache( id:String ):*
		{
			return externalCaches ? externalCaches[ id ] : null;
		}
		
		public function register( cache:*, id:String ):void
		{
			if ( !externalCaches )
				externalCaches = new Dictionary();
			
			externalCaches[ id ] = cache;
		}
		
		public final function setInheritedMessageRegistry( registry:MessageRegistry ):void
		{
			_messages = registry;
		}
		
		public function unregister( id:String ):void
		{
			delete( externalCaches[ id ]);
		}
	}
}


