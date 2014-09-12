package com.bojinx.command.util
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.command.cache.CommandCacheConstants;
	import com.bojinx.command.cache.CommandRegistry;
	import com.bojinx.command.core.CommandMapMessageListener;

	public final class CommandUtil
	{
		public function CommandUtil()
		{
		}
		
		public static function getMessageType( context:IApplicationContext, from:Class, id:String, trigger:Class ):Object
		{
//			var info:ObjectDefinitionInfo = context.getInfoByType( from, true, id );
//			var methods:Array = info.type.getMethods();
//			var commandMeta:CommandMetadata;
//			var parameter:Parameter;
//			
//			for each ( var method:Method in methods )
//			{
//				for each ( var meta:IMetaData in method.meta )
//				{
//					if ( meta is CommandMetadata )
//					{
//						commandMeta = meta as CommandMetadata;
//						
//						if ( method.parameters.length > 0 )
//							parameter = method.parameters[ 0 ];
//						else
//							throw new Error( "Method " + method.name + " In Command " +
//								info.clazz + " must have atleast 1 parameter" );
//						
//						if ( parameter && trigger && trigger == parameter.paramterType.getClass() || ( parameter && !trigger ))
//							return {trigger: parameter.paramterType.getClass(), scope: commandMeta.scope, topic: commandMeta.name};
//					}
//				}
//			}
			
			return null;
		}
		
		public static function createListener( context:IApplicationContext, trigger:Class, topic:String, scope:String):void
		{
			var cache:CommandRegistry = context.cache.getCache( CommandCacheConstants.CACHE_ID );
			var listener:CommandMapMessageListener = new CommandMapMessageListener();
			listener.trigger = trigger;
			listener.context = context;
			listener.topic = topic;
			listener.scope = scope;
			listener.cache = cache;
			
			// Start listening
			listener.start();
		}
		
		public static function addItemsAt( tarArray:Array, items:Array, index:int = 0x7FFFFFFF ):Boolean
		{
			if ( items.length == 0 )
				return false;
			
			var args:Array = items.concat();
			args.splice( 0, 0, index, 0 );
			
			tarArray.splice.apply( null, args );
			
			return true;
		}
	}
}