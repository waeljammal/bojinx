package com.bojinx.tests.injection.support
{
	public class TargetOne
	{
		[Inject(stage="ready")]
		public var targetTwo:TargetTwo;
		
		public function TargetOne()
		{
		}
	}
}