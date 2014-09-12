package com.bojinx.dialog
{
	import com.bojinx.dialog.wrapper.Dialog;
	
	public interface IDialogFactory
	{
		function closeAndDialogsAbove( dialog:Dialog, animate:Boolean = false,
									   animateAbove:Boolean = false ):void;
		function giveFocusTo( dialog:Dialog ):void;
		function giveFocusToTopMost():void;
		function releaseDialog( dialog:Dialog ):void;
		function updateAllWindowDepths():void;
	}
}