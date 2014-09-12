package com.bojinx.display.operation
{
	import com.bojinx.api.processor.display.IViewManager;
	import com.bojinx.display.meta.ViewManagerMetadata;
	import com.bojinx.reflection.Method;
	import com.bojinx.reflection.Property;
	import com.bojinx.system.cache.definition.MetaDefinition;
	import com.bojinx.system.processor.AbstractProcessor;
	
	public class DisplayProcessingOperation extends AbstractProcessor
	{
		public function DisplayProcessingOperation()
		{
			super();
		}
		
		override public function process(value:MetaDefinition):void
		{
			if(value.meta is ViewManagerMetadata)
				injectViewManager(value);
			
			complete(value);
		}
		
		private function injectViewManager(value:MetaDefinition):void
		{
			var viewManager:IViewManager = value.owner.context.displayRouter.viewManager;
			
			if(viewManager)
			{
				if(value.member is Property)
					(value.member as Property).setValue(value.owner.target, viewManager);
				else if(value.member is Method)
					(value.member as Method).invoke(value.owner.target, [viewManager]);
			}
			else
				throw new Error("No view manager was found, make sure you have registered your display processor");
		}
	}
}