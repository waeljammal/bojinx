package com.bojinx.tests.injection.support
{
	public class TargetTwo
	{
		[Inject]
		public var targetOne:TargetOne;
		
		public function TargetTwo()
		{
		}
	}
}