package com.bojinx.mnav.skinnable.effect
{
	import com.bojinx.mnav.core.message.EffectInfo;
	import com.bojinx.mnav.skinnable.ContactsSkin;
	import com.bojinx.mnav.skinnable.ContentSkin;
	import com.bojinx.mnav.skinnable.MessagesSkin;
	import com.greensock.TimelineMax;
	import com.greensock.TweenAlign;
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	
	[EffectFactory("content")]
	public class ContentEffectFactory extends BaseEffect
	{
		public function ContentEffectFactory()
		{
		}
		
		[Effect(kind="exit", state="contacts")]
		public function exitContactsViewEffect(effect:EffectInfo, c:ContentSkin):void
		{
			var tweens:Array = [];
			
			tweens.push(TweenMax.to(c.contactsView, TIME, {alpha: 0.5, percentHeight: 50, overwrite: OVERWRITE, ease: Expo.easeOut, startAt:{alpha: c.contactsView.alpha}}));
			
			timeline.insertMultiple(tweens);
		}
		
		[Effect(kind="enter", state="contacts")]
		public function enterContactsViewEffect(effect:EffectInfo, c:ContentSkin):void
		{
			var tweens:Array = [];
			
			tweens.push(TweenMax.to(c.contactsView, TIME, {alpha: 1, percentHeight: 100, overwrite: OVERWRITE, ease: Expo.easeOut, startAt:{alpha: 0, percentHeight: 0}}));
			
			timeline.insertMultiple(tweens, 0, TweenAlign.SEQUENCE);
		}
		
		[Effect(kind="exit", state="messages")]
		public function exitMessagesViewEffect(effect:EffectInfo, c:ContentSkin):void
		{
			var tweens:Array = [];
			
			tweens.push(TweenMax.to(c.messagesView, TIME, {alpha: 0.5, percentHeight: 50, overwrite: OVERWRITE, ease: Expo.easeOut, startAt:{alpha: c.messagesView.alpha}}));
			
			timeline.insertMultiple(tweens);
		}
		
		[Effect(kind="enter", state="messages")]
		public function enterMessagesViewEffect(effect:EffectInfo, c:ContentSkin):void
		{
			var tweens:Array = [];
			
			tweens.push(TweenMax.to(c.messagesView, TIME, {alpha: 1, percentHeight: 100, overwrite: OVERWRITE, ease: Expo.easeOut, startAt:{alpha: 0, percentHeight: 0}}));
			
			timeline.insertMultiple(tweens, 0, TweenAlign.SEQUENCE);
		}
	}
}