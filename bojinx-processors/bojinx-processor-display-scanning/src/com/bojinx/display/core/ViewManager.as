package com.bojinx.display.core
{
	import com.bojinx.api.processor.display.IViewManager;
	
	import flash.utils.Dictionary;
	
	/**
	 * @Manifest
	 */
	public class ViewManager implements IViewManager
	{
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var size:int = 0;
		
		private var views:Dictionary = new Dictionary();
		
		public function ViewManager()
		{
		}
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function add( value:Object ):void
		{
			if ( value.hasOwnProperty( "uid" ) && value.uid != null )
				views[ value.uid ] = { view: value, index: size };
			else
				views[ value ] = { view: value, index: size };
			
			size++;
		}
		
		public function getByType(type:Class):*
		{
			for each(var i:Object in views)
				if(i.view is type)
					return i.view;
			
			return null;
		}
		
		public function getByIdOrUID(value:String):*
		{
			return views[value] ? views[value].view : null;
		}
		
		public function containsIdOrUID(value:String):Boolean
		{
			return views[value] ? true : false;
		}
		
		public function contains( value:Object ):Boolean
		{
			if ( value.hasOwnProperty( "uid" ) && value.uid != null )
				return views[ value.uid ] ? true : false;
			else
				return views[ value ] ? true : false;
		}
		
		public function getAll():Array
		{
			var result:Array = [];
			
			for each ( var i:Object in views )
				result.push( i );
			
			result.sortOn( "index", Array.NUMERIC );
			
			return result;
		}
		
		public function remove( value:Object ):void
		{
			if ( value.hasOwnProperty( "uid" ) && value.uid != null )
				delete( views[ value.uid ]);
			else
				delete( views[ value ]);
			
			size--;
		}
	}
}
