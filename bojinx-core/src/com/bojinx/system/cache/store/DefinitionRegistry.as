package com.bojinx.system.cache.store
{
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.system.cache.definition.ObjectDefinition;
	import flash.utils.Dictionary;
	
	public class DefinitionRegistry
	{
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var context:IApplicationContext;
		
		private var definitions:Dictionary;
		
		public function DefinitionRegistry( context:IApplicationContext )
		{
			this.context = context;
		}
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function dispose():void
		{
			definitions = null;
			context = null;
		}
		
		public function forEach( callback:Function ):void
		{
			for each ( var i:ObjectDefinition in definitions )
				callback( i );
		}
		
		public function getDefinitionById( id:String ):ObjectDefinition
		{
			initDefinitions();
			
			if ( definitions[ id ])
				return definitions[ id ];
			else if ( context.parent )
				return context.parent.cache.definitions.getDefinitionById( id );
			
			return null;
		}
		
		public function getDefinitionByInstance( value:* ):ObjectDefinition
		{
			initDefinitions();
			
			if ( definitions[ value ])
				return definitions[ value ];
			else if ( context.parent )
				return context.parent.cache.definitions.getDefinitionByInstance( value );
			
			return null;
		}
		
		public function registerDefinition( definition:ObjectDefinition ):void
		{
			initDefinitions();
			
			if(definition.bean)
				definitions[ definition.bean.id ] = definition;
			
			definitions[ definition.target ] = definition;
		}
		
		public function removeDefinition( definition:ObjectDefinition ):void
		{
			if(definition.bean)
				delete(definitions[ definition.bean.id ]);
			
			delete(definitions[definition.target]);
		}
		
		public function removeDefinitionForInstance( value:* ):Boolean
		{
			if ( definitions[ value ])
				delete( definitions[ value ]);
			else if ( context.parent )
				return context.parent.cache.definitions.removeDefinitionForInstance( value );
			
			return true;
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function initDefinitions():void
		{
			if ( !definitions )
				definitions = new Dictionary( false );
		}
	}
}
