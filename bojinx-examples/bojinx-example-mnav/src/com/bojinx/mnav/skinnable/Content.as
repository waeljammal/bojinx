package com.bojinx.mnav.skinnable
{
	import com.bojinx.mnav.skinnable.presentation.ContentPM;
	import com.bojinx.mnav.util.SkinnableComponentBase;
	
	[WayPoint(path="content", target="skin", mode="states", factory="viewOneEffectFactory")]
	public class Content extends SkinnableComponentBase
	{
		public var wire:String = "yes";
		
		[Inject]
		[Bindable]
		public var pm:ContentPM;
		
		public function Content()
		{
			super();
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			trace(instance, partName);
		}
		
		public function onShowViewTwoClicked():void
		{
			
		}
	}
}