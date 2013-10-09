/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.core.pick
{
	import away.core.base.SubMesh;
	import away.core.geom.Vector3D;

	/**	 * Pure AS3 picking collider for entity objects. Used with the <code>RaycastPicker</code> picking object.	 *	 * @see away3d.entities.Entity#pickingCollider	 * @see away3d.core.pick.RaycastPicker	 */
	public class AS3PickingCollider extends PickingColliderBase implements IPickingCollider
	{
		private var _findClosestCollision:Boolean = false;
		
		/**		 * Creates a new <code>AS3PickingCollider</code> object.		 *		 * @param findClosestCollision Determines whether the picking collider searches for the closest collision along the ray. Defaults to false.		 */
		public function AS3PickingCollider(findClosestCollision:Boolean = false):void
		{
            super();
			this._findClosestCollision = findClosestCollision;
		}
		
		/**		 * @inheritDoc		 */
        //* TODO: Implement & Integrate Dependencies: SubMesh
		public function testSubMeshCollision(subMesh:SubMesh, pickingCollisionVO:PickingCollisionVO, shortestCollisionDistance:Number):Boolean
		{
			var t:Number;
			var i0:Number, i1:Number, i2:Number;
			var rx:Number, ry:Number, rz:Number;
			var nx:Number, ny:Number, nz:Number;
			var cx:Number, cy:Number, cz:Number;
			var coeff:Number, u:Number, v:Number, w:Number;
			var p0x:Number, p0y:Number, p0z:Number;
			var p1x:Number, p1y:Number, p1z:Number;
			var p2x:Number, p2y:Number, p2z:Number;
			var s0x:Number, s0y:Number, s0z:Number;
			var s1x:Number, s1y:Number, s1z:Number;
			var nl:Number, nDotV:Number, D:Number, disToPlane:Number;
			var Q1Q2:Number, Q1Q1:Number, Q2Q2:Number, RQ1:Number, RQ2:Number;
			var indexData:Vector.<Number>  = subMesh.indexData;//uint
			var vertexData:Vector.<Number> = subMesh.vertexData;
			var uvData:Vector.<Number> = subMesh.UVData;
			var collisionTriangleIndex:Number = -1;
			var bothSides:Boolean = subMesh.material.bothSides;
			
			var vertexStride:Number = subMesh.vertexStride;
			var vertexOffset:Number = subMesh.vertexOffset;
			var uvStride:Number = subMesh.UVStride;
			var uvOffset:Number = subMesh.UVOffset;
			var numIndices:Number = indexData.length;
			
			for (var index:Number = 0; index < numIndices; index += 3) { // sweep all triangles
				// evaluate triangle indices
				i0 = vertexOffset + indexData[ index ]*vertexStride;
				i1 = vertexOffset + indexData[ (index + 1) ]*vertexStride;
				i2 = vertexOffset + indexData[ (index + 2) ]*vertexStride;
				
				// evaluate triangle vertices
				p0x = vertexData[ i0 ];
				p0y = vertexData[ (i0 + 1) ];
				p0z = vertexData[ (i0 + 2) ];
				p1x = vertexData[ i1 ];
				p1y = vertexData[ (i1 + 1) ];
				p1z = vertexData[ (i1 + 2) ];
				p2x = vertexData[ i2 ];
				p2y = vertexData[ (i2 + 1) ];
				p2z = vertexData[ (i2 + 2) ];
				
				// evaluate sides and triangle normal
				s0x = p1x - p0x; // s0 = p1 - p0
				s0y = p1y - p0y;
				s0z = p1z - p0z;
				s1x = p2x - p0x; // s1 = p2 - p0
				s1y = p2y - p0y;
				s1z = p2z - p0z;
				nx = s0y*s1z - s0z*s1y; // n = s0 x s1
				ny = s0z*s1x - s0x*s1z;
				nz = s0x*s1y - s0y*s1x;
				nl = 1/Math.sqrt(nx*nx + ny*ny + nz*nz); // normalize n
				nx *= nl;
				ny *= nl;
				nz *= nl;
				
				// -- plane intersection test --
				nDotV = nx*this.rayDirection.x + ny* +this.rayDirection.y + nz*this.rayDirection.z; // rayDirection . normal
				if (( !bothSides && nDotV < 0.0 ) || ( bothSides && nDotV != 0.0 )) { // an intersection must exist
					// find collision t
					D = -( nx*p0x + ny*p0y + nz*p0z );
					disToPlane = -( nx*this.rayPosition.x + ny*this.rayPosition.y + nz*this.rayPosition.z + D );
					t = disToPlane/nDotV;
					// find collision point
					cx = this.rayPosition.x + t*this.rayDirection.x;
					cy = this.rayPosition.y + t*this.rayDirection.y;
					cz = this.rayPosition.z + t*this.rayDirection.z;
					// collision point inside triangle? ( using barycentric coordinates )
					Q1Q2 = s0x*s1x + s0y*s1y + s0z*s1z;
					Q1Q1 = s0x*s0x + s0y*s0y + s0z*s0z;
					Q2Q2 = s1x*s1x + s1y*s1y + s1z*s1z;
					rx = cx - p0x;
					ry = cy - p0y;
					rz = cz - p0z;
					RQ1 = rx*s0x + ry*s0y + rz*s0z;
					RQ2 = rx*s1x + ry*s1y + rz*s1z;
					coeff = 1/( Q1Q1*Q2Q2 - Q1Q2*Q1Q2 );
					v = coeff*( Q2Q2*RQ1 - Q1Q2*RQ2 );
					w = coeff*( -Q1Q2*RQ1 + Q1Q1*RQ2 );
					if (v < 0)
						continue;
					if (w < 0)
						continue;
					u = 1 - v - w;
					if (!( u < 0 ) && t > 0 && t < shortestCollisionDistance) { // all tests passed
						shortestCollisionDistance = t;
						collisionTriangleIndex = index/3;
						pickingCollisionVO.rayEntryDistance = t;
						pickingCollisionVO.localPosition = new Vector3D(cx, cy, cz);
						pickingCollisionVO.localNormal = new Vector3D(nx, ny, nz);
						pickingCollisionVO.uv = this._pGetCollisionUV(indexData, uvData, index, v, w, u, uvOffset, uvStride);
						pickingCollisionVO.index = index;
						pickingCollisionVO.subGeometryIndex = this.pGetMeshSubMeshIndex(subMesh);
						
						// if not looking for best hit, first found will do...
						if (!this._findClosestCollision)
							return true;
					}
				}
			}



			if (collisionTriangleIndex >= 0)
				return true;
			
			return false;
		}
        //*/
	}
}
