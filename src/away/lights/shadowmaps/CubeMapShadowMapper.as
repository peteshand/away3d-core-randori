/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../../_definitions.ts"/>

package away.lights.shadowmaps
{
	import away.cameras.Camera3D;
	import away.cameras.lenses.PerspectiveLens;
	import away.textures.TextureProxyBase;
	import away.errors.PartialImplementationError;
	import away.lights.PointLight;
	import away.geom.Vector3D;
	import away.display3D.TextureBase;
	import away.containers.Scene3D;
	import away.render.DepthRenderer;
	public class CubeMapShadowMapper extends ShadowMapperBase
	{
		
		private var _depthCameras:Vector.<Camera3D>;
		private var _lenses:Vector.<PerspectiveLens>;
		private var _needsRender:Vector.<Boolean>;
		
		public function CubeMapShadowMapper():void
		{
			super();
			
			this._pDepthMapSize = 512;
			this._needsRender = new Vector.<Boolean>;
			this.initCameras();
		}
		
		private function initCameras():void
		{
			_depthCameras = new Vector.<Camera3D>;
			_lenses = new Vector.<PerspectiveLens>;
			// posX, negX, posY, negY, posZ, negZ
			addCamera(0, 90, 0);
			addCamera(0, -90, 0);
			addCamera(-90, 0, 0);
			addCamera(90, 0, 0);
			addCamera(0, 0, 0);
			addCamera(0, 180, 0);
		}
		
		private function addCamera(rotationX:Number, rotationY:Number, rotationZ:Number):void
		{
			var cam:Camera3D = new Camera3D();
			cam.rotationX = rotationX;
			cam.rotationY = rotationY;
			cam.rotationZ = rotationZ;
			cam.lens.near = .01;
			
			var lens: PerspectiveLens = PerspectiveLens(cam.lens);
			lens.fieldOfView = 90;
			_lenses.push(lens);
			cam.lens.iAspectRatio = 1;
			_depthCameras.push( cam );
		}
		
		//@override
		override public function pCreateDepthTexture():TextureProxyBase
		{
			throw new PartialImplementationError();
			/*			return new away.textures.RenderCubeTexture( this._depthMapSize );			*/
		}
		
		//@override
		override public function pUpdateDepthProjection(viewCamera:Camera3D):void
		{
			var light:PointLight =  PointLight((_pLight));
			var maxDistance:Number = light._pFallOff;
			var pos:Vector3D = _pLight.scenePosition;
			
			// todo: faces outside frustum which are pointing away from camera need not be rendered!
			for( var i:Number = 0; i < 6; ++i ) {
				_lenses[i].far = maxDistance;
				_depthCameras[i].position = pos;
				_needsRender[i] = true;
			}
		}
		
		//@override
		override public function pDrawDepthMap(target:TextureBase, scene:Scene3D, renderer:DepthRenderer):void
		{
			for( var i:Number = 0; i < 6; ++i )
			{
				if( _needsRender[i] )
				{

					_pCasterCollector.camera = _depthCameras[i];
					_pCasterCollector.clear();
					scene.traversePartitions(_pCasterCollector );
					renderer.iRender( _pCasterCollector, target, null, i );
					_pCasterCollector.cleanUp();
				}
			}
		}

	}
}