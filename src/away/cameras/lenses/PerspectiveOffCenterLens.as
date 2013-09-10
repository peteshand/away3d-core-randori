/**
 * ...
 * @author Gary Paluk - http://www.plugin.io
 */
///<reference path="../../_definitions.ts" />

package away.cameras.lenses
{
	import away.geom.Vector3D;
	public class PerspectiveOffCenterLens extends LensBase
	{
		
		private var _minAngleX:Number;
		private var _minLengthX:Number;
		private var _tanMinX:Number;
		private var _maxAngleX:Number;
		private var _maxLengthX:Number;
		private var _tanMaxX:Number;
		private var _minAngleY:Number;
		private var _minLengthY:Number;
		private var _tanMinY:Number;
		private var _maxAngleY:Number;
		private var _maxLengthY:Number;
		private var _tanMaxY:Number;
		
		public function PerspectiveOffCenterLens(minAngleX:Number = -40, maxAngleX:Number = 40, minAngleY:Number = -40, maxAngleY:Number = 40):void
		{
			super();
			
			minAngleX = minAngleX;
			maxAngleX = maxAngleX;
			minAngleY = minAngleY;
			maxAngleY = maxAngleY;
		}
		
		public function get minAngleX():Number
		{
			return _minAngleX;
		}
		
		public function set minAngleX(value:Number):void
		{
			_minAngleX = value;
			_tanMinX = Math.tan( _minAngleX*Math.PI/180 );
			pInvalidateMatrix();
		}
		
		public function get maxAngleX():Number
		{
			return _maxAngleX;
		}
		
		public function set maxAngleX(value:Number):void
		{
			_maxAngleX = value;
			_tanMaxX = Math.tan(_maxAngleX*Math.PI/180);
			pInvalidateMatrix();
		}
		
		public function get minAngleY():Number
		{
			return _minAngleY;
		}
		
		public function set minAngleY(value:Number):void
		{
			_minAngleY = value;
			_tanMinY = Math.tan(_minAngleY*Math.PI/180);
			pInvalidateMatrix();
		}
		
		public function get maxAngleY():Number
		{
			return _maxAngleY;
		}
		
		public function set maxAngleY(value:Number):void
		{
			_maxAngleY = value;
			_tanMaxY = Math.tan(_maxAngleY*Math.PI/180);
			pInvalidateMatrix();
		}
		
		//@override
		override public function unproject(nX:Number, nY:Number, sZ:Number):Vector3D
		{
			var v:Vector3D = new Vector3D(nX, -nY, sZ, 1.0);
			
			v.x *= sZ;
			v.y *= sZ;
			v = unprojectionMatrix.transformVector(v);
			//z is unaffected by transform
			v.z = sZ;
			
			return v;
		}
		
		//@override
		override public function clone():LensBase
		{
			var clone:PerspectiveOffCenterLens = new PerspectiveOffCenterLens( _minAngleX, _maxAngleX, _minAngleY, _maxAngleY );
			clone._pNear = _pNear;
			clone._pFar = _pFar;
			clone._pAspectRatio = _pAspectRatio;
			return clone;
		}
		
		//@override
		override public function pUpdateMatrix():void
		{
			var raw:Vector.<Number> = new Vector.<Number>();
			
			_minLengthX = _pNear*_tanMinX;
			_maxLengthX = _pNear*_tanMaxX;
			_minLengthY = _pNear*_tanMinY;
			_maxLengthY = _pNear*_tanMaxY;
			
			var minLengthFracX:Number = -_minLengthX/(_maxLengthX - _minLengthX);
			var minLengthFracY:Number = -_minLengthY/(_maxLengthY - _minLengthY);
			
			var left:Number;
			var right:Number;
			var top:Number;
			var bottom:Number;
			
			// assume scissored frustum
			var center:Number = -_minLengthX*(_pScissorRect.x + _pScissorRect.width*minLengthFracX)/(_pScissorRect.width*minLengthFracX);
			var middle:Number = _minLengthY*(_pScissorRect.y + _pScissorRect.height*minLengthFracY)/(_pScissorRect.height*minLengthFracY);
			
			left = center - (_maxLengthX - _minLengthX)*(_pViewPort.width/_pScissorRect.width);
			right = center;
			top = middle;
			bottom = middle + (_maxLengthY - _minLengthY)*(_pViewPort.height/_pScissorRect.height);
			
			raw[0] = 2*_pNear/(right - left);
			raw[5] = 2*_pNear/(bottom - top);
			raw[8] = (right + left)/(right - left);
			raw[9] = (bottom + top)/(bottom - top);
			raw[10] = (_pFar + _pNear)/(_pFar - _pNear);
			raw[11] = 1;
			raw[1] = raw[2] = raw[3] = raw[4] =
				raw[6] = raw[7] = raw[12] = raw[13] = raw[15] = 0;
			raw[14] = -2*_pFar*_pNear/(_pFar - _pNear);
			
			_pMatrix.copyRawDataFrom(raw);

            //---------------------------------------------------------------------------------
            // HACK ! - Need to find real solution for flipping scene on Z axis
            _pMatrix.appendRotation( 180 , new Vector3D( 0 , 0 , 1 ));
            //---------------------------------------------------------------------------------

			_minLengthX = _pFar*_tanMinX;
			_maxLengthX = _pFar*_tanMaxX;
			_minLengthY = _pFar*_tanMinY;
			_maxLengthY = _pFar*_tanMaxY;
			
			_pFrustumCorners[0] = _pFrustumCorners[9] = left;
			_pFrustumCorners[3] = _pFrustumCorners[6] = right;
			_pFrustumCorners[1] = _pFrustumCorners[4] = top;
			_pFrustumCorners[7] = _pFrustumCorners[10] = bottom;
			
			_pFrustumCorners[12] = _pFrustumCorners[21] = _minLengthX;
			_pFrustumCorners[15] = _pFrustumCorners[18] = _maxLengthX;
			_pFrustumCorners[13] = _pFrustumCorners[16] = _minLengthY;
			_pFrustumCorners[19] = _pFrustumCorners[22] = _maxLengthY;
			
			_pFrustumCorners[2] = _pFrustumCorners[5] = _pFrustumCorners[8] = _pFrustumCorners[11] = _pNear;
			_pFrustumCorners[14] = _pFrustumCorners[17] = _pFrustumCorners[20] = _pFrustumCorners[23] = _pFar;
			
			_pMatrixInvalid = false;
		}
		
	}
}