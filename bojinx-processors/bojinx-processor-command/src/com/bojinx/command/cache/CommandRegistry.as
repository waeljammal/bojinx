package com.bojinx.command.cache
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.command.config.factory.CommandMapFactory;
	import com.bojinx.command.core.CommandMapMessageListener;
	import com.bojinx.command.core.handler.DynamicCommandBeanHandler;
	import com.bojinx.command.model.CommandMapInstanceInfo;
	import com.bojinx.command.operation.CommandOperation;
	
	import flash.utils.Dictionary;
	
	public class CommandRegistry
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		public var operation:CommandOperation;
		
		public var factory:CommandMapFactory;
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var listeners:Dictionary = new Dictionary();
		
		private var map:Dictionary = new Dictionary();
		
		private var sessionMap:Dictionary = new Dictionary();
		
		private var dynamic:Dictionary = new Dictionary();
		
		public function CommandRegistry(context:IApplicationContext)
		{
			factory = new CommandMapFactory();
		}
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function register( map:CommandMapFactory ):void
		{
			this.map[ map.trigger ] = map;
		}
		
		public function registerListener( value:CommandMapMessageListener ):void
		{
		
		}
		
		public function getSessionInfo(id:String):CommandMapInstanceInfo
		{
			var info:CommandMapInstanceInfo = sessionMap[id];
			
			if(!info)
			{
				info = new CommandMapInstanceInfo();
				sessionMap[id] = info;
			}
			
			return info;
		}
		
		public function addDynamicCommand(entry:DynamicCommandBeanHandler):void
		{
			dynamic[entry.messageType] = entry;
		}
	}
}
