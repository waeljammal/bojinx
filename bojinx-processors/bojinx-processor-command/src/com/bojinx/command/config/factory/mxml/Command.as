package com.bojinx.command.config.factory.mxml
{
	import com.bojinx.command.config.factory.CommandFactory;
	
	import mx.core.IMXMLObject;
	
	/**
	 * @Manifest("Command")
	 */
	public class Command extends com.bojinx.command.config.factory.CommandFactory implements IMXMLObject
	{
		public function Command()
		{
			super();
		}
		
		public function initialized(document:Object, id:String):void
		{
			this.id = id;
		}
	}
}