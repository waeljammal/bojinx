package com.bojinx.system.context.mxml
{
	import com.bojinx.system.context.ApplicationContext;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import mx.core.IMXMLObject;
	
	[DefaultProperty( "configFiles" )]
	/**
	 * MXML compatible version of the application context.
	 * 
	 * @Manifest
	 */
	public class ApplicationContext extends com.bojinx.system.context.ApplicationContext implements IMXMLObject
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		/**
		 * Auto loads the context once the stage
		 * is available.
		 */
		public var autoLoad:Boolean = true;
		
		private var _target:Object;
		
		/**
		 * The optional target otherwise the direct owner of the
		 * context is used as the target.
		 */
		public function set target( value:Object ):void
		{
			_target = value;
		}
		
		public function ApplicationContext( owner:Object = null, id:String = null )
		{
			super( owner, id );
		}
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		/**
		 * @private
		 */
		public final function initialized( document:Object, id:String ):void
		{
			if ( isInitialized )
			{
				return;
			}
			
			var useTarget:Object = _target ? _target : document;
			
			initialize( id, useTarget );
			
			if ( useTarget is IEventDispatcher && !useTarget.parent )
				useTarget.addEventListener( "creationComplete", onCreationComplete );
			else if ( autoLoad )
				load();
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function onAddedToStage( event:Event ):void
		{
			event.currentTarget.addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			
			if ( autoLoad && !isLoading && event.currentTarget.stage )
				load();
		}
		
		private function onCreationComplete( event:Event ):void
		{
			event.currentTarget.removeEventListener( "creationComplete", onCreationComplete );
			
			if ( autoLoad && !isLoading && event.currentTarget.stage )
				load();
			else
				event.currentTarget.addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
		}
	}
}
