/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts"/>

package away.render
{
	import away.display3D.Context3D;
	import away.managers.Stage3DProxy;
	import away.display3D.TextureBase;
	import away.sort.IEntitySorter;
	import away.textures.Texture2DBase;
	import away.display.BitmapData;
	import away.geom.Matrix3D;
	import away.sort.RenderableMergeSort;
	import away.traverse.EntityCollector;
	import away.events.Stage3DEvent;
	import away.geom.Rectangle;
	import away.display3D.Context3DCompareMode;
	import away.errors.AbstractMethodError;
	import away.events.Event;
	public class RenderBase
	{
		
		//TODO remove image render background stuff and provide a render target geometry
		
		public var _pContext:Context3D;
		public var _pStage3DProxy:Stage3DProxy;
		
		public var _pBackgroundR:Number = 0;
		public var _pBackgroundG:Number = 0;
		public var _pBackgroundB:Number = 0;
		public var _pBackgroundAlpha:Number = 1;
		public var _pShareContext:Boolean = false;
		
		public var _pRenderTarget:TextureBase;
		public var _pRenderTargetSurface:Number;
		
		// only used by renderers that need to render geometry to textures
		public var _pViewWidth:Number;
		public var _pViewHeight:Number;
		
		public var _pRenderableSorter:IEntitySorter;
		//private _backgroundImageRenderer:BackgroundImageRenderer;
		private var _background:Texture2DBase;
		
		public var _pRenderToTexture:Boolean;
		public var _pAntiAlias:Number;
		public var _pTextureRatioX:Number = 1;
		public var _pTextureRatioY:Number = 1;
		
		private var _snapshotBitmapData:BitmapData;
		private var _snapshotRequired:Boolean;
		
		private var _clearOnRender:Boolean = true;
		public var _pRttViewProjectionMatrix:Matrix3D = new Matrix3D();
		
		public function RenderBase(renderToTexture:Boolean = false):void
		{
			this._pRenderableSorter = new RenderableMergeSort();
			this._pRenderToTexture = renderToTexture;
		}
		
		//@arcane
		public function iCreateEntityCollector():EntityCollector
		{
			return new EntityCollector();
		}
		
		//@arcane
		public function get iViewWidth():Number
		{
			return _pViewWidth;
		}
		
		//@arcane
		public function set iViewWidth(value:Number):void
		{
			this._pViewWidth = value;
		}
		
		//@arcane
		public function get iViewHeight():Number
		{
			return _pViewHeight;
		}
		
		//@arcane
		public function set iViewHeight(value:Number):void
		{
			this._pViewHeight = value;
		}
		
		//@arcane
		public function get iRenderToTexture():Boolean
		{
			return _pRenderToTexture;
		}
		
		public function get renderableSorter():IEntitySorter
		{
			return _pRenderableSorter;
		}
		
		public function set renderableSorter(value:IEntitySorter):void
		{
			this._pRenderableSorter = value;
		}
		
		//@arcane
		public function get iClearOnRender():Boolean
		{
			return _clearOnRender;
		}
		
		//@arcane
		public function set iClearOnRender(value:Boolean):void
		{
			this._clearOnRender = value;
		}
		
		//@arcane
		public function get iBackgroundR():Number
		{
			return _pBackgroundR;
		}
		
		//@arcane
		public function set iBackgroundR(value:Number):void
		{
			this._pBackgroundR = value;
		}
		
		//@arcane
		public function get iBackgroundG():Number
		{
			return _pBackgroundG;
		}
		
		//@arcane
		public function set iBackgroundG(value:Number):void
		{
			this._pBackgroundG = value;
		}
		
		//@arcane
		public function get iBackgroundB():Number
		{
			return _pBackgroundB;
		}
		
		//@arcane
		public function set iBackgroundB(value:Number):void
		{
			this._pBackgroundB = value;
		}
		
		//@arcane
		public function get iStage3DProxy():Stage3DProxy
		{
			return _pStage3DProxy;
		}
		
		//@arcane
		public function set iStage3DProxy(value:Stage3DProxy):void
		{
			if( value == this._pStage3DProxy )
			{
				return;
			}
			if(!value)
			{
				if( this._pStage3DProxy )
				{
					this._pStage3DProxy.removeEventListener( Stage3DEvent.CONTEXT3D_CREATED, this.onContextUpdate, this );
					this._pStage3DProxy.removeEventListener( Stage3DEvent.CONTEXT3D_RECREATED, this.onContextUpdate, this );
				}
				this._pStage3DProxy = null;
				this._pContext = null;
				return;
			}
			
			this._pStage3DProxy = value;
			this._pStage3DProxy.addEventListener( Stage3DEvent.CONTEXT3D_CREATED, this.onContextUpdate, this );
			this._pStage3DProxy.addEventListener( Stage3DEvent.CONTEXT3D_RECREATED, this.onContextUpdate, this );
			
			/*if( this._pBackgroundImageRenderer )			{				this._pBackgroundImageRenderer.stage3DProxy = value;			}*/
			
			if( value.context3D )
			{
				this._pContext = value.context3D;
			}
		}
		
		//@arcane
		public function get iShareContext():Boolean
		{
			return _pShareContext;
		}
		
		//@arcane
		public function set iShareContext(value:Boolean):void
		{
			this._pShareContext = value;
		}
		
		//@arcane
		public function iDispose():void
		{
			_pStage3DProxy = null;
			/*			if( this._pBackgroundImageRenderer )			{				this._pBackgroundImageRenderer.dispose();				this._pBackgroundImageRenderer = null;			}*/
		}
		
		//@arcane
		public function iRender(entityCollector:EntityCollector, target:TextureBase = null, scissorRect:Rectangle = null, surfaceSelector:Number = 0):void
		{
			if( !_pStage3DProxy || !_pContext )
			{
				return;
			}
			
			_pRttViewProjectionMatrix.copyFrom( entityCollector.camera.viewProjection);
			_pRttViewProjectionMatrix.appendScale( _pTextureRatioX, _pTextureRatioY, 1);
			
			pExecuteRender( entityCollector, target, scissorRect, surfaceSelector );
			
			// clear buffers
			for( var i:Number = 0; i < 8; ++i )
			{
				_pContext.setVertexBufferAt( i, null );
				_pContext.setTextureAt( i, null );
			}
		}
		
		public function pExecuteRender(entityCollector:EntityCollector, target:TextureBase = null, scissorRect:Rectangle = null, surfaceSelector:Number = 0):void
		{
			_pRenderTarget = target;
			_pRenderTargetSurface = surfaceSelector;
			
			if( _pRenderableSorter )
			{
				_pRenderableSorter.sort(entityCollector);
			}
			if( _pRenderToTexture )
			{
				pExecuteRenderToTexturePass(entityCollector);
			}
			
			_pStage3DProxy.setRenderTarget( target, true, surfaceSelector );
			
			if ((target || !_pShareContext) && _clearOnRender)
			{
				_pContext.clear( _pBackgroundR, _pBackgroundG, _pBackgroundB, _pBackgroundAlpha, 1, 0 );
			}
			_pContext.setDepthTest(false, Context3DCompareMode.ALWAYS );
			_pStage3DProxy.scissorRect = scissorRect;
			/*			if( this._backgroundImageRenderer )			{				this._backgroundImageRenderer.render();			}*/
			pDraw(entityCollector, target);
			
			//line required for correct rendering when using away3d with starling. DO NOT REMOVE UNLESS STARLING INTEGRATION IS RETESTED!
			_pContext.setDepthTest( false, Context3DCompareMode.LESS_EQUAL );
			
			if( !_pShareContext )
			{
				if( _snapshotRequired && _snapshotBitmapData) {
					_pContext.drawToBitmapData( _snapshotBitmapData );
					_snapshotRequired = false;
				}
			}
			_pStage3DProxy.scissorRect = null;
		}
		
		public function queueSnapshot(bmd:BitmapData):void
		{
			_snapshotRequired = true;
			_snapshotBitmapData = bmd;
		}
		
		public function pExecuteRenderToTexturePass(entityCollector:EntityCollector):void
		{
			throw new AbstractMethodError();
		}
		
		public function pDraw(entityCollector:EntityCollector, target:TextureBase):void
		{
			throw new AbstractMethodError();
		}
		
		private function onContextUpdate(event:Event):void
		{
			_pContext = _pStage3DProxy.context3D;
		}
		
		//@arcane
		public function get iBackgroundAlpha():Number
		{
			return _pBackgroundAlpha;
		}
		
		//@arcane
		public function set iBackgroundAlpha(value:Number):void
		{
			this._pBackgroundAlpha = value;
		}
		
		//@arcane
		public function get iBackground():Texture2DBase
		{
			return _background;
		}
		
		//@arcane
		/*		public set iBackground( value:away.textures.Texture2DBase )		{			if( this._backgroundImageRenderer && !value )			{				this._backgroundImageRenderer.dispose();				this._backgroundImageRenderer = null;			}						if( !this._backgroundImageRenderer && value )			{				this._backgroundImageRenderer = new away.render.BackgroundImageRenderer( this._stage3DProxy );			}			this._background = value;						if( this._backgroundImageRenderer )			{				this._backgroundImageRenderer.texture = value;			}		}*/
		
		/*		public get backgroundImageRenderer():away.render.BackgroundImageRenderer		{			return this._backgroundImageRenderer;		}*/
		
		public function get antiAlias():Number
		{
			return _pAntiAlias;
		}
		
	}
}