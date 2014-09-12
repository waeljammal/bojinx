package com.bojinx.command.meta
{
	import com.bojinx.api.processor.metadata.IMetaData;
	
	public class CommandRunner implements IMetaData
	{
		public function CommandRunner()
		{
		}
		
		public function get stage():int
		{
			return 0;
		}
	}
}