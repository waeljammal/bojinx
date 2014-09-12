package com.bojinx.ui.loader
{
	import com.bojinx.ui.event.ClassLoaderEvent;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import mx.core.IMXMLObject;
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	
	public class ViewLoader extends EventDispatcher implements IMXMLObject
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _classPath:String;
		
		public function get classPath():String
		{
			return _classPath;
		}
		
		public function set classPath( value:String ):void
		{
			_classPath = value;
		}
		
		private var _classType:String;
		
		public function get classType():String
		{
			return _classType;
		}
		
		[Inspectable(defaultValue="mxml", enumeration="mxml,as")]
		public function set classType( value:String ):void
		{
			_classType = value;
		}
		
		private var _rootPath:String;
		
		public function get rootPath():String
		{
			return _rootPath;
		}
		
		public function set rootPath( value:String ):void
		{
			_rootPath = value;
		}
		
		private var _target:UIComponent;
		
		public function get target():UIComponent
		{
			return _target;
		}
		
		public function set target( value:UIComponent ):void
		{
			_target = value;
		}
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var classLoader:ClassLoader;
		
		private var currentClassPath:String;
		
		public function ViewLoader( target:IEventDispatcher = null )
		{
			super( target );
		}
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function initialized( document:Object, id:String ):void
		{
			if ( !_target )
				_target = document as UIComponent;
			
			loadView();
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function loadView():void
		{
			if ( !classLoader )
				classLoader = new ClassLoader();
			
			classLoader.addEventListener( ClassLoaderEvent.COMPLETE, onComplete );
			classLoader.load( classPath, rootPath, classType, "http://localhost:8080/bojinx" );
		}
		
		private function onComplete( event:ClassLoaderEvent ):void
		{
			classLoader.removeEventListener( ClassLoaderEvent.COMPLETE, onComplete );
			
			var c:UIComponent = event.data as UIComponent;
			c.systemManager = _target.systemManager;
			
			if ( _target is IVisualElementContainer )
				( _target as IVisualElementContainer ).addElement( c );
			else
				_target.addChild( c );
		}
	}
}