package com.bojinx.mnav.config
{
	import com.bojinx.utils.data.HashMap;

	[DefaultProperty("locations")]
	/**
	 * @Manifest
	 */
	public class SiteMap
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _locations:Array;
		
		public function get locations():Array
		{
			return _locations;
		}
		
		public function set locations( value:Array ):void
		{
			_locations = value;
			generateLocationMap();
		}
		
		private var locationMap:HashMap;
		
		private function generateLocationMap():void
		{
			if(!locations)
				return;
			
			locationMap = new HashMap();
			generateLocationMapRecursively(locations.concat());
		}
		
		private function generateLocationMapRecursively(locations:Array):void
		{
			// TODO Auto Generated method stub
			while(locations.length > 0)
			{
				var location:Location = locations.pop();
				
				locationMap.put(location.toString(), location);
					
				if(location.children)
					generateLocationMapRecursively(location.children.concat());
			}
		}
		
		public var defaultLocation:String;
		
		public var seperator:String = ".";
		
		public function SiteMap()
		{
		}
		
		public function getDefaultLocation():Location
		{
			if(defaultLocation)
			{	
				for each(var i:Location in locations)
				{
					if(i.rawDestination() == defaultLocation)
						return i;
				}
			}
			
			return null;
		}
		
		public function getLocation(value:String):Location
		{
			return locationMap.getValue(value);
		}
	}
}