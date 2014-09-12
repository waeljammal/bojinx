package com.bojinx.command.config.task
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.api.context.config.IBean;
	import com.bojinx.system.context.config.MethodInvoker;
	import com.bojinx.utils.GUID;
	import com.bojinx.utils.tasks.TaskGroup;
	
	public class CommandTaskBase extends TaskGroup implements IBean
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
				
		private var _id:String;
		
		public function get id():String
		{
			if ( !_id )
				_id = GUID.create();
			
			return _id;
		}
		
		public function set id( value:String ):void
		{
			_id = value;
		}
		
		private var _priority:int;
		
		public function get priority():int
		{
			return _priority;
		}
		
		public function set priority( value:int ):void
		{
			_priority = value;
		}
		
		public function CommandTaskBase( sequential:Boolean = true, description:String = "" )
		{
			super( sequential, description );
		}
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function register( context:IApplicationContext ):void
		{
		
		}
	}
}
