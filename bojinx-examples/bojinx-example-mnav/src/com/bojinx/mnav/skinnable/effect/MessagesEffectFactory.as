package com.bojinx.mnav.skinnable.effect
{
	import com.bojinx.mnav.core.message.EffectInfo;
	import com.bojinx.mnav.skinnable.ContactsSkin;
	import com.bojinx.mnav.skinnable.MessagesSkin;
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;

	[EffectFactory("content.messages")]
	public class MessagesEffectFactory extends BaseEffect
	{
		public function MessagesEffectFactory()
		{
		}
		
		[Effect(kind="exit", state="family")]
		public function exitPrivateState(effect:EffectInfo, con:MessagesSkin):void
		{
			var tweens:Array = [];
			
			if(con.testComp)
			{
				tweens.push( TweenMax.to(con.testComp, TIME/1.5, {alpha: 0, overwrite: OVERWRITE, ease: Expo.easeOut, startAt:{alpha: con.testComp.alpha}}));
			}
			
			timeline.insertMultiple(tweens);
		}
		
		[Effect(kind="enter", state="family")]
		public function enterPrivateState(effect:EffectInfo, con:MessagesSkin):void
		{
			var tweens:Array = [];
			
			if(con.testComp)
			{
				con.testComp.alpha = 0;
				tweens.push( TweenMax.to(con.testComp, TIME, {alpha: 1, delay: 0.5, overwrite: OVERWRITE, ease: Expo.easeOut, startAt:{alpha: con.testComp.alpha}}));
			}
			
			timeline.insertMultiple(tweens);
		}
	}
}