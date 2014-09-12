package com.bojinx.command.config.task
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.command.cache.CommandCacheConstants;
	import com.bojinx.command.cache.CommandRegistry;
	import com.bojinx.command.config.factory.CommandFactory;
	import com.bojinx.command.model.CommandMapInstanceInfo;
	import com.bojinx.command.util.error.InvalidCommandError;
	import com.bojinx.reflection.Method;
	import com.bojinx.reflection.Parameter;
	import com.bojinx.system.cache.definition.ObjectDefinition;
	import com.bojinx.system.processor.event.ProcessorQueueEvent;
	import com.bojinx.system.processor.event.ProcessorQueueFaultEvent;
	import com.bojinx.system.processor.queue.ProcessorQueue;
	import com.bojinx.utils.tasks.Task;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	public class CommandTask extends Task
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		public var executeMethod:String = "execute";
		
		public var faultMethod:String = "fault";
		
		public var ownerIsCommandMap:Boolean = false;
		
		public var resultMethod:String = "result";
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var cache:CommandRegistry;
		
		private var context:IApplicationContext;
		
		private var definition:ObjectDefinition;
		
		private var factory:CommandFactory;
		
		private var sessionInfo:CommandMapInstanceInfo;
		private var message:Object;
		
		public function CommandTask( factory:CommandFactory, message:Object )
		{
			this.factory = factory;
			this.context = factory.context;
			this.cache = context.cache.getCache( CommandCacheConstants.CACHE_ID );
			this.sessionInfo = cache.getSessionInfo( factory.id );
			this.message = message;
			
			super();
		}
		
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		override protected function doStart():void
		{
			definition = context.getDefinitionById( factory.id );
			
			if ( definition )
			{
				var queue:ProcessorQueue = context.processDefinition( definition, false );
				queue.addEventListener( ProcessorQueueEvent.ALL_COMPLETE, onDefinitionProcessed );
				queue.addEventListener( ProcessorQueueFaultEvent.FAULT, onDefinitionProcessingFault );
				queue.run();
			}
			else
			{
				throw new Error( "Definition could not be generated for command " + factory.id );
			}
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function addBasicCommandListeners( target:* ):void
		{
			if ( !( definition.target is IEventDispatcher ))
				throw new Error( "Command does not return an AsyncToken and neither " +
								 "extends EventDispatcher, one or the other should be available." );
			
			IEventDispatcher( definition.target ).addEventListener( Event.COMPLETE, onBasicCommandComplete );
			IEventDispatcher( definition.target ).addEventListener( ErrorEvent.ERROR, onBasicCommandError );
		}
		
		private function getParameter( method:Method, index:int ):Parameter
		{
			var params:Array;
			var param:Parameter;
			
			if ( method.parameters && method.parameters.length > index )
			{
				param = method.parameters[ index ];
			}
			
			return param;
		}
		
		private function onAsyncCommandFault( event:FaultEvent ):void
		{
			var token:AsyncToken = event.token;
			token.responders.splice( 0, token.responders.length );
			
			var method:Method = definition.type.getMethod( faultMethod );
			
			if ( method )
			{
				method.invoke( definition.target, [ message, event ]);
			}
			
			error( event.fault.faultString );
		}
		
		private function onAsyncCommandResult( event:ResultEvent ):void
		{
			var token:AsyncToken = event.token;
			token.responders.splice( 0, token.responders.length );
			
			var method:Method = definition.type.getMethod( resultMethod );
			
			if ( method )
			{
				method.invoke( definition.target, [ message, event ]);
				sessionInfo.storeResult( event.result, factory.id );
				context.releaseObject( definition.target );
			}
			
			complete();
		}
		
		private function onBasicCommandComplete( event:Event ):void
		{
			removeBasicCommandListeners( event.currentTarget );
			context.releaseObject( definition.target );
			complete();
		}
		
		private function onBasicCommandError( event:ErrorEvent ):void
		{
			removeBasicCommandListeners( event.currentTarget );
			context.releaseObject( definition.target );
			error( event.text );
		}
		
		private function onDefinitionProcessed( event:ProcessorQueueEvent ):void
		{
			removeListeners( event.currentTarget );
			var executeMethod:Method = definition.type.getMethod( executeMethod );
			
			if ( !executeMethod )
				throw new InvalidCommandError( "Command " + definition.type.name + " is missing the execute() method" );
			
			var returnType:Class = executeMethod.returnType ? executeMethod.returnType.getClass() : null;
			var target:Object = definition.target;
			var firstParam:Parameter = getParameter( executeMethod, 0 );
			var parameters:Array = sessionInfo.getParameters( factory.id );
			
			if(!ownerIsCommandMap)
				parameters.push(message);
			
			if ( executeMethod.parameters.length != parameters.length)
				throw new Error( "Invalid argument count on execute() method in Command " + target +
								 " method expects " + executeMethod.parameters.length + " but there are " +
								 parameters.length + " arguments available" );
			
			if ( !returnType )
				addBasicCommandListeners( target );
			
			var token:AsyncToken;
			
			if ( executeMethod.parameters.length == parameters.length )
				token = executeMethod.invoke( target, parameters ) as AsyncToken;
			else
				token = executeMethod.invoke( target );
			
			if ( token )
				token.addResponder( new Responder( onAsyncCommandResult, onAsyncCommandFault ));
		}
		
		private function onDefinitionProcessingFault( event:ProcessorQueueFaultEvent ):void
		{
			removeListeners( event.currentTarget );
			error( event.message );
		}
		
		private function removeBasicCommandListeners( target:* ):void
		{
			IEventDispatcher( definition.target ).removeEventListener( Event.COMPLETE, onBasicCommandComplete );
			IEventDispatcher( definition.target ).removeEventListener( ErrorEvent.ERROR, onBasicCommandError );
		}
		
		private function removeListeners( currentTarget:Object ):void
		{
			currentTarget.removeEventListener( ProcessorQueueEvent.ALL_COMPLETE, onDefinitionProcessed );
			currentTarget.removeEventListener( ProcessorQueueFaultEvent.FAULT, onDefinitionProcessingFault );
		}
	}
}
