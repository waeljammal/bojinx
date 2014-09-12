package com.bojinx.api.processor
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.system.cache.definition.MergedMetaDefinition;
	import com.bojinx.system.cache.definition.MetaDefinition;
	import flash.events.IEventDispatcher;
	
	public interface IProcessor extends IEventDispatcher
	{
		function process( value:MetaDefinition ):void;
		function processMerged( value:MergedMetaDefinition ):void;
		function release( value:MetaDefinition ):void;
		function releaseMerged( value:MergedMetaDefinition ):void;
	}
}
