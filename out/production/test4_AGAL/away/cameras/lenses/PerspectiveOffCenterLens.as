/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.cameras.lenses
{
	import away.core.geom.Vector3D;
	public class PerspectiveOffCenterLens extends LensBase
	{
		
		private var _minAngleX:Number = 0;
		private var _minLengthX:Number = 0;
		private var _tanMinX:Number = 0;
		private var _maxAngleX:Number = 0;
		private var _maxLengthX:Number = 0;
		private var _tanMaxX:Number = 0;
		private var _minAngleY:Number = 0;
		private var _minLengthY:Number = 0;
		private var _tanMinY:Number = 0;
		private var _maxAngleY:Number = 0;
		private var _maxLengthY:Number = 0;
		private var _tanMaxY:Number = 0;
		
		public function PerspectiveOffCenterLens(minAngleX:Number = -40, maxAngleX:Number = 40, minAngleY:Number = -40, maxAngleY:Number = 40):void
		{
			minAngleX = minAngleX || -40;
			maxAngleX = maxAngleX || 40;
			minAngleY = minAngleY || -40;
			maxAngleY = maxAngleY || 40;

			super();
			
			this.minAngleX = minAngleX;
			this.maxAngleX = maxAngleX;
			this.minAngleY = minAngleY;
			this.maxAngleY = maxAngleY;
		}
		
		public function get minAngleX():Number
		{
			return this._minAngleX;
		}
		
		public function set minAngleX(value:Number):void
		{
			this._minAngleX = value;
			this._tanMinX = Math.tan( this._minAngleX*Math.PI/180 );
			this.pInvalidateMatrix();
		}
		
		public function get maxAngleX():Number
		{
			return this._maxAngleX;
		}
		
		public function set maxAngleX(value:Number):void
		{
			this._maxAngleX = value;
			this._tanMaxX = Math.tan(this._maxAngleX*Math.PI/180);
			this.pInvalidateMatrix();
		}
		
		public function get minAngleY():Number
		{
			return this._minAngleY;
		}
		
		public function set minAngleY(value:Number):void
		{
			this._minAngleY = value;
			this._tanMinY = Math.tan(this._minAngleY*Math.PI/180);
			this.pInvalidateMatrix();
		}
		
		public function get maxAngleY():Number
		{
			return this._maxAngleY;
		}
		
		public function set maxAngleY(value:Number):void
		{
			this._maxAngleY = value;
			this._tanMaxY = Math.tan(this._maxAngleY*Math.PI/180);
			this.pInvalidateMatrix();
		}
		
		//@override
		override public function unproject(nX:Number, nY:Number, sZ:Number):Vector3D
		{
			var v:Vector3D = new Vector3D(nX, -nY, sZ, 1.0);
			
			v.x *= sZ;
			v.y *= sZ;
			v = this.unprojectionMatrix.transformVector(v);
			//z is unaffected by transform
			v.z = sZ;
			
			return v;
		}
		
		//@override
		override public function clone():LensBase
		{
			var clone:PerspectiveOffCenterLens = new PerspectiveOffCenterLens( this._minAngleX, this._maxAngleX, this._minAngleY, this._maxAngleY );
			clone._pNear = this._pNear;
			clone._pFar = this._pFar;
			clone._pAspectRatio = this._pAspectRatio;
			return clone;
		}
		
		//@override
		override public function pUpdateMatrix():void
		{
			var raw:Vector.<Number> = new Vector.<Number>();
			
			this._minLengthX = this._pNear*this._tanMinX;
			this._maxLengthX = this._pNear*this._tanMaxX;
			this._minLengthY = this._pNear*this._tanMinY;
			this._maxLengthY = this._pNear*this._tanMaxY;
			
			var minLengthFracX:Number = -this._minLengthX/(this._maxLengthX - this._minLengthX);
			var minLengthFracY:Number = -this._minLengthY/(this._maxLengthY - this._minLengthY);
			
			var left:Number;
			var right:Number;
			var top:Number;
			var bottom:Number;
			
			// assume scissored frustum
			var center:Number = -this._minLengthX*(this._pScissorRect.x + this._pScissorRect.width*minLengthFracX)/(this._pScissorRect.width*minLengthFracX);
			var middle:Number = this._minLengthY*(this._pScissorRect.y + this._pScissorRect.height*minLengthFracY)/(this._pScissorRect.height*minLengthFracY);
			
			left = center - (this._maxLengthX - this._minLengthX)*(this._pViewPort.width/this._pScissorRect.width);
			right = center;
			top = middle;
			bottom = middle + (this._maxLengthY - this._minLengthY)*(this._pViewPort.height/this._pScissorRect.height);
			
			raw[0] = 2*this._pNear/(right - left);
			raw[5] = 2*this._pNear/(bottom - top);
			raw[8] = (right + left)/(right - left);
			raw[9] = (bottom + top)/(bottom - top);
			raw[10] = (this._pFar + this._pNear)/(this._pFar - this._pNear);
			raw[11] = 1;
			raw[1] = 0;
			raw[2] = 0;
			raw[3] = 0;
			raw[4] = 0;
			raw[6] = 0;
			raw[7] = 0;
			raw[12] = 0;
			raw[13] = 0;
			raw[15] = 0;

			raw[14] = -2*this._pFar*this._pNear/(this._pFar - this._pNear);
			
			this._pMatrix.copyRawDataFrom(raw);

			this._minLengthX = this._pFar*this._tanMinX;
			this._maxLengthX = this._pFar*this._tanMaxX;
			this._minLengthY = this._pFar*this._tanMinY;
			this._maxLengthY = this._pFar*this._tanMaxY;
			
			this._pFrustumCorners[0] = left;
			this._pFrustumCorners[9] = left;

			this._pFrustumCorners[3] = right;
			this._pFrustumCorners[6] = right;

			this._pFrustumCorners[1] = top;
			this._pFrustumCorners[4] = top;

			this._pFrustumCorners[7] = bottom;
			this._pFrustumCorners[10] = bottom;

			
			this._pFrustumCorners[12] = this._minLengthX;
			this._pFrustumCorners[21] = this._minLengthX;

			this._pFrustumCorners[15] = this._maxLengthX;
			this._pFrustumCorners[18] = this._maxLengthX;

			this._pFrustumCorners[13] = this._minLengthY;
			this._pFrustumCorners[16] = this._minLengthY;

			this._pFrustumCorners[19] = this._maxLengthY;
			this._pFrustumCorners[22] = this._maxLengthY;

			
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