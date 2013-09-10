
///<reference path="../_definitions.ts"/>

package away.managers
{
	import away.events.EventDispatcher;
	import away.display3D.Context3D;
	import away.display.Stage3D;
	import away.display3D.Program3D;
	import away.display3D.TextureBase;
	import away.geom.Rectangle;
	import away.events.Event;
	import away.events.Stage3DEvent;
	import away.utils.Debug;
	import away.display3D.Context3DClearMask;
	import randori.webkit.html.HTMLCanvasElement;
	//import away3d.arcane;
	//import away3d.debug.Debug;
	//import away3d.events.Stage3DEvent;
	
	//import flash.display.Shape;
	//import flash.display.Stage3D;
	//import flash.display3D.Context3D;
	//import flash.display3D.Context3DClearMask;
	//import flash.display3D.Context3DRenderMode;
	//import flash.display3D.Program3D;
	//import flash.display3D.textures.TextureBase;
	//import flash.events.Event;
	//import flash.events.EventDispatcher;
	//import flash.geom.Rectangle;
	
	//use namespace arcane;
	
	//[Event(name="enterFrame", type="flash.events.Event")]
	//[Event(name="exitFrame", type="flash.events.Event")]
	
	/**	 * Stage3DProxy provides a proxy class to manage a single Stage3D instance as well as handling the creation and	 * attachment of the Context3D (and in turn the back buffer) is uses. Stage3DProxy should never be created directly,	 * but requested through Stage3DManager.	 *	 * @see away3d.core.managers.Stage3DProxy	 *	 * todo: consider moving all creation methods (createVertexBuffer etc) in here, so that disposal can occur here	 * along with the context, instead of scattered throughout the framework	 */
	public class Stage3DProxy extends EventDispatcher
	{
		//private static _frameEventDriver:Shape = new Shape(); // TODO: add frame driver / request animation frame
		
		public var _iContext3D:Context3D;
		public var _iStage3DIndex:Number = -1;
		
		private var _usesSoftwareRendering:Boolean;
		private var _profile:String;
		private var _stage3D:Stage3D;
		private var _activeProgram3D:Program3D;
		private var _stage3DManager:Stage3DManager;
		private var _backBufferWidth:Number;
		private var _backBufferHeight:Number;
		private var _antiAlias:Number = 0;
		private var _enableDepthAndStencil:Boolean;
		private var _contextRequested:Boolean;
		//private var _activeVertexBuffers : Vector.<VertexBuffer3D> = new Vector.<VertexBuffer3D>(8, true);
		//private var _activeTextures : Vector.<TextureBase> = new Vector.<TextureBase>(8, true);
		private var _renderTarget:TextureBase = null;
		private var _renderSurfaceSelector:Number = 0;
        private var _scissorRect:Rectangle;
		private var _color:Number;
		private var _backBufferDirty:Boolean;
		private var _viewPort:Rectangle;
		private var _enterFrame:Event;
		private var _exitFrame:Event;
		private var _viewportUpdated:Stage3DEvent;
		private var _viewportDirty:Boolean;
		private var _bufferClear:Boolean;
		private var _mouse3DManager:Mouse3DManager;
		//private _touch3DManager:Touch3DManager; //TODO: imeplement dependency Touch3DManager
		
		private function notifyViewportUpdated():void
		{
			if (_viewportDirty)
            {

                return;

            }

			_viewportDirty = true;

			//if (!this.hasEventListener(away.events.Stage3DEvent.VIEWPORT_UPDATED))
				//return;
			
			//if (!_viewportUpdated)
			_viewportUpdated = new Stage3DEvent(Stage3DEvent.VIEWPORT_UPDATED);
			dispatchEvent(_viewportUpdated);
		}
		
		private function notifyEnterFrame():void
		{
			//if (!hasEventListener(Event.ENTER_FRAME))
				//return;
			
			if (!_enterFrame)
            {

                _enterFrame = new Event(Event.ENTER_FRAME);

            }

			
			dispatchEvent(_enterFrame);

		}
		
		private function notifyExitFrame():void
		{
			//if (!hasEventListener(Event.EXIT_FRAME))
				//return;
			
			if (!_exitFrame)
				_exitFrame = new Event(Event.EXIT_FRAME);
			
			dispatchEvent(_exitFrame);
		}
		
		/**		 * Creates a Stage3DProxy object. This method should not be called directly. Creation of Stage3DProxy objects should		 * be handled by Stage3DManager.		 * @param stage3DIndex The index of the Stage3D to be proxied.		 * @param stage3D The Stage3D to be proxied.		 * @param stage3DManager		 * @param forceSoftware Whether to force software mode even if hardware acceleration is available.		 */
		public function Stage3DProxy(stage3DIndex:Number, stage3D:Stage3D, stage3DManager:Stage3DManager, forceSoftware:Boolean = false, profile:String = "baseline"):void
		{

            super();

			_iStage3DIndex = stage3DIndex;
            _stage3D = stage3D;

            _stage3D.x = 0;
            _stage3D.y = 0;
            _stage3D.visible = true;
            _stage3DManager = stage3DManager;
            _viewPort = new Rectangle();
            _enableDepthAndStencil = true;
			
			// whatever happens, be sure this has highest priority
			_stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContext3DUpdate, this ) ;//, false, 1000, false);
			requestContext( forceSoftware , profile);


		}
		
		public function get profile():String
		{
			return _profile;
		}
		
		/**		 * Disposes the Stage3DProxy object, freeing the Context3D attached to the Stage3D.		 */
		public function dispose():void
		{
			_stage3DManager.iRemoveStage3DProxy(this);
			_stage3D.removeEventListener(Event.CONTEXT3D_CREATE, onContext3DUpdate , this );
			freeContext3D();
            _stage3D = null;
            _stage3DManager = null;
            _iStage3DIndex = -1;
		}
		
		/**		 * Configures the back buffer associated with the Stage3D object.		 * @param backBufferWidth The width of the backbuffer.		 * @param backBufferHeight The height of the backbuffer.		 * @param antiAlias The amount of anti-aliasing to use.		 * @param enableDepthAndStencil Indicates whether the back buffer contains a depth and stencil buffer.		 */
		public function configureBackBuffer(backBufferWidth:Number, backBufferHeight:Number, antiAlias:Number, enableDepthAndStencil:Boolean):void
		{
			var oldWidth:Number = _backBufferWidth;
			var oldHeight:Number = _backBufferHeight;

            _backBufferWidth = _viewPort.width = backBufferWidth;
            _backBufferHeight = _viewPort.height = backBufferHeight;
			
			if (oldWidth != _backBufferWidth || oldHeight != _backBufferHeight)
                notifyViewportUpdated();

            _antiAlias = antiAlias;
            _enableDepthAndStencil = enableDepthAndStencil;
			
			if (_iContext3D)
                _iContext3D.configureBackBuffer(backBufferWidth, backBufferHeight, antiAlias, enableDepthAndStencil);

            _stage3D.width = backBufferWidth;
            _stage3D.height = backBufferHeight;

		}
		
		/*		 * Indicates whether the depth and stencil buffer is used		 */
		public function get enableDepthAndStencil():Boolean
		{
			return _enableDepthAndStencil;
		}
		
		public function set enableDepthAndStencil(enableDepthAndStencil:Boolean):void
		{
            _enableDepthAndStencil = enableDepthAndStencil;
            _backBufferDirty = true;
		}
		
		public function get renderTarget():TextureBase
		{
			return _renderTarget;
		}
		
		public function get renderSurfaceSelector():Number
		{
			return _renderSurfaceSelector;
		}
		
		public function setRenderTarget(target:TextureBase, enableDepthAndStencil:Boolean = false, surfaceSelector:Number = 0):void
		{
			if (_renderTarget === target && surfaceSelector == _renderSurfaceSelector && _enableDepthAndStencil == enableDepthAndStencil)
            {
                return;
            }

			_renderTarget = target;
            _renderSurfaceSelector = surfaceSelector;
            _enableDepthAndStencil = enableDepthAndStencil;

            Debug.throwPIR( 'Stage3DProxy' , 'setRenderTarget' , 'away.display3D.Context3D: setRenderToTexture , setRenderToBackBuffer');

            // todo : implement

            /*			if (target)            {                this._iContext3D.setRenderToTexture(target, enableDepthAndStencil, this._antiAlias, surfaceSelector);            }			else            {                this._iContext3D.setRenderToBackBuffer();            }            */
		}
		
		/*		 * Clear and reset the back buffer when using a shared context		 */
		public function clear():void
		{
			if (!_iContext3D)
				return;
			
			if (_backBufferDirty) {
				configureBackBuffer(_backBufferWidth, _backBufferHeight, _antiAlias, _enableDepthAndStencil);
                _backBufferDirty = false;
			}

            _iContext3D.clear( ( _color & 0xff000000 ) >>> 24 , // <--------- Zero-fill right shift
                                    ( _color & 0xff0000 ) >>> 16, // <-------------|
                                    ( _color & 0xff00 ) >>> 8, // <----------------|
                                      _color & 0xff ) ;

			_bufferClear = true;
		}
		
		/*		 * Display the back rendering buffer		 */
		public function present():void
		{
			if (!_iContext3D)
				return;
			
			_iContext3D.present();
			
			_activeProgram3D = null;
			
			if (_mouse3DManager)
                _mouse3DManager.fireMouseEvents();
		}
		
		/**		 * Registers an event listener object with an EventDispatcher object so that the listener receives notification of an event. Special case for enterframe and exitframe events - will switch Stage3DProxy into automatic render mode.		 * You can register event listeners on all nodes in the display list for a specific type of event, phase, and priority.		 *		 * @param type The type of event.		 * @param listener The listener function that processes the event.		 * @param useCapture Determines whether the listener works in the capture phase or the target and bubbling phases. If useCapture is set to true, the listener processes the event only during the capture phase and not in the target or bubbling phase. If useCapture is false, the listener processes the event only during the target or bubbling phase. To listen for the event in all three phases, call addEventListener twice, once with useCapture set to true, then again with useCapture set to false.		 * @param priority The priority level of the event listener. The priority is designated by a signed 32-bit integer. The higher the number, the higher the priority. All listeners with priority n are processed before listeners of priority n-1. If two or more listeners share the same priority, they are processed in the order in which they were added. The default priority is 0.		 * @param useWeakReference Determines whether the reference to the listener is strong or weak. A strong reference (the default) prevents your listener from being garbage-collected. A weak reference does not.		 */
		//public override function addEventListener(type:string, listener, useCapture:boolean = false, priority:number = 0, useWeakReference:boolean = false)
        override public function addEventListener(type:String, listener:Function, target:Object):void
		{
			super.addEventListener(type, listener, target ) ;//useCapture, priority, useWeakReference);

            //away.Debug.throwPIR( 'Stage3DProxy' , 'addEventListener' ,  'EnterFrame, ExitFrame');

            //if ((type == away.events.Event.ENTER_FRAME || type == away.events.Event.EXIT_FRAME) ){//&& ! this._frameEventDriver.hasEventListener(Event.ENTER_FRAME)){

                //_frameEventDriver.addEventListener(Event.ENTER_FRAME, onEnterFrame, useCapture, priority, useWeakReference);

            //}

            /* Original code            if ((type == Event.ENTER_FRAME || type == Event.EXIT_FRAME) && ! _frameEventDriver.hasEventListener(Event.ENTER_FRAME)){                _frameEventDriver.addEventListener(Event.ENTER_FRAME, onEnterFrame, useCapture, priority, useWeakReference);            }			*/
		}
		
		/**		 * Removes a listener from the EventDispatcher object. Special case for enterframe and exitframe events - will switch Stage3DProxy out of automatic render mode.		 * If there is no matching listener registered with the EventDispatcher object, a call to this method has no effect.		 *		 * @param type The type of event.		 * @param listener The listener object to remove.		 * @param useCapture Specifies whether the listener was registered for the capture phase or the target and bubbling phases. If the listener was registered for both the capture phase and the target and bubbling phases, two calls to removeEventListener() are required to remove both, one call with useCapture() set to true, and another call with useCapture() set to false.		 */
        override public function removeEventListener(type:String, listener:Function, target:Object):void
//public override function removeEventListener(type:string, listener, useCapture:boolean = false)		{
			super.removeEventListener(type, listener, target);

            //away.Debug.throwPIR( 'Stage3DProxy' , 'removeEventListener' ,  'EnterFrame, ExitFrame');

            /*			// Remove the main rendering listener if no EnterFrame listeners remain			if (    ! this.hasEventListener(away.events.Event.ENTER_FRAME , this.onEnterFrame , this )                &&  ! this.hasEventListener(away.events.Event.EXIT_FRAME , this.onEnterFrame , this) ) //&& _frameEventDriver.hasEventListener(Event.ENTER_FRAME))            {                //_frameEventDriver.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame, this );            }            */
		}
		
		public function get scissorRect():Rectangle
		{
			return _scissorRect;
		}
		public function set scissorRect(value:Rectangle):void
		{
			_scissorRect = value;
			_iContext3D.setScissorRectangle(_scissorRect);
		}
		
		/**		 * The index of the Stage3D which is managed by this instance of Stage3DProxy.		 */
		public function get stage3DIndex():Number
		{
			return _iStage3DIndex;
		}
		
		/**		 * The base Stage3D object associated with this proxy.		 */
		public function get stage3D():Stage3D
		{
			return _stage3D;
		}
		
		/**		 * The Context3D object associated with the given Stage3D object.		 */
		public function get context3D():Context3D
		{
			return _iContext3D;
		}
		
		/**		 * Indicates whether the Stage3D managed by this proxy is running in software mode.		 * Remember to wait for the CONTEXT3D_CREATED event before checking this property,		 * as only then will it be guaranteed to be accurate.		 */
		public function get usesSoftwareRendering():Boolean
		{
			return _usesSoftwareRendering;
		}
		
		/**		 * The x position of the Stage3D.		 */
		public function get x():Number
		{
			return _stage3D.x;
		}
		public function set x(value:Number):void
		{
			if (_viewPort.x == value)
				return;
			
			_stage3D.x = _viewPort.x = value;
			
			notifyViewportUpdated();
		}
		
		/**		 * The y position of the Stage3D.		 */
		public function get y():Number
		{
			return _stage3D.y;
		}
		public function set y(value:Number):void
		{
			if (_viewPort.y == value)
				return;
			
			_stage3D.y = _viewPort.y = value;

            notifyViewportUpdated();
		}

        /**         *         * @returns {HTMLCanvasElement}         */
        public function get canvas():HTMLCanvasElement
        {
            return _stage3D.canvas;
        }
		
		/**		 * The width of the Stage3D.		 */
		public function get width():Number
		{
			return _backBufferWidth;
		}
		public function set width(width:Number):void
		{
			if (_viewPort.width == width)
				return;

            _stage3D.width = _backBufferWidth = _viewPort.width = width;
			_backBufferDirty = true;
			
			notifyViewportUpdated();
		}
		
		/**		 * The height of the Stage3D.		 */
		public function get height():Number
		{
			return _backBufferHeight;
		}
		public function set height(height:Number):void
		{
			if (_viewPort.height == height)
				return;

            _stage3D.height = _backBufferHeight = _viewPort.height = height;
			_backBufferDirty = true;
			
			notifyViewportUpdated();
		}
		
		/**		 * The antiAliasing of the Stage3D.		 */
		public function get antiAlias():Number
		{
			return _antiAlias;
		}
		public function set antiAlias(antiAlias:Number):void
		{
			_antiAlias = antiAlias;
			_backBufferDirty = true;
		}
		
		/**		 * A viewPort rectangle equivalent of the Stage3D size and position.		 */
		public function get viewPort():Rectangle
		{
			_viewportDirty = false;
			
			return _viewPort;
		}
		
		/**		 * The background color of the Stage3D.		 */
		public function get color():Number
		{
			return _color;
		}
		
		public function set color(color:Number):void
		{
			_color = color;
		}
		
		/**		 * The visibility of the Stage3D.		 */
		public function get visible():Boolean
		{
            return _stage3D.visible;
		}
		public function set visible(value:Boolean):void
		{
			_stage3D.visible = value;
		}
		
		/**		 * The freshly cleared state of the backbuffer before any rendering		 */
		public function get bufferClear():Boolean
		{
			return _bufferClear;
		}
		public function set bufferClear(newBufferClear:Boolean):void
		{
			_bufferClear = newBufferClear;
		}
		
		/*		 * Access to fire mouseevents across multiple layered view3D instances		 */
		public function get mouse3DManager():Mouse3DManager
		{
			return _mouse3DManager;
		}
		
		public function set mouse3DManager(value:Mouse3DManager):void
		{
			_mouse3DManager = value;
		}

        /* TODO: implement dependency Touch3DManager		public get touch3DManager():Touch3DManager		{			return _touch3DManager;		}				public set touch3DManager(value:Touch3DManager)		{			_touch3DManager = value;		}		*/

		/**		 * Frees the Context3D associated with this Stage3DProxy.		 */
		private function freeContext3D():void
		{
			if (_iContext3D) {

				_iContext3D.dispose();
				dispatchEvent(new Stage3DEvent(Stage3DEvent.CONTEXT3D_DISPOSED));
			}

            _iContext3D = null;
		}
		
		/*		 * Called whenever the Context3D is retrieved or lost.		 * @param event The event dispatched.		 */
		private function onContext3DUpdate(event:Event):void
		{
			if (_stage3D.context3D)
            {

				var hadContext:Boolean = (_iContext3D != null);
				_iContext3D = _stage3D.context3D;

				// Only configure back buffer if width and height have been set,
				// which they may not have been if View3D.render() has yet to be
				// invoked for the first time.
				if (_backBufferWidth && _backBufferHeight)
                {
                    _iContext3D.configureBackBuffer(_backBufferWidth, _backBufferHeight, _antiAlias, _enableDepthAndStencil);
                }

				// Dispatch the appropriate event depending on whether context was
				// created for the first time or recreated after a device loss.
				dispatchEvent(new Stage3DEvent( hadContext ? Stage3DEvent.CONTEXT3D_RECREATED : Stage3DEvent.CONTEXT3D_CREATED));
				
			}
            else
            {
                throw new Error("Rendering context lost!");
            }

		}
		
		/**		 * Requests a Context3D object to attach to the managed Stage3D.		 */
		private function requestContext(forceSoftware:Boolean = false, profile:String = "baseline"):void
		{
			// If forcing software, we can be certain that the
			// returned Context3D will be running software mode.
			// If not, we can't be sure and should stick to the
			// old value (will likely be same if re-requesting.)

            if ( _usesSoftwareRendering != null )
            {

                _usesSoftwareRendering = forceSoftware;

            }

			_profile = profile;

            // Updated to work with current JS <> AS3 Display3D System
            _stage3D.requestContext( true );

		}
		
		/**		 * The Enter_Frame handler for processing the proxy.ENTER_FRAME and proxy.EXIT_FRAME event handlers.		 * Typically the proxy.ENTER_FRAME listener would render the layers for this Stage3D instance.		 */
		private function onEnterFrame(event:Event):void
		{
			if (!_iContext3D )
            {
                return;
            }

			// Clear the stage3D instance
			clear();
			//notify the enterframe listeners
			notifyEnterFrame();
			// Call the present() to render the frame
            present();
			//notify the exitframe listeners
            notifyExitFrame();
		}
		
		public function recoverFromDisposal():Boolean
		{
			if (!_iContext3D)
            {

                return false;

            }

            //away.Debug.throwPIR( 'Stage3DProxy' , 'recoverFromDisposal' , '' );

            /*            if (this._iContext3D.driverInfo == "Disposed")            {				this._iContext3D = null;				this.dispatchEvent(new away.events.Stage3DEvent(away.events.Stage3DEvent.CONTEXT3D_DISPOSED));				return false;			}            */
			return true;

		}
		
		public function clearDepthBuffer():void
		{
			if ( ! _iContext3D )
            {

                return;

            }

            _iContext3D.clear(0, 0, 0, 1, 1, 0, Context3DClearMask.DEPTH);

		}
	}
}
