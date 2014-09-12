package com.bojinx.dialog.ui
{
	import com.bojinx.dialog.IDialogAware;
	import com.bojinx.dialog.wrapper.Dialog;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class DefaultDialogWindow extends Sprite implements IDialogAware
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _dialog:Dialog;
		
		public function set dialog( value:Dialog ):void
		{
			_dialog = value;
		}
		
		public function DefaultDialogWindow()
		{
			super();
			
			addEventListener( Event.ENTER_FRAME, onRender );
		}
		
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		protected function draw():void
		{
			if ( _dialog )
			{
				graphics.clear();
				graphics.lineStyle( 1, 0X000000, 1 );
				graphics.beginFill( 0X000000, 1 );
				graphics.drawRoundRect( 0, 0, _dialog.width, _dialog.height, 5, 5 );
				graphics.endFill();
			}
		}
		
		protected function onRender( event:Event ):void
		{
			draw();
		}
	}
}