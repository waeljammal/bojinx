package com.bojinx.api.processor.display
{
	/**
	 * The minimum required contract for a view manager
	 * that should be returned through the display scanning
	 * processor.
	 */
	public interface IViewManager
	{
		function getAll():Array;
		function add(value:Object):void;
		function contains(value:Object):Boolean;
		function remove(value:Object):void;
		function getByType(type:Class):*;
		function getByIdOrUID(value:String):*;
		function containsIdOrUID(value:String):Boolean;
	}
}