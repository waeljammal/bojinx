package com.bojinx.command.model
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.command.config.factory.CommandMapFactory;
	
	import flash.utils.Dictionary;
	
	public class CommandMapInstanceInfo
	{
		public var map:CommandMapFactory;
		public var context:IApplicationContext;
		private var resultMap:Dictionary = new Dictionary();
		private var linkedParameters:Dictionary = new Dictionary();
		
		public function getResult(commandId:String):Object
		{
			return resultMap[commandId];
		}
		
		public function storeResult(result:Object, commandId:String):void
		{
			resultMap[commandId] = result;
		}
		
		public function addParameter(id:String, result:*):void
		{
			var params:Array = linkedParameters[id];
			
			if(!params)
			{
				params = [];
				linkedParameters[id] = params;
			}
			
			params.push(result);
		}
		
		public function getParameters(id:String):Array
		{
			var result:Array = [];
			
			if(linkedParameters[id])
				result = result.concat(linkedParameters[id]);
			
			return result;
		}
	}
}