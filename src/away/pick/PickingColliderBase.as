
///<reference path="../_definitions.ts"/>
package away.pick
{
	import away.geom.Vector3D;
	import away.geom.Point;
	import away.base.SubGeometry;
	import away.utils.Debug;
	import away.base.SubMesh;

	/**	 * An abstract base class for all picking collider classes. It should not be instantiated directly.	 */
	public class PickingColliderBase
	{
		public var rayPosition:Vector3D;
        public var rayDirection:Vector3D;
		
		public function PickingColliderBase():void
		{
		
		}
		
		public function _pPetCollisionNormal(indexData:Vector.<Number>/*uint*/, vertexData:Vector.<Number>, triangleIndex:Number):Vector3D // PROTECTED		{
			var normal:Vector3D = new Vector3D();
			var i0:Number = indexData[ triangleIndex ]*3;
			var i1:Number = indexData[ triangleIndex + 1 ]*3;
			var i2:Number = indexData[ triangleIndex + 2 ]*3;
			var p0:Vector3D = new Vector3D(vertexData[ i0 ], vertexData[ i0 + 1 ], vertexData[ i0 + 2 ]);
			var p1:Vector3D = new Vector3D(vertexData[ i1 ], vertexData[ i1 + 1 ], vertexData[ i1 + 2 ]);
			var p2:Vector3D = new Vector3D(vertexData[ i2 ], vertexData[ i2 + 1 ], vertexData[ i2 + 2 ]);
			var side0:Vector3D = p1.subtract(p0);
			var side1:Vector3D = p2.subtract(p0);
			normal = side0.crossProduct(side1);
			normal.normalize();
			return normal;
		}
		
		public function _pGetCollisionUV(indexData:Vector.<Number>/*uint*/, uvData:Vector.<Number>, triangleIndex:Number, v:Number, w:Number, u:Number, uvOffset:Number, uvStride:Number):Point // PROTECTED		{
			var uv:Point = new Point();
			var uIndex:Number = indexData[ triangleIndex ]*uvStride + uvOffset;
			var uv0:Vector3D = new Vector3D(uvData[ uIndex ], uvData[ uIndex + 1 ]);
			uIndex = indexData[ triangleIndex + 1 ]*uvStride + uvOffset;
			var uv1:Vector3D = new Vector3D(uvData[ uIndex ], uvData[ uIndex + 1 ]);
			uIndex = indexData[ triangleIndex + 2 ]*uvStride + uvOffset;
			var uv2:Vector3D = new Vector3D(uvData[ uIndex ], uvData[ uIndex + 1 ]);
			uv.x = u*uv0.x + v*uv1.x + w*uv2.x;
			uv.y = u*uv0.y + v*uv1.y + w*uv2.y;
			return uv;
		}

		//* TODO: implement & integrate GeometryUtils, SubGeometry, SubMesh
		public function pGetMeshSubgeometryIndex(subGeometry:SubGeometry):Number
		{

            Debug.throwPIR( 'away.pick.PickingColliderBase' , 'pGetMeshSubMeshIndex' , 'GeometryUtils.getMeshSubMeshIndex'  );
            return 0;
			//return GeometryUtils.getMeshSubgeometryIndex(subGeometry);
		}
		//*/

        //* TODO: implement & integrate
		public function pGetMeshSubMeshIndex(subMesh:SubMesh):Number
		{

            Debug.throwPIR( 'away.pick.PickingColliderBase' , 'pGetMeshSubMeshIndex' , 'GeometryUtils.getMeshSubMeshIndex'  );

            return 0;
			//return GeometryUtils.getMeshSubMeshIndex(subMesh);
		}
		//*/

		/**		 * @inheritDoc		 */
		public function setLocalRay(localPosition:Vector3D, localDirection:Vector3D):void
		{
			this.rayPosition = localPosition;
            this.rayDirection = localDirection;
		}
	}
}
