package com.bojinx.mnav.skinnable.presentation
{
	
	[RequestMapping( "viewTwo" )]
	public class ComponentTwoPM
	{
		public function ComponentTwoPM()
		{
		}
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		[Path( value = "/", time = "every" )]
		/**
		 * Gets called every time the url is /viewOne/viewTwo
		 */
		public final function onEnterEvery():void
		{
		
		}
		
		[Path( value = "testComponent", time = "every" )]
		/**
		 * Gets called every time the url is /viewOne/viewTwo/testComponent
		 */
		public final function onEnterEveryTestComponentState():void
		{
		
		}
	}
}
