/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.core.render
{
	import away.core.display3D.Context3D;
	import away.managers.Stage3DProxy;
	import away.core.display3D.TextureBase;
	import away.core.sort.IEntitySorter;
	import away.textures.Texture2DBase;
	import away.core.display.BitmapData;
	import away.core.geom.Matrix3D;
	import away.core.sort.RenderableMergeSort;
	import away.core.traverse.EntityCollector;
	import away.events.Stage3DEvent;
	import away.core.geom.Rectangle;
	import away.core.display3D.Context3DCompareMode;
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
		public var _pRenderTargetSurface:Number = 0;
		
		// only used by renderers that need to render geometry to textures
		public var _pViewWidth:Number = 0;
		public var _pViewHeight:Number = 0;
		
		public var _pRenderableSorter:IEntitySorter;
		//private _backgroundImageRenderer:BackgroundImageRenderer;
		private var _background:Texture2DBase;
		
		public var _pRenderToTexture:Boolean = false;
		public var _pAntiAlias:Number = 0;
		public var _pTextureRatioX:Number = 1;
		public var _pTextureRatioY:Number = 1;
		
		private var _snapshotBitmapData:BitmapData;
		private var _snapshotRequired:Boolean = false;
		
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
			return this._pViewWidth;
		}
		
		//@arcane
		public function set iViewWidth(value:Number):void
		{
			this._pViewWidth = value;
		}
		
		//@arcane
		public function get iViewHeight():Number
		{
			return this._pViewHeight;
		}
		
		//@arcane
		public function set iViewHeight(value:Number):void
		{
			this._pViewHeight = value;
		}
		
		//@arcane
		public function get iRenderToTexture():Boolean
		{
			return this._pRenderToTexture;
		}
		
		public function get renderableSorter():IEntitySorter
		{
			return this._pRenderableSorter;
		}
		
		public function set renderableSorter(value:IEntitySorter):void
		{
			this._pRenderableSorter = value;
		}
		
		//@arcane
		public function get iClearOnRender():Boolean
		{
			return this._clearOnRender;
		}
		
		//@arcane
		public function set iClearOnRender(value:Boolean):void
		{
			this._clearOnRender = value;
		}
		
		//@arcane
		public function get iBackgroundR():Number
		{
			return this._pBackgroundR;
		}
		
		//@arcane
		public function set iBackgroundR(value:Number):void
		{
			this._pBackgroundR = value;
		}
		
		//@arcane
		public function get iBackgroundG():Number
		{
			return this._pBackgroundG;
		}
		
		//@arcane
		public function set iBackgroundG(value:Number):void
		{
			this._pBackgroundG = value;
		}
		
		//@arcane
		public function get iBackgroundB():Number
		{
			return this._pBackgroundB;
		}
		
		//@arcane
		public function set iBackgroundB(value:Number):void
		{
			this._pBackgroundB = value;
		}
		
		//@arcane
		public function get iStage3DProxy():Stage3DProxy
		{
			return this._pStage3DProxy;
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
					this._pStage3DProxy.removeEventListener( Stage3DEvent.CONTEXT3D_CREATED, onContextUpdate, this );
					this._pStage3DProxy.removeEventListener( Stage3DEvent.CONTEXT3D_RECREATED, onContextUpdate, this );
				}
				this._pStage3DProxy = null;
				this._pContext = null;
				return;
			}
			
			this._pStage3DProxy = value;
			this._pStage3DProxy.addEventListener( Stage3DEvent.CONTEXT3D_CREATED, onContextUpdate, this );
			this._pStage3DProxy.addEventListener( Stage3DEvent.CONTEXT3D_RECREATED, onContextUpdate, this );
			
			/*if( this._pBackgroundImageRenderer )			{				this._pBackgroundImageRenderer.stage3DProxy = value;			}*/
			
			if( value.context3D )
			{
				this._pContext = value.context3D;
			}
		}
		
		//@arcane
		public function get iShareContext():Boolean
		{
			return this._pShareContext;
		}
		
		//@arcane
		public function set iShareContext(value:Boolean):void
		{
			this._pShareContext = value;
		}
		
		//@arcane
		public function iDispose():void
		{
			this._pStage3DProxy = null;
			/*			if( this._pBackgroundImageRenderer )			{				this._pBackgroundImageRenderer.dispose();				this._pBackgroundImageRenderer = null;			}*/
		}
		
		//@arcane
		public function iRender(entityCollector:EntityCollector, target:TextureBase = null, scissorRect:Rectangle = null, surfaceSelector:Number = 0):void
		{
			target = target || null;
			scissorRect = scissorRect || null;
			surfaceSelector = surfaceSelector || 0;

			if( !this._pStage3DProxy || !this._pContext )
			{
				return;
			}
			
			this._pRttViewProjectionMatrix.copyFrom( entityCollector.camera.viewProjection);
			this._pRttViewProjectionMatrix.appendScale( this._pTextureRatioX, this._pTextureRatioY, 1);
			
			this.pExecuteRender( entityCollector, target, scissorRect, surfaceSelector );
			
			// clear buffers
			for( var i:Number = 0; i < 8; ++i )
			{
				this._pContext.setVertexBufferAt( i, null );
				this._pContext.setTextureAt( i, null );
			}
		}
		
		public function pExecuteRender(entityCollector:EntityCollector, target:TextureBase = null, scissorRect:Rectangle = null, surfaceSelector:Number = 0):void
		{
			target = target || null;
			scissorRect = scissorRect || null;
			surfaceSelector = surfaceSelector || 0;

			this._pRenderTarget = target;
			this._pRenderTargetSurface = surfaceSelector;
			
			if( this._pRenderableSorter )
			{
				this._pRenderableSorter.sort(entityCollector);
			}
			if( this._pRenderToTexture )
			{
				this.pExecuteRenderToTexturePass(entityCollector);
			}
			
			this._pStage3DProxy.setRenderTarget( target, true, surfaceSelector );
			
			if ((target || !this._pShareContext) && this._clearOnRender)
			{
				this._pContext.clear( this._pBackgroundR, this._pBackgroundG, this._pBackgroundB, this._pBackgroundAlpha, 1, 0 );
			}
			this._pContext.setDepthTest(false, Context3DCompareMode.ALWAYS );
			this._pStage3DProxy.scissorRect = scissorRect;
			/*			if( this._backgroundImageRenderer )			{				this._backgroundImageRenderer.render();			}*/
			this.pDraw(entityCollector, target);
			
			//line required for correct rendering when using away3d with starling. DO NOT REMOVE UNLESS STARLING INTEGRATION IS RETESTED!
			this._pContext.setDepthTest( false, Context3DCompareMode.LESS_EQUAL );
			
			if( !this._pShareContext )
			{
				if( this._snapshotRequired && this._snapshotBitmapData) {
					this._pContext.drawToBitmapData( this._snapshotBitmapData );
					this._snapshotRequired = false;
				}
			}
			this._pStage3DProxy.scissorRect = null;
		}
		
		public function queueSnapshot(bmd:BitmapData):void
		{
			this._snapshotRequired = true;
			this._snapshotBitmapData = bmd;
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
			this._pContext = this._pStage3DProxy.context3D;
		}
		
		//@arcane
		public function get iBackgroundAlpha():Number
		{
			return this._pBackgroundAlpha;
		}
		
		//@arcane
		public function set iBackgroundAlpha(value:Number):void
		{
			this._pBackgroundAlpha = value;
		}
		
		//@arcane
		public function get iBackground():Texture2DBase
		{
			return this._background;
		}
		
		//@arcane
		/*		public set iBackground( value:away.textures.Texture2DBase )		{			if( this._backgroundImageRenderer && !value )			{				this._backgroundImageRenderer.dispose();				this._backgroundImageRenderer = null;			}						if( !this._backgroundImageRenderer && value )			{				this._backgroundImageRenderer = new away.render.BackgroundImageRenderer( this._stage3DProxy );			}			this._background = value;						if( this._backgroundImageRenderer )			{				this._backgroundImageRenderer.texture = value;			}		}*/
		
		/*		public get backgroundImageRenderer():away.render.BackgroundImageRenderer		{			return this._backgroundImageRenderer;		}*/
		
		public function get antiAlias():Number
		{
			return this._pAntiAlias;
		}
		
	}
}