package com.bojinx.mnav.core.cache
{
	import com.bojinx.mnav.core.manager.DestinationStateController;
	import com.bojinx.mnav.core.manager.NavigationController;
	import com.bojinx.mnav.util.NavUtil;
	import com.bojinx.utils.data.HashMap;
	
	import flash.utils.Dictionary;
	
	public class DestinationRegistry
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _destinations:HashMap = new HashMap();
		
		public function get destinations():HashMap
		{
			return _destinations;
		}
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var controller:NavigationController;
		
		private var pendingDestinations:Dictionary = new Dictionary( true );
		
		public function DestinationRegistry( controller:NavigationController )
		{
			this.controller = controller;
		}
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function addPending( destination:String ):void
		{
			pendingDestinations[ destination ] = true;
		}
		
		public function removePending( destination:String ):void
		{
			delete(pendingDestinations[ destination ]);
		}
		
		public function getDestination( destination:String ):DestinationStateController
		{
			return destinations.getValue( destination );
		}
		
		public function getNextPending( base:String ):String
		{
			return getAnyNext( base, pendingDestinations );
		}
		
		public function getValidDestination( destination:String ):DestinationStateController
		{
			var item:DestinationStateController = destinations.getValue( destination );
			
			while ( !item )
			{
				var parentDestination:String = NavUtil.getParent( destination )
				
				if ( parentDestination == null )
					return null;
				
				destination = parentDestination;
				item = destinations.getValue( parentDestination );
			}
			
			return item;
		}
		
		public function hasDestination( destination:String ):Boolean
		{
			return destinations.containsKey( destination );
		}
		
		public function registerDestination( destination:String, isEffectEndpoint:Boolean ):Boolean
		{
			var hasRegistered:Boolean;
			var destinationItem:DestinationStateController = destinations.getValue( destination );
			
			if ( destinationItem == null )
			{
				var parent:String = NavUtil.getParent( destination );
				
				if ( !hasDestination( parent ) && parent != null )
				{
					registerDestination( parent, isEffectEndpoint );
				}
				
				destinationItem = new DestinationStateController( destination );
				destinationItem.isEffectEndpoint = isEffectEndpoint;
				
				destinations.put( destination, destinationItem );
				hasRegistered = true;
			}
			
			return hasRegistered;
		}
		
		public function remove( destination:String ):void
		{
			_destinations.remove( destination );
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function getAnyNext( destination:String, destinations:Dictionary ):String
		{
			for ( var name:String in destinations )
			{
				var base:String = NavUtil.getFirstSharedDestination( destination, name );
				
				if ( base != null && name != destination
					&& base == NavUtil.getParent( name )
					&& NavUtil.getLength( name ) > NavUtil.getLength( base )
					&& NavUtil.getLength( name ) > NavUtil.getLength( destination ))
				{
					return name;
				}
			}
			
			return null;
		}
	}
}
