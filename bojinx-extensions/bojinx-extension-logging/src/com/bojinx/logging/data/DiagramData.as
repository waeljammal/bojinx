package com.bojinx.logging.data
{
	import mx.collections.ArrayCollection;
	
	[Bindable]
	[RemoteClass( "com.bojinx.logging.data.DiagramData" )]
	public class DiagramData
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _children:ArrayCollection;
		
		public function get children():ArrayCollection
		{
			return _children;
		}
		
		public function set children( value:ArrayCollection ):void
		{
			_children = value;
		}
		
		private var _group:String;
		
		public function get group():String
		{
			return _group;
		}
		
		public function set group( value:String ):void
		{
			_group = value;
		}
		
		private var _id:String;
		
		public function get id():String
		{
			return _id;
		}
		
		public function set id( value:String ):void
		{
			_id = value;
		}
		
		public var isFilter:Boolean;
		
		private var _label:String;
		
		public function get label():String
		{
			return _label;
		}
		
		public function set label( value:String ):void
		{
			_label = value;
		}
		
		private var _layout:String;
		
		public function get layout():String
		{
			return _layout;
		}
		
		public function set layout( value:String ):void
		{
			_layout = value;
		}
		
		private var _links:ArrayCollection;
		
		public function get links():ArrayCollection
		{
			return _links;
		}
		
		public function set links( value:ArrayCollection ):void
		{
			_links = value;
		}
		
		public var parentId:String;
		
		private var _type:String;
		
		public function get type():String
		{
			return _type;
		}
		
		public function set type( value:String ):void
		{
			_type = value;
		}
		
		private var _uid:Number;
		
		public function get uid():Number
		{
			return _uid;
		}
		
		public function set uid( value:Number ):void
		{
			_uid = value;
		}
		
		public function DiagramData()
		{
		
		}
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function addChild( item:DiagramData ):void
		{
			if ( !children )
				children = new ArrayCollection();
			
			children.addItem( item );
		}
		
		public function addLink( value:LinkTo ):void
		{
			if ( !links )
				links = new ArrayCollection();
			
			links.addItem( value );
		}
		
		public function updateFrom( item:DiagramData ):void
		{
			for ( var i:String in item )
			{
				if ( item[ i ])
					this[ i ] = item[ i ];
			}
		}
	}
}
