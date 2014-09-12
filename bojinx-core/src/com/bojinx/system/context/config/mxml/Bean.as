package com.bojinx.system.context.config.mxml
{
	import com.bojinx.system.context.config.Bean;
	import mx.core.IMXMLObject;
	
	[DefaultProperty( "elements" )]
	[Exclude( kind = "property", name = "id" )]
	/**
	 * MXML based object entry for a Context Configuration wrapper.
	 *
	 * @author Wael Jammal
	 * @Manifest
	 */
	public class Bean extends com.bojinx.system.context.config.Bean implements IMXMLObject
	{
		/**
		 * Constructor takes arguments to simplify AS3 creation.
		 *
		 * @param source The Class of the object to manage.
		 * @param objectId Optional identifier can be used when multiple instances are required.
		 * @param singleton False by default, set to true to only create a single instance.
		 */
		public function Bean( source:Class = null, objectId:String = null, singleton:Boolean = false )
		{
			super( source, objectId, singleton );
		}
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		/**
		 * @private
		 */
		public function initialized( document:Object, id:String ):void
		{
			this.id = id;
		}
	}
}
