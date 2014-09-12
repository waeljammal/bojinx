package com.bojinx.mnav.skinnable.effect
{
	import com.greensock.TimelineMax;
	
	public class BaseEffect
	{
		
		/*============================================================================*/
		/*= PROTECTED PROPERTIES                                                      */
		/*============================================================================*/
		
		protected var OVERWRITE:int = 3;
		
		protected var TIME:Number = 1;
		
		public function BaseEffect()
		{
		}
		
		/*============================================================================*/
		/*= STATIC PROTECTED PROPERTIES                                               */
		/*============================================================================*/
		
		protected static var timeline:TimelineMax;
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		[EffectQueue]
		/**
		 * Will only get called once for the root way point
		 * all children waypoints can then add their effects
		 * to the same queue.
		 */
		public function create( onComplete:Function ):void
		{
			if ( timeline )
				timeline.clear();
			
			timeline = new TimelineMax({ onComplete: onComplete });
			timeline.pause();
		}
		
		[EffectPlay]
		/**
		 * Will only get called once for the root way point
		 * after all children for the destination are available.
		 */
		public function play():void
		{
			timeline.play();
		}
	}
}
