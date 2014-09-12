package com.bojinx.mnav.core.constants
{
	public final class TaskPriority
	{
		public static const ENTER_SWITCH_STATE:int = 10;
		
		public static const CREATE_EXIT_EFFECT_QUEUE:int = 20;
		
		public static const EXIT_REGISTER_EFFECT:int = 30;
		public static const EXIT_DISPATCH:int = 40;
		public static const EXIT_PLAY_EFFECT:int = 50;
		
		public static const COMPLETE_DISPATCH_EXIT:int = 52;
		
		public static const EXIT_SWITCH_STATE:int = 55;
		
		public static const CREATE_ENTER_EFFECT_QUEUE:int = 60;
		
		public static const ENTER_REGISTER_EFFECT:int = 70;
		public static const ENTER_PLAY_EFFECT:int = 80;
		public static const ENTER_DISPATCH:int = 90;
		public static const COMPLETE_DISPATCH:int = 100;
		
		public function TaskPriority()
		{
		}
	}
}