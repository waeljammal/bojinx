package com.bojinx.mnav.core.manager
{
	import com.bojinx.mnav.core.constants.Action;
	import com.bojinx.mnav.util.NavUtil;
	
	public class DestinationStateController
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _destination:String;
		
		public function get destination():String
		{
			return _destination;
		}
		
		public var hasEnterInterceptor:Boolean;
		
		public var hasExitInterceptor:Boolean;
		
		public var hasFirstEntered:Boolean;
		
		public var isEffectEndpoint:Boolean;
		
		public var isPendingState:Boolean;
		
		public var isSelected:Boolean;
		
		public var isWaypointAvailable:Boolean;
		
		public var lastDestination:String;
		
		public function DestinationStateController( destination:String )
		{
			_destination = destination;
		}
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function navigateAway():String
		{
			var action:String;
			
			if ( isSelected )
			{
				isSelected = false;
				action = Action.EXIT;
			}
			else
			{
				action = null;
			}
			
			return action;
		}
		
		public function navigateTo( newDestination:String ):String
		{
			var action:String;
			
			if ( !isNoDuplicate( newDestination ))
			{
				return null;
			}
			
			if ( isFirstEnter( newDestination ))
			{
				hasFirstEntered = true;
				isSelected = true;
				action = Action.FIRST_ENTER;
			}
			else if ( isEnter( newDestination ))
			{
				isSelected = true;
				action = Action.ENTER;
			}
			else if ( isExit( newDestination ))
			{
				isSelected = false;
				action = Action.EXIT;
			}
			
			return action;
		}
		
		public function reset():void
		{
			hasFirstEntered = false;
			isSelected = false;
			lastDestination = null;
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function isEnter( newDestination:String ):Boolean
		{
			return ( hasFirstEntered && !isSelected && newDestination == destination );
		}
		
		private function isExit( newDestination:String ):Boolean
		{
			return ( isSelected && newDestination != destination &&
				NavUtil.hasSameWaypointAtAnyLevel( newDestination, destination ));
		}
		
		private function isFirstEnter( newDestination:String ):Boolean
		{
			return ( !hasFirstEntered && !isSelected && newDestination == destination );
		}
		
		private function isNoDuplicate( newDestination:String ):Boolean
		{
			return ( newDestination != lastDestination )
		}
	}
}
