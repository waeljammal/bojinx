package com.bojinx.mnav.skinnable
{
	import com.bojinx.mnav.util.SkinnableComponentBase;
	
	[WayPoint(path="messages", mode="states", target="skin")]
	[SkinState("friends")]
	[SkinState("family")]
	public class Messages extends SkinnableComponentBase
	{
		[Bindable]
		public var label:String;
		
		[Bindable]
		public var color:uint;
		
		public var wire:String = "yes";
		
		public function Messages()
		{
			super();
			
			setStates(["normal", "testComponent"]);
		}
	}
}