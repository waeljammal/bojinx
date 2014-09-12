package com.bojinx.api.constants
{
	
	/**
	 * Defines the different states a managed object can be in
	 * during it's lifecycle.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @productversion Flex 4
	 * @author Wael Jammal
	 */
	public class ProcessorLifeCycleStage
	{
		/*============================================================================*/
		/*= STATIC PUBLIC PROPERTIES                                                  */
		/*============================================================================*/
		
		/**
		 * Triggered after DESTROY.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion Flex 4
		 */
		public static const AFTER_DESTROY:int = 8;
		
		/**
		 * Triggered after POST_INIT but before READY.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion Flex 4
		 */
		public static const AFTER_POST_INIT:int = 4;
		
		/**
		 * Triggered after PRE_INIT but before POST_INIT.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion Flex 4
		 */
		public static const AFTER_PRE_INIT:int = 2;
		
		/**
		 * Triggered after READY.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion Flex 4
		 */
		public static const AFTER_READY:int = 6;
		
		/**
		 * Runs before pre init
		 *
		 * At this point only the object being processed
		 * has been detected.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion Flex 4
		 */
		public static const BEFORE_PRE_INIT:int = 0;
		
		/**
		 * Destruction stage
		 *
		 * At this point all processors have finished running
		 * and your class should be ready for use.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion Flex 4
		 */
		public static const DESTROY:int = 7;
		
		/**
		 * Post initialization stage.
		 *
		 * At this point the object has been processed and all
		 * post init processeors have been run.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion Flex 4
		 */
		public static const POST_INIT:int = 3;
		
		/**
		 * Pre initialization stage.
		 *
		 * At this point the object has been reflected but
		 * none of the processors have been applied.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion Flex 4
		 */
		public static const PRE_INIT:int = 1;
		
		/**
		 * Ready stage
		 *
		 * At this point all processors have finished running
		 * and your class should be ready for use.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion Flex 4
		 */
		public static const READY:int = 5;
		
		/*============================================================================*/
		/*= STATIC PUBLIC METHODS                                                     */
		/*============================================================================*/
		
		/**
		 * Returns all available life cycle states in their
		 * correct order.
		 *
		 * @return Array of Strings.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion Flex 4
		 */
		public static function getAll():Array
		{
			//  BEFORE_PRE_INIT, PRE_INIT, AFTER_PRE_INIT, POST_INIT, AFTER_POST_INIT, READY, AFTER_READY
			return [ AFTER_READY, READY, AFTER_POST_INIT, POST_INIT, AFTER_PRE_INIT, PRE_INIT, BEFORE_PRE_INIT ];
		}
	}
}
