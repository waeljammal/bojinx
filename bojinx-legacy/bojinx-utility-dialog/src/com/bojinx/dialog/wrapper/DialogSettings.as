package com.bojinx.dialog.wrapper
{
	import com.bojinx.dialog.layout.DialogPosition;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	
	public class DialogSettings extends EventDispatcher
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		public var alwaysOnTop:Boolean = false;
		
		public var animateHorizontalPosition:Boolean = true;
		
		public var animateOnOwnerResize:Boolean = false;
		
		public var animateVerticalPosition:Boolean = true;
		
		public var autoResizeToContent:Boolean = false;
		
		private var _bindTo:Sprite;
		
		public function get bindTo():Sprite
		{
			return _bindTo;
		}
		
		public function set bindTo( value:Sprite ):void
		{
			if ( value != _bindTo )
			{
				_bindTo = value;
			}
		}
		
		public var bindToAnchor:String = DialogPosition.CENTRE;
		
		public var bounds:Rectangle;
		
		public var bringToFrontOnClick:Boolean = false;
		
		private var _content:Sprite;
		
		public function get content():Sprite
		{
			return _content;
		}
		
		public function set content( value:Sprite ):void
		{
			if ( _content != value )
			{
				prevContent = _content;
				_content = value;
				contentChanged = true;
			}
		}
		
		public var contentFadeDuration:Number = .3;
		
		public var dialogAnchor:String = DialogPosition.CENTRE;
		
		public var draggable:Boolean = false;
		
		public var duration:Number = 1;
		
		public var easeInWindowFunction:Function;
		
		public var easeMoveFunction:Function;
		
		public var easeOutWindowFunction:Function;
		
		public var easeResizeFunction:Function;
		
		public var fadeContent:Boolean = false;
		
		public var fromAlpha:Number = 1;
		
		public var height:Number = NaN;
		
		public var hideContentOnAnimate:Boolean = true;
		
		public var hideDuration:Number = 1;
		
		public var horizontalScrollPosition:Number = 0;
		
		public var lockHeight:Boolean = false;
		
		public var lockWidth:Boolean = false;
		
		public var modalStyleName:String = "modalStyle";
		
		public var moveHPositionBeforeAnimating:Boolean = false;
		
		public var moveVPositionBeforeAnimating:Boolean = false;
		
		public var offSetX:Number = 0;
		
		public var offSetY:Number = 0;
		
		public var requiresFocus:Boolean = true;
		
		public var resizeToContent:Boolean;
		
		private var _styleName:String;
		
		public function get styleName():String
		{
			return _styleName;
		}
		
		public function set styleName( value:String ):void
		{
			_styleName = value;
		}
		
		public var toAlpha:Number = 1;
		
		public var verticalScrollPosition:Number = 0;
		
		public var width:Number = NaN;
		
		/*============================================================================*/
		/*= PROTECTED PROPERTIES                                                      */
		/*============================================================================*/
		
		protected var contentChanged:Boolean;
		
		protected var prevContent:Sprite;
		
		public function DialogSettings()
		{
		}
	}
}
