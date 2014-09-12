package com.bojinx.dialog.effects
{
	import com.bojinx.dialog.DialogEvent;
	import com.bojinx.dialog.util.TranslateUtil;
	import com.bojinx.dialog.wrapper.Dialog;
	import com.bojinx.dialog.wrapper.DialogData;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.GTweenTimeline;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	
	import org.as3commons.ui.layer.Placement;
	
	public class DialogEffects extends EventDispatcher
	{
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var animateOnRetry:Boolean;
		
		private var bindingChanged:Boolean;
		
		private var currentBinding:Sprite;
		
		private var currentPosition:Point;
		
		private var data:DialogData;
		
		private var isAnimateEffect:Boolean;
		
		private var isBoundDialogReady:Boolean = false;
		
		private var isFirstShowing:Boolean;
		
		private var isHideEffect:Boolean;
		
		private var isResize:Boolean;
		
		private var isResizeEffect:Boolean;
		
		private var isShowEffect:Boolean;
		
		private var lastVisibleState:Boolean;
		
		private var offset:Point;
		
		private var position:Placement;
		
		private var startedResizingAt:Number;
		
		public function DialogEffects( data:DialogData )
		{
			this.data = data;
			
			if ( !position )
			{
				position = new Placement();
				position.offset = new Point();
			}
		}
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function animate( animate:Boolean, firstStart:Boolean = false ):void
		{
			var dialog:Dialog = data.dialog;
			var window:Sprite = dialog.window;
			
			checkBinding();
			
			if ( !isBoundDialogReady && checkBoundForDialog())
			{
				animateOnRetry = animate;
				return;
			}
			
			isHideEffect = false;
			isShowEffect = false;
			isAnimateEffect = true;
			isFirstShowing = firstStart;
			
			if ( dialog.isVisible )
				data.dialog.window.visible = true;
			
			if ( firstStart || dialog.hideContentOnAnimate )
				hideContent();
			
			if ( firstStart )
			{
				setFirstStartPosition();
			}
			else
			{
				captureEndPoint();
			}
			
			updateTween( dialog.width, dialog.height,
						 data.dialog.toAlpha, data.dialog.duration,
						 firstStart, data.dialog.easeOutWindowFunction,
						 onTweenComplete, true, animate );
			
			isFirstShowing = false;
		}
		
		public function playHideEffect( animate:Boolean ):void
		{
			var dialog:Dialog = data.dialog;
			var window:Sprite = dialog.window;
			
			hideContent();
			isHideEffect = true;
			isShowEffect = false;
			isAnimateEffect = false;
			updateCurrentSize();
			captureStartPoint();
			lastVisibleState = false;
			
			var useHeight:Number = data.startHeight;
			var useWidth:Number = data.startWidth;
			
			if ( dialog.lockHeight )
			{
				useHeight = dialog.height;
			}
			
			if ( dialog.lockWidth )
			{
				useWidth = dialog.width;
			}
			
			updateTween( useWidth, useHeight,
						 data.dialog.fromAlpha, data.dialog.hideDuration,
						 false, data.dialog.easeInWindowFunction, onDialogHidden,
						 true, animate );
		}
		
		public function playShowEffect( animate:Boolean ):void
		{
			var dialog:Dialog = data.dialog;
			var window:Sprite = dialog.window;
			
			hideContent();
			isHideEffect = false;
			isShowEffect = true;
			isAnimateEffect = false;
			
			updateForShowAndResize();
			
			var useHeight:Number = dialog.height;
			var useWidth:Number = dialog.width;
			
			data.dialog.window.visible = true;
			
			updateTween( useWidth, useHeight,
						 data.dialog.toAlpha, data.dialog.duration,
						 false, data.dialog.easeOutWindowFunction,
						 onTweenComplete, true, animate );
			
			lastVisibleState = true;
		}
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		protected function onMove( event:Event ):void
		{
			animate( true );
		}
		
		protected function onOwnerResized( event:Event ):void
		{
			isResize = true;
			animate( data.dialog.animateOnOwnerResize, false );
			
			startedResizingAt = getTimer();
			data.attachTo.addEventListener( Event.ENTER_FRAME, onEnterFrame );
		}
		
		protected function onResize( event:Event ):void
		{
			var dialog:Dialog = data.dialog;
			var window:Sprite = dialog.window;
			
			dialog.width = dialog.content.width;
			dialog.height = dialog.content.height;
			
			if ( isShowEffect )
			{
				updateForShowAndResize();
				window.x = currentPosition.x + offset.x;
				window.y = currentPosition.y + offset.y;
			}
			else
			{
				isAnimateEffect = true;
				captureEndPoint();
			}
			
			hideContent();
			
			isResizeEffect = true;
			
			updateTween( dialog.width, dialog.height,
						 data.dialog.toAlpha, data.dialog.duration,
						 false, data.dialog.easeResizeFunction,
						 onTweenComplete, false, true );
			
			isResizeEffect = false;
		}
		
		protected function updateTween( w:Number, h:Number, alpha:Number,
										duration:Number, useOffset:Boolean,
										ease:Function, onComplete:Function,
										lock:Boolean, animate:Boolean ):void
		{
			var dialog:Dialog = data.dialog;
			var window:Sprite = dialog.window;
			
			
			if ( !animate )
			{
				window.width = w;
				window.height = h;
				updateTweenPosition( tween, useOffset, animate );
				showContent();
				
				return;
			}
			
			var tween:GTweenTimeline = data.tween;
			tween.paused = true;
			tween.duration = duration;
			tween.target = data.dialog.window;
			tween.onComplete = onComplete;
			
			updateTweenPosition( tween, useOffset, animate );
			
			if ( dialog.lockHeight && lock )
			{
				tween.setValue( "height", h );
				
				if ( dialog.content )
					data.dialog.window.height = data.startHeight;
				else
					data.dialog.window.height = dialog.height;
				
			}
			else
			{
				tween.setValue( "height", h );
			}
			
			if ( dialog.lockWidth && lock )
			{
				tween.setValue( "width", w );
				data.dialog.window.width = data.startWidth;
			}
			else
			{
				tween.setValue( "width", w );
			}
			
			tween.setValue( "alpha", alpha );
			
			if ( ease is Function )
				tween.ease = ease;
			else
				tween.ease = GTween.defaultEase;
			
			tween.paused = false;
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function addListeners():void
		{
			if ( data.dialog.content &&
				data.dialog.autoResizeToContent && data.dialog.resizeToContent )
			{
				data.dialog.content.addEventListener( Event.RESIZE, onResize );
			}
			
			if ( data.dialog.bindTo )
			{
				data.dialog.bindTo.addEventListener( "move", onMove );
			}
			
			data.attachTo.addEventListener( "resize", onOwnerResized );
		}
		
		private function captureEndPoint():void
		{
			var dialog:Dialog = data.dialog;
			var window:Sprite = dialog.window;
			
			if ( dialog.resizeToContent && dialog.content )
			{
				data.oldHeight = window.height;
				data.oldWidth = window.width;
				dialog.width = dialog.content.width;
				dialog.height = dialog.content.height;
				
				if ( dialog.lockHeight )
				{
					data.startHeight = dialog.content.height;
				}
				
				if ( dialog.lockWidth )
				{
					data.startWidth = dialog.content.width;
				}
			}
			else
			{
				data.oldHeight = window.height;
				data.oldWidth = window.width;
			}
			
			window.width = dialog.width;
			window.height = dialog.height;
			updatePosition();
			window.width = data.oldWidth;
			window.height = data.oldHeight;
		}
		
		private function captureStartPoint():void
		{
			var dialog:Dialog = data.dialog;
			var window:Sprite = dialog.window;
			
			data.oldHeight = window.height;
			data.oldWidth = window.width;
			window.width = dialog.lockWidth ? dialog.width : data.startWidth;
			window.height = dialog.lockHeight ? dialog.height : data.startHeight;
			updatePosition();
			window.width = data.oldWidth;
			window.height = data.oldHeight;
		}
		
		private function checkBinding():void
		{
			if ( data.dialog.bindTo != currentBinding )
			{
				if ( data.dialog.bindTo )
					isBoundDialogReady = false;
				
				if ( currentBinding != null )
					bindingChanged = true;
				
				currentBinding = data.dialog.bindTo;
			}
		}
		
		private function checkBoundForDialog():Boolean
		{
			var def:Object;
			
			try
			{
				def = getDefinitionByName( "com.bojinx.dialog.DialogFactory" );
				
				if ( !def )
				{
					def = getDefinitionByName( "com.bojinx.dialog.DialogFlashFactory" );
				}
			}
			catch ( e:Error )
			{
				// Ignore
			}
			
			if ( def )
			{
				var boundToDialog:Dialog = def.getDialogForWindow( data.dialog.bindTo );
				
				if ( boundToDialog )
				{
					boundToDialog.addEventListener( DialogEvent.EFFECT_COMPLETE, onBoundToReady );
					return true;
				}
			}
			
			return false
		}
		
		private function hideContent():void
		{
			var dialog:Dialog = data.dialog;
			var window:Sprite = dialog.window;
			
			if ( dialog.content )
				dialog.content.visible = false;
		}
		
		private function onBoundToReady( event:Event ):void
		{
			event.currentTarget.removeEventListener( DialogEvent.EFFECT_COMPLETE, onBoundToReady );
			isBoundDialogReady = true;
			animate( animateOnRetry, true );
		}
		
		private function onDialogHidden( tween:GTween ):void
		{
			data.dialog.dispatchEvent( new DialogEvent( DialogEvent.HIDE_COMPLETE ));
			data.dialog.dispatchEvent( new DialogEvent( DialogEvent.EFFECT_COMPLETE ));
			data.dialog.window.visible = false;
		}
		
		private function onEnterFrame( event:Event ):void
		{
			var next:Number = getTimer();
			
			if ( next - startedResizingAt > 1000 )
			{
				data.attachTo.removeEventListener( Event.ENTER_FRAME, onEnterFrame );
			}
			else
			{
				animate( data.dialog.animateOnOwnerResize );
			}
		}
		
		private function onTweenComplete( tween:GTween ):void
		{
			if ( isShowEffect )
			{
				data.dialog.dispatchEvent( new DialogEvent( DialogEvent.SHOW_COMPLETE ));
			}
			
			isHideEffect = false;
			isShowEffect = false;
			isAnimateEffect = false;
			addListeners();
			showContent();
			data.dialog.dispatchEvent( new DialogEvent( DialogEvent.EFFECT_COMPLETE ));
		
		}
		
		private function removeListeners():void
		{
			data.dialog.content.removeEventListener( Event.RESIZE, onResize );
		}
		
		private function setFirstStartPosition( resize:Boolean = true ):void
		{
			var dialog:Dialog = data.dialog;
			var window:Sprite = dialog.window;
			updateCurrentSize();
			
			if ( !isNaN( dialog.width ))
				data.oldWidth = dialog.width;
			else
				data.oldWidth = window.width;
			
			if ( !isNaN( dialog.height ))
				data.oldHeight = dialog.height;
			else
				data.oldHeight = window.height;
			
			
			if ( !dialog.lockHeight )
			{
				window.height = 0;
				data.startHeight = 0;
			}
			else
			{
				data.startHeight = data.oldHeight;
				window.height = data.startHeight;
			}
			
			if ( !dialog.lockWidth )
			{
				window.width = 0;
				data.startWidth = 0;
			}
			else
			{
				data.startWidth = data.oldWidth;
				window.width = data.startWidth;
			}
			
			updatePosition();
			window.x = currentPosition.x + dialog.offSetX;
			window.y = currentPosition.y + dialog.offSetY;
		}
		
		private function showContent():void
		{
			var dialog:Dialog = data.dialog;
			var window:Sprite = dialog.window;
			
			if ( dialog.content && dialog.isVisible )
				dialog.content.visible = true;
			
			if ( dialog.fadeContent && dialog.content.alpha == dialog.fromAlpha )
			{
//				var tween:GTweenTimeline = data.tween;
//				tween.duration = dialog.contentFadeDuration;
//				tween.target = data.dialog.content;
//				tween.setValue( "alpha", data.dialog.toAlpha );
			}
		}
		
		private function updateCurrentSize():void
		{
			var dialog:Dialog = data.dialog;
			var window:Sprite = dialog.window;
			
			if ( isNaN( dialog.width ))
				dialog.width = window.width;
			
			if ( isNaN( dialog.height ))
				dialog.height = window.height;
		
		}
		
		private function updateForShowAndResize():void
		{
			var dialog:Dialog = data.dialog;
			var window:Sprite = dialog.window;
			
			captureEndPoint();
			
			if ( lastVisibleState == false && dialog.moveVPositionBeforeAnimating )
			{
				window.y = currentPosition.y;
			}
			
			if ( lastVisibleState == false && dialog.moveHPositionBeforeAnimating )
			{
				window.x = currentPosition.x;
			}
			
			captureEndPoint();
		}
		
		
		private function updatePosition():void
		{
			var window:Sprite = data.dialog.window;
			var dialogAnchor:uint = TranslateUtil.translateAnchor( data.dialog.dialogAnchor );
			var ownerAnchor:uint = TranslateUtil.translateAnchor( data.dialog.bindToAnchor );
			
			offset = TranslateUtil.updateOffset( data.dialog.dialogAnchor, data );
			
			position.layer = data.dialog.window;
			position.source = data.dialog.bindTo ? data.dialog.bindTo : data.attachTo;
			position.layerAnchor = dialogAnchor;
			position.sourceAnchor = ownerAnchor;
			
			position.offset.y = -data.dialog.verticalScrollPosition;
			position.offset.x = -data.dialog.horizontalScrollPosition;
			
			position.place( false );
			
			currentPosition = position.layerLocal;
		}
		
		private function updateTweenPosition( tween:GTweenTimeline, useOffset:Boolean, animate:Boolean ):void
		{
			var dialog:Dialog = data.dialog;
			var window:Sprite = dialog.window;
			var ox:Number = useOffset ? offset.x : 0;
			var oy:Number = useOffset ? offset.y : 0;
			var y:Number = currentPosition.y + data.dialog.offSetY - oy;
			var x:Number = currentPosition.x + data.dialog.offSetX - ox;
			
			if ( dialog.animateVerticalPosition || isHideEffect )
			{
				if ( dialog.moveVPositionBeforeAnimating && isShowEffect )
				{
					window.y = y + offset.y;
				}
				
				if ( animate )
					tween.setValue( "y", y );
				else
					window.y = y;
			}
			else if ( isShowEffect && !dialog.animateVerticalPosition )
			{
				window.y = y + offset.y;
				
				if ( animate )
					tween.setValue( "y", y );
				else
					window.y = y;
			}
			else if ( isAnimateEffect )
			{
				if ( !isFirstShowing && !isResizeEffect )
				{
					window.y = y;
				}
				
				if ( animate )
					tween.setValue( "y", y );
				else
					window.y = y;
			}
			
			
			if ( dialog.animateHorizontalPosition || isHideEffect )
			{
				if ( dialog.moveHPositionBeforeAnimating && isShowEffect )
				{
					window.x = x + offset.x;
				}
				
				if ( animate )
					tween.setValue( "x", x );
				else
					window.x = x;
			}
			else if ( isShowEffect && !dialog.animateHorizontalPosition )
			{
				window.x = x + offset.x;
				
				if ( animate )
					tween.setValue( "x", x );
				else
					window.x = x;
			}
			else if ( isAnimateEffect )
			{
				if ( !isFirstShowing && !isResizeEffect )
				{
					window.x = x;
				}
				
				if ( animate )
					tween.setValue( "x", x );
				else
					window.x = x;
			}
		}
	}
}
