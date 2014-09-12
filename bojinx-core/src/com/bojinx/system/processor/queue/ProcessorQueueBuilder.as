package com.bojinx.system.processor.queue
{
	import com.bojinx.api.constants.ProcessorLifeCycleStage;
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.api.context.config.support.IAutoDetectBeans;
	import com.bojinx.api.context.config.support.IBeanReferenceSupport;
	import com.bojinx.api.context.config.support.IMultiBeanReferenceSupport;
	import com.bojinx.api.processor.IProcessor;
	import com.bojinx.api.processor.IProcessorConfigurationFactory;
	import com.bojinx.reflection.Method;
	import com.bojinx.reflection.Parameter;
	import com.bojinx.reflection.Property;
	import com.bojinx.system.build.definition.ObjectDefinitionProcessorDecorator;
	import com.bojinx.system.cache.definition.MemberProcessors;
	import com.bojinx.system.cache.definition.MergedMetaDefinition;
	import com.bojinx.system.cache.definition.MetaDefinition;
	import com.bojinx.system.cache.definition.ObjectDefinition;
	import com.bojinx.system.processor.event.ProcessorQueueEvent;
	import com.bojinx.utils.ObjectPool;
	import com.bojinx.utils.logging.Logger;
	import com.bojinx.utils.logging.LoggingContext;
	
	import flash.utils.Dictionary;
	
	public class ProcessorQueueBuilder
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _processorPool:ObjectPool;
		
		public function get processorPool():ObjectPool
		{
			if ( !_processorPool )
				_processorPool = new ObjectPool( createQueue, cleanQueue );
			
			return _processorPool;
		}
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var context:IApplicationContext;
		
		public function ProcessorQueueBuilder( context:IApplicationContext )
		{
			this.context = context;
		}
		
		/*============================================================================*/
		/*= STATIC PROTECTED PROPERTIES                                               */
		/*============================================================================*/
		
		CONFIG::log
		protected static var log:Logger = LoggingContext.getLogger( ProcessorQueueBuilder );
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function generateQueueFromDefinition( definition:ObjectDefinition, queue:ProcessorQueue = null,
													 destroy:Boolean = false, data:* = null ):ProcessorQueue
		{
			if ( definition.isProcessing )
				return queue;
			
			var queue:ProcessorQueue = queue ? queue : processorPool.checkOut();
			var dependencies:Array = definition.dependencies ? definition.dependencies : [];
			var dependency:ObjectDefinition;
			
			if(CONFIG::log)
			{
				log.debug("Generating Processor Queue for Definition " + definition.type.simpleName);
			}
			
			queue.setOwner(definition);
			
			var pq:Array = [];
			
			 processDefinition( queue, definition, destroy, data, "-", pq );
			 
			 pq = pq.sortOn(["i", "pr"], Array.NUMERIC);
			 
			 for each(var i:Object in pq)
			 {
				 if(i.mode == "single")
					 queue.append( i.m, i.p, i.d, i.f);
				 else
					 queue.appendMerged( i.m, i.p, i.d, i.i );
			 }
			
			return queue;
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private final function cleanQueue( queue:ProcessorQueue ):void
		{
			queue.reset();
		}
		
		private final function createQueue():ProcessorQueue
		{
			var queue:ProcessorQueue = new ProcessorQueue();
			queue.addEventListener( ProcessorQueueEvent.ALL_COMPLETE, onProcessorQueueComplete );
			
			return queue;
		}
		
		private function getDependencies( member:MemberProcessors, definition:ObjectDefinition, queue:ProcessorQueue ):Array
		{
			var dependencies:Array = [];
			var dependency:ObjectDefinition;
			var ids:Array;
			
			if(member.meta is IMultiBeanReferenceSupport)
				ids = IMultiBeanReferenceSupport( member.meta ).getIds();
			
			if ( member.member is Property && member.meta is IAutoDetectBeans )
			{
				var property:Property = member.member as Property;
				
				if ( member.meta is IBeanReferenceSupport && IBeanReferenceSupport( member.meta ).id )
					dependency = context.getDefinitionById( IBeanReferenceSupport( member.meta ).id );
				
				if ( !dependency && member.meta is IAutoDetectBeans && !IBeanReferenceSupport( member.meta ).id )
					dependency = context.getDefinitionByType( property.returnType.getClass() );
				
				if(dependency)
					dependencies.push( dependency );
				else if(IBeanReferenceSupport( member.meta ).id)
					throw new Error("Unable to locate dependency with id " + IBeanReferenceSupport( member.meta ).id);
				else if(!IBeanReferenceSupport( member.meta ).id)
					throw new Error("Unable to locate dependency with type " + property.returnType.getClass());
			}
			else if( member.member is Method && member.meta is IMultiBeanReferenceSupport && ids)
			{
					for each(var refId:String in ids)
						dependencies.push(context.getDefinitionById( refId ))
			}
			else if ( member.member is Method && member.meta is IAutoDetectBeans )
			{
				var method:Method = member.member as Method;
				var params:Array = method.parameters;
				var i:int;
				var len:int = params ? params.length : 0;
				var param:Parameter;
				
				dependencies = [];
				
				for ( i = 0; i < len; i++ )
				{
					param = params[ i ];
					
					if ( member.meta is IBeanReferenceSupport && IBeanReferenceSupport( member.meta ).id )
						dependency = context.getDefinitionById( IBeanReferenceSupport( member.meta ).id );
					
					if ( !dependency && member.meta is IAutoDetectBeans )
						dependency = context.getDefinitionByType( param.paramterType.getClass() );
					
					if ( dependency && !dependency.isProcessing && !dependency.isReady )
						context.processDefinition(dependency);
					
					dependencies.push( dependency );
					dependency = null;
				}
			}
			
			return dependencies;
		}
		
		private function onProcessorQueueComplete( event:ProcessorQueueEvent ):void
		{
			var queue:ProcessorQueue = event.currentTarget as ProcessorQueue;
			queue.removeEventListener( ProcessorQueueEvent.ALL_COMPLETE, onProcessorQueueComplete );
			processorPool.checkIn( queue );
		}
		
		private function processDefinition( queue:ProcessorQueue, definition:ObjectDefinition,
											destroy:Boolean = false, data:* = null, depth:String = "-", appendTo:Array = null ):void
		{
			var members:Array = definition.members;
			var i:int, j:int;
			var processors:Array, dependencies:Array;
			var factory:IProcessorConfigurationFactory;
			var processor:IProcessor;
			var member:MemberProcessors;
			var meta:MetaDefinition;
			var mergedMetas:Dictionary;
			var stageIsDestroy:Boolean;
			var queueData:Array = [];
			var processQueue:Array = appendTo ? appendTo : [];
			
			definition.isPendingProcessing = true;
			
			if ( members )
			{
				members = members.sortOn(["stage", "priority"], Array.NUMERIC);
				
				for ( i = 0; i < members.length; i++ )
				{
					member = members[ i ];
					
					if ( !member.processors )
						continue;
					
					for ( j = 0; j < member.processors.length; j++ )
					{
						factory = member.processors[ j ];
						
						if ( !definition.isProcessing )
						{
							stageIsDestroy = member.meta.stage == ProcessorLifeCycleStage.DESTROY ||
								member.meta.stage == ProcessorLifeCycleStage.AFTER_DESTROY;
							
//							if(stageIsDestroy != destroy)
//								continue;
							
							// Get the dependencies for whatever the annotation is targeting
							if ( !destroy )
								dependencies = getDependencies( member, definition, queue );
							
							CONFIG::log
							{
								log.debug( depth + " Merging Operation into queue" +
									" [Context] " + context.id +
									" [Meta] " + member.meta +
									" [Target] " + definition.type.name +
									" [Member]: " + member.name );
							}
							
							if(dependencies && dependencies.length > 0)
							{
								for each(var di:ObjectDefinition in dependencies)
								{
									if(!di.isReady && !di.isPendingProcessing && !di.isProcessing)
									{
//										log.debug( depth + "Processing [Dependency]: " + di.type.name + " for [Owner]: " + definition.type.name + " [Member]: " + member.name);
										
										if(!di.isDecorated)
										{
//											log.debug( depth + "Decorating [Dependency]: " + di.type.name + " for [Owner]: " + definition.type.name + " [Member]: " + member.name);							
											var decorator:ObjectDefinitionProcessorDecorator  = new ObjectDefinitionProcessorDecorator(context);
											decorator.decorate(di);
										}

										processDefinition(queue, di, destroy, null, depth + "-", processQueue);
									}
								}
							}
							
							if ( factory.mode == "merged" )
							{
								if ( !mergedMetas )
									mergedMetas = new Dictionary();
								
								if ( !mergedMetas[ factory ])
									mergedMetas[ factory ] = { processor: factory.getInstance( definition.context ),
										meta: new MergedMetaDefinition(context, definition),
										index: 0 };
								
								processor = mergedMetas[ factory ].processor;
								
								if ( member.meta.stage > mergedMetas[ factory ].index )
									mergedMetas[ factory ].index = member.meta.stage;
							}
							else
							{
								processor = factory.getInstance( definition.context );
							}
							
							// Merge dependency into the queue
							meta = processDependenciesFromDefinition( queue, definition, dependencies, processor, member, destroy, data );
							
							var isFinal:Boolean =  meta.meta.stage == ProcessorLifeCycleStage.READY || meta.meta.stage == ProcessorLifeCycleStage.AFTER_READY;
							
							// Single entry in queue (Per meta processing) else Merged
							if ( meta && factory.mode == "single")
							{
								processQueue.push({mode: "single", m: meta, p: processor, d:destroy, f: isFinal, i: member.stage, pr: member.priority});
//								queue.append( meta, processor, destroy, isFinal);
							}
							else if(mergedMetas && meta)
								MergedMetaDefinition( mergedMetas[ factory ].meta ).add( meta );
						}
					}
					processor = null;
				}
			}
			
			if ( mergedMetas )
			{
				for each ( var merged:Object in mergedMetas )
				{
					processQueue.push({mode: "merged", m: merged.meta, p: merged.processor, d: destroy, i: merged.index});
				}
			}
		}
		
		private function processDependenciesFromDefinition( queue:ProcessorQueue, definition:ObjectDefinition,
															dependencies:Array, processor:IProcessor,
															member:MemberProcessors, destroy:Boolean =
															false,
															data:* = null ):MetaDefinition
		{
			var meta:MetaDefinition = new MetaDefinition();
			meta.dependencies = dependencies;
			meta.owner = definition;
			meta.member = member.member;
			meta.meta = member.meta;
			meta.data = data;
			return meta;
		}
	}
}
