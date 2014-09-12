package com.bojinx.utils.tasks.api
{
	import com.bojinx.utils.tasks.TaskState;
	
	import flash.events.IEventDispatcher;

	public interface ITask extends IEventDispatcher
	{
		function get label():String;
		function set label( value:String ):void;
		
		[Bindable("currentStateChange")]
		function get currentState():TaskState;
		
		function get parent():ITaskGroup;
		
		function setParent(value:ITaskGroup):void;
		function cancel():void;
		function start():void;
	}
}