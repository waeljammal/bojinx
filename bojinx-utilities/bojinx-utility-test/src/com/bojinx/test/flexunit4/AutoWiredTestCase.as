package com.bojinx.test.flexunit4
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.system.context.event.ContextEvent;
	import com.bojinx.test.core.TestCaseContextFactory;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flexunit.framework.Assert;
	import org.flexunit.async.Async;
	
	public class AutoWiredTestCase extends EventDispatcher
	{
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var beans:Array;
		
		private var context:IApplicationContext;
		
		public function AutoWiredTestCase( target:IEventDispatcher = null )
		{
			super( target );
		}
		
		
		/*============================================================================*/
		/*= STATIC PRIVATE PROPERTIES                                                 */
		/*============================================================================*/
		
		private static var factory:TestCaseContextFactory;
		
		
		/*============================================================================*/
		/*= STATIC PRIVATE METHODS                                                    */
		/*============================================================================*/
		
		private static function initialize():void
		{
			if ( !factory )
				factory = new TestCaseContextFactory();
		}
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		[After]
		public final function afterAutoWiredTestCase():void
		{
			context.unload();
			context = null;
		}
		
		[Before( async )]
		public function beforeAutoWiredTestCase():void
		{
			initialize();
			context = factory.newContext( beans );
			Async.handleEvent( this, context, ContextEvent.CONTEXT_LOADED, checkEvent );
			context.load();
		}
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		protected function registerBeans( clazz:Class ):void
		{
			if ( !beans )
				beans = [];
			
			beans.push( clazz );
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function checkEvent( event:ContextEvent, passThroughData:Object ):void
		{
			Assert.assertTrue( "Context Was Not Initialized.", context.isLoaded == true );
		}
	}
}
