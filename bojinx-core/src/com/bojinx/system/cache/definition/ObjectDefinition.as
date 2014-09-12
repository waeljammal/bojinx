package com.bojinx.system.cache.definition
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.reflection.ClassInfo;
	import com.bojinx.system.context.config.ResolvableBean;
	
	public class ObjectDefinition
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		public var bean:ResolvableBean;
		
		public var context:IApplicationContext;
		
		/**
		 * Generic data object that you can use to pass
		 * extra information onto your processor in the
		 * case where you are intercepting this definition
		 * and modifying it before hand.
		 */
		public var data:Object;
		
		private var _dependencies:Array;
		
		public function get dependencies():Array
		{
			return _dependencies;
		}
		
		public var isDecorated:Boolean;
		
		public var isProcessing:Boolean;
		
		public var isReady:Boolean;
		
		public var isResolved:Boolean;
		
		public var markedForDestruction:Boolean;
		
		private var _members:Array = [];
		
		public function get members():Array
		{
			return _members;
		}
		
		public var mergedIntoQueue:Boolean;
		
		public var target:*;
		
		public var type:ClassInfo;
		public var isPendingProcessing:Boolean;
		public var isSingleton:Boolean;
		
		public function ObjectDefinition()
		{
		}
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function addMember( memberInfo:MemberProcessors ):void
		{
			members.push( memberInfo );
		}
		
		public function generateTypeInfo():void
		{
			if ( !type )
				type = bean.getType();
		}
		
		public function registerDependency( value:ObjectDefinition ):void
		{
			if ( !_dependencies )
				_dependencies = [];
			
			_dependencies.push( value );
		}
	}
}
