package com.bojinx.injection.descriptor
{
	import com.bojinx.injection.meta.Inject;
	import com.bojinx.reflection.Method;
	import com.bojinx.reflection.Property;
	import com.bojinx.system.cache.definition.MetaDefinition;
	import com.bojinx.system.cache.definition.ObjectDefinition;
	import com.bojinx.utils.FactoryUtil;
	
	import flash.events.IEventDispatcher;
	
	import flight.binding.Bind;
	import flight.events.PropertyEvent;
	
	/**
	 * Stores binding information so it can be rleased at a later point.
	 *
	 * @author Wael Jammal
	 */
	public class BindingItem
	{
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _metaDefinition:MetaDefinition;
		
		
		public function get metaDefinition():MetaDefinition
		{
			return _metaDefinition;
		}
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var binding:Bind;
		
		private var sourceWatcher:Object;
		
		private var targetWatcher:Object;
		
		public function BindingItem( meta:MetaDefinition )
		{
			_metaDefinition = meta;
			super();
		}
		
		/*============================================================================*/
		/*= STATIC PRIVATE PROPERTIES                                                 */
		/*============================================================================*/
		
		private static const CHANGE:String = "Change";
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function release():void
		{
			if ( sourceWatcher )
			{
				sourceWatcher[ "unwatch" ]();
			}
			
			if ( targetWatcher )
			{
				targetWatcher[ "unwatch" ]();
			}
			
			sourceWatcher = null;
			targetWatcher = null;
		}
		
		public function setupMethodBinding():void
		{
			var definition:ObjectDefinition = _metaDefinition.owner;
			var method:Method = _metaDefinition.member as Method;
			var meta:Inject = ( _metaDefinition.meta as Inject );
			var event:String = method.name + CHANGE;
			var dependency:ObjectDefinition = ObjectDefinition( _metaDefinition.dependencies[ 0 ]);
			var factoryName:String = dependency.bean.factoryMethod;
			var parameter:Object = factoryName ?  FactoryUtil.valueFromFactory(dependency) : dependency.target;
			var hasDependencies:Boolean =
				_metaDefinition.owner.context.applicationDomain.hasDefinition( "mx.binding.utils.ChangeWatcher" );
			
			if ( !parameter )
			{
				throw new Error( "No Managed Objects found with id " + meta.id );
			}
			
			if ( !hasDependencies )
			{
				if ( !( parameter is IEventDispatcher ))
				{
					throw new Error( "Object " + parameter + " with " +
									 "property chain " + meta.property + " is being used as a " +
									 "source for binding but is not an event dispatcher" );
				}
				else if ( !hasDependencies )
				{
					binding = new Bind( definition.target, method.name, parameter, meta.property );
					binding.addEventListener( PropertyEvent.PROPERTY_CHANGE, invokeMethod );
				}
			}
			else if ( hasDependencies )
			{
				var chain:Array = meta.property.split( "." );
				var util:Object =
					_metaDefinition.owner.context.applicationDomain.getDefinition( "mx.binding.utils.ChangeWatcher" );
				
				sourceWatcher =
					util[ "watch" ]( parameter, chain, null, false, false );
				
				if ( sourceWatcher != null )
				{
					sourceWatcher.setHandler( assignToTargetMethod );
					assignToTargetMethod( null );
				}
				
				if ( meta.mode == "twoWay" )
				{
					throw new Error( "Methods do not support two way binding" );
				}
			}
		}
		
		public function setupPropertyBinding():void
		{
			var definition:ObjectDefinition = _metaDefinition.owner;
			var property:Property = _metaDefinition.member as Property;
			var meta:Inject = ( _metaDefinition.meta as Inject );
			var event:String = property.name + CHANGE;
			var dependency:ObjectDefinition = ObjectDefinition( _metaDefinition.dependencies[ 0 ]);
			var factoryName:String = dependency.bean.factoryMethod;
			var target:Object = factoryName ?  FactoryUtil.valueFromFactory(dependency) : dependency.target;
			var hasDependencies:Boolean =
				definition.context.applicationDomain.hasDefinition( "mx.binding.utils.ChangeWatcher" );
			
			// Pure AS3 Support
			if ( !hasDependencies && !( target is IEventDispatcher ))
			{
				throw new Error( "Object " + target + " with " +
								 "property name " + property.name + " is being used as a " +
								 "source for binding but is not an event dispatcher" );
			}
			else if ( !hasDependencies )
			{
				binding = new Bind( definition.target, property.name, target, meta.property, meta.mode == "twoWay" );
			}
			else if ( hasDependencies )
			{
				var chain:Array = meta.property.split( "." );
				var util:Object =
					definition.context.applicationDomain.getDefinition( "mx.binding.utils.ChangeWatcher" );
				
				sourceWatcher =
					util[ "watch" ]( target, chain, null, false, false );
				
				if ( sourceWatcher != null )
				{
					sourceWatcher.setHandler( assignToTargetProperty );
					assignToTargetProperty( null );
				}
				
				if ( meta.mode == "twoWay" )
				{
					targetWatcher =
						util[ "watch" ]( definition.target, property.name, null, false, false );
					
					if ( targetWatcher != null )
					{
						targetWatcher.setHandler( assignToSourceProperty );
						assignToSourceProperty( null );
					}
				}
			}
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function assignToSourceProperty( event:* ):void
		{
			var meta:Inject = ( _metaDefinition.meta as Inject );
			var property:Property = _metaDefinition.member as Property;
			var target:Object = ObjectDefinition( _metaDefinition.dependencies[ 0 ]).target;
			
			target[ meta.property ] = targetWatcher.getValue();
		}
		
		private function assignToTargetMethod( event:* ):void
		{
			var method:Method = _metaDefinition.member as Method;
			method.invoke( _metaDefinition.owner.target, [ sourceWatcher.getValue()]);
		}
		
		private function assignToTargetProperty( event:* ):void
		{
			var property:Property = _metaDefinition.member as Property;
			_metaDefinition.owner.target[ property.name ] = sourceWatcher.getValue();
		}
		
		private function invokeMethod( event:PropertyEvent ):void
		{
			var method:Method = _metaDefinition.member as Method;
			method.invoke( _metaDefinition.owner.target, [ event.newValue ]);
		}
	}
}
