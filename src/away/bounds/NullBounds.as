/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts" />

package away.bounds
{
	import away.primitives.WireframePrimitiveBase;
	import away.math.Plane3D;
	import away.base.Geometry;
	import away.geom.Vector3D;
	import away.math.PlaneClassification;
	import away.geom.Matrix3D;
	public class NullBounds extends BoundingVolumeBase
	{
		
		private var _alwaysIn:Boolean;
		private var _renderable:WireframePrimitiveBase;
		
		public function NullBounds(alwaysIn:Boolean = true, renderable:WireframePrimitiveBase = null):void
		{
			super();
			this._alwaysIn = alwaysIn;
			this._renderable = renderable;
			this._pMax.x = this._pMax.y = this._pMax.z = Number.POSITIVE_INFINITY;
			this._pMin.x = this._pMin.y = this._pMin.z = this._alwaysIn ? Number.NEGATIVE_INFINITY : Number.POSITIVE_INFINITY;
		}
		
		//@override
		override public function clone():BoundingVolumeBase
		{
			return new NullBounds( _alwaysIn );
		}
		
		//@override
		override public function pCreateBoundingRenderable():WireframePrimitiveBase
		{
			//return this._renderable || new away.primitives.WireframeSphere( 100, 16, 12, 0xffffff, 0.5 );
			return null;
		}
		
		//@override
		override public function isInFrustum(planes:Vector.<Plane3D>, numPlanes:Number):Boolean
		{
			planes = planes;
			numPlanes = numPlanes;
			return _alwaysIn;
		}
		
		//@override
		override public function fromGeometry(geometry:Geometry):void
		{
		}

		//@override
		override public function fromSphere(center:Vector3D, radius:Number):void
		{
		}
		
		//@override
		override public function fromExtremes(minX:Number, minY:Number, minZ:Number, maxX:Number, maxY:Number, maxZ:Number):void
		{
		}
		
		override public function classifyToPlane(plane:Plane3D):Number
		{
			plane = plane;
			return PlaneClassification.INTERSECT;
		}
		
		//@override
		override public function transformFrom(bounds:BoundingVolumeBase, matrix:Matrix3D):void
		{
			matrix = matrix;
			var nullBounds:NullBounds = NullBounds(bounds);
			_alwaysIn = nullBounds._alwaysIn;
		}
	}
}