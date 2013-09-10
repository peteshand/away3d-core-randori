/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../../_definitions.ts" />

package away.lights.shadowmaps
{
	import away.cameras.Camera3D;
	import away.geom.Matrix3D;
	import away.cameras.lenses.FreeMatrixLens;
	import away.math.Plane3D;
	import away.display3D.TextureBase;
	import away.containers.Scene3D;
	import away.render.DepthRenderer;
	import away.lights.DirectionalLight;
	import away.geom.Vector3D;
	public class DirectionalShadowMapper extends ShadowMapperBase
	{
		
		public var _pOverallDepthCamera:Camera3D;
		public var _pLocalFrustum:Vector.<Number>;
		
		public var _pLightOffset:Number = 10000;
		public var _pMatrix:Matrix3D;
		public var _pOverallDepthLens:FreeMatrixLens;
		public var _pSnap:Number = 64;
		
		public var _pCullPlanes:Vector.<Plane3D>;
		public var _pMinZ:Number;
		public var _pMaxZ:Number;
		
		public function DirectionalShadowMapper():void
		{
			super();
			_pCullPlanes = new <Plane3D>[];
			_pOverallDepthLens = new FreeMatrixLens();
			_pOverallDepthCamera = new Camera3D( _pOverallDepthLens );
			_pLocalFrustum = new <Number>[];
			_pMatrix = new Matrix3D();
		}
		
		public function get snap():Number
		{
			return _pSnap;
		}
		
		public function set snap(value:Number):void
		{
			_pSnap = value;
		}
		
		public function get lightOffset():Number
		{
			return _pLightOffset;
		}
		
		public function set lightOffset(value:Number):void
		{
			_pLightOffset = value;
		}
		
		//@arcane
		public function get iDepthProjection():Matrix3D
		{
			return _pOverallDepthCamera.viewProjection;
		}
		
		//@arcane
		public function get depth():Number
		{
			return _pMaxZ - _pMinZ;
		}
		
		//@override
		override public function pDrawDepthMap(target:TextureBase, scene:Scene3D, renderer:DepthRenderer):void
		{
			_pCasterCollector.camera = _pOverallDepthCamera;
			_pCasterCollector.cullPlanes = _pCullPlanes;
			_pCasterCollector.clear();
			scene.traversePartitions( _pCasterCollector);
			renderer.iRender( _pCasterCollector, target);
			_pCasterCollector.cleanUp();
		}

		//@protected
		public function pUpdateCullPlanes(viewCamera:Camera3D):void
		{
			var lightFrustumPlanes:Vector.<Plane3D> = _pOverallDepthCamera.frustumPlanes;
			var viewFrustumPlanes:Vector.<Plane3D> = viewCamera.frustumPlanes;
			_pCullPlanes.length = 4;
			
			_pCullPlanes[0] = lightFrustumPlanes[0];
			_pCullPlanes[1] = lightFrustumPlanes[1];
			_pCullPlanes[2] = lightFrustumPlanes[2];
			_pCullPlanes[3] = lightFrustumPlanes[3];
			
			var light:DirectionalLight = (_pLight as DirectionalLight);
			var dir:Vector3D = light.sceneDirection;
			var dirX:Number = dir.x;
			var dirY:Number = dir.y;
			var dirZ:Number = dir.z;
			var j:Number = 4;
			for (var i:Number = 0; i < 6; ++i)
			{
				var plane:Plane3D = viewFrustumPlanes[i];
				if( plane.a*dirX + plane.b*dirY + plane.c*dirZ < 0 )
				{
					_pCullPlanes[j++] = plane;
				}
			}
		}
		
		//@override
		override public function pUpdateDepthProjection(viewCamera:Camera3D):void
		{
			pUpdateProjectionFromFrustumCorners( viewCamera, viewCamera.lens.frustumCorners, _pMatrix );
			_pOverallDepthLens.matrix = _pMatrix;
			pUpdateCullPlanes( viewCamera );
		}
		
		public function pUpdateProjectionFromFrustumCorners(viewCamera:Camera3D, corners:Vector.<Number>, matrix:Matrix3D):void
		{
			var raw:Vector.<Number> = new Vector.<Number>();
			var dir:Vector3D;
			var x:Number, y:Number, z:Number;
			var minX:Number, minY:Number;
			var maxX:Number, maxY:Number;
			var i:Number;
			
			var light: DirectionalLight = (_pLight as DirectionalLight);
			dir = light.sceneDirection;
			_pOverallDepthCamera.transform = _pLight.sceneTransform;
			x = Math.floor((viewCamera.x - dir.x*_pLightOffset)/_pSnap)*_pSnap;
			y = Math.floor((viewCamera.y - dir.y*_pLightOffset)/_pSnap)*_pSnap;
			z = Math.floor((viewCamera.z - dir.z*_pLightOffset)/_pSnap)*_pSnap;
			_pOverallDepthCamera.x = x;
			_pOverallDepthCamera.y = y;
			_pOverallDepthCamera.z = z;
			
			_pMatrix.copyFrom( _pOverallDepthCamera.inverseSceneTransform );
			_pMatrix.prepend( viewCamera.sceneTransform );
			_pMatrix.transformVectors( corners, _pLocalFrustum );
			
			minX = maxX = _pLocalFrustum[0];
			minY = maxY = _pLocalFrustum[1];
			_pMaxZ = _pLocalFrustum[2];
			
			i = 3;
			while (i < 24) {
				x = _pLocalFrustum[i];
				y = _pLocalFrustum[i + 1];
				z = _pLocalFrustum[i + 2];
				if (x < minX)
					minX = x;
				if (x > maxX)
					maxX = x;
				if (y < minY)
					minY = y;
				if (y > maxY)
					maxY = y;
				if (z > _pMaxZ)
					_pMaxZ = z;
				i += 3;
			}
			_pMinZ = 1;
			
			var w:Number = maxX - minX;
			var h:Number = maxY - minY;
			var d:Number = 1/(_pMaxZ - _pMinZ);
			
			if( minX < 0 )
			{
				minX -= _pSnap; // because int() rounds up for < 0
			}
			if( minY < 0 )
			{
				minY -= _pSnap;
			}
			minX = Math.floor(minX/_pSnap)*_pSnap;
			minY = Math.floor(minY/_pSnap)*_pSnap;
			
			var snap2:Number = 2*_pSnap;
			w = Math.floor(w/snap2 + 2)*snap2;
			h = Math.floor(h/snap2 + 2)*snap2;
			
			maxX = minX + w;
			maxY = minY + h;
			
			w = 1/w;
			h = 1/h;
			
			raw[0] = 2*w;
			raw[5] = 2*h;
			raw[10] = d;
			raw[12] = -(maxX + minX)*w;
			raw[13] = -(maxY + minY)*h;
			raw[14] = -_pMinZ*d;
			raw[15] = 1;
			raw[1] = raw[2] = raw[3] = raw[4] = raw[6] = raw[7] = raw[8] = raw[9] = raw[11] = 0;
			
			matrix.copyRawDataFrom(raw);
		}
	}
}