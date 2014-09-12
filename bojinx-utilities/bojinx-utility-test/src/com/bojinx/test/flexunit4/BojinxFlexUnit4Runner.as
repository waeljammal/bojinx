package com.bojinx.test.flexunit4
{
	import avmplus.getQualifiedClassName;
	
	import com.bojinx.display.DisplayObjectProcessor;
	import com.bojinx.logging.LoggingExtension;
	import com.bojinx.reflection.ClassInfo;
	import com.bojinx.reflection.ClassInfoFactory;
	import com.bojinx.reflection.registry.MetaDataRegistry;
	import com.bojinx.system.cache.definition.ObjectDefinition;
	import com.bojinx.system.context.ApplicationContext;
	import com.bojinx.system.context.event.ContextEvent;
	import com.bojinx.system.context.loaders.config.EmbeddedConfig;
	import com.bojinx.system.context.loaders.settings.ViewSettings;
	import com.bojinx.system.processor.event.ProcessorQueueEvent;
	import com.bojinx.system.processor.queue.ProcessorQueue;
	import com.bojinx.test.meta.ConfigMetadata;
	
	import flash.utils.getDefinitionByName;
	
	import mx.utils.UIDUtil;
	
	import org.as3commons.stageprocessing.impl.selector.AllowAllObjectSelector;
	import org.flexunit.internals.AssumptionViolatedException;
	import org.flexunit.internals.runners.model.EachTestNotifier;
	import org.flexunit.internals.runners.statements.IAsyncStatement;
	import org.flexunit.internals.runners.statements.StatementSequencer;
	import org.flexunit.runner.IDescription;
	import org.flexunit.runner.notification.IRunNotifier;
	import org.flexunit.runners.BlockFlexUnit4ClassRunner;
	import org.flexunit.runners.ParentRunner;
	import org.flexunit.runners.model.FrameworkMethod;
	import org.flexunit.token.AsyncTestToken;
	import org.flexunit.token.ChildResult;
	import org.flexunit.token.IAsyncTestToken;
	import org.fluint.uiImpersonation.UIImpersonator;
	
	/**
	 * @Manifest
	 */
	public class BojinxFlexUnit4Runner extends BlockFlexUnit4ClassRunner
	{
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var config:Class;
		
		private var context:ApplicationContext;
		
		private var queue:ProcessorQueue = new ProcessorQueue();
		
		private var test:Object;
		
		public function BojinxFlexUnit4Runner( klass:Class )
		{
			super( klass );
			setConfig( klass );
		}
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		override public function run( notifier:IRunNotifier, previousToken:IAsyncTestToken ):void
		{
			super.run( notifier, previousToken );
		}
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		override protected function createTest():Object
		{
			test = super.createTest();
			queue = context.processObject( test );
			
			return test;
		}
		
		override protected function methodBlock( frameworkMethod:FrameworkMethod ):IAsyncStatement
		{
			var test:Object = createTest();
			var sequencer:StatementSequencer = new StatementSequencer();
			sequencer.addStep( withDecoration( frameworkMethod, test ));
			
			return sequencer;
		}
		
		override protected function runChild( child:*, notifier:IRunNotifier, childRunnerToken:AsyncTestToken ):void
		{
			var method:FrameworkMethod = FrameworkMethod( child );
			var eachNotifier:EachTestNotifier = makeNotifier( method, notifier );
			
			//Determine if the method should be ignored and not run
			if ( method.hasMetaData( "Ignore" ))
			{
				eachNotifier.fireTestIgnored();
				childRunnerToken.sendResult();
				return;
			}
			
			var token:AsyncTestToken = new AsyncTestToken( getQualifiedClassName( this ));
			token.parentToken = childRunnerToken;
			token.addNotificationMethod( onBlockComplete );
			token[ ParentRunner.EACH_NOTIFIER ] = eachNotifier;
			
			try
			{
				loadContext();
			}
			catch ( e:Error )
			{
				throw new Error( e.message );
			}
			
			runAfterContextLoaded( methodBlock( method ), eachNotifier, token, childRunnerToken );
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function loadContext():void
		{
			var filter:AllowAllObjectSelector = new AllowAllObjectSelector();
			var dp:DisplayObjectProcessor = new DisplayObjectProcessor( filter );
			context = new ApplicationContext( UIImpersonator.testDisplay, UIDUtil.createUID());
			context.viewSettings = new ViewSettings();
			context.viewSettings.inheritFromParentContext = false;
			context.displayProcessor = dp;
			var logging:LoggingExtension = new LoggingExtension();
			logging.logLevel = "debug";
			
			if ( config )
			{
				context.addConfig( new EmbeddedConfig( config ));
			}
			
			context.addConfig(logging);
			
			context.load();
		}
		
		private function makeNotifier( method:FrameworkMethod, notifier:IRunNotifier ):EachTestNotifier
		{
			var description:IDescription = describeChild( method );
			return new EachTestNotifier( notifier, description );
		}
		
		private function onBlockComplete( result:ChildResult ):void
		{
			var error:Error = result.error;
			var token:AsyncTestToken = result.token;
			var eachNotifier:EachTestNotifier = result.token[ EACH_NOTIFIER ];
			
			//Determine if an assumption failed, if it did, ignore the test; otherwise, report the error
			if ( error is AssumptionViolatedException )
			{
				eachNotifier.fireTestIgnored();
			}
			else if ( error )
			{
				eachNotifier.addFailure( error );
			}
			
			token.parentToken.sendResult();
			context.unload();
			eachNotifier.fireTestFinished();
		}
		
		private function runAfterContextLoaded( statement:IAsyncStatement, eachNotifier:EachTestNotifier,
												token:AsyncTestToken, childRunnerToken:AsyncTestToken, 
												definition:ObjectDefinition = null):void
		{
			var error:Error;
			
			if ( !context.isLoaded )
			{
				context.addEventListener( ContextEvent.CONTEXT_LOADED, function( event:ProcessorQueueEvent ):void {
					runAfterContextLoaded( statement, eachNotifier, token, childRunnerToken );
				});
				
				return;
			}
			
			if ( !test )
			{
				throw new Error( "Missing Test" );
			}
			
			definition = definition ? definition : context.cache.definitions.getDefinitionByInstance( test );
			
			if(!definition)
			{
				var oQueue:ProcessorQueue = context.processObject(test, false, false);
				oQueue.addEventListener( ProcessorQueueEvent.ALL_COMPLETE, function( event:ProcessorQueueEvent ):void {
					runAfterContextLoaded( statement, eachNotifier, token, childRunnerToken, event.owner );
				});
				oQueue.run();
				return;
			}
			
			if ( !definition )
			{
				trace( "Could not parse " + test + " as IObjectDefinition" );
				throw new Error( "Could not parse " + test + " as IObjectDefinition" );
			}
			
			if ( definition.isReady )
			{
				eachNotifier.fireTestStarted();
				
				try
				{
					statement.evaluate( token );
				}
				catch ( e:AssumptionViolatedException )
				{
					error = e;
					eachNotifier.addFailedAssumption( e );
				}
				catch ( e:Error )
				{
					error = e;
					eachNotifier.addFailure( e );
				}
				
				if ( error )
				{
					eachNotifier.fireTestFinished();
					childRunnerToken.sendResult();
					context.unload();
				}
			}
			else
			{
				queue.addEventListener( ProcessorQueueEvent.ALL_COMPLETE, function( event:ProcessorQueueEvent ):void {
					runAfterContextLoaded( statement, eachNotifier, token, childRunnerToken );
				});
			}
		}
		
		private function setConfig( klass:Class ):void
		{
			MetaDataRegistry.getInstance().registerMetaData( ConfigMetadata );
			
			var info:ClassInfo = ClassInfoFactory.forClass( klass );
			var meta:Array;
			
			try
			{
				meta = info.getMetadata( ConfigMetadata );
			}
			catch ( e:Error )
			{
				trace( e.message );
			}
			
			if ( meta.length > 0 )
			{
				var conf:ConfigMetadata = meta[ 0 ];
				
				try
				{
					config = getDefinitionByName( conf.configFile ) as Class;
				}
				catch ( e:Error )
				{
					throw new Error( "Could not locate configuration " + conf.configFile );
				}
			}
			
			ClassInfoFactory.removeForClass( klass );
		}
	}
}
