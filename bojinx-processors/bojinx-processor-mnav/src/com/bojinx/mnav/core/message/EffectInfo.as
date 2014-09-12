package com.bojinx.mnav.core.message
{
	import flash.utils.Dictionary;
	import com.bojinx.system.message.queue.MessageQueue;

	public class EffectInfo
	{
		public var destination:String;
		public var destinationDetail:String;
		public var queue:MessageQueue;
		public var state:String;
		public var fromState:String;
		public var toState:String;
		public var action:String;
		
		public function EffectInfo()
		{
			
		}
		
	}
}