/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts" />

package away.bounds
{
	import away.math.Plane3D;
	import away.geom.Vector3D;
	import away.primitives.WireframePrimitiveBase;
	import away.primitives.WireframeSphere;
	import away.math.PlaneClassification;
	import away.geom.Matrix3D;
	public class BoundingSphere extends BoundingVolumeBase
	{
		
		private var _radius:Number = 0;
		private var _centerX:Number = 0;
		private var _centerY:Number = 0;
		private var _centerZ:Number = 0;
		
		public function BoundingSphere():void
		{
			super();
		}
		
		public function get radius():Number
		{
			return this._radius;
		}
		
		override public function nullify():void
		{
			super.nullify();
			this._centerX = 0;
			this._centerY = 0;
			this._centerZ = 0;

			this._radius = 0;
		}
		
		override public function isInFrustum(planes:Vector.<Plane3D>, numPlanes:Number):Boolean
		{
			for( var i:Number = 0; i < numPlanes; ++i )
			{
				var plane:Plane3D = planes[i];
				var flippedExtentX:Number = plane.a < 0? -this._radius : this._radius;
				var flippedExtentY:Number = plane.b < 0? -this._radius : this._radius;
				var flippedExtentZ:Number = plane.c < 0? -this._radius : this._radius;
				var projDist:Number = plane.a*( this._centerX + flippedExtentX ) + plane.b*( this._centerY + flippedExtentY) + plane.c*( this._centerZ + flippedExtentZ ) - plane.d;
				if( projDist < 0 )
				{
					return false;
				}
			}
			return true;
		}
		
		override public function fromSphere(center:Vector3D, radius:Number):void
		{
			this._centerX = center.x;
			this._centerY = center.y;
			this._centerZ = center.z;
			this._radius = radius;
			this._pMax.x = this._centerX + radius;
			this._pMax.y = this._centerY + radius;
			this._pMax.z = this._centerZ + radius;
			this._pMin.x = this._centerX - radius;
			this._pMin.y = this._centerY - radius;
			this._pMin.z = this._centerZ - radius;
			this._pAabbPointsDirty = true;
			if( this._pBoundingRenderable )
			{
				this.pUpdateBoundingRenderable();
			}
		}
		
		override public function fromExtremes(minX:Number, minY:Number, minZ:Number, maxX:Number, maxY:Number, maxZ:Number):void
		{
			this._centerX = (maxX + minX)*.5;
			this._centerY = (maxY + minY)*.5;
			this._centerZ = (maxZ + minZ)*.5;
			
			var d:Number = maxX - minX;
			var y:Number = maxY - minY;
			var z:Number = maxZ - minZ;
			if( y > d )
			{
				d = y;
			}
			if (z > d)
			{
				d = z;
			}
			this._radius = d*Math.sqrt(.5);
			super.fromExtremes( minX, minY, minZ, maxX, maxY, maxZ );
		}
		
		override public function clone():BoundingVolumeBase
		{
			var clone:BoundingSphere = new BoundingSphere();
			clone.fromSphere( new Vector3D( this._centerX, this._centerY, this._centerZ), this._radius );
			return clone;
		}
		
		override public function rayIntersection(position:Vector3D, direction:Vector3D, targetNormal:Vector3D):Number
		{
			if ( this.containsPoint(position) )
			{
				return 0;
			}
			
			var px:Number = position.x - this._centerX, py:Number = position.y - this._centerY, pz:Number = position.z - this._centerZ;
			var vx:Number = direction.x, vy:Number = direction.y, vz:Number = direction.z;
			var rayEntryDistance:Number;
			
			var a:Number = vx*vx + vy*vy + vz*vz;
			var b:Number = 2*( px*vx + py*vy + pz*vz );
			var c:Number = px*px + py*py + pz*pz - this._radius * this._radius;
			var det:Number = b*b - 4*a*c;
			
			if (det >= 0)
			{ // ray goes through sphere
				var sqrtDet:Number = Math.sqrt(det);
				rayEntryDistance = ( -b - sqrtDet )/( 2*a );
				if( rayEntryDistance >= 0 )
				{
					targetNormal.x = px + rayEntryDistance*vx;
					targetNormal.y = py + rayEntryDistance*vy;
					targetNormal.z = pz + rayEntryDistance*vz;
					targetNormal.normalize();
					
					return rayEntryDistance;
				}
			}
			// ray misses sphere
			return -1;
		}
		
		override public function containsPoint(position:Vector3D):Boolean
		{
			var px:Number = position.x - this._centerX;
			var py:Number = position.y - this._centerY;
			var pz:Number = position.z - this._centerZ;
			var distance:Number = Math.sqrt( px*px + py*py + pz*pz );
			return distance <= this._radius;
		}
		
		override public function pUpdateBoundingRenderable():void
		{
			var sc:Number = this._radius;
			if (sc == 0)
			{
				sc = 0.001;
			}
			this._pBoundingRenderable.scaleX = sc;
			this._pBoundingRenderable.scaleY = sc;
			this._pBoundingRenderable.scaleZ = sc;
			this._pBoundingRenderable.x = this._centerX;
			this._pBoundingRenderable.y = this._centerY;
			this._pBoundingRenderable.z = this._centerZ;
		}
		
		// TODO pCreateBoundingRenderable():WireframePrimitiveBase

		override public function pCreateBoundingRenderable():WireframePrimitiveBase
		{
			return new WireframeSphere(1, 16, 12, 0xffffff, 0.5);
		}

		
		//@override
		override public function classifyToPlane(plane:Plane3D):Number
		{
			var a:Number = plane.a;
			var b:Number = plane.b;
			var c:Number = plane.c;
			var dd:Number = a*this._centerX + b*this._centerY + c*this._centerZ - plane.d;
			if( a < 0 )
			{
				a = -a;
			}
			if( b < 0 )
			{
				b = -b;
			}
			if( c < 0 )
			{
				c = -c;
			}
			var rr:Number = (a + b + c)*this._radius;
			
			return dd > rr? PlaneClassification.FRONT :
				dd < -rr? PlaneClassification.BACK :
				PlaneClassification.INTERSECT;
		}
		
		override public function transformFrom(bounds:BoundingVolumeBase, matrix:Matrix3D):void
		{
			var sphere:BoundingSphere = (bounds as BoundingSphere);
			var cx:Number = sphere._centerX;
			var cy:Number = sphere._centerY;
			var cz:Number = sphere._centerZ;
			var raw:Vector.<Number> = new Vector.<Number>();
            matrix.copyRawDataTo( raw );
			var m11:Number = raw[0], m12:Number = raw[4], m13:Number = raw[8], m14:Number = raw[12];
			var m21:Number = raw[1], m22:Number = raw[5], m23:Number = raw[9], m24:Number = raw[13];
			var m31:Number = raw[2], m32:Number = raw[6], m33:Number = raw[10], m34:Number = raw[14];
			
			this._centerX = cx*m11 + cy*m12 + cz*m13 + m14;
			this._centerY = cx*m21 + cy*m22 + cz*m23 + m24;
			this._centerZ = cx*m31 + cy*m32 + cz*m33 + m34;
			
			if (m11 < 0)
				m11 = -m11;
			if (m12 < 0)
				m12 = -m12;
			if (m13 < 0)
				m13 = -m13;
			if (m21 < 0)
				m21 = -m21;
			if (m22 < 0)
				m22 = -m22;
			if (m23 < 0)
				m23 = -m23;
			if (m31 < 0)
				m31 = -m31;
			if (m32 < 0)
				m32 = -m32;
			if (m33 < 0)
				m33 = -m33;
			var r:Number = sphere._radius;
			var rx:Number = m11 + m12 + m13;
			var ry:Number = m21 + m22 + m23;
			var rz:Number = m31 + m32 + m33;
			this._radius = r*Math.sqrt(rx*rx + ry*ry + rz*rz);
			
			this._pMin.x = this._centerX - this._radius;
			this._pMin.y = this._centerY - this._radius;
			this._pMin.z = this._centerZ - this._radius;
			
			this._pMax.x = this._centerX + this._radius;
			this._pMax.y = this._centerY + this._radius;
			this._pMax.z = this._centerZ + this._radius;
		}
	}
}