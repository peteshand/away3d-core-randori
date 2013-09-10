/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../../_definitions.ts" />

package away.cameras.lenses
{
	import away.geom.Vector3D;
	public class OrthographicLens extends LensBase
	{
		
		private var _projectionHeight:Number;
		private var _xMax:Number;
		private var _yMax:Number;

		public function OrthographicLens(projectionHeight:Number = 500):void
		{
			super();
			_projectionHeight = projectionHeight;
		}
		
		public function get projectionHeight():Number
		{
			return _projectionHeight;
		}
		
		public function set projectionHeight(value:Number):void
		{
			if( value == _projectionHeight )
			{
				return;
			}
			_projectionHeight = value;
			pInvalidateMatrix();
		}
		
		//@override
		override public function unproject(nX:Number, nY:Number, sZ:Number):Vector3D
		{
			var v:Vector3D = new Vector3D( nX + matrix.rawData[12], -nY + matrix.rawData[13], sZ, 1.0);
			v = unprojectionMatrix.transformVector(v);
			
			//z is unaffected by transform
			v.z = sZ;
			
			return v;
		}
		
		//@override
		override public function clone():LensBase
		{
			var clone:OrthographicLens = new OrthographicLens();
			clone._pNear = _pNear;
			clone._pFar = _pFar;
			clone._pAspectRatio = _pAspectRatio;
			clone.projectionHeight = _projectionHeight;
			return clone;
		}
		
		//@override
		override public function pUpdateMatrix():void
		{
			var raw:Vector.<Number> = new Vector.<Number>();
			_yMax = _projectionHeight*.5;
			_xMax = _yMax*_pAspectRatio;
			
			var left:Number;
			var right:Number;
			var top:Number;
			var bottom:Number;
			
			if( _pScissorRect.x == 0 && _pScissorRect.y == 0 && _pScissorRect.width == _pViewPort.width && _pScissorRect.height == _pViewPort.height) {
				// assume symmetric frustum
				
				left = -_xMax;
				right = _xMax;
				top = -_yMax;
				bottom = _yMax;
				
				raw[0] = 2/(_projectionHeight*_pAspectRatio);
				raw[5] = 2/_projectionHeight;
				raw[10] = 1/(_pFar - _pNear);
				raw[14] = _pNear/(_pNear - _pFar);
				raw[1] = raw[2] = raw[3] = raw[4] =
				raw[6] = raw[7] = raw[8] = raw[9] =
				raw[11] = raw[12] = raw[13] = 0;
				raw[15] = 1;
				
			} else {
				
				var xWidth:Number = _xMax*(_pViewPort.width/_pScissorRect.width);
				var yHgt:Number = _yMax*(_pViewPort.height/_pScissorRect.height);
				var center:Number = _xMax*(_pScissorRect.x*2 - _pViewPort.width)/_pScissorRect.width + _xMax;
				var middle:Number = -_yMax*(_pScissorRect.y*2 - _pViewPort.height)/_pScissorRect.height - _yMax;
				
				left = center - xWidth;
				right = center + xWidth;
				top = middle - yHgt;
				bottom = middle + yHgt;
				
				raw[0] = 2*1/(right - left);
				raw[5] = -2*1/(top - bottom);
				raw[10] = 1/(_pFar - _pNear);
				
				raw[12] = (right + left)/(right - left);
				raw[13] = (bottom + top)/(bottom - top);
				raw[14] = _pNear/(near - far);
				
				raw[1] = raw[2] = raw[3] = raw[4] =
				raw[6] = raw[7] = raw[8] = raw[9] = raw[11] = 0;
				raw[15] = 1;
			}



			_pFrustumCorners[0] = _pFrustumCorners[9] = _pFrustumCorners[12] = _pFrustumCorners[21] = left;
			_pFrustumCorners[3] = _pFrustumCorners[6] = _pFrustumCorners[15] = _pFrustumCorners[18] = right;
			_pFrustumCorners[1] = _pFrustumCorners[4] = _pFrustumCorners[13] = _pFrustumCorners[16] = top;
			_pFrustumCorners[7] = _pFrustumCorners[10] = _pFrustumCorners[19] = _pFrustumCorners[22] = bottom;
			_pFrustumCorners[2] = _pFrustumCorners[5] = _pFrustumCorners[8] = _pFrustumCorners[11] = _pNear;
			_pFrustumCorners[14] = _pFrustumCorners[17] = _pFrustumCorners[20] = _pFrustumCorners[23] = _pFar;
			
			_pMatrix.copyRawDataFrom(raw);

            //---------------------------------------------------------------------------------
            // HACK ! - Need to find real solution for flipping scene on Z axis
            _pMatrix.appendRotation( 180 , new Vector3D( 0 , 0 , 1 ));
            //---------------------------------------------------------------------------------

			_pMatrixInvalid = false;
		}
	}
}