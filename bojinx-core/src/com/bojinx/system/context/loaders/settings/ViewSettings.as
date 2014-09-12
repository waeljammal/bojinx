package com.bojinx.system.context.loaders.settings
{
	import com.bojinx.api.context.config.IConfigItem;
	
	/**
	 * View settings for the context, only one may be defined per application context.
	 *
	 * @author Wael Jammal
	 * @Manifest
	 */
	public class ViewSettings implements IConfigItem
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		/**
		 * True by default, auto releases components from the
		 * framework when they are removed from the stage.
		 *
		 * @default true
		 */
		public var autoReleaseComponents:Boolean = true;
		
		/**
		 * True by default, auto releases a context from the
		 * framework when it's owner is removed from the stage.
		 *
		 * @default true
		 */
		public var autoReleaseContexts:Boolean = true;
		
		/**
		 * True by default, inherits processors and configuration
		 * from a parent context.
		 *
		 * @default true
		 */
		public var inheritFromParentContext:Boolean = true;
		
		/**
		 * @private
		 */
		public function ViewSettings()
		{
		}
	}
}
