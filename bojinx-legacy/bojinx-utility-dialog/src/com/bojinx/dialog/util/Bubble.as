package com.bojinx.dialog.util
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Bubble
	{
		public function Bubble()
		{
		}
		
		
		/*============================================================================*/
		/*= STATIC PUBLIC METHODS                                                     */
		/*============================================================================*/
		
		public static function drawSpeechBubble( target:Sprite, rect:Rectangle, cornerRadius:Number,
												 point:Point ):void
		{
			var g:Graphics = target.graphics;
			var r:Number = cornerRadius;
			
			var x:Number = rect.x;
			var y:Number = rect.y;
			var w:Number = rect.width;
			var h:Number = rect.height;
			var px:Number = point.x;
			var py:Number = point.y;
			var min_gap:Number = 20;
			var hgap:Number = 30; //Math.min( w - r - r, Math.max( min_gap, w / 5 ));
			
			var left:Number = px <= x + w / 2 ?
				( Math.max( x + r, px - ( hgap / 2 )))
				: ( Math.min( x + w - r - ( hgap / 2 ), px - ( hgap / 2 )));
			
			var right:Number = px <= x + w / 2 ?
				( Math.max( x + r + ( hgap / 2 ), px + ( hgap / 2 )))
				: ( Math.min( x + w - r + ( hgap / 2 ), px + ( hgap / 2 )));
			
			var vgap:Number = 30;
			
			var top:Number = py < y + h / 2 ?
				Math.max( y + r, py - ( vgap / 2 ))
				: Math.min( y + h - r - ( vgap / 2 ), py - ( vgap / 2 ));
			
			var bottom:Number = py < y + h / 2 ?
				Math.max( y + r + ( vgap / 2 ), py + ( vgap / 2 ))
				: Math.min( y + h - r, py + ( vgap / 2 ));
			
			//bottom right corner
			var a:Number = r - ( r * 0.707106781186547 );
			var s:Number = r - ( r * 0.414213562373095 );
			
			g.moveTo( x + w, y + h - r );
			
			if ( r > 0 )
			{
				if ( px > x + w - r && py > y + h - r && Math.abs(( px - x - w ) - ( py - y - h )) <=
					r )
				{
					g.lineTo( px, py );
					g.lineTo( x + w - r, y + h );
				}
				else
				{
					g.curveTo( x + w, y + h - s, x + w - a, y + h - a );
					g.curveTo( x + w - s, y + h, x + w - r, y + h );
				}
			}
			
			if ( py > y + h && ( px - x - w ) < ( py - y - h - r ) && ( py - y - h - r ) > ( x - px ))
			{
				// bottom edge
				g.lineTo( right, y + h );
				g.lineTo( px, py );
				g.lineTo( left, y + h );
			}
			
			g.lineTo( x + r, y + h );
			
			//bottom left corner
			if ( r > 0 )
			{
				if ( px < x + r && py > y + h - r && Math.abs(( px - x ) + ( py - y - h )) <= r )
				{
					g.lineTo( px, py );
					g.lineTo( x, y + h - r );
				}
				else
				{
					g.curveTo( x + s, y + h, x + a, y + h - a );
					g.curveTo( x, y + h - s, x, y + h - r );
				}
			}
			
			if ( px < x && ( py - y - h + r ) < ( x - px ) && ( px - x ) < ( py - y - r ))
			{
				// left edge
				g.lineTo( x, bottom );
				g.lineTo( px, py );
				g.lineTo( x, top );
			}
			
			g.lineTo( x, y + r );
			
			//top left corner
			if ( r > 0 )
			{
				if ( px < x + r && py < y + r && Math.abs(( px - x ) - ( py - y )) <= r )
				{
					g.lineTo( px, py );
					g.lineTo( x + r, y );
				}
				else
				{
					g.curveTo( x, y + s, x + a, y + a );
					g.curveTo( x + s, y, x + r, y );
				}
			}
			
			if ( py < y && ( px - x ) > ( py - y + r ) && ( py - y + r ) < ( x - px + w ))
			{
				//top edge
				g.lineTo( left, y );
				g.lineTo( px, py );
				g.lineTo( right, y );
			}
			
			g.lineTo( x + w - r, y );
			
			//top right corner
			if ( r > 0 )
			{
				if ( px > x + w - r && py < y + r && Math.abs(( px - x - w ) + ( py - y )) <= r )
				{
					g.lineTo( px, py );
					g.lineTo( x + w, y + r );
				}
				else
				{
					g.curveTo( x + w - s, y, x + w - a, y + a );
					g.curveTo( x + w, y + s, x + w, y + r );
				}
			}
			
			if ( px > x + w && ( py - y - r ) > ( x - px + w ) && ( px - x - w ) > ( py - y - h + r ))
			{
				// right edge
				g.lineTo( x + w, top );
				g.lineTo( px, py );
				g.lineTo( x + w, bottom );
			}
			g.lineTo( x + w, y + h - r );
		
		}
	}
}
