/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts" />

package away.bounds
{
	import away.geom.Vector3D;
	import away.primitives.WireframePrimitiveBase;
	import away.base.Geometry;
	import away.base.ISubGeometry;
	import away.math.Plane3D;
	import away.errors.AbstractMethodError;
	import away.geom.Matrix3D;
	public class BoundingVolumeBase
	{
		
		public var _pMin:Vector3D;
		public var _pMax:Vector3D;
		public var _pAabbPoints:Vector.<Number> = new Vector.<Number>();
		public var _pAabbPointsDirty:Boolean = true;
		public var _pBoundingRenderable:WireframePrimitiveBase;
		
		public function BoundingVolumeBase():void
		{
			_pMin = new Vector3D();
			_pMax = new Vector3D();
		}
		
		public function get max():Vector3D
		{
			return _pMax;
		}
		
		public function get min():Vector3D
		{
			return _pMin;
		}
		
		public function get aabbPoints():Vector.<Number>
		{
			if( _pAabbPointsDirty )
			{
				pUpdateAABBPoints();
			}
			return _pAabbPoints;
		}
		
		public function get boundingRenderable():WireframePrimitiveBase
		{
			if( !_pBoundingRenderable )
			{
				_pBoundingRenderable = pCreateBoundingRenderable();
				pUpdateBoundingRenderable();
			}
			return _pBoundingRenderable;
		}
		
		public function nullify():void
		{
			_pMin.x = _pMin.y = _pMin.z = 0;
			_pMax.x = _pMax.y = _pMax.z = 0;
			_pAabbPointsDirty = true;
			
			if( _pBoundingRenderable )
			{
				pUpdateBoundingRenderable();
			}
		}
		
		public function disposeRenderable():void
		{
			if( _pBoundingRenderable )
			{
				_pBoundingRenderable.dispose();
			}
			_pBoundingRenderable = null;
		}
		
		public function fromVertices(vertices:Vector.<Number>):void
		{
			var i:Number;
			var len:Number = vertices.length;
			var minX:Number, minY:Number, minZ:Number;
			var maxX:Number, maxY:Number, maxZ:Number;
			
			if( len == 0 )
			{
				nullify();
				return;
			}
			
			var v:Number;
			
			minX = maxX = vertices[i++];
			minY = maxY = vertices[i++];
			minZ = maxZ = vertices[i++];
			
			while( i < len )
			{
				v = vertices[i++];
				if (v < minX)
					minX = v;
				else if (v > maxX)
					maxX = v;
				v = vertices[i++];
				if (v < minY)
					minY = v;
				else if (v > maxY)
					maxY = v;
				v = vertices[i++];
				if (v < minZ)
					minZ = v;
				else if (v > maxZ)
					maxZ = v;
			}
			
			fromExtremes( minX, minY, minZ, maxX, maxY, maxZ );
		}
		
		public function fromGeometry(geometry:Geometry):void
		{

            var subGeoms:Vector.<ISubGeometry> = geometry.subGeometries; //var subGeoms:Vector.<away.base.ISubGeometry> = geometry.subGeometries;
			var numSubGeoms:Number = subGeoms.length;
			var minX:Number, minY:Number, minZ:Number;
			var maxX:Number, maxY:Number, maxZ:Number;
			
			if (numSubGeoms > 0)
            {

				var j:Number = 0;

				minX = minY = minZ = Number.POSITIVE_INFINITY;
				maxX = maxY = maxZ = Number.NEGATIVE_INFINITY;
				
				while (j < numSubGeoms)
                {

					var subGeom:ISubGeometry = subGeoms[j++];
                    var vertices:Vector.<Number> = subGeom.vertexData;//var vertices:Vector.<Number> = subGeom.vertexData;
					var vertexDataLen:Number = vertices.length;
					var i:Number = subGeom.vertexOffset;
					var stride:Number = subGeom.vertexStride;
					
					while (i < vertexDataLen)
                    {
						var v:Number = vertices[i];
						if (v < minX)
                        {
                            minX = v;
                        }
						else if (v > maxX)
                        {

                            maxX = v;

                        }


						v = vertices[i + 1];

						if (v < minY)
                        {

                            minY = v;

                        }
						else if (v > maxY)
                        {

                            maxY = v;

                        }

						v = vertices[i + 2];

						if (v < minZ)
                        {

                            minZ = v;

                        }
						else if (v > maxZ)
                        {

                            maxZ = v;

                        }

						i += stride;
					}
				}
				
				fromExtremes(minX, minY, minZ, maxX, maxY, maxZ);
			}
            else
            {

                fromExtremes(0, 0, 0, 0, 0, 0);

            }

		}

		public function fromSphere(center:Vector3D, radius:Number):void
		{
			fromExtremes( center.x - radius, center.y - radius, center.z - radius, center.x + radius, center.y + radius, center.z + radius );
		}
		
		public function fromExtremes(minX:Number, minY:Number, minZ:Number, maxX:Number, maxY:Number, maxZ:Number):void
		{
			_pMin.x = minX;
			_pMin.y = minY;
			_pMin.z = minZ;
			_pMax.x = maxX;
			_pMax.y = maxY;
			_pMax.z = maxZ;
			_pAabbPointsDirty = true;
			
			if( _pBoundingRenderable )
			{
				pUpdateBoundingRenderable();
			}
		}
		
		public function isInFrustum(planes:Vector.<Plane3D>, numPlanes:Number):Boolean
		{
			throw new AbstractMethodError();
		}
		
		public function overlaps(bounds:BoundingVolumeBase):Boolean
		{
			var min:Vector3D = bounds._pMin;
			var max:Vector3D = bounds._pMax;
			return _pMax.x > min.x &&
				_pMin.x < max.x &&
				_pMax.y > min.y &&
				_pMin.y < max.y &&
				_pMax.z > min.z &&
				_pMin.z < max.z;
		}
		
		public function clone():BoundingVolumeBase
		{
			throw new AbstractMethodError();
		}
		
		public function rayIntersection(position:Vector3D, direction:Vector3D, targetNormal:Vector3D):Number
		{
			position = position;
			direction = direction;
			targetNormal = targetNormal;
			return -1;
		}
		
		public function containsPoint(position:Vector3D):Boolean
		{
			position = position;
			return false;
		}
		
		public function pUpdateAABBPoints():void
		{
			var maxX:Number = _pMax.x;
			var maxY:Number = _pMax.y;
			var maxZ:Number = _pMax.z;
			var minX:Number = _pMin.x;
			var minY:Number = _pMin.y;
			var minZ:Number = _pMin.z;
			
			_pAabbPoints[0] = minX;
			_pAabbPoints[1] = minY;
			_pAabbPoints[2] = minZ;
			_pAabbPoints[3] = maxX;
			_pAabbPoints[4] = minY;
			_pAabbPoints[5] = minZ;
			_pAabbPoints[6] = minX;
			_pAabbPoints[7] = maxY;
			_pAabbPoints[8] = minZ;
			_pAabbPoints[9] = maxX;
			_pAabbPoints[10] = maxY;
			_pAabbPoints[11] = minZ;
			_pAabbPoints[12] = minX;
			_pAabbPoints[13] = minY;
			_pAabbPoints[14] = maxZ;
			_pAabbPoints[15] = maxX;
			_pAabbPoints[16] = minY;
			_pAabbPoints[17] = maxZ;
			_pAabbPoints[18] = minX;
			_pAabbPoints[19] = maxY;
			_pAabbPoints[20] = maxZ;
			_pAabbPoints[21] = maxX;
			_pAabbPoints[22] = maxY;
			_pAabbPoints[23] = maxZ;
			_pAabbPointsDirty = false;
		}
		
		public function pUpdateBoundingRenderable():void
		{
			throw new AbstractMethodError();
		}
		
		public function pCreateBoundingRenderable():WireframePrimitiveBase
		{
			throw new AbstractMethodError();
		}
		
		public function classifyToPlane(plane:Plane3D):Number
		{
			throw new AbstractMethodError();
		}
		
		public function transformFrom(bounds:BoundingVolumeBase, matrix:Matrix3D):void
		{
			throw new AbstractMethodError();
		}
	}
}