package com.bojinx.test.core
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.display.DisplayObjectProcessor;
	import com.bojinx.logging.LoggingExtension;
	import com.bojinx.system.context.ApplicationContext;
	import com.bojinx.system.context.loaders.config.EmbeddedConfig;
	import com.bojinx.system.context.loaders.extensions.ExtentionLoader;
	import com.bojinx.system.context.loaders.settings.ViewSettings;
	
	import mx.utils.UIDUtil;
	
	import org.as3commons.stageprocessing.impl.selector.AllowAllObjectSelector;
	import org.fluint.uiImpersonation.UIImpersonator;
	import org.spicefactory.lib.flash.logging.LogLevel;
	import org.spicefactory.lib.flash.logging.impl.TraceAppender;

	public class TestCaseContextFactory
	{
		public function TestCaseContextFactory()
		{
		}
		
		public function newContext(beans:Array):IApplicationContext
		{
			var configurations:Array = [];
			var logging:LoggingExtension = new LoggingExtension();
			logging.logLevel = "debug";
			
			for each(var i:Class in beans)
				configurations.push(new EmbeddedConfig(i));
			
			configurations.push(logging);
			
			var filter:AllowAllObjectSelector = new AllowAllObjectSelector();
			var context:IApplicationContext = new ApplicationContext(UIImpersonator.testDisplay, UIDUtil.createUID(), configurations);
			context.displayProcessor = new DisplayObjectProcessor(filter);
			context.viewSettings = new ViewSettings();
			context.viewSettings.autoReleaseComponents = false;
			context.viewSettings.autoReleaseContexts = false;
			
			return context;
		}
	}
}