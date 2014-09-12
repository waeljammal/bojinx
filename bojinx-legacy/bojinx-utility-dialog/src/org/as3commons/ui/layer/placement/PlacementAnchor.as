package org.as3commons.ui.layer.placement
{
	import org.as3commons.ui.framework.core.as3commons_ui;
	
	/**
	 * Placement anchor constants.
	 *
	 * @author Jens Struwe 06.06.2011
	 */
	public class PlacementAnchor
	{
		
		use namespace as3commons_ui;
		
		
		/*============================================================================*/
		/*= STATIC PUBLIC PROPERTIES                                                  */
		/*============================================================================*/
		
		/**
		 * Bottom center.
		 */
		public static const BOTTOM:uint = 4 + 16;
		
		/**
		 * Bottom left.
		 */
		public static const BOTTOM_LEFT:uint = 4 + 8;
		
		/**
		 * Bottom right.
		 */
		public static const BOTTOM_RIGHT:uint = 4 + 32;
		
		/**
		 * Middle center.
		 */
		public static const CENTER:uint = 2 + 16;
		
		/**
		 * Middle left.
		 */
		public static const LEFT:uint = 2 + 8;
		
		/**
		 * Middle right.
		 */
		public static const RIGHT:uint = 2 + 32;
		
		/**
		 * Top center.
		 */
		public static const TOP:uint = 1 + 16;
		
		/**
		 * Top left.
		 */
		public static const TOP_LEFT:uint = 1 + 8;
		
		/**
		 * Top right.
		 */
		public static const TOP_RIGHT:uint = 1 + 32;
		
		/**
		 * Array of all placement anchors.
		 *
		 * <p>Useful for debugging pursoses.</p>
		 */
		public static const anchors:Array = [
			TOP_LEFT, TOP, TOP_RIGHT,
			LEFT, CENTER, RIGHT,
			BOTTOM_LEFT, BOTTOM, BOTTOM_RIGHT
			];
		
		/*============================================================================*/
		/*= STATIC INTERNAL PROPERTIES                                                */
		/*============================================================================*/
		
		/**
		 * Bottom.
		 */
		as3commons_ui static const POSITION_BOTTOM:uint = 4;
		
		/**
		 * Center.
		 */
		as3commons_ui static const POSITION_CENTER:uint = 16;
		
		/**
		 * Left.
		 */
		as3commons_ui static const POSITION_LEFT:uint = 8;
		
		/**
		 * Middle.
		 */
		as3commons_ui static const POSITION_MIDDLE:uint = 2;
		
		/**
		 * Right.
		 */
		as3commons_ui static const POSITION_RIGHT:uint = 32;
		
		/**
		 * Top.
		 */
		as3commons_ui static const POSITION_TOP:uint = 1;
		
		
		/*============================================================================*/
		/*= STATIC PUBLIC METHODS                                                     */
		/*============================================================================*/
		
		/**
		 * Tests if an anchor is a bottom anchor.
		 *
		 * @param anchor The anchor to test.
		 * @return <code>true</code> if the anchor is a bottom anchor.
		 */
		public static function isBottom( anchor:uint ):Boolean
		{
			return ( anchor & POSITION_BOTTOM ) == POSITION_BOTTOM;
		}
		
		/**
		 * Tests if an anchor is a center anchor.
		 *
		 * @param anchor The anchor to test.
		 * @return <code>true</code> if the anchor is a center anchor.
		 */
		public static function isCenter( anchor:uint ):Boolean
		{
			return ( anchor & POSITION_CENTER ) == POSITION_CENTER;
		}
		
		/**
		 * Tests if an anchor is a left anchor.
		 *
		 * @param anchor The anchor to test.
		 * @return <code>true</code> if the anchor is a left anchor.
		 */
		public static function isLeft( anchor:uint ):Boolean
		{
			return ( anchor & POSITION_LEFT ) == POSITION_LEFT;
		}
		
		/**
		 * Tests if an anchor is a middle anchor.
		 *
		 * @param anchor The anchor to test.
		 * @return <code>true</code> if the anchor is a middle anchor.
		 */
		public static function isMiddle( anchor:uint ):Boolean
		{
			return ( anchor & POSITION_MIDDLE ) == POSITION_MIDDLE;
		}
		
		/**
		 * Tests if an anchor is a right anchor.
		 *
		 * @param anchor The anchor to test.
		 * @return <code>true</code> if the anchor is a right anchor.
		 */
		public static function isRight( anchor:uint ):Boolean
		{
			return ( anchor & POSITION_RIGHT ) == POSITION_RIGHT;
		}
		
		/**
		 * Tests if an anchor is a top anchor.
		 *
		 * @param anchor The anchor to test.
		 * @return <code>true</code> if the anchor is a top anchor.
		 */
		public static function isTop( anchor:uint ):Boolean
		{
			return ( anchor & POSITION_TOP ) == POSITION_TOP;
		}
	}
}
