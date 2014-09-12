package com.bojinx.included.operation
{
	import com.bojinx.included.meta.ContextMetadata;
	import com.bojinx.included.meta.DestroyMetadata;
	import com.bojinx.included.meta.ILifeCyleMetadata;
	import com.bojinx.reflection.Method;
	import com.bojinx.reflection.Property;
	import com.bojinx.system.cache.definition.MetaDefinition;
	import com.bojinx.system.processor.AbstractProcessor;
	
	[ExcludeClass]
	/**
	 * @private
	 */
	public class BuiltInFeatureOperation extends AbstractProcessor
	{
		public function BuiltInFeatureOperation()
		{
			super();
		}
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		override public function process( value:MetaDefinition ):void
		{
			if ( value.meta is ContextMetadata )
				invokeOrSet( value, value.owner.context );
			else if ( value.meta is ILifeCyleMetadata )
				invokeOrSet( value );
			
			complete( value );
		}
		
		override public function release( value:MetaDefinition ):void
		{
			if ( value.meta is DestroyMetadata )
				invokeOrSet(value);
			
			complete(value);
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function invokeOrSet( meta:MetaDefinition, value:* = null ):void
		{
			if ( meta.member is Property )
				( meta.member as Property ).setValue( meta.owner.target, value );
			else if ( meta.member is Method )
				( meta.member as Method ).invoke( meta.owner.target, value ? [ value ] : null );
		}
	}
}
