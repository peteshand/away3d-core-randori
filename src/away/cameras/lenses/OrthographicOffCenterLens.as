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
			_minX = minX;
			_maxX = maxX;
			_minY = minY;
			_maxY = maxY;
		}
		
		public function get minX():Number
		{
			return _minX;
		}
		
		public function set minX(value:Number):void
		{
			_minX = value;
			pInvalidateMatrix();
		}
		
		public function get maxX():Number
		{
			return _maxX;
		}
		
		public function set maxX(value:Number):void
		{
			_maxX = value;
			pInvalidateMatrix();
		}
		
		public function get minY():Number
		{
			return _minY;
		}
		
		public function set minY(value:Number):void
		{
			_minY = value;
			pInvalidateMatrix();
		}
		
		public function get maxY():Number
		{
			return _maxY;
		}
		
		public function set maxY(value:Number):void
		{
			_maxY = value;
			pInvalidateMatrix();
		}
		
		//@override
		override public function unproject(nX:Number, nY:Number, sZ:Number):Vector3D
		{
			var v:Vector3D = new Vector3D(nX, -nY, sZ, 1.0);
			v = unprojectionMatrix.transformVector(v);
			//z is unaffected by transform
			v.z = sZ;
			
			return v;
		}
		
		//@override
		override public function clone():LensBase
		{
			var clone:OrthographicOffCenterLens = new OrthographicOffCenterLens(_minX, _maxX, _minY, _maxY);
			clone._pNear = _pNear;
			clone._pFar = _pFar;
			clone._pAspectRatio = _pAspectRatio;
			return clone;
		}
		
		//@override
		override public function pUpdateMatrix():void
		{
			var raw:Vector.<Number> = new Vector.<Number>();
			var w:Number = 1/(_maxX - _minX);
			var h:Number = 1/(_maxY - _minY);
			var d:Number = 1/(_pFar - _pNear);
			
			raw[0] = 2*w;
			raw[5] = 2*h;
			raw[10] = d;
			raw[12] = -(_maxX + _minX)*w;
			raw[13] = -(_maxY + _minY)*h;
			raw[14] = -_pNear*d;
			raw[15] = 1;
			raw[1] = raw[2] = raw[3] = raw[4] =
				raw[6] = raw[7] = raw[8] = raw[9] = raw[11] = 0;
			_pMatrix.copyRawDataFrom(raw);
			
			_pFrustumCorners[0] = _pFrustumCorners[9] = _pFrustumCorners[12] = _pFrustumCorners[21] = _minX;
			_pFrustumCorners[3] = _pFrustumCorners[6] = _pFrustumCorners[15] = _pFrustumCorners[18] = _maxX;
			_pFrustumCorners[1] = _pFrustumCorners[4] = _pFrustumCorners[13] = _pFrustumCorners[16] = _minY;
			_pFrustumCorners[7] = _pFrustumCorners[10] = _pFrustumCorners[19] = _pFrustumCorners[22] = _maxY;
			_pFrustumCorners[2] = _pFrustumCorners[5] = _pFrustumCorners[8] = _pFrustumCorners[11] = _pNear;
			_pFrustumCorners[14] = _pFrustumCorners[17] = _pFrustumCorners[20] = _pFrustumCorners[23] = _pFar;
			
			_pMatrixInvalid = false;
		}
	}
}