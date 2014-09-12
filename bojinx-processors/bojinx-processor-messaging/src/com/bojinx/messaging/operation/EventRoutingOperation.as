package com.bojinx.messaging.operation
{
	import com.bojinx.api.processor.metadata.IMetaData;
	import com.bojinx.messaging.meta.EventMetadata;
	import com.bojinx.messaging.meta.RouteEventsMetadata;
	import com.bojinx.reflection.ClassInfo;
	import com.bojinx.system.cache.definition.MetaDefinition;
	import com.bojinx.system.processor.AbstractProcessor;
	import com.bojinx.utils.data.HashMap;
	import com.bojinx.utils.logging.Logger;
	import com.bojinx.utils.logging.LoggingContext;
	
	import flash.events.IEventDispatcher;
	
	public class EventRoutingOperation extends AbstractProcessor
	{
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var eventMap:HashMap;
		
		public function EventRoutingOperation()
		{
			super();
		}
		
		/*============================================================================*/
		/*= STATIC PRIVATE PROPERTIES                                                 */
		/*============================================================================*/
		
		CONFIG::log
		private static const log:Logger = LoggingContext.getLogger( EventRoutingOperation );
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		override public function process( value:MetaDefinition ):void
		{
			var metaData:ClassInfo = value.owner.type;
			var eventNames:Array = RouteEventsMetadata( value.meta ).getEventsAsArray();
			var annotation:RouteEventsMetadata = value.meta as RouteEventsMetadata;
			var eventName:String;
			var eventType:String;
			var e:EventMetadata;
			var listener:Listener;
			
			if ( !eventMap )
				eventMap = new HashMap();
			
			if(!annotation.events)
			{
				for each ( var i:IMetaData in metaData.meta )
				{
					if ( i is EventMetadata && !annotation.events )
					{
						e = i as EventMetadata;
						
						eventName = e.name;
						eventType = e.type;
						
						if (( value.owner.target is IEventDispatcher && !eventNames ) ||
							( value.owner.target is IEventDispatcher ) &&
							eventNames && eventNames.indexOf( eventName ) > -1 )
						{
							listener = eventMap.getValue( value.owner.target );
							
							if ( !listener )
								listener = new Listener( eventName, value.owner );
							else
								listener.addListener( eventName );
							
							CONFIG::log
							{
								log.debug( "Added routing for event " + eventType + " with name " + eventName );
							}
							
							eventMap.put( value.owner.target, listener );
						}
					}
				}
			}
			else if(annotation.events)
			{
				for each(var en:String in eventNames)
				{
					listener = eventMap.getValue( value.owner.target );
					
					if ( !listener )
						listener = new Listener( en, value.owner );
					else
						listener.addListener( en );
					
					CONFIG::log
					{
						log.debug( "Added routing for event " + eventType + " with name " + en );
					}
					
					eventMap.put( value.owner.target, listener );
				}
			}
			
			complete( value );
		}
		
		override public function release( value:MetaDefinition ):void
		{
			var listener:Listener = eventMap.getValue( value.owner.target );
			
			if ( listener )
			{
				listener.dispose();
			}
			
			eventMap.remove( value.owner.target );
			
			complete( value );
		}
	}
}

import com.bojinx.system.cache.definition.ObjectDefinition;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.IEventDispatcher;

class Listener
{
	/*============================================================================*/
	/*= PUBLIC PROPERTIES                                                         */
	/*============================================================================*/
	
	private var _target:ObjectDefinition;
	
	public function get target():ObjectDefinition
	{
		return _target;
	}
	
	/*============================================================================*/
	/*= PRIVATE PROPERTIES                                                        */
	/*============================================================================*/
	
	private var events:Array = [];
	
	public function Listener( name:String, target:ObjectDefinition )
	{
		this._target = target;
		
		addListener( name );
	}
	
	/*============================================================================*/
	/*= PUBLIC METHODS                                                            */
	/*============================================================================*/
	
	public function addListener( name:String ):void
	{
		events.push( name );
		IEventDispatcher( target.target ).addEventListener( name, onEvent );
	}
	
	public function dispose():void
	{
		while ( events.length > 0 )
		{
			var name:String = events.pop();
			
			IEventDispatcher( target.target ).removeEventListener( name, onEvent );
		}
		
		_target = null;
		events = null;
	}
	
	/*============================================================================*/
	/*= PRIVATE METHODS                                                           */
	/*============================================================================*/
	
	private function onEvent( event:Event ):void
	{
		var asSprite:Sprite = target.target as Sprite;
		
		if ( !asSprite ||
			( asSprite && event.bubbles && asSprite.visible == true && asSprite.parent != null ))
		{
			target.context.messageBus.dispatch( event, event.type );
		}
	}
}
