package com.bojinx.test.core
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.utils.data.HashMap;

	public class TestCaseRegistry
	{
		public function TestCaseRegistry()
		{
		}
		
		private var map:HashMap = new HashMap();
		
		public function add(testCase:Class, context:IApplicationContext):void
		{
			map.put(testCase, context);
		}
		
		public function get(cls:Class):IApplicationContext
		{
			return map.getValue(cls);
		}
	}
}