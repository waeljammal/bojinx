package com.bojinx.mnav.core.message
{
	public class InternalDestinationMessage
	{
		public var finalDestination:String;
		public var newDestination:String;
		public var oldDestination:String;
		public var action:String;
		public var isEvery:Boolean;
		
		public function InternalDestinationMessage(newDestination:String = null)
		{
			this.newDestination = newDestination;
		}
	}
}