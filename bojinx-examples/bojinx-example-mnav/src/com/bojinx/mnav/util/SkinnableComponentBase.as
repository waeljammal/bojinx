package com.bojinx.mnav.util
{
	import mx.states.State;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	public class SkinnableComponentBase extends SkinnableComponent
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		override public function set currentState( value:String ):void
		{
			super.currentState = value;
			
			if ( skin )
			{
				invalidateSkinState();
			}
		}
		
		public function SkinnableComponentBase()
		{
			super();
		}
		
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		override protected function getCurrentSkinState():String
		{
			return currentState;
		}
		
		protected function setStates( array:Array ):void
		{
			for each ( var i:String in array )
			{
				states.push( new State({ name: i }));
			}
		}
	}
}
