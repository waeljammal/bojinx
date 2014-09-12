package com.bojinx.tests.display.support
{
	import mx.core.UIComponent;
	
	public class DisplayComponent extends UIComponent
	{
		public var wire:String = "yes";
		
		[Inject]
		public var obj:DisplayInjectableObject;
		
		public var isReady:Boolean;
		
		public function DisplayComponent()
		{
			super();
		}
		
		[Ready]
		public final function onReady():void
		{
			isReady = true;
		}
	}
}