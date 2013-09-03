///<reference path="../_definitions.ts"/>

package away.render
{
	import away.display3D.Context3D;
	import away.managers.Stage3DProxy;
	import away.display3D.TextureBase;
	import away.sort.IEntitySorter;
	import away.display.BitmapData;
	import away.geom.Matrix3D;
	import away.sort.RenderableMergeSort;
	import away.traverse.EntityCollector;
	import away.events.Stage3DEvent;
	import away.geom.Rectangle;
	import away.display3D.Context3DCompareMode;
	import away.errors.AbstractMethodError;
	import away.events.Event;

	/**	 * RendererBase forms an abstract base class for classes that are used in the rendering pipeline to render geometry	 * to the back buffer or a texture.	 */
	public class RendererBase
	{
		public var _pContext:Context3D;
		public var _pStage3DProxy:Stage3DProxy;
		
		private var _backgroundR:Number = 0;
		private var _backgroundG:Number = 0;
		private var _backgroundB:Number = 0;
		private var _backgroundAlpha:Number = 1;
		private var _shareContext:Boolean = false;
		
		public var _pRenderTarget:TextureBase;
		public var _pRenderTargetSurface:Number;
		
		// only used by renderers that need to render geometry to textures
		private var _viewWidth:Number;
		private var _viewHeight:Number;
		
		public var _pRenderableSorter:IEntitySorter;

		//private _backgroundImageRenderer:BackgroundImageRenderer;
		//private _background:Texture2DBase;
		
		private var _renderToTexture:Boolean;
		private var _antiAlias:Number;
		private var _textureRatioX:Number = 1;
		private var _textureRatioY:Number = 1;
		
		private var _snapshotBitmapData:BitmapData;
		private var _snapshotRequired:Boolean;
		
		private var _clearOnRender:Boolean = true;
		public var _pRttViewProjectionMatrix:Matrix3D = new Matrix3D();

		
		/**		 * Creates a new RendererBase object.		 */
		public function RendererBase(renderToTexture:Boolean = false):void
		{
			this._pRenderableSorter = new RenderableMergeSort();
			this._renderToTexture = renderToTexture;
		}
		
		public function iCreateEntityCollector():EntityCollector
		{
			return new EntityCollector();
		}
		
		public function get iViewWidth():Number
		{
			return _viewWidth;
		}
		
		public function set iViewWidth(value:Number):void
		{
			this._viewWidth = value;
		}
		
		public function get iViewHeight():Number
		{
			return _viewHeight;
		}
		
		public function set iViewHeight(value:Number):void
		{
			this._viewHeight = value;
		}
		
		public function get iRenderToTexture():Boolean
		{
			return _renderToTexture;
		}
		
		public function get renderableSorter():IEntitySorter
		{
			return _pRenderableSorter;
		}
		
		public function set renderableSorter(value:IEntitySorter):void
		{
			this._pRenderableSorter = value;
		}
		
		public function get iClearOnRender():Boolean
		{
			return _clearOnRender;
		}
		
		public function set iClearOnRender(value:Boolean):void
		{
			this._clearOnRender = value;
		}
		
		/**		 * The background color's red component, used when clearing.		 *		 * @private		 */
		public function get iBackgroundR():Number
		{
			return _backgroundR;
		}
		
		public function set iBackgroundR(value:Number):void
		{
			this._backgroundR = value;
		}
		
		/**		 * The background color's green component, used when clearing.		 *		 * @private		 */
		public function get iBackgroundG():Number
		{
			return _backgroundG;
		}
		
		public function set iBackgroundG(value:Number):void
		{
			this._backgroundG = value;
		}
		
		/**		 * The background color's blue component, used when clearing.		 *		 * @private		 */
		public function get iBackgroundB():Number
		{
			return _backgroundB;
		}
		
		public function set iBackgroundB(value:Number):void
		{
			this._backgroundB = value;
		}
		
		/**		 * The Stage3DProxy that will provide the Context3D used for rendering.		 *		 * @private		 */
		public function get iStage3DProxy():Stage3DProxy
		{
			return _pStage3DProxy;
		}
		
		public function set iStage3DProxy(value:Stage3DProxy):void
		{

            this.iSetStage3DProxy( value );

		}

        public function iSetStage3DProxy(value:Stage3DProxy):void
        {

            if (value == _pStage3DProxy)
            {

                return;

            }


            if (!value)
            {

                if (_pStage3DProxy)
                {

                    _pStage3DProxy.removeEventListener(Stage3DEvent.CONTEXT3D_CREATED, onContextUpdate , this );
                    _pStage3DProxy.removeEventListener(Stage3DEvent.CONTEXT3D_RECREATED, onContextUpdate , this );

                }

                _pStage3DProxy = null;
                _pContext = null;

                return;
            }

            //else if (_pStage3DProxy) throw new Error("A Stage3D instance was already assigned!");

            _pStage3DProxy = value;
            _pStage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_CREATED, onContextUpdate , this );
            _pStage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_RECREATED, onContextUpdate , this );

            /*             if (_backgroundImageRenderer)             _backgroundImageRenderer.stage3DProxy = value;             */
            if (value.context3D)
                _pContext = value.context3D;

        }
		
		/**		 * Defers control of Context3D clear() and present() calls to Stage3DProxy, enabling multiple Stage3D frameworks		 * to share the same Context3D object.		 *		 * @private		 */
		public function get iShareContext():Boolean
		{
			return _shareContext;
		}
		
		public function set iShareContext(value:Boolean):void
		{
			this._shareContext = value;
		}
		
		/**		 * Disposes the resources used by the RendererBase.		 *		 * @private		 */
		public function iDispose():void
		{
			_pStage3DProxy = null;

            /*			if (_backgroundImageRenderer) {				_backgroundImageRenderer.dispose();				_backgroundImageRenderer = null;			}			*/
		}
		
		/**		 * Renders the potentially visible geometry to the back buffer or texture.		 * @param entityCollector The EntityCollector object containing the potentially visible geometry.		 * @param target An option target texture to render to.		 * @param surfaceSelector The index of a CubeTexture's face to render to.		 * @param additionalClearMask Additional clear mask information, in case extra clear channels are to be omitted.		 */
		public function iRender(entityCollector:EntityCollector, target:TextureBase = null, scissorRect:Rectangle = null, surfaceSelector:Number = 0):void
		{
			if (!_pStage3DProxy || !_pContext)
            {

                return;


            }

			
			_pRttViewProjectionMatrix.copyFrom(entityCollector.camera.viewProjection);
            _pRttViewProjectionMatrix.appendScale(_textureRatioX, _textureRatioY, 1);

            pExecuteRender(entityCollector, target, scissorRect, surfaceSelector);
			
			// clear buffers
			
			for (var i:Number = 0; i < 8; ++i)
            {

				_pContext.setVertexBufferAt(i, null);
                _pContext.setTextureAt(i, null);

			}
		}
		
		/**		 * Renders the potentially visible geometry to the back buffer or texture. Only executed if everything is set up.		 * @param entityCollector The EntityCollector object containing the potentially visible geometry.		 * @param target An option target texture to render to.		 * @param surfaceSelector The index of a CubeTexture's face to render to.		 * @param additionalClearMask Additional clear mask information, in case extra clear channels are to be omitted.		 */
		public function pExecuteRender(entityCollector:EntityCollector, target:TextureBase = null, scissorRect:Rectangle = null, surfaceSelector:Number = 0):void
		{
			_pRenderTarget = target;
			_pRenderTargetSurface = surfaceSelector;
			
			if (_pRenderableSorter)
            {

                _pRenderableSorter.sort(entityCollector);

            }

			
			if (_renderToTexture){

                pExecuteRenderToTexturePass(entityCollector);

            }

			_pStage3DProxy.setRenderTarget(target, true, surfaceSelector);
			
			if ((target || !_shareContext) && _clearOnRender)
            {

               this. _pContext.clear(_backgroundR, _backgroundG, _backgroundB, _backgroundAlpha, 1, 0);

            }

			_pContext.setDepthTest(false, Context3DCompareMode.ALWAYS);

			_pStage3DProxy.scissorRect = scissorRect;

            /*			if (_backgroundImageRenderer)				_backgroundImageRenderer.render();			*/

			pDraw(entityCollector, target);
			
			//line required for correct rendering when using away3d with starling. DO NOT REMOVE UNLESS STARLING INTEGRATION IS RETESTED!
			_pContext.setDepthTest(false, Context3DCompareMode.LESS_EQUAL);
			
			if (!_shareContext)
            {

				if (_snapshotRequired && _snapshotBitmapData)
                {

                    _pContext.drawToBitmapData(_snapshotBitmapData);
                    _snapshotRequired = false;

				}

			}
            _pStage3DProxy.scissorRect = null;
		}
		
		/*		 * Will draw the renderer's output on next render to the provided bitmap data.		 * */
		public function queueSnapshot(bmd:BitmapData):void
		{
			_snapshotRequired = true;
            _snapshotBitmapData = bmd;
		}
		
		public function pExecuteRenderToTexturePass(entityCollector:EntityCollector):void
		{
			throw new AbstractMethodError();
		}
		
		/**		 * Performs the actual drawing of geometry to the target.		 * @param entityCollector The EntityCollector object containing the potentially visible geometry.		 */
		public function pDraw(entityCollector:EntityCollector, target:TextureBase):void
		{
            throw new AbstractMethodError();
		}
		
		/**		 * Assign the context once retrieved		 */
		private function onContextUpdate(event:Event):void
		{
			_pContext = _pStage3DProxy.context3D;
		}
		
		public function get iBackgroundAlpha():Number
		{
			return _backgroundAlpha;
		}
		
		public function set iBackgroundAlpha(value:Number):void
		{
			this._backgroundAlpha = value;
		}

        /*		public get iBackground():away.textures.Texture2DBase		{			return this._background;		}		*/

        /*		public set iBackground(value:away.textures.Texture2DBase)		{			if (this._backgroundImageRenderer && !value) {                this._backgroundImageRenderer.dispose();                this._backgroundImageRenderer = null;			}						if (!this._backgroundImageRenderer && value)            {                this._backgroundImageRenderer = new BackgroundImageRenderer(this._pStage3DProxy);            }						this._background = value;						if (this._backgroundImageRenderer)                this._backgroundImageRenderer.texture = value;		}		*/
		/*		public get backgroundImageRenderer():BackgroundImageRenderer		{			return _backgroundImageRenderer;		}		*/

		public function get antiAlias():Number
		{
			return _antiAlias;
		}
		
		public function set antiAlias(antiAlias:Number):void
		{
            this._antiAlias = antiAlias;
		}
		
		public function get iTextureRatioX():Number
		{
			return _textureRatioX;
		}
		
		public function set iTextureRatioX(value:Number):void
		{
			this._textureRatioX = value;
		}
		
		public function get iTextureRatioY():Number
		{
			return _textureRatioY;
		}
		
		public function set iTextureRatioY(value:Number):void
		{
			this._textureRatioY = value;
		}

	}
}
