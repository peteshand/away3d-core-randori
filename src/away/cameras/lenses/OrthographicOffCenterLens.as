/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../../_definitions.ts" />

package away.cameras.lenses
{
	import away.geom.Vector3D;
	public class OrthographicOffCenterLens extends LensBase
	{
		
		private var _minX:Number;
		private var _maxX:Number;
		private var _minY:Number;
		private var _maxY:Number;
		
		public function OrthographicOffCenterLens(minX:Number, maxX:Number, minY:Number, maxY:Number):void
		{
			super();
			this._minX = minX;
			this._maxX = maxX;
			this._minY = minY;
			this._maxY = maxY;
		}
		
		public function get minX():Number
		{
			return this._minX;
		}
		
		public function set minX(value:Number):void
		{
			this._minX = value;
			this.pInvalidateMatrix();
		}
		
		public function get maxX():Number
		{
			return this._maxX;
		}
		
		public function set maxX(value:Number):void
		{
			this._maxX = value;
			this.pInvalidateMatrix();
		}
		
		public function get minY():Number
		{
			return this._minY;
		}
		
		public function set minY(value:Number):void
		{
			this._minY = value;
			this.pInvalidateMatrix();
		}
		
		public function get maxY():Number
		{
			return this._maxY;
		}
		
		public function set maxY(value:Number):void
		{
			this._maxY = value;
			this.pInvalidateMatrix();
		}
		
		//@override
		override public function unproject(nX:Number, nY:Number, sZ:Number):Vector3D
		{
			var v:Vector3D = new Vector3D(nX, -nY, sZ, 1.0);
			v = this.unprojectionMatrix.transformVector(v);
			//z is unaffected by transform
			v.z = sZ;
			
			return v;
		}
		
		//@override
		override public function clone():LensBase
		{
			var clone:OrthographicOffCenterLens = new OrthographicOffCenterLens(this._minX, this._maxX, this._minY, this._maxY);
			clone._pNear = this._pNear;
			clone._pFar = this._pFar;
			clone._pAspectRatio = this._pAspectRatio;
			return clone;
		}
		
		//@override
		override public function pUpdateMatrix():void
		{
			var raw:Vector.<Number> = new Vector.<Number>();
			var w:Number = 1/(this._maxX - this._minX);
			var h:Number = 1/(this._maxY - this._minY);
			var d:Number = 1/(this._pFar - this._pNear);
			
			raw[0] = 2*w;
			raw[5] = 2*h;
			raw[10] = d;
			raw[12] = -(this._maxX + this._minX)*w;
			raw[13] = -(this._maxY + this._minY)*h;
			raw[14] = -this._pNear*d;
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

			this._pMatrix.copyRawDataFrom(raw);
			
			this._pFrustumCorners[0] = this._minX;
			this._pFrustumCorners[9] = this._minX;
			this._pFrustumCorners[12] = this._minX;
			this._pFrustumCorners[21] = this._minX;

			this._pFrustumCorners[3] = this._maxX;
			this._pFrustumCorners[6] = this._maxX;
			this._pFrustumCorners[15] = this._maxX;
			this._pFrustumCorners[18] = this._maxX;

			this._pFrustumCorners[1] = this._minY;
			this._pFrustumCorners[4] = this._minY;
			this._pFrustumCorners[13] = this._minY;
			this._pFrustumCorners[16] = this._minY;

			this._pFrustumCorners[7] = this._maxY;
			this._pFrustumCorners[10] = this._maxY;
			this._pFrustumCorners[19] = this._maxY;
			this._pFrustumCorners[22] = this._maxY;

			this._pFrustumCorners[2] = this._pNear;
			this._pFrustumCorners[5] = this._pNear;
			this._pFrustumCorners[8] = this._pNear;
			this._pFrustumCorners[11] = this._pNear;

			this._pFrustumCorners[14] = this._pFar;
			this._pFrustumCorners[17] = this._pFar;
			this._pFrustumCorners[20] = this._pFar;
			this._pFrustumCorners[23] = this._pFar;

			
			this._pMatrixInvalid = false;
		}
	}
}