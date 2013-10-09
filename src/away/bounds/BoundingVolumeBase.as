/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.bounds
{
	import away.core.geom.Vector3D;
	import away.primitives.WireframePrimitiveBase;
	import away.core.base.Geometry;
	import away.core.base.ISubGeometry;
	import away.core.math.Plane3D;
	import away.errors.AbstractMethodError;
	import away.core.geom.Matrix3D;
	public class BoundingVolumeBase
	{
		
		public var _pMin:Vector3D;
		public var _pMax:Vector3D;
		public var _pAabbPoints:Vector.<Number> = new Vector.<Number>();
		public var _pAabbPointsDirty:Boolean = true;
		public var _pBoundingRenderable:WireframePrimitiveBase;
		
		public function BoundingVolumeBase():void
		{
			this._pMin = new Vector3D();
			this._pMax = new Vector3D();
		}
		
		public function get max():Vector3D
		{
			return this._pMax;
		}
		
		public function get min():Vector3D
		{
			return this._pMin;
		}
		
		public function get aabbPoints():Vector.<Number>
		{
			if( this._pAabbPointsDirty )
			{
				this.pUpdateAABBPoints();
			}
			return this._pAabbPoints;
		}
		
		public function get boundingRenderable():WireframePrimitiveBase
		{
			if( !this._pBoundingRenderable )
			{
				this._pBoundingRenderable = this.pCreateBoundingRenderable();
				this.pUpdateBoundingRenderable();
			}
			return this._pBoundingRenderable;
		}
		
		public function nullify():void
		{
			this._pMin.z =  0;
			this._pMin.y = this._pMin.z
			this._pMin.x = this._pMin.y
			this._pMax.z =  0;
			this._pMax.y = this._pMax.z
			this._pMax.x = this._pMax.y
			this._pAabbPointsDirty = true;
			
			if( this._pBoundingRenderable )
			{
				this.pUpdateBoundingRenderable();
			}
		}
		
		public function disposeRenderable():void
		{
			if( this._pBoundingRenderable )
			{
				this._pBoundingRenderable.dispose();
			}
			this._pBoundingRenderable = null;
		}
		
		public function fromVertices(vertices:Vector.<Number>):void
		{
			var i:Number;
			var len:Number = vertices.length;
			var minX:Number, minY:Number, minZ:Number;
			var maxX:Number, maxY:Number, maxZ:Number;
			
			if( len == 0 )
			{
				this.nullify();
				return;
			}
			
			var v:Number;
			
			maxX =  vertices[i++];
			minX = maxX
			maxY =  vertices[i++];
			minY = maxY
			maxZ =  vertices[i++];
			minZ = maxZ
			
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
			
			this.fromExtremes( minX, minY, minZ, maxX, maxY, maxZ );
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

				minZ =  Number.POSITIVE_INFINITY;
				minY = minZ
				minX = minY
				maxZ =  Number.NEGATIVE_INFINITY;
				maxY = maxZ
				maxX = maxY
				
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
				
				this.fromExtremes(minX, minY, minZ, maxX, maxY, maxZ);
			}
            else
            {

                this.fromExtremes(0, 0, 0, 0, 0, 0);

            }

		}

		public function fromSphere(center:Vector3D, radius:Number):void
		{
			this.fromExtremes( center.x - radius, center.y - radius, center.z - radius, center.x + radius, center.y + radius, center.z + radius );
		}
		
		public function fromExtremes(minX:Number, minY:Number, minZ:Number, maxX:Number, maxY:Number, maxZ:Number):void
		{
			this._pMin.x = minX;
			this._pMin.y = minY;
			this._pMin.z = minZ;
			this._pMax.x = maxX;
			this._pMax.y = maxY;
			this._pMax.z = maxZ;
			this._pAabbPointsDirty = true;
			
			if( this._pBoundingRenderable )
			{
				this.pUpdateBoundingRenderable();
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
			return this._pMax.x > min.x &&
				this._pMin.x < max.x &&
				this._pMax.y > min.y &&
				this._pMin.y < max.y &&
				this._pMax.z > min.z &&
				this._pMin.z < max.z;
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
			var maxX:Number = this._pMax.x;
			var maxY:Number = this._pMax.y;
			var maxZ:Number = this._pMax.z;
			var minX:Number = this._pMin.x;
			var minY:Number = this._pMin.y;
			var minZ:Number = this._pMin.z;
			
			this._pAabbPoints[0] = minX;
			this._pAabbPoints[1] = minY;
			this._pAabbPoints[2] = minZ;
			this._pAabbPoints[3] = maxX;
			this._pAabbPoints[4] = minY;
			this._pAabbPoints[5] = minZ;
			this._pAabbPoints[6] = minX;
			this._pAabbPoints[7] = maxY;
			this._pAabbPoints[8] = minZ;
			this._pAabbPoints[9] = maxX;
			this._pAabbPoints[10] = maxY;
			this._pAabbPoints[11] = minZ;
			this._pAabbPoints[12] = minX;
			this._pAabbPoints[13] = minY;
			this._pAabbPoints[14] = maxZ;
			this._pAabbPoints[15] = maxX;
			this._pAabbPoints[16] = minY;
			this._pAabbPoints[17] = maxZ;
			this._pAabbPoints[18] = minX;
			this._pAabbPoints[19] = maxY;
			this._pAabbPoints[20] = maxZ;
			this._pAabbPoints[21] = maxX;
			this._pAabbPoints[22] = maxY;
			this._pAabbPoints[23] = maxZ;
			this._pAabbPointsDirty = false;
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