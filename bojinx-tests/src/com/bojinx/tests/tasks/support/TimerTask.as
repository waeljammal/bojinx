package com.bojinx.tests.tasks.support
{
	import com.bojinx.utils.tasks.Task;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class TimerTask extends Task
	{
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var shouldComplete:Boolean;
		
		private var timer:Timer;
		
		public function TimerTask( shouldComplete:Boolean = true )
		{
			this.shouldComplete = shouldComplete;
			super();
		}
		
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		override protected function doCancel():void
		{
			timer.removeEventListener( TimerEvent.TIMER, onTimer );
			timer.stop();
			timer = null;
		}
		
		override protected function doStart():void
		{
			timer = new Timer( 10, 0 );
			timer.addEventListener( TimerEvent.TIMER, onTimer );
			timer.start();
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function onTimer( event:TimerEvent ):void
		{
			timer.removeEventListener( TimerEvent.TIMER, onTimer );
			timer.stop();
			timer = null;
			
			if ( shouldComplete )
				complete();
			else
				error( "Task did not complete" );
		}
	}
}
