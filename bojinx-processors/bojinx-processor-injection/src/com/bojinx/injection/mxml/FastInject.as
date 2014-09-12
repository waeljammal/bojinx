package com.bojinx.injection.mxml
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.api.util.IDisposable;
	import com.bojinx.system.cache.definition.ObjectDefinition;
	import com.bojinx.system.cache.store.ContextRegistry;
	import com.bojinx.system.context.event.ContextEvent;
	import com.bojinx.system.processor.event.ProcessorQueueEvent;
	import com.bojinx.system.processor.event.ProcessorQueueFaultEvent;
	import com.bojinx.system.processor.queue.ProcessorQueue;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.core.IMXMLObject;
	
	/**
	 * Allows injecting managed objects into display objects that
	 * are not flagged for auto wiring.
	 * <br />
	 * This is useful for things like auto wiring item renderers.
	 * 
	 * @Manifest
	 */
	public class FastInject implements IMXMLObject, IDisposable
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		/**
		 * The id of the managed object or it's type
		 */
		public var source:*;
		
		/**
		 * The name of the method to inject.
		 * <br />
		 * Note: Fast inject only supports a single
		 * parameter on the target method.
		 */
		public var targetMethod:String;
		
		/**
		 * The name of the property to inject
		 */
		public var targetProperty:String;
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var context:IApplicationContext;
		
		private var definition:ObjectDefinition;
		
		private var document:Object;
		
		public function FastInject()
		{
		}
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function dispose():void
		{
			if(document)
				IEventDispatcher( document ).removeEventListener( "removedToStage", onRemovedToStage );
			
			context = null;
			definition = null;
			document = null;
			source = null;
			targetMethod = null;
			targetProperty = null;
		}
		
		public function initialized( document:Object, id:String ):void
		{
			this.document = document;
			
			var hasParentProperty:Boolean = document.hasOwnProperty("parent");
			
			if ( hasParentProperty && !document.parent && document is IEventDispatcher )
				IEventDispatcher( document ).addEventListener( "addedToStage", onAddedToStage );
			else if ( hasParentProperty && document.parent )
			{
				context = ContextRegistry.getContextForChild( document );
				process();
			}
			else
				throw new Error( "FastInject can only be used on Display Objects [Source]: " + document );
		}
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		protected function doInject():void
		{
			if(!definition || definition && !definition.target)
				throw new Error("FastInject could not locate managed object " + source + " [Source]: " + document);
			
			if ( targetProperty && document.hasOwnProperty( targetProperty ))
				document[ targetProperty ] = definition.target;
			else if ( targetProperty && !document.hasOwnProperty( targetProperty ))
				throw new Error( "FastInject failed " + targetProperty + " does not exist in " + document );
			else if ( targetMethod && document.hasOwnProperty( targetMethod ))
				document.targetMethod( definition.target );
			else if ( targetMethod && !document.hasOwnProperty( targetMethod ))
				throw new Error( "FastInject failed " + targetMethod + " does not exist in " + document );
			else
				throw new Error("FastInject failed with unknown reason, please submit a bug report [Source]: " + document);
			
			dispose();
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function onAddedToStage( event:Event ):void
		{
			event.currentTarget.removeEventListener( "addedToStage", onAddedToStage );
			context = ContextRegistry.getContextForChild( event.currentTarget );
			
			if ( context.isLoaded )
				process();
			else
				context.addEventListener( ContextEvent.CONTEXT_LOADED, onContextLoaded );
		}
		
		private function onAllComplete( event:ProcessorQueueEvent ):void
		{
			removeListeners( event.currentTarget as ProcessorQueue );
			doInject();
		}
		
		private function onContextLoaded( event:ContextEvent ):void
		{
			event.currentTarget.removeEventListener( ContextEvent.CONTEXT_LOADED, onContextLoaded );
			process();
		}
		
		private function onFault( event:ProcessorQueueFaultEvent ):void
		{
			removeListeners( event.currentTarget as ProcessorQueue );
			dispose();
			throw new Error( "Fast Inject failed [Error]: " + event.message + " [Source]: " + document );
		}
		
		private function onRemovedToStage( event:Event ):void
		{
			dispose();
		}
		
		private function process():void
		{
			IEventDispatcher( document ).addEventListener( "removedToStage", onRemovedToStage );
			
			var queue:ProcessorQueue;
			
			if ( source is Class )
				definition = context.getDefinitionByType( source );
			else if(source is String)
				definition = context.getDefinitionById(source);
			
			if ( !definition.isReady )
			{
				queue = context.processDefinition( definition, false, false );
				
				if ( queue )
					addListeners(queue);
			}
			else
				doInject();
		}
		
		private function addListeners(queue:ProcessorQueue):void
		{
			queue.addEventListener( ProcessorQueueEvent.ALL_COMPLETE, onAllComplete );
			queue.addEventListener( ProcessorQueueFaultEvent.FAULT, onFault );
		}
		
		private function removeListeners( queue:ProcessorQueue ):void
		{
			queue.removeEventListener( ProcessorQueueEvent.ALL_COMPLETE, onAllComplete );
			queue.removeEventListener( ProcessorQueueFaultEvent.FAULT, onFault );
		}
	}
}
