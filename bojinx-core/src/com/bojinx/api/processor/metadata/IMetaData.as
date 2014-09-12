package com.bojinx.api.processor.metadata
{
	import com.bojinx.reflection.MetaDataDescriptor;
	
	public interface IMetaData
	{
		/**
		 * The life cycle stage to run the request in.
		 *
		 * @para value String (preInit, afterPreInit, postInit, afterPostInit, ready, afterReady, destroy, afterDestroy)
		 * @return String
		 */
		function get stage():int;
	}
}
