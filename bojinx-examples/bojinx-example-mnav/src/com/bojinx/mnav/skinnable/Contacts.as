package com.bojinx.mnav.skinnable
{
	import com.bojinx.mnav.util.SkinnableComponentBase;
	
	[WayPoint(path="contacts", mode="states", target="skin")]
	[SkinState("public")]
	[SkinState("private")]
	public class Contacts extends SkinnableComponentBase
	{
		[Bindable]
		public var label:String;
		
		[Bindable]
		public var color:uint;
		
		public var wire:String = "yes";
		
		public function Contacts()
		{
			super();
			
			setStates(["normal", "testComponent"]);
		}
	}
}