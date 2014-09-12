package com.bojinx.dialog
{
	import com.bojinx.dialog.ui.DefaultDialogWindow;
	import com.bojinx.dialog.wrapper.Dialog;
	import com.bojinx.dialog.wrapper.DialogData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	public class DialogFlashFactory implements IDialogFactory
	{
		
		public function DialogFlashFactory()
		{
		}
		
		
		/*============================================================================*/
		/*= STATIC PRIVATE PROPERTIES                                                 */
		/*============================================================================*/
		
		private static var data:Dictionary = new Dictionary();
		
		private static var dialogs:Dictionary = new Dictionary();
		
		
		/*============================================================================*/
		/*= STATIC PUBLIC METHODS                                                     */
		/*============================================================================*/
		
		public static function generateDialog( attachTo:Sprite = null, modalTarget:Sprite = null,
											   windowClass:Class = null ):Dialog
		{
			if ( !windowClass )
			{
				windowClass = DefaultDialogWindow;
			}
			
			var dialogData:DialogData = new DialogData( attachTo, modalTarget, windowClass );
			var dialog:Dialog = new Dialog( dialogData, new DialogFlashFactory());
			
			dialogs[ dialogData ] = dialog;
			data[ dialog ] = dialogData;
			
			return dialog;
		}
		
		public static function getDataForDialog( dialog:Dialog ):DialogData
		{
			return data[ dialog ];
		}
		
		public static function getDialogForData( dialogData:DialogData ):Dialog
		{
			return dialogs[ dialogData ];
		}
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function closeAndDialogsAbove( dialog:Dialog, animate:Boolean = false,
											  animateAbove:Boolean = false ):void
		{
		
		}
		
		public function giveFocusTo( dialog:Dialog ):void
		{
		}
		
		public function giveFocusToTopMost():void
		{
		
		}
		
		public function releaseDialog( dialog:Dialog ):void
		{
			delete( dialogs[ dialog.data ]);
			delete( data[ dialog ]);
		}
		
		public function updateAllWindowDepths():void
		{
			for each ( var i:Dialog in dialogs )
			{
				if ( i.window && i.window.parent )
				{
					var smgr:DisplayObjectContainer = i.window.parent as DisplayObjectContainer;
					
					// Try to get the index for depth
					if ( smgr && smgr.contains( i.window as DisplayObject ))
					{
						i.index = smgr.getChildIndex( i.window );
					}
				}
			}
		}
	}
}