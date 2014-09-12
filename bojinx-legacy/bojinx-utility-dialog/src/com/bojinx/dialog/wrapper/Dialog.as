package com.bojinx.dialog.wrapper
{
	import com.bojinx.dialog.DialogEvent;
	import com.bojinx.dialog.IDialog;
	import com.bojinx.dialog.IDialogAware;
	import com.bojinx.dialog.IDialogFactory;
	import com.bojinx.dialog.ModalManager;
	import com.bojinx.dialog.util.FocusUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	
	public class Dialog extends DialogSettings implements IDialog
	{
		
		/*============================================================================*/
		/*= PUBLIC PROPERTIES                                                         */
		/*============================================================================*/
		
		private var _data:DialogData;
		
		public function get data():DialogData
		{
			return _data;
		}
		
		private var _destroyed:Boolean = false;
		
		public function get destroyed():Boolean
		{
			return _destroyed;
		}
		
		private var _factory:IDialogFactory;
		
		public function get factory():IDialogFactory
		{
			return _factory;
		}
		
		private var _index:int = 0;
		
		public function get index():int
		{
			return _index;
		}
		
		public function set index( value:int ):void
		{
			_index = value;
		}
		
		private var _isVisible:Boolean = false;
		
		[Bindable( event = "visibleChanged" )]
		public function get isVisible():Boolean
		{
			return _isVisible;
		}
		
		
		private var _modal:Boolean = false;
		
		public function get modal():Boolean
		{
			return _modal;
		}
		
		public function set modal( value:Boolean ):void
		{
			_modal = value;
			
			if ( !value && modalManager && modalManager.isVisible )
			{
				modalManager.hide();
			}
			else if ( data.modalTarget && modalManager && isVisible )
			{
				modalManager.show( data.modalTarget, getSystemManager());
			}
		}
		
		private var _root:Object;
		
		public function get root():Object
		{
			return _root;
		}
		
		override public function set styleName( value:String ):void
		{
			super.styleName = value;
			
			if ( value && window && window.hasOwnProperty( "styleName" ))
				window[ "styleName" ] = styleName;
		}
		
		private var _window:Sprite;
		
		public function get window():Sprite
		{
			return _window;
		}
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var animateOnFirstStart:Boolean = false;
		
		private var contentAttached:Boolean = false;
		
		private var firstStart:Boolean = true;
		
		private var modalManager:ModalManager;
		
		private var mouseIsDown:Boolean = false;
		
		private var sm:Object;
		
		private var visualElement:Class;
		
		private var windowAttached:Boolean = false;
		
		public function Dialog( data:DialogData, factory:IDialogFactory )
		{
			_factory = factory;
			_data = data;
			_data.setDialog( this );
		}
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function getModalOverlay():Sprite
		{
			return modalManager.sprite;
		}
		
		public function updateModal():void
		{
			modalManager.draw();
		}
		
		public function hide( animate:Boolean = true ):void
		{
			checkFirstStart();
			_isVisible = false;
			dispatchEvent( new DialogEvent( DialogEvent.VISIBLE_CHANGED ));
			
			if ( modalManager && modalManager.isVisible )
				modalManager.hide();
			
			if ( requiresFocus )
				FocusUtil.removeFocus( window );
			
			if ( !firstStart )
				_data.effects.playHideEffect( animate );
		}
		
		public function moveBack():void
		{
			var sm:Object = getSystemManager();
			
			if ( index - 1 > 0 )
			{
				root.setChildIndex( window, index - 1 );
				factory.updateAllWindowDepths();
			}
		}
		
		public function moveForward():void
		{
			var sm:Object = getSystemManager();
			var num:int = getNumChildren();
			
			if ( index + 1 <= num )
			{
				root.setChildIndex( window, index + 1 );
				factory.updateAllWindowDepths();
			}
		}
		
		public function movetoTop():void
		{
			var newIndex:int = root.numChildren - 1;
			
			root.setChildIndex( window, newIndex );
			factory.updateAllWindowDepths();
		}
		
		public function removeWindow( animate:Boolean = false ):void
		{
			_destroyed = true;
			
			if ( animate && isVisible )
			{
				addEventListener( DialogEvent.HIDE_COMPLETE, onHideComplete );
				hide( animate );
			}
			else
			{
				onHideComplete( null );
			}
		}
		
		public function show( animate:Boolean = true ):void
		{
			var firstStart:Boolean = this.firstStart;
			animateOnFirstStart = animate;
			checkFirstStart();
			_isVisible = true;
			dispatchEvent( new DialogEvent( DialogEvent.VISIBLE_CHANGED ));
			
			if ( !firstStart )
			{
				showModal();
				_data.effects.playShowEffect( animate );
			}
		}
		
		public function updateDepthIndex():void
		{
			var newIndex:int = root.getChildIndex( window ) + 1;
			var oldIndex:int = index;
			index = newIndex;
			
			if ( alwaysOnTop && newIndex != oldIndex )
			{
				movetoTop();
			}
		}
		
		public function updateNow( animate:Boolean = true ):void
		{
			checkFirstStart();
			factory.updateAllWindowDepths();
			
			if ( requiresFocus )
				FocusUtil.giveFocus( window );
			
			if ( !firstStart && contentChanged && isVisible )
				doAnimateAfterAdding( animate );
			else if ( !firstStart && isVisible )
				doAnimate( animate, false );
			else if ( !firstStart )
				show( animate );
		}
		
		/*============================================================================*/
		/*= PRIVATE METHODS                                                           */
		/*============================================================================*/
		
		private function attachContent():void
		{
			if ( content && !contentAttached )
			{
				contentAttached = true;
				
				if ( content is IDialogAware )
				{
					IDialogAware( content ).dialog = this;
				}
				
				if ( visualElement && window is visualElement )
					Object( window ).addElement( content );
				else
					window.addChild( content );
				
				if ( requiresFocus )
					factory.giveFocusTo( this );
			}
		}
		
		
		private function attachWindow():void
		{
			if ( !root )
			{
				_root = getSystemManager();
				
				try
				{
					visualElement = getDefinitionByName( "mx.core.IVisualElement" ) as Class;
				}
				catch ( e:Error )
				{
					// Ignore is Flash
				}
			}
			
			if ( !windowAttached )
			{
				windowAttached = true;
				window.alpha = 0;
				
				// First try to get a system manager if we
				// are running in flex and the user has not
				// defined a target to attach to.
				if ( data.attachTo || root )
				{
					if ( !root && !data.attachTo )
					{
						throw new Error( "You are running in flash so you need to set attachTo in order to display a dialog" );
					}
					else if ( root && visualElement )
					{
						window.addEventListener( "creationComplete", onFlexWindowCreationComplete );
						root.addChild( window );
						factory.updateAllWindowDepths();
					}
					else
					{
						window.addEventListener( Event.ADDED_TO_STAGE, onFlexWindowCreationComplete );
						root.addChild( window );
						factory.updateAllWindowDepths();
					}
					
					if ( styleName && window && window.hasOwnProperty( "styleName" ))
						window[ "styleName" ] = styleName;
					
					dispatchEvent( new DialogEvent( DialogEvent.WINDOW_ADDED ));
					
					// Start hidden so we can resize, animate etc.
					
					window.addEventListener( MouseEvent.CLICK, onWindowClicked, false, -1000 );
					window.addEventListener( MouseEvent.MOUSE_DOWN, onWindowMouseDown );
					window.addEventListener( MouseEvent.MOUSE_UP, onWindowMouseUp );
					window.addEventListener( MouseEvent.MOUSE_OUT, onWindowMouseUp );
					window.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
				}
			}
		}
		
		private function checkFirstStart():void
		{
			if ( firstStart )
			{
				firstStart = false;
				
				createWindow();
				attachWindow();
				attachContent();
			}
		}
		
		private function createWindow():void
		{
			if ( data.windowClass )
			{
				_window = new data.windowClass();
				
				if ( _window is IDialogAware )
					IDialogAware( _window ).dialog = this;
			}
		}
		
		private function doAnimate( animate:Boolean, firstStart:Boolean ):void
		{
			_data.effects.animate( animate, firstStart );
		}
		
		private function doAnimateAfterAdding( animate:Boolean ):void
		{
			contentChanged = false;
			
			if ( prevContent && prevContent.parent )
			{
				if ( prevContent && prevContent.parent is visualElement )
					Object( prevContent.parent ).removeElement( prevContent );
				else if(prevContent)
					prevContent.parent.removeChild( prevContent );
				
				contentAttached = false;
				prevContent = null;
			}
			
			if ( content && !content.parent )
			{
				if ( content is visualElement )
					content.addEventListener( "creationComplete", onDeferedContentAdded );
				else
					content.addEventListener( Event.ADDED_TO_STAGE, onDeferedContentAdded );
				
				attachContent();
			}
		}
		
		private function getNumChildren():int
		{
			var sm:Object = getSystemManager();
			var numChildren:int;
			
			if ( sm )
				numChildren = sm.numChildren;
			else
				numChildren = data.attachTo.numChildren;
			
			return numChildren - 1;
		}
		
		private function getSystemManager():Object
		{
			var app:Object;
			var sm:Object;
			
			try
			{
				app = getDefinitionByName( "mx.core.FlexGlobals" );
				
				if ( data.attachTo.hasOwnProperty( "systemManager" ))
				{
					this.sm = data.attachTo[ "systemManager" ];
				}
				else
				{
					this.sm = app.topLevelApplication.systemManager;
				}
			}
			catch ( e:Error )
			{
				// Ignore it's flash!
			}
			
			if ( this.sm )
				sm = this.sm.popUpChildren;
			else
				sm = this.data.attachTo;
			
			return sm;
		}
		
		private function onDeferedContentAdded( event:Event ):void
		{
			content.removeEventListener( Event.ADDED_TO_STAGE, onDeferedContentAdded );
			updateNow();
		}
		
		private function onFlexWindowCreationComplete( event:Event ):void
		{
			_isVisible = true;
			factory.updateAllWindowDepths();
			
			window.removeEventListener( "updateComplete", onFlexWindowCreationComplete );
			
			showModal();
			doAnimate( animateOnFirstStart, true );
		}
		
		private function onHideComplete( event:Event ):void
		{
			if ( !destroyed )
				return;
			
			modalManager.dispose();
			factory.releaseDialog( this );
			
			if ( content )
			{
				if ( visualElement && window is visualElement && window.contains( content ))
					Object( window ).removeElement( content );
				else if ( window.contains( content ))
					window.removeChild( content );
				
				dispatchEvent( new DialogEvent( DialogEvent.WINDOW_REMOVED ));
				contentAttached = false;
			}
			
			if ( window && window.parent )
				root.removeChild( window );
			
			firstStart = true;
			_isVisible = false;
			dispatchEvent( new DialogEvent( DialogEvent.VISIBLE_CHANGED ));
		}
		
		private function onMouseMove( event:MouseEvent ):void
		{
			if ( mouseIsDown && draggable )
			{
				window.startDrag( false, bounds );
			}
		}
		
		private function onWindowClicked( event:MouseEvent ):void
		{
			if ( bringToFrontOnClick )
				movetoTop();
			else
			{
				var previousIndex:int = index;
				factory.updateAllWindowDepths();
				var newIndex:int = index;
				
				if ( previousIndex > -1 && previousIndex != newIndex )
				{
					root.setChildIndex( window, previousIndex );
					
					factory.updateAllWindowDepths();
					
					if ( requiresFocus )
						factory.giveFocusTo( this );
					else
						factory.giveFocusToTopMost();
					
					dispatchEvent( new DialogEvent( DialogEvent.DEPTH_CHANGED ));
				}
			}
		}
		
		private function onWindowMouseDown( event:MouseEvent ):void
		{
			mouseIsDown = true;
		}
		
		private function onWindowMouseUp( event:MouseEvent ):void
		{
			mouseIsDown = false;
			window.stopDrag();
		}
		
		private function showModal():void
		{
			if ( !modalManager )
			{
				modalManager = new ModalManager( this );
			}
			
			if ( modal )
			{
				modalManager.show( data.modalTarget ? data.modalTarget : sm as Sprite, root );
			}
		}
	}
}
