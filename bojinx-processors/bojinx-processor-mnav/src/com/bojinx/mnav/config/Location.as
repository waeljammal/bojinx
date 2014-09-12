package com.bojinx.mnav.config
{
	
	[DefaultProperty( "children" )]
	/**
	 * @Manifest
	 */
	public class Location implements ILocationChild
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _children:Array = [];
		
		public function get children():Array
		{
			return _children;
		}
		
		public function set children( value:Array ):void
		{
			_children = value;
			
			for each ( var i:Location in value )
				i.setParent( this );
		}
		
		public var data:*;
		
		public var defaultState:String;
		
		private var _destination:String;
		
		public function get destination():String
		{
			return toString();
		}
		
		public function set destination( value:String ):void
		{
			_destination = value;
		}
		
		public var label:String;
		
		private var _parent:Location;
		
		public function get parent():Location
		{
			return _parent;
		}
		
		public var title:String;
		
		public function Location()
		{
		}
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function getPathTo( destination:String ):String
		{
			var destinations:Array = [];
			
			if ( this.destination == destination )
				return toString( );
			else
			{
				destinations.push( this.destination );
				
				for each ( var c:Location in children )
				{
					if ( c.destination != destination )
						destinations.push( c.destination );
					else if ( c.destination == destination )
					{
						destinations.push( c.destination );
						break;
					}
				}
			}
			
			return destinations.join( "." );
		}
		
		public function toString():String
		{
			var destinations:Array = [ rawDestination() ];
			var p:Location = parent;
			
			while ( p )
			{
				destinations.push( p.rawDestination() );
				p = p.parent;
			}
			
			return destinations.reverse().join( "." );
		}
		
		/*============================================================================*/
		/*= INTERNAL METHODS                                                          */
		/*============================================================================*/
		
		internal function setParent( value:Location ):void
		{
			_parent = value;
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function processChild( entry:ILocationChild ):void
		{
			if ( entry is Location )
			{
				if ( entry != this )
					Location( entry ).setParent( this );
				
				_children.push( entry );
			}
		}
		
		public function rawDestination():String
		{
			return _destination;
		}
	}
}