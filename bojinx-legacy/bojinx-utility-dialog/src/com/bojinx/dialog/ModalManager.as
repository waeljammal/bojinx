package com.bojinx.dialog
{
	import com.bojinx.dialog.wrapper.Dialog;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.GTweener;
	import com.gskinner.motion.plugins.BlurPlugin;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.utils.getDefinitionByName;
	import mx.core.IChildList;
	import mx.effects.Blur;
	import mx.managers.ISystemManager;
	import mx.managers.SystemManager;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.IStyleManager2;
	import mx.styles.StyleManager;
	import org.as3commons.ui.layer.Placement;
	import org.as3commons.ui.layer.placement.PlacementAnchor;
	
	/**
	 * @Manifest
	 */
	public class ModalManager
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _isVisible:Boolean = false;
		
		public function get isVisible():Boolean
		{
			return _isVisible;
		}
		
		private var _sprite:Sprite;
		
		public function get sprite():Sprite
		{
			return _sprite;
		}
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var blur:Blur;
		
		private var filter:BlurFilter;
		
		private var layer:Object;
		
		private var owner:Dialog;
		
		private var position:Placement;
		
		private var sm:Object;
		
		private var target:Sprite;
		
		public function ModalManager( owner:Dialog )
		{
			this.owner = owner;
		}
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function dispose():void
		{
			if ( owner )
			{
				owner.data.attachTo.removeEventListener( "resize", onResize );
				owner.data.attachTo.removeEventListener( "move", onResize );
			}
			
			if ( sprite )
			{
				IChildList( layer ).removeChild( sprite );
			}
			
			_sprite = null;
			position = null;
			_isVisible = false;
			
			if ( owner && owner.factory )
				owner.factory.updateAllWindowDepths();
			
			owner = null;
		}
		
		public function draw( first:Boolean = false ):void
		{
			if(!sprite)
				return;
			
			position.place( false );
			
			var fillColor:uint = 0XFFFFFF;
			var fillAlpha:Number = .7;
			var cornerRadius:Number = 0;
			var duration:Number = 0.1;
			var blurX:Number = 0;
			var blurY:Number = 0;
			var blurQuality:int = 1;
			var animated:Boolean = false;
			
			if ( target.hasOwnProperty( "moduleFactory" ))
			{
				var sm:IStyleManager2 = StyleManager.getStyleManager( target[ "moduleFactory" ]);
				var style:CSSStyleDeclaration = sm.getStyleDeclaration( "." + owner.modalStyleName );
				
				if ( style && style.getStyle( "backgroundColor" ) != null )
					fillColor = style.getStyle( "backgroundColor" );
				
				if ( style && style.getStyle( "backgroundAlpha" ) != null )
					fillAlpha = style.getStyle( "backgroundAlpha" );
				
				if ( style && style.getStyle( "cornerRadius" ) != null )
					cornerRadius = style.getStyle( "cornerRadius" );
				
				if ( style && style.getStyle( "duration" ) != null )
					duration = style.getStyle( "duration" );
				
				if ( style && style.getStyle( "blurQuality" ) != null )
					blurQuality = style.getStyle( "blurQuality" );
				
				if ( style && style.getStyle( "blurX" ) != null )
					blurX = style.getStyle( "blurX" );
				
				if ( style && style.getStyle( "blurY" ) != null )
					blurY = style.getStyle( "blurY" );
				
				if ( style && style.getStyle( "animated" ) != null )
					animated = style.getStyle( "animated" );
			}
			
			
			if ( !first && animated )
				animated = false;
			
			var g:Graphics = sprite.graphics;
			g.clear();
			g.beginFill( fillColor, fillAlpha );
			g.drawRoundRect( position.layerLocal.x, position.layerLocal.y, target.width, target.height, cornerRadius, cornerRadius );
			
//			g.endFill();
			
			if ( !animated )
			{
				if ( !filter )
					filter = new BlurFilter( blurX, blurY );
				
				filter.blurX = blurX;
				filter.blurY = blurY;
				filter.quality = blurQuality;
				
				if ( sprite.filters.length == 0 )
					sprite.filters = [ filter ];
			}
			else if ( first )
			{
				BlurPlugin.install();
				sprite.alpha = 0;
				
				GTweener.to( sprite, duration, { blurX: blurX, blurY: blurY, alpha: fillAlpha });
			}
		}
		
		public function hide():void
		{
			if ( sprite && sprite.parent )
			{
				sprite.visible = false;
			}
		}
		
		public function show( target:Sprite, sm:Object ):void
		{
			if ( sprite )
			{
				sprite.visible = true;
				return;
			}
			
			this.target = target;
			this.sm = sm;
			
			doShow();
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function doShow():void
		{
			_isVisible = true;
			
			var element:Class = getDefinitionByName( "mx.core.IVisualElement" ) as Class;
			var index:int = 0;
			var type:Class = getDefinitionByName( "mx.managers.SystemManager" ) as Class;
			var nextChild:DisplayObject;
			var first:Boolean = false;
			
			if ( !sprite )
			{
				layer = owner.root;
				
				_sprite = new Sprite();
				position = new Placement( target, sprite );
				position.sourceAnchor = PlacementAnchor.TOP_LEFT;
				position.layerAnchor = PlacementAnchor.TOP_LEFT;
				first = true;
			}
			
			IChildList( layer ).addChild( sprite );
			owner.factory.updateAllWindowDepths();
			setIndex();
			
			owner.data.attachTo.addEventListener( "resize", onResize );
			owner.data.attachTo.addEventListener( "move", onResize );
			
			draw( first );
		}
		
		private function onResize( event:Event ):void
		{
			draw();
		}
		
		private function setIndex():void
		{
			if ( owner.index == 1 )
			{
				sprite.parent.setChildIndex( sprite, 1 );
			}
			else
			{
				sprite.parent.setChildIndex( sprite, owner.index - 1 );
			}
		}
	}
}
