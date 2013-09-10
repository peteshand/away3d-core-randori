/**
 * ...
 * @author Gary Paluk - http://www.plugin.io
 */
///<reference path="../../_definitions.ts" />

package away.cameras.lenses
{
	import away.math.Plane3D;
	import away.events.LensEvent;
	import away.geom.Vector3D;
	import away.geom.Matrix3D;
	public class ObliqueNearPlaneLens extends LensBase
	{
		
		private var _baseLens:LensBase;
		private var _plane:Plane3D;
		
		public function ObliqueNearPlaneLens(baseLens:LensBase, plane:Plane3D):void
		{
			super();
			baseLens = baseLens;
			plane = plane;
		}
		
		//@override
		override public function get frustumCorners():Vector.<Number>
		{
			return _baseLens.frustumCorners;
		}
		
		//@override
		override public function get near():Number
		{
			return _baseLens.near;
		}
		
		//@override
		override public function set near(value:Number):void
		{
			_baseLens.near = value;
		}
		
		//@override
		override public function get far():Number
		{
			return _baseLens.far;
		}
		
		//@override
		override public function set far(value:Number):void
		{
			_baseLens.far = value;
		}
		
		//@override
		override public function get iAspectRatio():Number
		{
			return _baseLens.iAspectRatio;
		}
		
		//@override
		override public function set iAspectRatio(value:Number):void
		{
			_baseLens.iAspectRatio = value;
		}
		
		public function get plane():Plane3D
		{
			return _plane;
		}
		
		public function set plane(value:Plane3D):void
		{
			_plane = value;
			pInvalidateMatrix();
		}
		
		public function set baseLens(value:LensBase):void
		{
			if (_baseLens)
			{
				_baseLens.removeEventListener( LensEvent.MATRIX_CHANGED, onLensMatrixChanged, this );
			}
			_baseLens = value;
			
			if (_baseLens)
			{
				_baseLens.addEventListener( LensEvent.MATRIX_CHANGED, onLensMatrixChanged, this );
			}
			pInvalidateMatrix();
		}
		
		private function onLensMatrixChanged(event:LensEvent):void
		{
			pInvalidateMatrix();
		}
		
		//@override
		override public function pUpdateMatrix():void
		{
			_pMatrix.copyFrom(_baseLens.matrix);
			
			var cx:Number = _plane.a;
			var cy:Number = _plane.b;
			var cz:Number = _plane.c;
			var cw:Number = -_plane.d + .05;
			var signX:Number = cx >= 0? 1 : -1;
			var signY:Number = cy >= 0? 1 : -1;
			var p:Vector3D = new Vector3D(signX, signY, 1, 1);
			var inverse:Matrix3D = _pMatrix.clone();
			inverse.invert();
			var q:Vector3D = inverse.transformVector(p);
			_pMatrix.copyRowTo(3, p);
			var a:Number = (q.x*p.x + q.y*p.y + q.z*p.z + q.w*p.w)/(cx*q.x + cy*q.y + cz*q.z + cw*q.w);
			_pMatrix.copyRowFrom(2, new Vector3D(cx*a, cy*a, cz*a, cw*a));
		}
	}
}