package com.bojinx.command.config.factory.mxml
{
	import com.bojinx.command.config.factory.CommandMapFactory;
	
	import mx.core.IMXMLObject;
	
	/**
	 * @Manifest("CommandMap")
	 */
	public class CommandMap extends CommandMapFactory implements IMXMLObject
	{
		public function CommandMap()
		{
			super();
		}
		
		public function initialized(document:Object, id:String):void
		{
			this.id = id;
		}
	}
}