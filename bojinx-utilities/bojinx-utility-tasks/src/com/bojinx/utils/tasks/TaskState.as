package com.bojinx.utils.tasks
{
	
	public class TaskState
	{
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var name:String;
		
		public function TaskState( name:String )
		{
			this.name = name;
		}
		
		
		/*============================================================================*/
		/*= STATIC PUBLIC PROPERTIES                                                  */
		/*============================================================================*/
		
		public static const CANCELED:TaskState = new TaskState( "CANCELED" );
		
		public static const COMPLETED:TaskState = new TaskState( "COMPLETED" );
		
		public static const ERRORED:TaskState = new TaskState( "ERRORED" );
		
		public static const INACTIVE:TaskState = new TaskState( "INACTIVE" );
		
		public static const RUNNING:TaskState = new TaskState( "RUNNING" );
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function toString():String
		{
			return name;
		}
	}
}
