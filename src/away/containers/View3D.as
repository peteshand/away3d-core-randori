/**
 * ...
 * @author Gary Paluk - http://www.plugin.io
 */
///<reference path="../_definitions.ts" />

package away.containers
{
	import away.display.Stage;
	import away.cameras.Camera3D;
	import away.traverse.EntityCollector;
	import away.render.Filter3DRenderer;
	import away.display3D.Texture;
	import away.managers.Stage3DProxy;
	import away.managers.RTTBufferManager;
	import away.geom.Rectangle;
	import away.render.RendererBase;
	import away.geom.Point;
	import away.render.DepthRenderer;
	import away.events.Scene3DEvent;
	import away.render.DefaultRenderer;
	import away.events.CameraEvent;
	import away.events.Stage3DEvent;
	import away.filters.Filter3DBase;
	import away.display3D.Context3D;
	import away.display3D.Context3DTextureFormat;
	import away.managers.Stage3DManager;
	import away.geom.Vector3D;
	import randori.webkit.html.HTMLCanvasElement;
	public class View3D
	{

        /*
         *************************************************************************************************************************
         * Development Notes
         *************************************************************************************************************************
         *
         * ShareContext     - this is not being used at the moment integration with other frameworks is not yet implemented or tested
         *                    and ( _localPos / _globalPos ) position of viewport are the same for the moment
         *
         * Background
         *                  - this is currently not being included in our tests and is currently disabled
         *
         **************************************************************************************************************************
         */

        // Static
        private static var sStage:Stage; // View3D's share the same stage

        // Public
        public var stage:Stage;

        // Protected
		public var _pScene:Scene3D;
		public var _pCamera:Camera3D;
		public var _pEntityCollector:EntityCollector;
        public var _pFilter3DRenderer:Filter3DRenderer;
        public var _pRequireDepthRender:Boolean;
        public var _pDepthRender:Texture;
        public var _pStage3DProxy:Stage3DProxy;
        public var _pBackBufferInvalid:Boolean = true;
        public var _pRttBufferManager:RTTBufferManager;

        public var _pShareContext:Boolean = false;
        public var _pScissorRect:Rectangle;
        public var _pRenderer:RendererBase;

        // Private
        private var _aspectRatio:Number;
        private var _width:Number = 0;
        private var _height:Number = 0;

        private var _localPos:Point = new Point();
        private var _globalPos:Point = new Point();
        private var _globalPosDirty:Boolean;
		private var _time:Number = 0;
		private var _deltaTime:Number = 0;
		private var _backgroundColor:Number = 0x000000;
		private var _backgroundAlpha:Number = 1;
        private var _depthRenderer:DepthRenderer;
        private var _addedToStage:Boolean;
        private var _forceSoftware:Boolean;
        private var _depthTextureInvalid:Boolean = true;

        private var _antiAlias:Number = 0;
        private var _scissorRectDirty:Boolean = true;
        private var _viewportDirty:Boolean = true;
        private var _depthPrepass:Boolean = false;
        private var _profile:String;
        private var _layeredView:Boolean = false;

        /*
         ***********************************************************************
         * Disabled / Not yet implemented
         ***********************************************************************
         *
         * private _background:away.textures.Texture2DBase;
         *
		 * public _pMouse3DManager:away.managers.Mouse3DManager;
		 * public _pTouch3DManager:away.managers.Touch3DManager;
		 *
         */
		public function View3D(scene:Scene3D = null, camera:Camera3D = null, renderer:RendererBase = null, forceSoftware:Boolean = false, profile:String = "baseline"):void
		{


            if ( View3D.sStage == null )
            {
                View3D.sStage = new Stage();
            }

			_profile = profile;
			_pScene = scene || new Scene3D();
			_pScene.addEventListener( Scene3DEvent.PARTITION_CHANGED, onScenePartitionChanged, this );
			_pCamera = camera || new Camera3D();
			_pRenderer = renderer || new DefaultRenderer();
			_depthRenderer = new DepthRenderer();
			_forceSoftware = forceSoftware;
			_pEntityCollector = _pRenderer.iCreateEntityCollector();
			_pEntityCollector.camera = _pCamera;
			_pScissorRect = new Rectangle();
			_pCamera.addEventListener( CameraEvent.LENS_CHANGED, onLensChanged, this );
			_pCamera.partition = _pScene.partition;
            stage = View3D.sStage;

            onAddedToStage();

		}

        /**
         *
         * @param e
         */
		private function onScenePartitionChanged(e:Scene3DEvent):void
		{
			if( _pCamera )
			{
				_pCamera.partition = scene.partition;
			}
		}
        /**
         *
         * @returns {away.managers.Stage3DProxy}
         */
		public function get stage3DProxy():Stage3DProxy
		{
			return _pStage3DProxy;
		}
        /**
         *
         * @param stage3DProxy
         */
		public function set stage3DProxy(stage3DProxy:Stage3DProxy):void
		{

			if (_pStage3DProxy)
			{
				_pStage3DProxy.removeEventListener(Stage3DEvent.VIEWPORT_UPDATED, onViewportUpdated, this );
			}
			
			_pStage3DProxy = stage3DProxy;
			_pStage3DProxy.addEventListener( Stage3DEvent.VIEWPORT_UPDATED, onViewportUpdated, this );
			_pRenderer.iStage3DProxy = _depthRenderer.iStage3DProxy = _pStage3DProxy;
			_globalPosDirty = true;
			_pBackBufferInvalid = true;

		}
        /**
         *
         * @returns {boolean}
         */
		public function get layeredView():Boolean
		{
			return _layeredView;
		}
        /**
         *
         * @param value
         */
		public function set layeredView(value:Boolean):void
		{
			_layeredView = value;
		}
        /**
         *
         * @returns {*}
         */
		public function get filters3d():Vector.<Filter3DBase>
		{
			return _pFilter3DRenderer ? _pFilter3DRenderer.filters : null;
		}
        /**
         *
         * @param value
         */
        public function set filters3d(value:Vector.<Filter3DBase>):void
        {
            if (value && value.length == 0)
                value = null;

            if (_pFilter3DRenderer && !value)
            {
                _pFilter3DRenderer.dispose();
                _pFilter3DRenderer = null;
            }
            else if (!_pFilter3DRenderer && value)
            {
                _pFilter3DRenderer = new Filter3DRenderer( _pStage3DProxy );
                _pFilter3DRenderer.filters = value;
            }

            if (_pFilter3DRenderer)
            {
                _pFilter3DRenderer.filters = value;
                _pRequireDepthRender = _pFilter3DRenderer.requireDepthRender;
            }
            else
            {
                _pRequireDepthRender = false;

                if (_pDepthRender)
                {
                    _pDepthRender.dispose();
                    _pDepthRender = null;
                }
            }
        }
        /**
         *
         * @returns {away.render.RendererBase}
         */
		public function get renderer():RendererBase
		{
			return _pRenderer;
		}
        /**
         *
         * @param value
         */
        public function set renderer(value:RendererBase):void
        {
            _pRenderer.iDispose();
            _pRenderer = value;

            _pEntityCollector = _pRenderer.iCreateEntityCollector();
            _pEntityCollector.camera = _pCamera;
            _pRenderer.iStage3DProxy = _pStage3DProxy;
            _pRenderer.antiAlias = _antiAlias;
            _pRenderer.iBackgroundR = ((_backgroundColor >> 16) & 0xff)/0xff;
            _pRenderer.iBackgroundG = ((_backgroundColor >> 8) & 0xff)/0xff;
            _pRenderer.iBackgroundB = (_backgroundColor & 0xff)/0xff;
            _pRenderer.iBackgroundAlpha = _backgroundAlpha;
            _pRenderer.iViewWidth = _width;
            _pRenderer.iViewHeight = _height;

            _pBackBufferInvalid = true;

        }
        /**
         *
         * @returns {number}
         */
		public function get backgroundColor():Number
		{
			return _backgroundColor;
		}
        /**
         *
         * @param value
         */
        public function set backgroundColor(value:Number):void
        {
            _backgroundColor      = value;
            _pRenderer.iBackgroundR = ((value >> 16) & 0xff)/0xff;
            _pRenderer.iBackgroundG = ((value >> 8) & 0xff)/0xff;
            _pRenderer.iBackgroundB = (value & 0xff)/0xff;
        }
        /**
         *
         * @returns {number}
         */
		public function get backgroundAlpha():Number
		{
			return _backgroundAlpha;
		}
        /**
         *
         * @param value
         */
		public function set backgroundAlpha(value:Number):void
		{
			if (value > 1)
			{
				value = 1;
			}
			else if (value < 0)
			{
				value = 0;
			}
			
			_pRenderer.iBackgroundAlpha = value;
			_backgroundAlpha = value;
		}
        /**
         *
         * @returns {away.cameras.Camera3D}
         */
		public function get camera():Camera3D
		{
			return _pCamera;
		}
        /**
         * Set camera that's used to render the scene for this viewport
         */
        public function set camera(camera:Camera3D):void
        {
            _pCamera.removeEventListener(CameraEvent.LENS_CHANGED, onLensChanged , this );
            _pCamera = camera;

            _pEntityCollector.camera = _pCamera;

            if (_pScene)
            {
                _pCamera.partition = _pScene.partition;
            }

            _pCamera.addEventListener(CameraEvent.LENS_CHANGED, onLensChanged , this);
            _scissorRectDirty = true;
            _viewportDirty = true;

        }
        /**
         *
         * @returns {away.containers.Scene3D}
         */
		public function get scene():Scene3D
		{
			return _pScene;
		}
        /**
         * Set the scene that's used to render for this viewport
         */
        public function set scene(scene:Scene3D):void
        {
            _pScene.removeEventListener(Scene3DEvent.PARTITION_CHANGED, onScenePartitionChanged , this );
            _pScene = scene;
            _pScene.addEventListener(Scene3DEvent.PARTITION_CHANGED, onScenePartitionChanged , this );

            if (_pCamera)
            {
                _pCamera.partition = _pScene.partition;
            }

        }
        /**
         *
         * @returns {number}
         */
		public function get deltaTime():Number
		{
			return _deltaTime;
		}
        /**
         *
         * @returns {number}
         */
		public function get width():Number
		{
			return _width;
		}
        /**
         *
         * @param value
         */
        public function set width(value:Number):void
        {

            if (_width == value)
            {
                return;
            }

            if (_pRttBufferManager)
            {
                _pRttBufferManager.viewWidth = value;
            }

            _width = value;
            _aspectRatio = _width/_height;
            _pCamera.lens.iAspectRatio= _aspectRatio;
            _depthTextureInvalid = true;
            _pRenderer.iViewWidth= value;
            _pScissorRect.width = value;
            _pBackBufferInvalid = true;
            _scissorRectDirty = true;
        }
        /**
         *
         * @returns {number}
         */
		public function get height():Number
		{
			return _height;
		}
        /**
         *
         * @param value
         */
        public function set height(value:Number):void
        {

            if (_height == value)
            {
                return;
            }

            if (_pRttBufferManager)
            {
                _pRttBufferManager.viewHeight = value;
            }

            _height = value;
            _aspectRatio = _width/_height;
            _pCamera.lens.iAspectRatio = _aspectRatio;
            _depthTextureInvalid = true;
            _pRenderer.iViewHeight = value;
            _pScissorRect.height = value;
            _pBackBufferInvalid = true;
            _scissorRectDirty = true;

        }
        /**
         *
         * @param value
         */
        public function set x(value:Number):void
        {
            if (x == value)
                return;

            _globalPos.x = _localPos.x = value;
            _globalPosDirty = true;
        }
        /**
         *
         * @param value
         */
        public function set y(value:Number):void
        {
            if (y == value)
                return;

            _globalPos.y = _localPos.y = value;
            _globalPosDirty = true;
        }
        /**
         *
         * @returns {number}
         */
        public function get x():Number
        {
            return _localPos.x;
        }
        /**
         *
         * @returns {number}
         */
        public function get y():Number
        {
            return _localPos.y;
        }
        /**
         *
         * @returns {boolean}
         */
        public function get visible():Boolean
        {
            return true;
        }
        /**
         *
         * @param v
         */
        public function set visible(v:Boolean):void
        {

        }
        public function get canvas():HTMLCanvasElement
        {

            return _pStage3DProxy.canvas;

        }
        /**
         *
         * @returns {number}
         */
		public function get antiAlias():Number
		{
			return _antiAlias;
		}
        /**
         *
         * @param value
         */
		public function set antiAlias(value:Number):void
		{
			_antiAlias = value;
			_pRenderer.antiAlias = value;
			_pBackBufferInvalid = true;
		}
        /**
         *
         * @returns {number}
         */
		public function get renderedFacesCount():Number
		{
			return _pEntityCollector._pNumTriangles;//numTriangles;
		}
        /**
         *
         * @returns {boolean}
         */
		public function get shareContext():Boolean
		{
			return _pShareContext;
		}
        /**
         *
         * @param value
         */
		public function set shareContext(value:Boolean):void
		{
			if ( _pShareContext == value)
			{
				return;
			}
			_pShareContext = value;
			_globalPosDirty = true;
		}
        /**
         * Updates the backbuffer dimensions.
         */
        public function pUpdateBackBuffer():void
        {
            // No reason trying to configure back buffer if there is no context available.
            // Doing this anyway (and relying on _stage3DProxy to cache width/height for
            // context does get available) means usesSoftwareRendering won't be reliable.

            if (_pStage3DProxy._iContext3D && ! _pShareContext)
            {

                if ( _width && _height)
                {

                    _pStage3DProxy.configureBackBuffer( _width, _height, _antiAlias, true);
                    _pBackBufferInvalid = false;
                }

            }
        }
		/**
         * Renders the view.
         */
        public function render():void
        {

            if (!_pStage3DProxy.recoverFromDisposal()) //if context3D has Disposed by the OS,don't render at this frame
            {
                _pBackBufferInvalid = true;
                return;
            }

            if (_pBackBufferInvalid)// reset or update render settings
            {
                pUpdateBackBuffer();
            }

            if (_pShareContext && _layeredView)
            {
                _pStage3DProxy.clearDepthBuffer();
            }

            if (_globalPosDirty)
            {
                pUpdateGlobalPos();
            }

            pUpdateTime();
            pUpdateViewSizeData();
            _pEntityCollector.clear();
            _pScene.traversePartitions( _pEntityCollector );// collect stuff to render

            // TODO: implement & integrate mouse3DManager
            // update picking
            //_mouse3DManager.updateCollider(this);
            //_touch3DManager.updateCollider();

            if (_pRequireDepthRender)
            {
                pRenderSceneDepthToTexture(_pEntityCollector);
            }

            if (_depthPrepass)
            {
                pRenderDepthPrepass(_pEntityCollector);
            }

            _pRenderer.iClearOnRender = !_depthPrepass;

            if (_pFilter3DRenderer && _pStage3DProxy._iContext3D)
            {

                _pRenderer.iRender( _pEntityCollector, _pFilter3DRenderer.getMainInputTexture( _pStage3DProxy), _pRttBufferManager.renderToTextureRect);
                _pFilter3DRenderer.render( _pStage3DProxy, _pCamera , _pDepthRender);

            }
            else
            {
                _pRenderer.iShareContext = _pShareContext;

                if (_pShareContext)
                {
                    _pRenderer.iRender( _pEntityCollector, null, _pScissorRect);
                }
                else
                {
                    _pRenderer.iRender( _pEntityCollector );
                }

            }

            if (! _pShareContext)
            {
                _pStage3DProxy.present();

                // TODO: imeplement mouse3dManager
                // fire collected mouse events
                //_mouse3DManager.fireMouseEvents();
                //_touch3DManager.fireTouchEvents();

            }

            // clean up data for this render
            _pEntityCollector.cleanUp();

            // register that a view has been rendered
            _pStage3DProxy.bufferClear = false;

        }
        /**
         *
         */
        public function pUpdateGlobalPos():void
        {

            _globalPosDirty = false;

            if (!_pStage3DProxy)
            {
                return;
            }

            if (_pShareContext)
            {

                _pScissorRect.x = _globalPos.x - _pStage3DProxy.x;
                _pScissorRect.y = _globalPos.y - _pStage3DProxy.y;

            }
            else
            {

                _pScissorRect.x = 0;
                _pScissorRect.y = 0;
                _pStage3DProxy.x = _globalPos.x;
                _pStage3DProxy.y = _globalPos.y;

            }

            _scissorRectDirty = true;
        }
        /**
         *
         */
		public function pUpdateTime():void
		{
			var time:Number = new Date().getTime();

			if ( _time == 0 )
			{
				_time = time;
			}

			_deltaTime = time - _time;
			_time = time;

		}
        /**
         *
         */
        public function pUpdateViewSizeData():void
        {
            _pCamera.lens.iAspectRatio = _aspectRatio;

            if (_scissorRectDirty)
            {
                _scissorRectDirty = false;
                _pCamera.lens.iUpdateScissorRect(_pScissorRect.x, _pScissorRect.y, _pScissorRect.width, _pScissorRect.height);
            }

            if (_viewportDirty)
            {
                _viewportDirty = false;
                _pCamera.lens.iUpdateViewport(_pStage3DProxy.viewPort.x, _pStage3DProxy.viewPort.y, _pStage3DProxy.viewPort.width, _pStage3DProxy.viewPort.height);
            }

            if (_pFilter3DRenderer || _pRenderer.iRenderToTexture )
            {
                _pRenderer.iTextureRatioX = _pRttBufferManager.textureRatioX;
                _pRenderer.iTextureRatioY = _pRttBufferManager.textureRatioY;
            }
            else
            {
                _pRenderer.iTextureRatioX = 1;
                _pRenderer.iTextureRatioY = 1;
            }
        }
        /**
         *
         * @param entityCollector
         */
        public function pRenderDepthPrepass(entityCollector:EntityCollector):void
        {
            _depthRenderer.disableColor = true;

            if ( _pFilter3DRenderer || _pRenderer.iRenderToTexture )
            {
                _depthRenderer.iTextureRatioX = _pRttBufferManager.textureRatioX;
                _depthRenderer.iTextureRatioY = _pRttBufferManager.textureRatioY;
                _depthRenderer.iRender( entityCollector, _pFilter3DRenderer.getMainInputTexture(_pStage3DProxy), _pRttBufferManager.renderToTextureRect);
            }
            else
            {
                _depthRenderer.iTextureRatioX = 1;
                _depthRenderer.iTextureRatioY = 1;
                _depthRenderer.iRender(entityCollector);
            }

            _depthRenderer.disableColor = false;

        }
        /**
         *
         * @param entityCollector
         */
        public function pRenderSceneDepthToTexture(entityCollector:EntityCollector):void
        {
            if (_depthTextureInvalid || !_pDepthRender)
            {
                initDepthTexture( _pStage3DProxy._iContext3D);
            }
            _depthRenderer.iTextureRatioX = _pRttBufferManager.textureRatioX;
            _depthRenderer.iTextureRatioY = _pRttBufferManager.textureRatioY;
            _depthRenderer.iRender(entityCollector, _pDepthRender);
        }
        /**
         *
         * @param context
         */
		private function initDepthTexture(context:Context3D):void
		{
			_depthTextureInvalid = false;
			
			if ( _pDepthRender)
			{
				_pDepthRender.dispose();
			}
			_pDepthRender = context.createTexture( _pRttBufferManager.textureWidth, _pRttBufferManager.textureHeight, Context3DTextureFormat.BGRA, true );
		}
        /**
         *
         */
        public function dispose():void
        {
            _pStage3DProxy.removeEventListener(Stage3DEvent.VIEWPORT_UPDATED, onViewportUpdated , this );

            if (!shareContext)
            {
                _pStage3DProxy.dispose();
            }

            _pRenderer.iDispose();

            if (_pDepthRender)
            {
                _pDepthRender.dispose();
            }

            if (_pRttBufferManager)
            {
                _pRttBufferManager.dispose();
            }

            // TODO: imeplement mouse3DManager / touch3DManager
            //this._mouse3DManager.disableMouseListeners(this);
            //this._mouse3DManager.dispose();
            //this._touch3DManager.disableTouchListeners(this);
            //this._touch3DManager.dispose();
            //this._mouse3DManager = null;
            //this._touch3DManager = null;

            _pRttBufferManager = null;
            _pDepthRender = null;
            _depthRenderer = null;
            _pStage3DProxy = null;
            _pRenderer = null;
            _pEntityCollector = null;
        }
        /**
         *
         * @returns {away.traverse.EntityCollector}
         */
		public function get iEntityCollector():EntityCollector
		{
			return _pEntityCollector;
		}
        /**
         *
         * @param event
         */
		private function onLensChanged(event:CameraEvent):void
		{
			_scissorRectDirty = true;
			_viewportDirty = true;
		}
        /**
         *
         * @param event
         */
		private function onViewportUpdated(event:Stage3DEvent):void
		{
			if( _pShareContext)
            {
				_pScissorRect.x = _globalPos.x - _pStage3DProxy.x;
				_pScissorRect.y = _globalPos.y - _pStage3DProxy.y;
				_scissorRectDirty = true;
			}
			_viewportDirty = true;
		}
        /**
         *
         * @returns {boolean}
         */
		public function get depthPrepass():Boolean
		{
			return _depthPrepass;
		}
        /**
         *
         * @param value
         */
		public function set depthPrepass(value:Boolean):void
		{
			_depthPrepass = value;
		}
        /**
         *
         */
        private function onAddedToStage():void
        {

            _addedToStage = true;

            if (_pStage3DProxy == null )
            {

                _pStage3DProxy= Stage3DManager.getInstance( stage ).getFreeStage3DProxy(_forceSoftware, _profile);
                _pStage3DProxy.addEventListener(Stage3DEvent.VIEWPORT_UPDATED, onViewportUpdated , this );

            }

            _globalPosDirty = true;
            _pRttBufferManager = RTTBufferManager.getInstance(_pStage3DProxy);
            _pRenderer.iStage3DProxy = _depthRenderer.iStage3DProxy = _pStage3DProxy;

            if (_width == 0)
            {
                width = stage.stageWidth;
            }
            else
            {
                _pRttBufferManager.viewWidth = _width;
            }

            if (_height == 0)
            {
                height = stage.stageHeight;
            }
            else
            {
                _pRttBufferManager.viewHeight = _height;
            }

        }

        // TODO private function onAddedToStage(event:Event):void
        // TODO private function onAdded(event:Event):void

        public function project(point3d:Vector3D):Vector3D
        {
            var v:Vector3D = _pCamera.project( point3d );
            v.x = (v.x + 1.0) * _width/2.0;
            v.y = (v.y + 1.0) * _height/2.0;
            return v;
        }

        public function unproject(sX:Number, sY:Number, sZ:Number):Vector3D
        {
            return _pCamera.unproject( (sX*2 - _width)/_pStage3DProxy.width, (sY*2 - _height)/_pStage3DProxy.height, sZ );
        }

        public function getRay(sX:Number, sY:Number, sZ:Number):Vector3D
        {
            return _pCamera.getRay( (sX*2 - _width)/_width, (sY*2 - _height)/_height, sZ );
        }
        /* TODO: implement Mouse3DManager
        public get mousePicker():away.pick.IPicker
        {
            return this._mouse3DManager.mousePicker;
        }
        */
        /* TODO: implement Mouse3DManager
        public set mousePicker( value:away.pick.IPicker )
        {
            this._mouse3DManager.mousePicker = value;
        }
        */
        /* TODO: implement Touch3DManager
        public get touchPicker():away.pick.IPicker
        {
            return this._touch3DManager.touchPicker;
        }
        */
        /* TODO: implement Touch3DManager
        public set touchPicker( value:away.pick.IPicker)
        {
            this._touch3DManager.touchPicker = value;
        }
        */
        /*TODO: implement Mouse3DManager
        public get forceMouseMove():boolean
        {
            return this._mouse3DManager.forceMouseMove;
        }
        */
        /* TODO: implement Mouse3DManager
        public set forceMouseMove( value:boolean )
        {
            this._mouse3DManager.forceMouseMove = value;
            this._touch3DManager.forceTouchMove = value;
        }
        */
        /*TODO: implement Background
        public get background():away.textures.Texture2DBase
        {
            return this._background;
        }
        */
        /*TODO: implement Background
        public set background( value:away.textures.Texture2DBase )
        {
            this._background = value;
            this._renderer.background = _background;
        }
        */

	}
}