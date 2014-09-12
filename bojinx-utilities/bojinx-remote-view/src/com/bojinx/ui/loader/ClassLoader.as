package com.bojinx.ui.loader
{
	import com.bojinx.ui.event.ClassLoaderEvent;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	[Event( name = "complete", type = "com.bojinx.ui.event.ClassLoaderEvent" )]
	public class ClassLoader extends EventDispatcher
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _result:*;
		
		public function get result():*
		{
			return _result;
		}
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var mLoader:Loader;
		
		public function ClassLoader( target:IEventDispatcher = null )
		{
			super( target );
		}
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function load( classPath:String, rootPath:String, classType:String, server:String ):void
		{
			mLoader = new Loader();
			var mRequest:URLRequest = new URLRequest( server + "?classPath=" + classPath + "&rootPath=" + rootPath + "&classType=" + classType);
			addListeners();
			mLoader.load( mRequest, new LoaderContext( false, ApplicationDomain.currentDomain ));
		}
		
		/*============================================================================*/
		/*= PROTECTED METHODS                                                         */
		/*============================================================================*/
		
		protected function onCompleteHandler( event:Event ):void
		{
			removeListeners();
			
			_result = event.currentTarget.content;
			
			dispatchEvent(new ClassLoaderEvent(ClassLoaderEvent.COMPLETE, _result));
		}
		
		protected function onProgressHandler( event:ProgressEvent ):void
		{
			var percent:Number = event.bytesLoaded/event.bytesTotal;
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function addListeners():void
		{
			mLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, onCompleteHandler );
			mLoader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, onProgressHandler );
		}
		
		private function removeListeners():void
		{
			mLoader.contentLoaderInfo.removeEventListener( Event.COMPLETE, onCompleteHandler );
			mLoader.contentLoaderInfo.removeEventListener( ProgressEvent.PROGRESS, onProgressHandler );
		}
	}
}