package com.bojinx.dialog.ui
{
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.IStyleManager2;
	import mx.styles.StyleManager;
	import spark.components.SkinnableContainer;
	import spark.components.SkinnablePopUpContainer;
	import spark.skins.spark.SkinnablePopUpContainerSkin;
	
	public class DefaultFlexDialogWindow extends SkinnablePopUpContainer
	{
		public function DefaultFlexDialogWindow()
		{
			super();
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
				sm.getStyleDeclaration( "com.bojinx.dialog.ui.DefaultFlexDialogWindow" );
			
			if ( !selector )
			{
				selector = new CSSStyleDeclaration();
				sm.setStyleDeclaration( "com.bojinx.dialog.ui.DefaultFlexDialogWindow", selector, true );
			}
			
			
			selector.defaultFactory = function():void
			{
				this.skinClass = DefaultFlexDialogWindowSkin;
				this.backgroundColor = 0XCCCCCC;
			}
			
			return true;
		}
	}
}