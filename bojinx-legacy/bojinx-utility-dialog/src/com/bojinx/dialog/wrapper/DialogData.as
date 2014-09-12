package com.bojinx.dialog.wrapper
{
	import com.bojinx.dialog.DialogEvent;
	import com.bojinx.dialog.effects.DialogEffects;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.GTweenTimeline;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class DialogData
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _attachTo:Sprite;
		
		public function get attachTo():Sprite
		{
			return _attachTo;
		}
		
		private var _currentHeight:Number;
		
		public function get currentHeight():Number
		{
			return _currentHeight;
		}
		
		private var _currentWidth:Number;
		
		public function get currentWidth():Number
		{
			return _currentWidth;
		}
		
		private var _currentX:Number;
		
		public function get currentX():Number
		{
			return _currentX;
		}
		
		private var _currentY:Number;
		
		public function get currentY():Number
		{
			return _currentY;
		}
		
		private var _dialog:Dialog;
		
		public function get dialog():Dialog
		{
			return _dialog;
		}
		
		private var _effects:DialogEffects;
		
		public function get effects():DialogEffects
		{
			return _effects;
		}
		
		private var _modalTarget:Sprite;
		
		public function get modalTarget():Sprite
		{
			return _modalTarget;
		}
		
		public var oldHeight:Number;
		
		public var oldWidth:Number;
		
		private var _positionTween:GTweenTimeline;
		
		public function get positionTween():GTweenTimeline
		{
			return _positionTween;
		}
		
		public function set positionTween( value:GTweenTimeline ):void
		{
			_positionTween = value;
		}
		
		public var startHeight:Number = NaN;
		
		public var startWidth:Number = NaN;
		
		public var startX:Number = NaN;
		
		public var startY:Number = NaN;
		
		private var _tween:GTweenTimeline;
		
		public function get tween():GTweenTimeline
		{
			return _tween;
		}
		
		public function set tween( value:GTweenTimeline ):void
		{
			_tween = value;
		}
		
		private var _windowClass:Class;
		
		public function get windowClass():Class
		{
			return _windowClass;
		}
		
		public function DialogData( attachTo:Sprite, modalTarget:Sprite, windowClass:Class )
		{
			_effects = new DialogEffects( this );
			_attachTo = attachTo;
			_modalTarget = modalTarget;
			_windowClass = windowClass;
			
			_tween = new GTweenTimeline();
			_tween.onChange = onChange;
		}
		
		
		/*============================================================================*/
		/*= INTERNAL METHODS                                                          */
		/*============================================================================*/
		
		internal function setDialog( dialog:Dialog ):void
		{
			_dialog = dialog;
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function onChange( tween:GTween ):void
		{
			_currentWidth = tween.getValue( "width" );
			_currentHeight = tween.getValue( "height" );
			_currentX = tween.getValue( "x" );
			_currentY = tween.getValue( "y" );
			
			if ( dialog.hasEventListener( DialogEvent.UPDATE ))
			{
				dialog.dispatchEvent( new DialogEvent( DialogEvent.UPDATE ));
			}
		}
	}
}