/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../../_definitions.ts" />

package away.cameras.lenses
{
	import away.geom.Vector3D;
	public class PerspectiveLens extends LensBase
	{
		
		private var _fieldOfView:Number;
		private var _focalLength:Number;
		private var _focalLengthInv:Number;
		private var _yMax:Number;
		private var _xMax:Number;
		
		public function PerspectiveLens(fieldOfView:Number = 60):void
		{
			super();
			this.fieldOfView = fieldOfView;
		}
		
		public function get fieldOfView():Number
		{
			return this._fieldOfView;
		}
		
		public function set fieldOfView(value:Number):void
		{
			if ( value == this._fieldOfView )
			{
				return;
			}
			this._fieldOfView = value;
			
			this._focalLengthInv = Math.tan( this._fieldOfView * Math.PI/360 );
			this._focalLength = 1 / this._focalLengthInv;
			
			this.pInvalidateMatrix();
		}
		
		public function get focalLength():Number
		{
			return this._focalLength;
		}
		
		public function set focalLength(value:Number):void
		{
			if ( value == this._focalLength )
			{
				return;
			}
			this._focalLength = value;
			
			this._focalLengthInv = 1/this._focalLength;
			this._fieldOfView = Math.atan( this._focalLengthInv ) * 360/Math.PI;
			
			this.pInvalidateMatrix();
		}
		
		//@override
		override public function unproject(nX:Number, nY:Number, sZ:Number):Vector3D
		{
			var v:Vector3D = new Vector3D( nX, -nY, sZ, 1.0 );
			
			v.x *= sZ;
			v.y *= sZ;
			v.z = sZ;
			v = this.unprojectionMatrix.transformVector( v );
			
			return v;
		}
		
		//@override
		override public function clone():LensBase
		{
			var clone:PerspectiveLens = new PerspectiveLens( this._fieldOfView );
			clone._pNear = this._pNear;
			clone._pFar = this._pFar;
			clone._pAspectRatio = this._pAspectRatio;
			return clone;
		}
		
		//@override
		override public function pUpdateMatrix():void
		{
			var raw:Vector.<Number> = new Vector.<Number>();
			
			this._yMax = this._pNear * this._focalLengthInv;
			this._xMax = this._yMax * this._pAspectRatio;
			
			var left:Number, right:Number, top:Number, bottom:Number;
			
			if( this._pScissorRect.x == 0 && this._pScissorRect.y == 0 && this._pScissorRect.width == this._pViewPort.width && this._pScissorRect.height == this._pViewPort.height )
			{
				// assume unscissored frustum
				left = -this._xMax;
				right = this._xMax;
				top = -this._yMax;
				bottom = this._yMax;
				// assume unscissored frustum
				raw[0] = this._pNear/this._xMax;
                raw[5] = this._pNear/this._yMax;
				raw[10] = this._pFar/(this._pFar - this._pNear);
				raw[11] = 1;
				raw[1] = 0;
				raw[2] = 0;
				raw[3] = 0;
				raw[4] = 0;
				raw[6] = 0;
				raw[7] = 0;
				raw[8] = 0;
				raw[9] = 0;
				raw[12] = 0;
				raw[13] = 0;
				raw[15] = 0;

				raw[14] = -this._pNear*raw[10];
			} else {
				// assume scissored frustum
				var xWidth:Number = this._xMax*(this._pViewPort.width/this._pScissorRect.width);
				var yHgt:Number = this._yMax*(this._pViewPort.height/this._pScissorRect.height);
				var center:Number = this._xMax*(this._pScissorRect.x*2 - this._pViewPort.width)/this._pScissorRect.width + this._xMax;
				var middle:Number = -this._yMax*(this._pScissorRect.y*2 - this._pViewPort.height)/this._pScissorRect.height - this._yMax;
				
				left = center - xWidth;
				right = center + xWidth;
				top = middle - yHgt;
				bottom = middle + yHgt;
				
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
			}
			
			this._pMatrix.copyRawDataFrom( raw );
			
			var yMaxFar:Number = this._pFar * this._focalLengthInv;
			var xMaxFar:Number = yMaxFar * this._pAspectRatio;
			
			this._pFrustumCorners[0] = left;
			this._pFrustumCorners[9] = left;

			this._pFrustumCorners[3] = right;
			this._pFrustumCorners[6] = right;

			this._pFrustumCorners[1] = top;
			this._pFrustumCorners[4] = top;

			this._pFrustumCorners[7] = bottom;
			this._pFrustumCorners[10] = bottom;

			
			this._pFrustumCorners[12] = -xMaxFar;
			this._pFrustumCorners[21] = -xMaxFar;

			this._pFrustumCorners[15] = xMaxFar;
			this._pFrustumCorners[18] = xMaxFar;

			this._pFrustumCorners[13] = -yMaxFar;
			this._pFrustumCorners[16] = -yMaxFar;

			this._pFrustumCorners[19] = yMaxFar;
			this._pFrustumCorners[22] = yMaxFar;

			
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