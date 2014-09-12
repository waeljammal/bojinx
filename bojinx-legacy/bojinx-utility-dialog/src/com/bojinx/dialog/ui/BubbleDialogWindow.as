package com.bojinx.dialog.ui
{
	import com.bojinx.dialog.DialogEvent;
	import com.bojinx.dialog.IDialogAware;
	import com.bojinx.dialog.util.Bubble;
	import com.bojinx.dialog.wrapper.Dialog;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import mx.core.UIComponent;
	
	public class BubbleDialogWindow extends MovieClip implements IDialogAware
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _dialog:Dialog;
		
		public function set dialog( value:Dialog ):void
		{
			_dialog = value;
			
			if ( value )
			{
				value.addEventListener( DialogEvent.UPDATE, onUpdate );
			}
		}
		
		public function BubbleDialogWindow()
		{
			super();
		}
		
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function onUpdate( event:DialogEvent ):void
		{
//			if ( isNaN( _dialog.data.currentWidth ))
//				drawSpeechBubble( this, new Rectangle( _dialog.data.currentX, _dialog.data.currentY, _dialog.data.currentWidth, _dialog.data.currentHeight ), 20, new Point( 120, 300 ));
//			else
			
			
			var m:Matrix = new Matrix();
			m.createGradientBox( _dialog.width, _dialog.height, 90 * Math.PI / 180, 80, 80 );
			
			var g:Graphics = this.graphics;
			g.clear();
			g.lineStyle( 2, 0x888888, 1, true );
			g.beginGradientFill( GradientType.LINEAR, [ 0xe0e0e0, 0xffffff ], [ 1, 1 ], [ 1, 0xff ], m );
			Bubble.drawSpeechBubble( this, new Rectangle( 33, 180, _dialog.width, _dialog.height ), 20, new Point( 120, 300 ));
			g.endFill();
		}
	}
}