/**
 * ...
 * @author Gary Paluk - http://www.plugin.io
 */
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
			fieldOfView = fieldOfView;
		}
		
		public function get fieldOfView():Number
		{
			return _fieldOfView;
		}
		
		public function set fieldOfView(value:Number):void
		{
			if ( value == _fieldOfView )
			{
				return;
			}
			_fieldOfView = value;
			
			_focalLengthInv = Math.tan( _fieldOfView * Math.PI/360 );
			_focalLength = 1 / _focalLengthInv;
			
			pInvalidateMatrix();
		}
		
		public function get focalLength():Number
		{
			return _focalLength;
		}
		
		public function set focalLength(value:Number):void
		{
			if ( value == _focalLength )
			{
				return;
			}
			_focalLength = value;
			
			_focalLengthInv = 1/_focalLength;
			_fieldOfView = Math.atan( _focalLengthInv ) * 360/Math.PI;
			
			pInvalidateMatrix();
		}
		
		//@override
		override public function unproject(nX:Number, nY:Number, sZ:Number):Vector3D
		{
			var v:Vector3D = new Vector3D( nX, -nY, sZ, 1.0 );
			
			v.x *= sZ;
			v.y *= sZ;
			v.z = sZ;
			v = unprojectionMatrix.transformVector( v );
			
			return v;
		}
		
		//@override
		override public function clone():LensBase
		{
			var clone:PerspectiveLens = new PerspectiveLens( _fieldOfView );
			clone._pNear = _pNear;
			clone._pFar = _pFar;
			clone._pAspectRatio = _pAspectRatio;
			return clone;
		}
		
		//@override
		override public function pUpdateMatrix():void
		{
			var raw:Vector.<Number> = new Vector.<Number>();
			
			_yMax = _pNear * _focalLengthInv;
			_xMax = _yMax * _pAspectRatio;
			
			var left:Number, right:Number, top:Number, bottom:Number;
			
			if( _pScissorRect.x == 0 && _pScissorRect.y == 0 && _pScissorRect.width == _pViewPort.width && _pScissorRect.height == _pViewPort.height )
			{
				// assume unscissored frustum
				left = -_xMax;
				right = _xMax;
				top = -_yMax;
				bottom = _yMax;
				// assume unscissored frustum
				raw[0] = _pNear/_xMax;
                raw[5] = _pNear/_yMax;
				raw[10] = _pFar/(_pFar - _pNear);
				raw[11] = 1;
				raw[1] = raw[2] = raw[3] = raw[4] =
					raw[6] = raw[7] = raw[8] = raw[9] =
					raw[12] = raw[13] = raw[15] = 0;
				raw[14] = -_pNear*raw[10];
			} else {
				// assume scissored frustum
				var xWidth:Number = _xMax*(_pViewPort.width/_pScissorRect.width);
				var yHgt:Number = _yMax*(_pViewPort.height/_pScissorRect.height);
				var center:Number = _xMax*(_pScissorRect.x*2 - _pViewPort.width)/_pScissorRect.width + _xMax;
				var middle:Number = -_yMax*(_pScissorRect.y*2 - _pViewPort.height)/_pScissorRect.height - _yMax;
				
				left = center - xWidth;
				right = center + xWidth;
				top = middle - yHgt;
				bottom = middle + yHgt;
				
				raw[0] = 2*_pNear/(right - left);
				raw[5] = 2*_pNear/(bottom - top);
				raw[8] = (right + left)/(right - left);
				raw[9] = (bottom + top)/(bottom - top);
				raw[10] = (_pFar + _pNear)/(_pFar - _pNear);
				raw[11] = 1;
				raw[1] = raw[2] = raw[3] = raw[4] =
					raw[6] = raw[7] = raw[12] = raw[13] = raw[15] = 0;
				raw[14] = -2*_pFar*_pNear/(_pFar - _pNear);
			}


			_pMatrix.copyRawDataFrom( raw );

            //---------------------------------------------------------------------------------
            // HACK ! - Need to find real solution for flipping scene on Z axis
            _pMatrix.appendRotation( 180 , new Vector3D( 0 , 0 , 1 ));
            //---------------------------------------------------------------------------------

			var yMaxFar:Number = _pFar * _focalLengthInv;
			var xMaxFar:Number = yMaxFar * _pAspectRatio;
			
			_pFrustumCorners[0] = _pFrustumCorners[9] = left;
			_pFrustumCorners[3] = _pFrustumCorners[6] = right;
			_pFrustumCorners[1] = _pFrustumCorners[4] = top;
			_pFrustumCorners[7] = _pFrustumCorners[10] = bottom;
			
			_pFrustumCorners[12] = _pFrustumCorners[21] = -xMaxFar;
			_pFrustumCorners[15] = _pFrustumCorners[18] = xMaxFar;
			_pFrustumCorners[13] = _pFrustumCorners[16] = -yMaxFar;
			_pFrustumCorners[19] = _pFrustumCorners[22] = yMaxFar;
			
			_pFrustumCorners[2] = _pFrustumCorners[5] = _pFrustumCorners[8] = _pFrustumCorners[11] = _pNear;
			_pFrustumCorners[14] = _pFrustumCorners[17] = _pFrustumCorners[20] = _pFrustumCorners[23] = _pFar;
			
			_pMatrixInvalid = false;


		}
	}
}