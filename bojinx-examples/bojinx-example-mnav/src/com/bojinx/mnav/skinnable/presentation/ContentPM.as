package com.bojinx.mnav.skinnable.presentation
{
	import com.bojinx.api.message.IInterceptedMessage;
	import com.bojinx.mnav.core.message.NavigationChangeMessage;
	import com.bojinx.utils.logging.Logger;
	import flash.utils.setTimeout;
	import org.spicefactory.lib.logging.LogContext;
	
	[RequestMapping( "content" )]
	public class ContentPM
	{
		public function ContentPM()
		{
		}
		
		
		/*============================================================================*/
		/*= STATIC PRIVATE PROPERTIES                                                 */
		/*============================================================================*/
		
		private static const log:Logger = LogContext.getLogger( ContentPM );
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		[Enter( time = "every", path = "contacts" )]
		/**
		 * Gets called every time the url is /viewOne
		 */
		public final function onEnterEveryContacts( m:NavigationChangeMessage ):void
		{
			log.info( "ENTER:Every Contacts State" );
			//i.resume();
		}
		
		[Enter( time = "every", path = "contacts.private" )]
		/**
		 * Gets called every time the url is /viewOne
		 */
		public final function onEnterEveryContactsPrivate( m:NavigationChangeMessage ):void
		{
			log.info( "ENTER:Every Contacts Private State" );
			//i.resume();
		}
		
		[Enter( time = "every", path = "messages" )]
		/**
		 * Gets called every time the url is /viewOne
		 */
		public final function onEnterEveryMessages( m:NavigationChangeMessage ):void
		{
			log.info( "ENTER:Every Messages State" );
//			//i.resume();
//			setTimeout(i.resume, 3000);
		}
		
		[Enter( time = "every", path = "messages.family" )]
		/**
		 * Gets called every time the url is /viewOne
		 */
		public final function onEnterEveryMessagesFamily( m:NavigationChangeMessage ):void
		{
			log.info( "ENTER:Every Messages Family State" );
			//			//i.resume();
			//			setTimeout(i.resume, 3000);
		}
		
		[Enter( time = "every" )]
		/**
		 * Gets called every time the url is /viewOne
		 */
		public final function onEnterEveryWaypoint( m:NavigationChangeMessage ):void
		{
			log.info( "ENTER:Every Waypoint" );
			//i.resume();
		}
		
		[Enter( time = "first", path = "contacts" )]
		/**
		 * Gets called every time the url is /viewOne
		 */
		public final function onEnterFirstContacts( m:NavigationChangeMessage ):void
		{
			log.info( "ENTER:First Contacts State" );
			//i.resume();
		}
		
		[Enter( time = "first", path = "contacts.private" )]
		/**
		 * Gets called every time the url is /viewOne
		 */
		public final function onEnterFirstContactsPrivate( m:NavigationChangeMessage ):void
		{
			log.info( "ENTER:First Contacts Private State" );
			//i.resume();
		}
		
		[Enter( time = "first", path = "messages" )]
		/**
		 * Gets called every time the url is /viewOne
		 */
		public final function onEnterFirstMessages( m:NavigationChangeMessage ):void
		{
			log.info( "ENTER:First Messages State" );
			//			//i.resume();
			//			setTimeout(i.resume, 3000);
		}
		
		[Enter( time = "first", path = "messages.family" )]
		/**
		 * Gets called every time the url is /viewOne
		 */
		public final function onEnterFirstMessagesFamily( m:NavigationChangeMessage ):void
		{
			log.info( "ENTER:First Messages Family State" );
			//			//i.resume();
			//			setTimeout(i.resume, 3000);
		}
		
		[Exit( path = "contacts" )]
		/**
		 * Gets called every time the url is /viewOne
		 */
		public final function onExitContacts( m:NavigationChangeMessage ):void
		{
			log.info( "Exit Contacts State" );
			//i.resume();
		}
		
		[Exit( path = "messages" )]
		/**
		 * Gets called every time the url is /viewOne
		 */
		public final function onExitMessages( m:NavigationChangeMessage ):void
		{
			log.info( "Exit Messages State" );
			//i.resume();
		}
		
		[Exit]
		/**
		 * Gets called every time the url is /viewOne
		 */
		public final function onExitWaypoint( m:NavigationChangeMessage ):void
		{
			log.info( "Exit Waypoint" );
			//i.resume();
		}
	}
}
