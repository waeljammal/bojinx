package com.bojinx.mnav.core.waypoint
{
	import com.bojinx.api.processor.metadata.IMetaData;
	import com.bojinx.mnav.core.manager.NavigationController;
	import com.bojinx.mnav.core.message.NavigationMessage;
	import com.bojinx.mnav.meta.WayPointMetadata;
	import com.bojinx.mnav.util.NavUtil;
	import com.bojinx.system.cache.definition.MetaDefinition;
	import com.bojinx.system.cache.definition.ObjectDefinition;
	import com.bojinx.utils.logging.Logger;
	import com.bojinx.utils.logging.LoggingContext;
	
	import flash.events.EventDispatcher;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.StateChangeEvent;
	import mx.states.State;
	
	[Event(name="stateChangeComplete", type="mx.events.FlexEvent")]
	public class CurrentStateWaypoint extends EventDispatcher implements IWaypoint
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		public var _endpoint:Boolean;
		
		private var _controller:NavigationController;
		
		public function get controller():NavigationController
		{
			return _controller;
		}
		
		private var _meta:WayPointMetadata;
		
		public function get meta():WayPointMetadata
		{
			return _meta;
		}
		
		private var _name:String;
		
		public function get name():String
		{
			return _name;
		}
		
		private var _registry:StateDestination;
		
		public function get registry():StateDestination
		{
			return _registry;
		}
		
		private var _selectedIndex:int;
		
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		private var _statesTarget:String;
		
		public function get statesTarget():String
		{
			return _statesTarget;
		}
		
		private var _target:ObjectDefinition;
		
		public function get target():ObjectDefinition
		{
			return _target;
		}
		
		private var _view:UIComponent;
		
		public function get view():UIComponent
		{
			return _view;
		}
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private function get states():Array
		{
			return NavUtil.getStatesOfTarget( this );
		}
		
		public function CurrentStateWaypoint()
		{
		
		}
		
		
		/*============================================================================*/
		/*= STATIC PRIVATE PROPERTIES                                                 */
		/*============================================================================*/
		
		private static const log:Logger = LoggingContext.getLogger( CurrentStateWaypoint );
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function hasState(state:String):Boolean
		{
			return _registry.hasState(state);
		}
		
		public function dispose():void
		{
//			_view.removeEventListener( StateChangeEvent.CURRENT_STATE_CHANGE, changeHandler );
		}
		
		public function getDefaultDestination():String
		{
			var defaultDestination:String;
			var currentState:String = NavUtil.getCurrentState( this );
			
			if ( currentState != null || currentState != "" )
			{
				defaultDestination = buildFullDestination( currentState );
				_selectedIndex = getSelectedIndex( currentState );
			}
			return defaultDestination;
		}
		
		public function getRealTarget():UIComponent
		{
			return NavUtil.getTarget( this );
		}
		
		public function handleNavigationChange( message:NavigationMessage ):void
		{
			var name:String = NavUtil.getLast( message.destination );
//			log.info( "Setting state to " + name + " for view " + target.type.name );
			NavUtil.setState( this, name );
		}
		
		public function initialize( md:MetaDefinition, controller:NavigationController, path:String ):void
		{
			_meta = md.meta as WayPointMetadata;
			_controller = controller;
			_name = path;
			_target = md.owner;
			_statesTarget = _meta.target;
			_endpoint = _meta.effectEndpoint;
			
			_view = NavUtil.getTarget( this );
			
			_registry = new StateDestination( this );
			_registry.initialize( name, controller );
		}
		
		
		public function subscribeToViewChange( view:UIComponent ):void
		{
			if ( !_view )
				_view = NavUtil.getTarget( this );
			
//			_view.addEventListener( StateChangeEvent.CURRENT_STATE_CHANGE, changeHandler, false, 0, true );
			_view.addEventListener( FlexEvent.STATE_CHANGE_COMPLETE, onStateChangeComplete, false, 0, true);
		}

		private function onStateChangeComplete(event:FlexEvent):void
		{
			dispatchEvent(event.clone());
		}
		
		/*============================================================================*/
		/*= INTERNAL METHODS                                                          */
		/*============================================================================*/
		
		internal function changeName( name:String ):void
		{
			_name = name;
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function buildFullDestination( state:String ):String
		{
			return registry.name + "." + state;
		}
		
		protected function changeHandler( event:StateChangeEvent ):void
		{
			var destination:String = buildFullDestination( event.newState );
			_selectedIndex = getSelectedIndex( event.newState );
			
			dispatchEvent(event.clone());
		
			controller.enterAndExitInvoker.applyExits( destination, null );
			controller.enterAndExitInvoker.applyEnters( destination, null );
		}
		
		private function getSelectedIndex( state:String ):int
		{
			var length:int = states.length;
			
			for ( var i:int; i < length; i++ )
			{
				var stateObject:State = states[ i ];
				
				if ( stateObject.name == state )
				{
					return i;
				}
			}
			return -1
		}
	}
}
