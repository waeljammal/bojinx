package com.bojinx.dialog.util
{
	import com.bojinx.dialog.layout.DialogPosition;
	import com.bojinx.dialog.wrapper.DialogData;
	import flash.geom.Point;
	import org.as3commons.ui.layer.placement.PlacementAnchor;
	
	public class TranslateUtil
	{
		public function TranslateUtil()
		{
		}
		
		
		/*============================================================================*/
		/*= STATIC PRIVATE PROPERTIES                                                 */
		/*============================================================================*/
		
		private static var offset:Point;
		
		
		/*============================================================================*/
		/*= STATIC PUBLIC METHODS                                                     */
		/*============================================================================*/
		
		public static function translateAnchor( dialogAnchor:String ):uint
		{
			switch ( dialogAnchor )
			{
				case DialogPosition.BOTTOM_LEFT:
					return PlacementAnchor.BOTTOM_LEFT;
					break;
				case DialogPosition.BOTTOM_MIDDLE:
					return PlacementAnchor.BOTTOM;
					break;
				case DialogPosition.BOTTOM_RIGHT:
					return PlacementAnchor.BOTTOM_RIGHT;
					break;
				case DialogPosition.CENTRE:
					return PlacementAnchor.CENTER;
					break;
				case DialogPosition.LEFT_MIDDLE:
					return PlacementAnchor.LEFT;
					break;
				case DialogPosition.NONE:
					return PlacementAnchor.TOP_LEFT;
					break;
				case DialogPosition.RIGHT_MIDDLE:
					return PlacementAnchor.RIGHT;
					break;
				case DialogPosition.TOP_LEFT:
					return PlacementAnchor.TOP_LEFT;
					break;
				case DialogPosition.TOP_MIDDLE:
					return PlacementAnchor.TOP;
					break;
				case DialogPosition.TOP_RIGHT:
					return PlacementAnchor.TOP_RIGHT;
					break;
				default:
					throw new Error( "Unknown Dialog Anchor " + dialogAnchor );
			}
		}
		
		public static function updateNoLockOffset( dialogAnchor:String, width:Number, height:Number ):Point
		{
			var offset:Point = new Point();
			
			switch ( dialogAnchor )
			{
				case DialogPosition.BOTTOM_LEFT:
					offset.x = 0
					offset.y = ( height );
					break;
				case DialogPosition.BOTTOM_MIDDLE:
					offset.x = ( width / 2 );
					offset.y = ( height );
					break;
				case DialogPosition.BOTTOM_RIGHT:
					offset.x = ( width );
					offset.y = ( height );
					break;
				case DialogPosition.CENTRE:
					offset.x = ( width / 2 );
					offset.y = ( height / 2 );
					break;
				case DialogPosition.LEFT_MIDDLE:
					offset.x = 0;
					offset.y = ( height / 2 );
					break;
				case DialogPosition.NONE:
					break;
				case DialogPosition.RIGHT_MIDDLE:
					offset.x = width;
					offset.y = height / 2;
					break;
				case DialogPosition.TOP_LEFT:
					offset.x = 0;
					offset.y = 0;
					break;
				case DialogPosition.TOP_MIDDLE:
					offset.x = width / 2;
					offset.y = 0;
					break;
				case DialogPosition.TOP_RIGHT:
					offset.x = width;
					offset.y = 0;
					break;
				default:
					throw new Error( "Unknown Dialog Anchor " + dialogAnchor );
			}
			
			return offset;
		}
		
		public static function updateOffset( dialogAnchor:String, data:DialogData ):Point
		{
			if ( !offset )
			{
				offset = new Point();
			}
			
			switch ( dialogAnchor )
			{
				case DialogPosition.BOTTOM_LEFT:
					
					offset.x = 0
					
					if ( !data.dialog.lockHeight )
						offset.y = ( data.dialog.height );
					else
						offset.y = 0;
					
					break;
				case DialogPosition.BOTTOM_MIDDLE:
					
					if ( !data.dialog.lockWidth )
						offset.x = ( data.dialog.width / 2 );
					else
						offset.x = 0;
					
					if ( !data.dialog.lockHeight )
						offset.y = ( data.dialog.height );
					else
						offset.y = 0;
					
					break;
				case DialogPosition.BOTTOM_RIGHT:
					
					if ( !data.dialog.lockWidth )
						offset.x = ( data.dialog.width );
					else
						offset.x = 0;
					
					if ( !data.dialog.lockHeight )
						offset.y = ( data.dialog.height );
					else
						offset.y = 0;
					
					break;
				case DialogPosition.CENTRE:
					
					if ( !data.dialog.lockWidth )
						offset.x = ( data.dialog.width / 2 );
					else
						offset.x = 0;
					
					if ( !data.dialog.lockHeight )
						offset.y = ( data.dialog.height / 2 );
					else
						offset.y = 0;
					
					break;
				case DialogPosition.LEFT_MIDDLE:
					
					offset.x = 0;
					
					if ( !data.dialog.lockHeight )
						offset.y = ( data.dialog.height / 2 );
					else
						offset.y = 0;
					
					break;
				case DialogPosition.NONE:
					break;
				case DialogPosition.RIGHT_MIDDLE:
					
					if ( !data.dialog.lockWidth )
						offset.x = data.dialog.width;
					else
						offset.x = 0;
					
					if ( !data.dialog.lockHeight )
						offset.y = data.dialog.height / 2;
					else
						offset.y = 0;
					
					break;
				case DialogPosition.TOP_LEFT:
					offset.x = 0;
					offset.y = 0;
					break;
				case DialogPosition.TOP_MIDDLE:
					
					if ( !data.dialog.lockWidth )
						offset.x = data.dialog.width / 2;
					else
						offset.x = 0;
					
					offset.y = 0;
					
					break;
				case DialogPosition.TOP_RIGHT:
					
					if ( !data.dialog.lockWidth )
						offset.x = data.dialog.width;
					else
						offset.x = 0;
					
					offset.y = 0;
					
					break;
				default:
					throw new Error( "Unknown Dialog Anchor " + dialogAnchor );
			}
			
			return offset;
		}
	}
}