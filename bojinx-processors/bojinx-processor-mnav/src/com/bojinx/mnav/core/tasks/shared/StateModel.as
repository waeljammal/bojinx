package com.bojinx.mnav.core.tasks.shared
{
	import flash.utils.Dictionary;

	public class StateModel
	{
		private static var activeExitEffects:Dictionary = new Dictionary();
		public static var exitInProgress:Boolean;
		public static var pendingEffects:int = 0;
		
		public static function setEffectState(name:String, state:Boolean):void
		{
			activeExitEffects[name] = state;
		}
		
		public static function getEffectState(name:String):Boolean
		{
			return activeExitEffects[name];
		}
		
		public function StateModel()
		{
		}
		
		public static function resetEffectStates():void
		{
			activeExitEffects = new Dictionary();
		}
	}
}