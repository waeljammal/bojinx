package com.bojinx.mnav.core.tasks
{
	import com.bojinx.mnav.core.constants.Action;
	import com.bojinx.mnav.core.manager.NavigationController;
	import com.bojinx.mnav.core.message.InternalDestinationMessage;
	import com.bojinx.mnav.core.message.NavigationChangeMessage;
	import com.bojinx.mnav.core.tasks.shared.SortableTask;
	import com.bojinx.utils.logging.Logger;
	import com.bojinx.utils.logging.LoggingContext;
	
	public class DispatchEnterTask extends SortableTask
	{
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var controller:NavigationController;
		
		private var data:InternalDestinationMessage;
		
		public function DispatchEnterTask( data:InternalDestinationMessage, controller:NavigationController )
		{
			super();
			
			this.data = data;
			this.controller = controller;
		}
		
		/*============================================================================*/
		/*= STATIC PRIVATE PROPERTIES                                                 */
		/*============================================================================*/
		
		private static const log:Logger = LoggingContext.getLogger( DispatchEnterTask );
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		override protected function doStart():void
		{
			var type:String;
			var eMsg:NavigationChangeMessage;
			
			if ( data.action == Action.FIRST_ENTER )
			{
				type = data.newDestination + ":" + data.action;
				log.info( "Dispatching First Enter State [Destination]: " + data.newDestination + " [Action]: " + type );
				eMsg = new NavigationChangeMessage( data.oldDestination, data.newDestination );
				controller.context.messageBus.dispatch( eMsg, type );
			}
			
			type = data.newDestination + ":" + Action.EVERY_ENTER;
			log.info( "Dispatching Every Enter State [Destination]: " + data.newDestination + " [Action]: " + type );
			
			eMsg = new NavigationChangeMessage( data.oldDestination, data.newDestination );
			controller.context.messageBus.dispatch( eMsg, type );
			
			complete();
		}
	}
}
