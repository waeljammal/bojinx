package com.bojinx.dialog
{
	import com.bojinx.dialog.ui.DefaultFlexDialogWindow;
	import com.bojinx.dialog.util.FocusUtil;
	import com.bojinx.dialog.wrapper.Dialog;
	import com.bojinx.dialog.wrapper.DialogData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import mx.managers.FocusManager;
	
	public class DialogFactory implements IDialogFactory
	{
		
		public function DialogFactory()
		{
		
		}
		
		
		/*============================================================================*/
		/*= STATIC PRIVATE PROPERTIES                                                 */
		/*============================================================================*/
		
		private static var dialogs:Array = [];
		
		
		/*============================================================================*/
		/*= STATIC PUBLIC METHODS                                                     */
		/*============================================================================*/
		
		public static function generateDialog( attachTo:Sprite, modalTarget:Sprite = null,
											   windowClass:Class = null ):Dialog
		{
			if ( !windowClass )
			{
				windowClass = DefaultFlexDialogWindow;
			}
			
			var dialogData:DialogData = new DialogData( attachTo, modalTarget, windowClass );
			var dialog:Dialog = new Dialog( dialogData, new DialogFactory());
			
			dialogs.push( dialog );
			
			return dialog;
		}
		
		public static function getDataForDialog( dialog:Dialog ):DialogData
		{
			for each ( var i:Dialog in dialogs )
			{
				if ( i == dialog )
				{
					return i.data;
				}
			}
			
			return null;
		}
		
		public static function getDialogForContent( target:Sprite ):Dialog
		{
			for each ( var i:Dialog in dialogs )
			{
				if ( i.content == target )
				{
					return i;
				}
			}
			
			return null;
		}
		
		public static function getDialogForData( dialogData:DialogData ):Dialog
		{
			for each ( var i:Dialog in dialogs )
			{
				if ( i.data == dialogData )
				{
					return i;
				}
			}
			
			return null;
		}
		
		public static function getDialogForWindow( bindTo:Sprite ):Dialog
		{
			for each ( var i:Dialog in dialogs )
			{
				if ( i.window == bindTo )
				{
					return i;
				}
			}
			
			return null;
		}
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function closeAndDialogsAbove( dialog:Dialog, animate:Boolean = false,
											  animateAbove:Boolean = false ):void
		{
			var index:int = dialogs.indexOf( dialog );
			
			if ( index > -1 && dialogs.length > index + 1 )
			{
				for ( var i:int = index + 1; i < dialogs.length; i++ )
				{
					Dialog( dialogs[ i ]).removeWindow( animateAbove );
				}
			}
			
			dialog.removeWindow( animate );
		}
		
		public function giveFocusTo( dialog:Dialog ):void
		{
			FocusUtil.giveFocus( dialog.window );
		}
		
		public function giveFocusToTopMost():void
		{
			var dialog:Dialog = dialogs[ dialogs.length - 1 ];
			
			FocusUtil.giveFocus( dialog.window );
		}
		
		public function reSort():void
		{
			dialogs = dialogs.sortOn( "index" );
		}
		
		public function releaseDialog( dialog:Dialog ):void
		{
			if ( dialog.requiresFocus )
				FocusUtil.unManageFocus( dialog );
			
			dialogs.splice( dialogs.indexOf( dialog ));
			
			if ( dialogs.length > 0 )
			{
				var nextDialog:Dialog = dialogs[ dialogs.length - 1 ];
				giveFocusTo( nextDialog );
			}
		}
		
		public function updateAllWindowDepths():void
		{
			for each ( var i:Dialog in dialogs )
			{
				if ( i.window && i.window.parent )
				{
					i.updateDepthIndex();
				}
			}
			
			reSort();
		}
	}
}