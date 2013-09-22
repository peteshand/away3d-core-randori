/** * ... * @author Gary Paluk - http://www.plugin.io */

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
			this.baseLens = baseLens;
			this.plane = plane;
		}
		
		//@override
		override public function get frustumCorners():Vector.<Number>
		{
			return this._baseLens.frustumCorners;
		}
		
		//@override
		override public function get near():Number
		{
			return this._baseLens.near;
		}
		
		//@override
		override public function set near(value:Number):void
		{
			this._baseLens.near = value;
		}
		
		//@override
		override public function get far():Number
		{
			return this._baseLens.far;
		}
		
		//@override
		override public function set far(value:Number):void
		{
			this._baseLens.far = value;
		}
		
		//@override
		override public function get iAspectRatio():Number
		{
			return this._baseLens.iAspectRatio;
		}
		
		//@override
		override public function set iAspectRatio(value:Number):void
		{
			this._baseLens.iAspectRatio = value;
		}
		
		public function get plane():Plane3D
		{
			return this._plane;
		}
		
		public function set plane(value:Plane3D):void
		{
			this._plane = value;
			this.pInvalidateMatrix();
		}
		
		public function set baseLens(value:LensBase):void
		{
			if (this._baseLens)
			{
				this._baseLens.removeEventListener( LensEvent.MATRIX_CHANGED, onLensMatrixChanged, this );
			}
			this._baseLens = value;
			
			if (this._baseLens)
			{
				this._baseLens.addEventListener( LensEvent.MATRIX_CHANGED, onLensMatrixChanged, this );
			}
			this.pInvalidateMatrix();
		}
		
		private function onLensMatrixChanged(event:LensEvent):void
		{
			this.pInvalidateMatrix();
		}
		
		//@override
		override public function pUpdateMatrix():void
		{
			this._pMatrix.copyFrom(this._baseLens.matrix);
			
			var cx:Number = this._plane.a;
			var cy:Number = this._plane.b;
			var cz:Number = this._plane.c;
			var cw:Number = -this._plane.d + .05;
			var signX:Number = cx >= 0? 1 : -1;
			var signY:Number = cy >= 0? 1 : -1;
			var p:Vector3D = new Vector3D(signX, signY, 1, 1);
			var inverse:Matrix3D = this._pMatrix.clone();
			inverse.invert();
			var q:Vector3D = inverse.transformVector(p);
			this._pMatrix.copyRowTo(3, p);
			var a:Number = (q.x*p.x + q.y*p.y + q.z*p.z + q.w*p.w)/(cx*q.x + cy*q.y + cz*q.z + cw*q.w);
			this._pMatrix.copyRowFrom(2, new Vector3D(cx*a, cy*a, cz*a, cw*a));
		}
	}
}