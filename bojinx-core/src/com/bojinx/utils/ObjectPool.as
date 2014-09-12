package com.bojinx.utils
{
	public class ObjectPool
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		public var clean:Function;
		
		public var create:Function;
		
		public var length:int = 0;
		
		public var minSize:int;
		
		public var size:int = 0;
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var disposed:Boolean = false;
		
		private var list:Array = [];
		
		public function ObjectPool( create:Function, clean:Function = null, minSize:int = 0 )
		{
			this.create = create;
			this.clean = clean;
			this.minSize = minSize;
			
			for ( var i:int = 0; i < minSize; i++ )
				add();
		}
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function add():void
		{
			list[ length++ ] = create();
			size++;
		}
		
		public function checkIn( item:* ):void
		{
			if ( clean != null )
				clean( item );
			
			list[ length++ ] = item;
		}
		
		public function checkOut():*
		{
			if ( length == 0 )
			{
				size++;
				return create();
			}
			
			return list[ --length ];
		}
		
		public function dispose():void
		{
			if ( disposed )
				return;
			
			disposed = true;
			
			create = null;
			clean = null;
			list = null;
		}
	}
}
