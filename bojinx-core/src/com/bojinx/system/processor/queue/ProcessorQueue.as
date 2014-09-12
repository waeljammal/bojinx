package com.bojinx.system.processor.queue
{
	import com.bojinx.api.constants.MetaKind;
	import com.bojinx.api.constants.ProcessorQueueMode;
	import com.bojinx.api.processor.IProcessor;
	import com.bojinx.api.processor.metadata.IMetaDefinition;
	import com.bojinx.api.util.IDisposable;
	import com.bojinx.system.cache.definition.MergedMetaDefinition;
	import com.bojinx.system.cache.definition.MetaDefinition;
	import com.bojinx.system.cache.definition.ObjectDefinition;
	import com.bojinx.system.processor.event.ProcessorEvent;
	import com.bojinx.system.processor.event.ProcessorQueueEvent;
	import com.bojinx.system.processor.event.ProcessorQueueFaultEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	[Event( name = "allComplete", type = "com.bojinx.system.processor.event.ProcessorQueueEvent" )]
	[Event( name = "complete", type = "com.bojinx.system.processor.event.ProcessorQueueEvent" )]
	[Event( name = "fault", type = "com.bojinx.system.processor.event.ProcessorQueueFaultEvent" )]
	public class ProcessorQueue extends EventDispatcher implements IDisposable
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _index:int = 0;
		
		public function get index():int
		{
			return _index;
		}
		
		private var _length:int = 0;
		
		public function get length():int
		{
			return _length;
		}
		
		private var _totalCompleted:int = 0;
		
		public function get totalCompleted():int
		{
			return _totalCompleted;
		}
		
		/*============================================================================*/
		/*= INTERNAL PROPERTIES                                                       */
		/*============================================================================*/
		
		internal var parent:ProcessorQueue;
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var mode:String;
		
		private var queue:Array;
		
		private var finalQueue:Array;
		
		private var queueErrored:Boolean;
		
		private var owner:ObjectDefinition;
		
		public function ProcessorQueue( mode:String = "sequential", target:IEventDispatcher = null )
		{
			super( target );
			this.mode = mode;
		}
		
		internal function setOwner(owner:ObjectDefinition):void
		{
			this.owner = owner;
		}
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function append( meta:MetaDefinition, processor:IProcessor, destroy:Boolean, isFinal:Boolean = false ):void
		{
			if ( !queue )
				queue = [];
			
			if(!isFinal)
			{
				queue.push({ meta: meta, processor: processor, destroy: destroy, index: meta.meta.stage });
			}
			else if(isFinal)
			{
				if(!finalQueue)
					finalQueue = [];
				
				finalQueue.push({ meta: meta, processor: processor, destroy: destroy, index: meta.meta.stage });
			}
			
			_length++;
		}
		
		public function appendMerged( meta:MergedMetaDefinition, processor:IProcessor, destroy:Boolean, index:int ):void
		{
			if ( !queue )
				queue = [];

			queue.push({ meta: meta, processor: processor, destroy: destroy, index: index });
			
			_length++;
		}
		
		public function appendQueue( queue:ProcessorQueue ):void
		{
			if ( !this.queue )
				this.queue = [];
			
			queue.parent = parent ? parent : this;
			this.queue.push( queue );
			
			_length += queue.length;
		}
		
		public function dispose():void
		{
			var queue:ProcessorQueue;
			
			for each ( var i:Object in queue )
			{
				if ( i is ProcessorQueue )
				{
					queue = i as ProcessorQueue;
					queue.dispose();
					removeSubQueueListeners( queue );
				}
			}
		}
		
		public function run():void
		{
			if ( queue && queue.length > 0 )
				next();
			if(finalQueue && finalQueue.length > 0)
				next();
			else
				complete();
		}
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		protected function onNestedQueueComplete( event:ProcessorQueueEvent ):void
		{
			removeSubQueueListeners( event.currentTarget as ProcessorQueue );
			next();
		}
		
		protected function onNestedQueueError( event:ProcessorQueueFaultEvent ):void
		{
			removeSubQueueListeners( event.currentTarget as ProcessorQueue );
		}
		
		protected function onNestedQueueProcessorComplete( event:Event ):void
		{
			_totalCompleted++;
		}
		
		protected function onProcessorComplete( event:ProcessorEvent ):void 
		{
			event.currentTarget.removeEventListener( ProcessorEvent.COMPLETE, onProcessorComplete );
			_totalCompleted++;
			
			if(event.meta is MergedMetaDefinition)
				flagMultipleAsProcessing(event.meta as MergedMetaDefinition, false);
			else
				flagSingleAsProcessing(event.meta as MetaDefinition, false);
			
			dispatchEvent( new ProcessorQueueEvent( ProcessorQueueEvent.COMPLETE, owner, event.meta as MetaDefinition, false, true ));
			
			if ( mode == ProcessorQueueMode.SEQUENTIAL )
				next();
			else if (( !queue || queue.length == 0 ) && !queueErrored && totalCompleted == length )
				complete();
		}
		
		protected function onProcessorError( event:ProcessorEvent ):void
		{
			queue = null;
			queueErrored = true;
			
			var e:ProcessorQueueFaultEvent = new ProcessorQueueFaultEvent( ProcessorQueueFaultEvent.FAULT, event.message, false, true );
			dispatchEvent( e );
			
			if ( !e.isDefaultPrevented())
				throw new Error( "Processor Queue halted with error " + event.message );
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function addSubQueueListeners( subQueue:ProcessorQueue ):void
		{
			subQueue.addEventListener( ProcessorQueueEvent.ALL_COMPLETE, onNestedQueueComplete );
			subQueue.addEventListener( ProcessorQueueEvent.COMPLETE, onNestedQueueProcessorComplete );
			subQueue.addEventListener( ProcessorQueueFaultEvent.FAULT, onNestedQueueError );
		}
		
		private function complete():void
		{
			dispatchEvent( new ProcessorQueueEvent( ProcessorQueueEvent.COMPLETE, owner ));
			dispatchEvent( new ProcessorQueueEvent( ProcessorQueueEvent.ALL_COMPLETE, owner ));
		}
		
		private function next():void
		{
			if ( queue && queue.length == 0 && finalQueue && finalQueue.length > 0)
			{
				queue = finalQueue;
			}
			
			if ( !queue || queue.length == 0 )
			{
				if ( !queueErrored )
					complete();
				
				return;
			}
			
			if ( mode == ProcessorQueueMode.CONCURRENT )
			{
				for ( var i:int = 0; i < queue.length; i++ )
					processEntry( queue[ i ] );
				
				queue = [];
			}
			else
				processEntry( queue.shift() );
		}
		
		private function processEntry( entry:Object ):void
		{
			if ( entry is ProcessorQueue )
			{
				var subQueue:ProcessorQueue = entry as ProcessorQueue;
				addSubQueueListeners(subQueue);
				subQueue.run();
			}
			else
			{
				var processor:IProcessor = entry.processor;
				var meta:IMetaDefinition = entry.meta;
				
				processor.addEventListener( ProcessorEvent.COMPLETE, onProcessorComplete );
				processor.addEventListener( ProcessorEvent.ERROR, onProcessorError );
				
				if ( entry.destroy && meta.metaKind == MetaKind.SINGLE )
				{
					flagSingleAsProcessing(entry.meta, true);
					processor.release( meta as MetaDefinition );
				}
				else if ( entry.destroy && meta.metaKind == MetaKind.MERGED )
				{
					flagMultipleAsProcessing(entry.meta, true);
					processor.releaseMerged( meta as MergedMetaDefinition );
				}
				else if ( meta.metaKind == MetaKind.SINGLE )
				{	
					flagSingleAsProcessing(entry.meta, true);
					processor.process( meta as MetaDefinition );
				}
				else if ( meta.metaKind == MetaKind.MERGED )
				{
					flagMultipleAsProcessing(entry.meta, true);
					processor.processMerged( meta as MergedMetaDefinition );
				}
			}
		}
		
		private function flagMultipleAsProcessing(entry:MergedMetaDefinition, value:Boolean):void
		{
			for each(var i:MetaDefinition in entry.data)
				flagSingleAsProcessing(i, value);
		}
		
		private function flagSingleAsProcessing(entry:MetaDefinition, value:Boolean):void
		{
			entry.owner.isPendingProcessing = false;
			entry.owner.isProcessing = true;
			
			if(value)
				entry.owner.isReady = true;
		}
		
		private function removeSubQueueListeners( subQueue:ProcessorQueue ):void
		{
			subQueue.removeEventListener( ProcessorQueueEvent.ALL_COMPLETE, onNestedQueueComplete );
			subQueue.removeEventListener( ProcessorQueueEvent.COMPLETE, onNestedQueueProcessorComplete );
			subQueue.removeEventListener( ProcessorQueueFaultEvent.FAULT, onNestedQueueError );
		}
		
		public function reset():void
		{
			_index = 0;
			_length = 0;
			_totalCompleted = 0;
			this.parent = null;
			this.queue = null;
			this.queueErrored = false;
		}
	}
}
