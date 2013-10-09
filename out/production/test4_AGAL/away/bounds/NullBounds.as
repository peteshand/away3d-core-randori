/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.bounds
{
	import away.primitives.WireframePrimitiveBase;
	import away.core.math.Plane3D;
	import away.core.base.Geometry;
	import away.core.geom.Vector3D;
	import away.core.math.PlaneClassification;
	import away.core.geom.Matrix3D;
	public class NullBounds extends BoundingVolumeBase
	{
		
		private var _alwaysIn:Boolean = false;
		private var _renderable:WireframePrimitiveBase;
		
		public function NullBounds(alwaysIn:Boolean = true, renderable:WireframePrimitiveBase = null):void
		{
			alwaysIn = alwaysIn || true;
			renderable = renderable || null;

			super();
			this._alwaysIn = alwaysIn;
			this._renderable = renderable;
			this._pMax.x = Number.POSITIVE_INFINITY;
			this._pMax.y = Number.POSITIVE_INFINITY;
			this._pMax.z = Number.POSITIVE_INFINITY;

			this._pMin.x = this._alwaysIn ? Number.NEGATIVE_INFINITY : Number.POSITIVE_INFINITY;
			this._pMin.y = this._alwaysIn ? Number.NEGATIVE_INFINITY : Number.POSITIVE_INFINITY;
			this._pMin.z = this._alwaysIn ? Number.NEGATIVE_INFINITY : Number.POSITIVE_INFINITY;

		}
		
		//@override
		override public function clone():BoundingVolumeBase
		{
			return new NullBounds( this._alwaysIn );
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
			return this._alwaysIn;
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
			var nullBounds:NullBounds = (bounds as NullBounds);
			this._alwaysIn = nullBounds._alwaysIn;
		}
	}
}