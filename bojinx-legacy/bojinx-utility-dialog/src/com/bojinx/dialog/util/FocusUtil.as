package com.bojinx.dialog.util
{
	import com.bojinx.dialog.DialogEvent;
	import com.bojinx.dialog.wrapper.Dialog;
	import flash.events.Event;
	import mx.managers.FocusManager;
	import mx.managers.IActiveWindowManager;
	import mx.managers.IFocusManager;
	import mx.managers.IFocusManagerContainer;
	import mx.managers.ISystemManager;
	import mx.managers.SystemManagerGlobals;
	
	public class FocusUtil
	{
		public function FocusUtil()
		{
		}
		
		
		/*============================================================================*/
		/*= STATIC PUBLIC METHODS                                                     */
		/*============================================================================*/
		
		public static function giveFocus( target:Object ):void
		{
			if ( !( target is IFocusManagerContainer ))
			{
				return;
			}
			
			var sm:ISystemManager = ISystemManager( SystemManagerGlobals.topLevelSystemManagers[ 0 ]);
			
			var awm:IActiveWindowManager =
				IActiveWindowManager( sm.getImplementation( "mx.managers::IActiveWindowManager" ));
			
			if ( !IFocusManagerContainer( target ).focusManager )
			{
				IFocusManagerContainer( target ).focusManager =
					new FocusManager( IFocusManagerContainer( target ), true );
			}
			
			awm.activate( IFocusManagerContainer( target ));
		}
		
		public static function manageFocus( target:Dialog ):void
		{
			target.addEventListener( DialogEvent.WINDOW_ADDED, onShowComplete );
			target.addEventListener( DialogEvent.WINDOW_REMOVED, onHideComplete );
		}
		
		public static function removeFocus( target:Object ):void
		{
			if ( !( target is IFocusManagerContainer ))
			{
				return;
			}
			
			var sm:ISystemManager = ISystemManager( SystemManagerGlobals.topLevelSystemManagers[ 0 ]);
			
			var awm:IActiveWindowManager =
				IActiveWindowManager( sm.getImplementation( "mx.managers::IActiveWindowManager" ));
			
			awm.removeFocusManager( IFocusManagerContainer( target ));
			awm.deactivate( IFocusManagerContainer( target ));
			
			if ( IFocusManagerContainer( target ).focusManager )
			{
				try
				{
//					IFocusManagerContainer( target ).focusManager = null;
				}
				catch ( e:Error )
				{
					
				}
			}
		}
		
		public static function unManageFocus( target:Dialog ):void
		{
			target.removeEventListener( DialogEvent.WINDOW_ADDED, onShowComplete );
			target.removeEventListener( DialogEvent.WINDOW_REMOVED, onHideComplete );
			
			removeFocus( target.window );
		}
		
		/*============================================================================*/
		/*= STATIC PRIVATE METHODS                                                    */
		/*============================================================================*/
		
		private static function onHideComplete( event:Event ):void
		{
			var dialog:Dialog = event.currentTarget as Dialog;
			
			removeFocus( dialog.window );
		}
		
		private static function onShowComplete( event:Event ):void
		{
			var dialog:Dialog = event.currentTarget as Dialog;
			
			giveFocus( dialog.window );
		}
	}
}
