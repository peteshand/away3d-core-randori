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
			this._pCullPlanes = new <Plane3D>[];
			this._pOverallDepthLens = new FreeMatrixLens();
			this._pOverallDepthCamera = new Camera3D( this._pOverallDepthLens );
			this._pLocalFrustum = new <Number>[];
			this._pMatrix = new Matrix3D();
		}
		
		public function get snap():Number
		{
			return this._pSnap;
		}
		
		public function set snap(value:Number):void
		{
			this._pSnap = value;
		}
		
		public function get lightOffset():Number
		{
			return this._pLightOffset;
		}
		
		public function set lightOffset(value:Number):void
		{
			this._pLightOffset = value;
		}
		
		//@arcane
		public function get iDepthProjection():Matrix3D
		{
			return this._pOverallDepthCamera.viewProjection;
		}
		
		//@arcane
		public function get depth():Number
		{
			return this._pMaxZ - this._pMinZ;
		}
		
		//@override
		override public function pDrawDepthMap(target:TextureBase, scene:Scene3D, renderer:DepthRenderer):void
		{
			this._pCasterCollector.camera = this._pOverallDepthCamera;
			this._pCasterCollector.cullPlanes = this._pCullPlanes;
			this._pCasterCollector.clear();
			scene.traversePartitions( this._pCasterCollector);
			renderer.iRender( this._pCasterCollector, target);
			this._pCasterCollector.cleanUp();
		}

		//@protected
		public function pUpdateCullPlanes(viewCamera:Camera3D):void
		{
			var lightFrustumPlanes:Vector.<Plane3D> = this._pOverallDepthCamera.frustumPlanes;
			var viewFrustumPlanes:Vector.<Plane3D> = viewCamera.frustumPlanes;
			this._pCullPlanes.length = 4;
			
			this._pCullPlanes[0] = lightFrustumPlanes[0];
			this._pCullPlanes[1] = lightFrustumPlanes[1];
			this._pCullPlanes[2] = lightFrustumPlanes[2];
			this._pCullPlanes[3] = lightFrustumPlanes[3];
			
			var light:DirectionalLight = (this._pLight as DirectionalLight);
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
					this._pCullPlanes[j++] = plane;
				}
			}
		}
		
		//@override
		override public function pUpdateDepthProjection(viewCamera:Camera3D):void
		{
			this.pUpdateProjectionFromFrustumCorners( viewCamera, viewCamera.lens.frustumCorners, this._pMatrix );
			this._pOverallDepthLens.matrix = this._pMatrix;
			this.pUpdateCullPlanes( viewCamera );
		}
		
		public function pUpdateProjectionFromFrustumCorners(viewCamera:Camera3D, corners:Vector.<Number>, matrix:Matrix3D):void
		{
			var raw:Vector.<Number> = new Vector.<Number>();
			var dir:Vector3D;
			var x:Number, y:Number, z:Number;
			var minX:Number, minY:Number;
			var maxX:Number, maxY:Number;
			var i:Number;
			
			var light: DirectionalLight = (this._pLight as DirectionalLight);
			dir = light.sceneDirection;
			this._pOverallDepthCamera.transform = this._pLight.sceneTransform;
			x = Math.floor((viewCamera.x - dir.x*this._pLightOffset)/this._pSnap)*this._pSnap;
			y = Math.floor((viewCamera.y - dir.y*this._pLightOffset)/this._pSnap)*this._pSnap;
			z = Math.floor((viewCamera.z - dir.z*this._pLightOffset)/this._pSnap)*this._pSnap;
			this._pOverallDepthCamera.x = x;
			this._pOverallDepthCamera.y = y;
			this._pOverallDepthCamera.z = z;
			
			this._pMatrix.copyFrom( this._pOverallDepthCamera.inverseSceneTransform );
			this._pMatrix.prepend( viewCamera.sceneTransform );
			this._pMatrix.transformVectors( corners, this._pLocalFrustum );
			
			minX = this._pLocalFrustum[0];
			maxX = this._pLocalFrustum[0];

			minY = this._pLocalFrustum[1];
			maxY = this._pLocalFrustum[1];

			this._pMaxZ = this._pLocalFrustum[2];
			
			i = 3;
			while (i < 24) {
				x = this._pLocalFrustum[i];
				y = this._pLocalFrustum[i + 1];
				z = this._pLocalFrustum[i + 2];
				if (x < minX)
					minX = x;
				if (x > maxX)
					maxX = x;
				if (y < minY)
					minY = y;
				if (y > maxY)
					maxY = y;
				if (z > this._pMaxZ)
					this._pMaxZ = z;
				i += 3;
			}
			this._pMinZ = 1;
			
			var w:Number = maxX - minX;
			var h:Number = maxY - minY;
			var d:Number = 1/(this._pMaxZ - this._pMinZ);
			
			if( minX < 0 )
			{
				minX -= this._pSnap; // because int() rounds up for < 0
			}
			if( minY < 0 )
			{
				minY -= this._pSnap;
			}
			minX = Math.floor(minX/this._pSnap)*this._pSnap;
			minY = Math.floor(minY/this._pSnap)*this._pSnap;
			
			var snap2:Number = 2*this._pSnap;
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
			raw[14] = -this._pMinZ*d;
			raw[15] = 1;
			raw[1] = 0;
			raw[2] = 0;
			raw[3] = 0;
			raw[4] = 0;
			raw[6] = 0;
			raw[7] = 0;
			raw[8] = 0;
			raw[9] = 0;
			raw[11] = 0;

			
			matrix.copyRawDataFrom(raw);
		}
	}
}