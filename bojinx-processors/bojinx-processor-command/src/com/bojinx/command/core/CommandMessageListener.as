package com.bojinx.command.core
{
	import com.bojinx.command.config.factory.CommandFactory;
	import com.bojinx.command.meta.CommandMetadata;
	import com.bojinx.reflection.ClassInfo;
	import com.bojinx.reflection.ClassInfoFactory;

	public class CommandMessageListener
	{
		public function CommandMessageListener()
		{
		}
		
		public function parse(command:CommandFactory):void
		{
			var info:ClassInfo = ClassInfoFactory.forClass(command.source);
			var methods:Array = info.getMethodsWithMeta(CommandMetadata);
		}
		
		public function listen():void
		{
			// TODO Auto Generated method stub
			
		}
	}
}