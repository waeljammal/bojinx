package com.bojinx.utils.application
{
	import com.bojinx.api.context.IApplicationDomainAware;
	import com.bojinx.utils.type.ClassUtils;
	import flash.display.LoaderInfo;
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	
	/**
	 * Utilities for dealing with domains and root application retreival.
	 *
	 * @author Wael Jammal
	 */
	public final class AppUtil
	{
		public function AppUtil()
		{
		}
		
		/*============================================================================*/
		/*= STATIC PUBLIC PROPERTIES                                                  */
		/*============================================================================*/
		
		private static var _application:Object;
		
		/**
		 * Attempts to return the root application
		 *
		 * @return Object
		 */
		public static function get application():Object
		{
			if ( _application == null )
			{
				var domain:ApplicationDomain = ApplicationDomain.currentDomain;
				var flexVersion:Class;
				
				if ( domain.hasDefinition( "mx.core.FlexVersion" ))
					flexVersion = domain.getDefinition( "mx.core.FlexVersion" ) as Class;
				
				if ( domain.hasDefinition( "mx.core.FlexVersion" ) &&
					flexVersion[ "CURRENT_VERSION" ] > flexVersion[ "VERSION_3_0" ])
				{
					var flexGlobalsClass:Class = ClassUtils.forName( "mx.core.FlexGlobals" );
					
					if ( flexGlobalsClass && flexGlobalsClass[ "topLevelApplication" ])
					{
						_application = flexGlobalsClass[ "topLevelApplication" ];
					}
				}
			}
			
			return _application;
		}
		
		/*============================================================================*/
		/*= STATIC PRIVATE PROPERTIES                                                 */
		/*============================================================================*/
		
		private static var sprite:Class;
		
		/*============================================================================*/
		/*= STATIC PUBLIC METHODS                                                     */
		/*============================================================================*/
		
		/**
		 *  @copy com.bojinx.context.IApplicationContext#applicationDomain
		 */
		public static function getApplicationDomain( owner:Object ):ApplicationDomain
		{
			var applicationDomain:ApplicationDomain;
			
			if ( owner is IApplicationDomainAware )
				return ( owner as IApplicationDomainAware ).domain;
			
			if ( !sprite )
				sprite = getDefinitionByName( "flash.display.Sprite" ) as Class;
			
			var target:Object = owner;
			
			if ( target && !( target is sprite ))
				target = AppUtil.application;
			
			if ( target && target is sprite )
			{
				if ( target.hasOwnProperty( "moduleFactory" ) && target.moduleFactory )
				{
					applicationDomain = ( target[ "moduleFactory" ].info ) ?
						target[ "moduleFactory" ].info()[ "currentDomain" ] :
						ApplicationDomain.currentDomain;
				}
				else if ( target.hasOwnProperty( "loaderInfo" ))
				{
					var inf:LoaderInfo = target.loaderInfo;
					
					if ( inf )
						applicationDomain = inf.applicationDomain;
				}
			}
			else
			{
				applicationDomain = ApplicationDomain.currentDomain;
			}
			
			return applicationDomain;
		}
	}
}
