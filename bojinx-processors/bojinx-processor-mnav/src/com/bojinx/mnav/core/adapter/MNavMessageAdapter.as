package com.bojinx.mnav.core.adapter
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.mnav.config.SiteMap;
	import com.bojinx.mnav.core.message.NavigationMessage;
	import com.bojinx.mnav.operation.MNavProcessorOperation;
	
	/**
	 * @Manifest
	 */
	public class MNavMessageAdapter implements IMnavAdapter
	{
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var context:Object;
		
		private var processor:MNavProcessorOperation;
		
		private var sitemap:SiteMap;
		
		public function MNavMessageAdapter()
		{
		}
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		[Message]
		public final function handleNavigationRequest( message:NavigationMessage ):void
		{
			processor.navigateToPath(message.destination);
		}
		
		public function setContext( value:IApplicationContext ):void
		{
			this.context = context;
		}
		
		public function setProcessor( value:MNavProcessorOperation ):void
		{
			this.processor = value;
		}
		
		public function setSiteMap( value:SiteMap ):void
		{
			this.sitemap = value;
		}
	}
}
