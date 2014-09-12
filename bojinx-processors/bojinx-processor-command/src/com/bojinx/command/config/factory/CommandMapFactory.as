package com.bojinx.command.config.factory
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.api.context.config.IBean;
	
	[Exclude( kind = "property", name = "name" )]
	[DefaultProperty("flows")]
	public class CommandMapFactory implements IBean
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _flows:Array;
		
		[ArrayElementType("com.bojinx.command.config.factory.CommandFlowFactory")]
		public function get flows():Array
		{
			return _flows;
		}
		
		public function set flows( value:Array ):void
		{
			_flows = value;
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
		
		public function get priority():int
		{
			return 0;
		}
		
		public function set priority( value:int ):void
		{
			// Not supported
		}
		
		public var trigger:Class;
		
		public var filter:String;
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var context:IApplicationContext;
		
		public function CommandMapFactory()
		{
		}
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function register( context:IApplicationContext ):void
		{
			this.context = context;
		}
	}
}
