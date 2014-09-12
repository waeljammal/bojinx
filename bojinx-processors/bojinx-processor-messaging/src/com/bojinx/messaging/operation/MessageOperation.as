package com.bojinx.messaging.operation
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.messaging.error.InvalidInterceptorError;
	import com.bojinx.messaging.error.InvalidMessageHandlerError;
	import com.bojinx.messaging.meta.MessageDispatcherMetadata;
	import com.bojinx.messaging.meta.MessageInterceptorMetadata;
	import com.bojinx.messaging.meta.MessageMetadata;
	import com.bojinx.reflection.Method;
	import com.bojinx.reflection.Parameter;
	import com.bojinx.reflection.Property;
	import com.bojinx.system.cache.definition.MetaDefinition;
	import com.bojinx.system.message.MessageBus;
	import com.bojinx.system.processor.AbstractProcessor;
	
	public class MessageOperation extends AbstractProcessor
	{
		public function MessageOperation()
		{
			super();
		}
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		override public function process( value:MetaDefinition ):void
		{
			if ( value.meta is MessageDispatcherMetadata )
				processMessageDispatcher( value );
			else if ( value.meta is MessageMetadata )
				processMessageHandler( value );
			else if ( value.meta is MessageInterceptorMetadata )
				processInterceptor( value );
			
			complete( value );
		}
		
		override public function release(value:MetaDefinition):void
		{
			if ( value.meta is MessageMetadata )
				processMessageHandler( value, true );
			else if ( value.meta is MessageInterceptorMetadata )
				processInterceptor( value, true );
			
			complete( value );
		}
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		protected function processInterceptor( value:MetaDefinition, release:Boolean = false ):void
		{
			var context:IApplicationContext = value.owner.context;
			var meta:MessageInterceptorMetadata = value.meta as MessageInterceptorMetadata;
			var method:Method = value.member as Method;
			var bus:MessageBus = context.messageBus;
			
			if ( method.parameters.length < 2 )
				throw new InvalidInterceptorError( "Interceptor " + method.name + " in " +
												   value.owner.target + " requires atleast 2 parameters " +
												   "[Message, IMessageInterceptor]" );
			
			var handler:Function = value.owner.target[ method.name ];
			var type:Class;
			
			if ( meta.type )
				type = context.applicationDomain.getDefinition( meta.type ) as Class;
			else
				type = Parameter( method.parameters[ 0 ]).paramterType.getClass();
			
			if(!release)
				bus.addInterceptor( handler, type, meta.name, meta.scope, meta.priority );
			else
				bus.removeInterceptor(handler, type);
		}
		
		protected function processMessageDispatcher( value:MetaDefinition, release:Boolean = false ):void
		{
			var bus:MessageBus = value.owner.context.messageBus;
			
			if ( value.member is Property )
				( value.member as Property ).setValue( value.owner.target, bus.dispatch );
			else if ( value.member is Method )
				( value.member as Method ).invoke( value.owner.target, [ bus.dispatch ]);
		}
		
		protected function processMessageHandler( value:MetaDefinition, release:Boolean = false ):void
		{
			var context:IApplicationContext = value.owner.context;
			var bus:MessageBus = context.messageBus;
			var meta:MessageMetadata = value.meta as MessageMetadata;
			var member:Method = value.member as Method;
			var handler:Function = value.owner.target[ member.name ];
			var type:Class;
			
			if ( member.parameters.length == 0 )
				throw new InvalidMessageHandlerError( "Message handler " + member.name + " in " +
													  value.owner.type.getClass() + " must accept atleast one parameter" );
			
			if ( meta.type )
				type = context.applicationDomain.getDefinition( meta.type ) as Class;
			else
				type = Parameter( member.parameters[ 0 ]).paramterType.getClass();
			
			if(!release)
				bus.addListener( handler, type, meta.name, meta.scope, meta.priority );
			else
				bus.removeListener(handler, type);
		}
	}
}
