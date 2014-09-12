package com.bojinx.mnav.skinnable.effect
{
	import com.bojinx.mnav.core.message.EffectInfo;
	import com.bojinx.mnav.skinnable.ContactsSkin;
	import com.greensock.OverwriteManager;
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	
	[EffectFactory("content.contacts")]
	public class ContactsEffectFactory extends BaseEffect
	{
		public function ContactsEffectFactory()
		{
			OverwriteManager.init()
		} 
		
		[Effect(kind="exit", state="private")]
		public function exitPrivateState(effect:EffectInfo, con:ContactsSkin):void
		{
			var tweens:Array = [];
			
			if(con.testComp)
			{
				tweens.push( TweenMax.to(con.testComp, TIME/1.5, {alpha: 0, overwrite: OVERWRITE, ease: Expo.easeOut, startAt:{alpha: con.testComp.alpha}}));
			}
			
			timeline.insertMultiple(tweens);
		}
		
		[Effect(kind="enter", state="private")]
		public function enterPrivateState(effect:EffectInfo, con:ContactsSkin):void
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