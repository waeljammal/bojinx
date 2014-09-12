/*
   Copyright (c) 2007 Ultraweb Development

   This file is part of Bojinx.

   Bojinx is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   Bojinx is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with Bojinx.  If not, see <http://www.gnu.org/licenses/>.

   Pointer code taken from http://anotherflexdev.blogspot.com
 */
package com.bojinx.dialog.ui
{
	import com.bojinx.dialog.DialogEvent;
	import com.bojinx.dialog.IDialog;
	import com.bojinx.dialog.IDialogAware;
	import com.bojinx.dialog.layout.DialogPosition;
	import com.bojinx.dialog.util.Bubble;
	import com.bojinx.dialog.util.TranslateUtil;
	import com.bojinx.dialog.wrapper.Dialog;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import mx.core.FlexGlobals;
	import mx.events.MoveEvent;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.IStyleManager2;
	import mx.styles.StyleManager;
	import org.as3commons.ui.layer.Placement;
	import spark.components.SkinnableContainer;
	import spark.skins.*;
	
	[Style( name = "backgroundAlphas", type = "Array", format = "Number", inherit = "no" )]
	[Style( name = "backgroundColors", type = "Array", format = "Color", inherit = "no" )]
	[Style( name = "backgroundRatios", type = "Array", format = "Number", inherit = "no" )]
	[Style( name = "borderAlpha", type = "Number", format = "Length", inherit = "no" )]
	[Style( name = "borderColor", type = "uint", format = "Color", inherit = "no" )]
	[Style( name = "borderThickness", type = "Number", format = "Length", inherit = "no" )]
	[Style( name = "cornerRadius", type = "Number", format = "Length", inherit = "no" )]
	[Style( name = "distance", type = "Number", format = "Length", inherit = "no" )]
	[Style( name = "legPoint", type = "String", arrayType = "String", inherit = "no" )]
	[Style( name = "legSize", type = "Number", format = "Length", inherit = "no" )]
	/**
	 * <p>A skinnable dialog container that will hold content
	 * for the dialog plugin.</p>
	 *
	 * <p>You can replace this class with your own, you will need
	 * to implement the <code>IDialogWindow</code> interface to use
	 * it with the manager. You can also extend this class to save time.</p>
	 *
	 * <p><b>Note:</b> This container is not currently draggable.</p>
	 *
	 * <p>Default skin: <code>com.bojinx.plugins.dialog.DialogSkinnableWindowSkin</code></p>
	 *
	 * @manifest
	 * @see com.bojinx.plugins.dialog.DialogSkinnableWindowSkin
	 * @author wael
	 * @since Jul 6, 2009
	 */
	public class DialogBubbleWindow extends SkinnableContainer implements IDialogAware
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
		
		private var _dragEnabled:Boolean;
		
		/** @private */
		public function get dragEnabled():Boolean
		{
			return _dragEnabled;
		}
		
		/**
		 * <p>Sets the draggable state</p>
		 */
		public function set dragEnabled( value:Boolean ):void
		{
			_dragEnabled = value;
		}
		
		public var session:Dialog;
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var _complete:Boolean = false;
		
		private var contentChanged:Boolean = false;
		
		private var mo:Number = 0;
		
		private var position:Placement = new Placement();
		
		private var useOffset:Point = new Point();
		
		/** @private */
		public function DialogBubbleWindow()
		{
			super();
			
			addEventListener( MoveEvent.MOVE, onMove );
		}
		
		
		/*============================================================================*/
		/*= STATIC PRIVATE PROPERTIES                                                 */
		/*============================================================================*/
		
		private static var stylesInited:Boolean = initStyles();
		
		
		/*============================================================================*/
		/*= STATIC PRIVATE METHODS                                                    */
		/*============================================================================*/
		
		/**
		 * Default Style
		 */
		private static function initStyles():Boolean
		{
			var sm:IStyleManager2 = StyleManager.getStyleManager( null );
			var selector:CSSStyleDeclaration =
				sm.getStyleDeclaration( "com.bojinx.dialog.ui.DialogBubbleWindow" );
			
			if ( !selector )
			{
				selector = new CSSStyleDeclaration();
				sm.setStyleDeclaration( "com.bojinx.dialog.ui.DialogBubbleWindow", selector, true );
			}
			
			selector.defaultFactory = function():void
			{
				this.skinClass = DialogBubbleWindowSkin;
				this.borderColor = 0XCCCCCC;
				this.backgroundColor = 0XCCCCCC;
				this.alpha = 1;
				this.borderThickness = 1;
				this.backgroundAlpha = 1;
				this.borderAlpha = 1;
				this.legSize = 10;
				this.cornerRadius = 10;
				this.legPoint = [ "L20", "L-10" ];
				this.color = 0XFFFFFF;
			}
			
			return true;
		}
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function dialogChanged( session:Dialog ):void
		{
			var legSize:Number = getStyle( "legSize" );
			var l1:Number;
			var l2:Number;
			var distance:Number = getStyle( "distance" );
			
			this.session = session;
			
			if ( isNaN( legSize ))
			{
				legSize = 10;
			}
			
			if ( isNaN( distance ))
			{
				distance = 10;
			}
			
			if ( _dialog.bindTo )
			{
				l1 = 10;
				l2 = 20;
				
//				setStyle( "legPoint", [ "L" + l1, "L" + l2 ]);
			}
		}
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		protected function onUpdate( event:Event = null ):void
		{
			useOffset.x = _dialog.offSetX;
			useOffset.y = _dialog.offSetY;
			doUpdate();
		}
		
		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
		{
			onUpdate();
			
			super.updateDisplayList( unscaledWidth, unscaledHeight );
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function doUpdate():void
		{
			var offset:Point = TranslateUtil.updateNoLockOffset( _dialog.dialogAnchor, _dialog.window.width + useOffset.x, _dialog.window.height + useOffset.y );
			var offset2:Point = TranslateUtil.updateNoLockOffset( _dialog.bindToAnchor, _dialog.bindTo.width + useOffset.x, _dialog.bindTo.height + useOffset.y );
			
			var distance:Number = getStyle( "distance" );
			var L1:Number = 0;
			var L2:Number = 0;
			
//			if ( isNaN( distance ))
//			{
			distance = 15;
//			}
			
//			var pos:Placement = new Placement( this, _dialog.bindTo );
//			pos.layerAnchor = TranslateUtil.translateAnchor( _dialog.bindToAnchor );
//			pos.sourceAnchor = TranslateUtil.translateAnchor( _dialog.dialogAnchor );
//			pos.place( false );
			
			// The point on a global scale
			// Ie: If binding anchor is none this would be the
			// top left of the owner (0,0) on a global scale.
			var bindPoint:Point = _dialog.bindTo.localToGlobal( offset );
			var dialogPoint:Point = _dialog.window.localToGlobal( offset );
			
			switch ( _dialog.dialogAnchor )
			{
				case DialogPosition.BOTTOM_MIDDLE:
					L1 = ( bindPoint.x - dialogPoint.x + offset2.x );
					L2 = ( bindPoint.y - dialogPoint.y + offset2.y );
					break;
				case DialogPosition.BOTTOM_RIGHT:
					L1 = ( bindPoint.x - dialogPoint.x + offset2.x - distance );
					L2 = ( bindPoint.y - dialogPoint.y );
					break;
				case DialogPosition.BOTTOM_LEFT:
					L1 = ( bindPoint.x - dialogPoint.x + offset2.x + ( distance ));
					L2 = ( bindPoint.y - dialogPoint.y + offset2.y - ( distance ));
					break;
				case DialogPosition.CENTRE:
					L1 = 0;
					L2 = 0;
					break;
				case DialogPosition.LEFT_MIDDLE:
					L1 = ( bindPoint.x - dialogPoint.x + offset2.x - distance );
					L2 = ( bindPoint.y - dialogPoint.y + offset2.y );
					break;
				case DialogPosition.RIGHT_MIDDLE:
					L1 = ( bindPoint.x - dialogPoint.x + offset2.x );
					L2 = ( bindPoint.y - dialogPoint.y + offset2.y - distance );
					break;
				case DialogPosition.TOP_LEFT:
					L1 = ( bindPoint.x - dialogPoint.x + distance );
					L2 = ( bindPoint.y - dialogPoint.y + ( distance * 2 ));
					break;
				case DialogPosition.TOP_MIDDLE:
					L1 = ( bindPoint.x - dialogPoint.x + offset2.x );
					L2 = ( bindPoint.y - dialogPoint.y + offset2.y + distance );
					break;
				case DialogPosition.TOP_RIGHT:
					L1 = ( bindPoint.x - dialogPoint.x );
					L2 = ( bindPoint.y - dialogPoint.y );
					break;
			}
			
			if ( height > 20 && width > 20 )
			{
				setStyle( "legPoint", [ "L" + L1, "L" + L2 ]);
			}
			else
			{
				setStyle( "legPoint", [ "L" + 0, "L" + 0 ]);
			}
			
			if ( skin )
			{
				var g:Graphics;
				var borderThickness:Number = getStyle( "borderThickness" );
				var legSize:Number = getStyle( "legSize" );
				var cornerRadius:Number = getStyle( "cornerRadius" );
				var backgroundColours:Array = getStyle( "backgroundColors" );
				var backgroundAlphas:Array = getStyle( "backgroundAlphas" );
				var backgroundRatios:Array = getStyle( "backgroundRatios" );
				var borderColor:Number = getStyle( "borderColor" );
				
				g = skin.graphics;
				var m:Matrix = new Matrix();
				m.createGradientBox( 200, 100, 90 * Math.PI / 180, 80, 80 );
				g.clear();
				g.lineStyle( borderThickness, borderColor, 1, true );
				g.beginGradientFill( GradientType.LINEAR, backgroundColours, backgroundAlphas, backgroundRatios, m );
				Bubble.drawSpeechBubble( this.skin, new Rectangle( 0, 0, width, height ), 5, new Point( L1, L2 ));
				g.endFill();
				
//				g = FlexGlobals.topLevelApplication.skin.grp.graphics;
//				g.beginFill( 0XFF0000, 1 );
//				g.drawCircle( L1, L2, 5 );
//				g.endFill();
				
			}
		}
		
		private function onMove( event:MoveEvent ):void
		{
			useOffset.x = 0;
			useOffset.y = 0;
			doUpdate();
		}
	}
}
