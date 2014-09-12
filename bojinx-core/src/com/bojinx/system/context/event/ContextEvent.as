package com.bojinx.system.context.event
{
	import flash.events.Event;
	
	public class ContextEvent extends Event
	{
		public function ContextEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable );
		}
		
		/*============================================================================*/
		/*= STATIC PUBLIC PROPERTIES                                                  */
		/*============================================================================*/
		
		/**
		 * Dispatched when Configuration has been parsed
		 */
		public static const CONFIGURATION_LOADED:String = "configurationLoaded";
		
		/**
		 * Context has been loaded
		 */
		public static const CONTEXT_LOADED:String = "contextLoaded";
		
		/**
		 * Dispatched when Configuration has started loading
		 */
		public static const CONTEXT_LOADING:String = "contextLoading";
		
		/**
		 * Context has been unloaded
		 */
		public static const CONTEXT_UNLOADED:String = "contextUnloaded";
		
		/**
		 * An object has been processed
		 */
		public static const OBJECT_PROCESSED:String = "objectProcessed";
		
		/**
		 * An object has been released
		 */
		public static const OBJECT_RELEASED:String = "objectReleased";
		
		/**
		 * Pending display objects have been processed
		 */
		public static const PENDING_DISPLAY_OBJECTS_PROCESSED:String = "pendingDisplayObjectsProcessed";
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new ContextEvent( type, bubbles, cancelable );
		}
	}
}
