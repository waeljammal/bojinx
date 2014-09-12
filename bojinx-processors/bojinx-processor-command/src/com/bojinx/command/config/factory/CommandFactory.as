package com.bojinx.command.config.factory
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.command.cache.CommandRegistry;
	import com.bojinx.system.cache.definition.ObjectDefinition;
	import com.bojinx.system.context.config.Bean;
	import com.bojinx.system.message.support.Scope;
	import com.bojinx.system.processor.queue.ProcessorQueue;
	import com.bojinx.utils.GUID;
	import com.bojinx.utils.logging.Logger;
	import com.bojinx.utils.logging.LoggingContext;
	
	[DefaultProperty( "elements" )]
	public class CommandFactory extends Bean
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _context:IApplicationContext;
		
		public function get context():IApplicationContext
		{
			return _context;
		}
		
		public var scope:String = Scope.GLOBAL;
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var beanId:String;
		
		private var cache:CommandRegistry;
		
//		private var flow:CommandFlow;
		
		private var queue:ProcessorQueue;
		
		public function CommandFactory( source:Class = null, id:String = null )
		{
			this.source = source;
			this.id = id;
		}
		
		/*============================================================================*/
		/*= STATIC PRIVATE PROPERTIES                                                 */
		/*============================================================================*/
		
		/**
		 * @private
		 */
		private static const log:Logger = LoggingContext.getLogger( CommandFactory );
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		/**
		 * Because command is a bean factory we just implement ISourceSupport
		 * and generate a dynamic bean for the source of the factory itself.
		 * <br/>
		 * This way anytime a new Command task is invoked we return a new Command task
		 * and the task itself will create a bean for it's source and return a new
		 * intance of the runnable command.
		 */
		override public function getInstance():ObjectDefinition
		{
			var bean:Bean;
			
			if ( beanId )
				bean = context.cache.beans.getBeanById( beanId ) as Bean;
			
			if ( !bean )
			{
				beanId = GUID.create();
				
				bean = new Bean( source, beanId, false );
				bean.constructorArgs = constructorArgs;
				bean.properties = properties;
				bean.methodInvokers = methodInvokers;
				bean.register( context );
				
				context.cache.beans.register( bean );
			}
			
			return bean.getInstance();
		}
		
		/**
		 * Copied over from Bean, Command supports all the standard bean features but
		 * we need to exclude things like singleton and a few other parameters.
		 */
		override public function register( context:IApplicationContext ):void
		{
			_context = context;
			super.register( context );
		}
	}
}
