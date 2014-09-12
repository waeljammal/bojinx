package com.bojinx.utils.tasks.api
{
	public interface ITaskGroup extends ITask
	{
		function get current():int;
		function get description():String;
		function get sequential():Boolean;
		function get size():uint;
		function get tasks():Array;
		
		
		function sortBy(property:String):void;
		function sortByMultiple(properties:Array):void;
		function addTask(task:ITask):void;
		function removeTask(task:ITask):void;
		function removeAllTasks():void;
	}
}