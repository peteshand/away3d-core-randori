/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../../_definitions.ts"/>

package away.lights.shadowmaps
{
	import away.traverse.ShadowCasterCollector;
	import away.textures.TextureProxyBase;
	import away.lights.LightBase;
	import away.textures.RenderTexture;
	import away.managers.Stage3DProxy;
	import away.traverse.EntityCollector;
	import away.render.DepthRenderer;
	import away.cameras.Camera3D;
	import away.errors.AbstractMethodError;
	import away.display3D.TextureBase;
	import away.containers.Scene3D;
	public class ShadowMapperBase
	{
		
		public var _pCasterCollector:ShadowCasterCollector;
		
		private var _depthMap:TextureProxyBase;
		public var _pDepthMapSize:Number = 2048;
		public var _pLight:LightBase;
		private var _explicitDepthMap:Boolean;
		private var _autoUpdateShadows:Boolean = true;
		public var _iShadowsInvalid:Boolean;
		
		public function ShadowMapperBase():void
		{
			this._pCasterCollector = this.pCreateCasterCollector();
		}
		
		public function pCreateCasterCollector():ShadowCasterCollector
		{
			return new ShadowCasterCollector();
		}
		
		public function get autoUpdateShadows():Boolean
		{
			return _autoUpdateShadows;
		}
		
		public function set autoUpdateShadows(value:Boolean):void
		{
			this._autoUpdateShadows = value;
		}
		
		public function updateShadows():void
		{
			_iShadowsInvalid = true;
		}
		
		public function iSetDepthMap(depthMap:TextureProxyBase):void
		{
			if( _depthMap == depthMap )
			{
				return;
			}
			if( _depthMap && !_explicitDepthMap )
			{
				_depthMap.dispose();
			}
			_depthMap = depthMap;
			if( _depthMap )
			{
				_explicitDepthMap = true;
				_pDepthMapSize = _depthMap.width;
			}
			else
			{
				_explicitDepthMap = false;
			}
		}
		
		public function get light():LightBase
		{
			return _pLight;
		}
		
		public function set light(value:LightBase):void
		{
			this._pLight = value;
		}
		
		public function get depthMap():TextureProxyBase
		{
			if ( !_depthMap )
			{
				_depthMap = pCreateDepthTexture()
			}
			return _depthMap;
		}
		
		public function get depthMapSize():Number
		{
			return _pDepthMapSize;
		}
		
		public function set depthMapSize(value:Number):void
		{
			if( value == this._pDepthMapSize )
			{
				return;
			}
			this._pDepthMapSize = value;
			
			if( this._explicitDepthMap )
			{
				throw Error("Cannot set depth map size for the current renderer.");
			}
			else if( this._depthMap )
			{
				this._depthMap.dispose();
				this._depthMap = null;
			}
		}
		
		public function dispose():void
		{
			_pCasterCollector = null;
			if ( _depthMap && !_explicitDepthMap )
			{
				_depthMap.dispose();
			}
			_depthMap = null;
		}

        public function pCreateDepthTexture():TextureProxyBase
        {

            //away.Debug.throwPIR( 'ShadowMapperBase' , 'pCreateDepthTexture' , 'Depedency: RenderTexture');
            //return null;

            return new RenderTexture( _pDepthMapSize, _pDepthMapSize);
        }

		public function iRenderDepthMap(stage3DProxy:Stage3DProxy, entityCollector:EntityCollector, renderer:DepthRenderer):void
		{
			_iShadowsInvalid = false;

			pUpdateDepthProjection( entityCollector.camera );

			if( !_depthMap )
			{
				_depthMap = pCreateDepthTexture();
			}
			pDrawDepthMap( _depthMap.getTextureForStage3D(stage3DProxy), entityCollector.scene, renderer);
		}
		
		public function pUpdateDepthProjection(viewCamera:Camera3D):void
		{
			throw new AbstractMethodError();
		}
		
		public function pDrawDepthMap(target:TextureBase, scene:Scene3D, renderer:DepthRenderer):void
		{
			throw new AbstractMethodError();
		}
	}
}