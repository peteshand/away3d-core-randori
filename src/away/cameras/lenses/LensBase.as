/**
 * ...
 * @author Gary Paluk - http://www.plugin.io
 */
///<reference path="../../_definitions.ts" />

package away.cameras.lenses
{
	import away.events.EventDispatcher;
	import away.geom.Matrix3D;
	import away.geom.Rectangle;
	import away.geom.Vector3D;
	import away.errors.AbstractMethodError;
	import away.events.LensEvent;
	public class LensBase extends EventDispatcher
	{
		
		public var _pMatrix:Matrix3D;
		public var _pScissorRect:Rectangle = new Rectangle();
		public var _pViewPort:Rectangle = new Rectangle();
		public var _pNear:Number = 20;
		public var _pFar:Number = 3000;
		public var _pAspectRatio:Number = 1;
		
		public var _pMatrixInvalid:Boolean = true;
		public var _pFrustumCorners:Vector.<Number> = new Vector.<Number>();
		
		private var _unprojection:Matrix3D;
		private var _unprojectionInvalid:Boolean = true;
		
		public function LensBase():void
		{
			super();
			_pMatrix = new Matrix3D();
		}
		
		public function get frustumCorners():Vector.<Number>
		{
			return _pFrustumCorners;
		}
		
		public function set frustumCorners(frustumCorners:Vector.<Number>):void
		{
			_pFrustumCorners = frustumCorners;
		}
		
		public function get matrix():Matrix3D
		{
			if( _pMatrixInvalid )
			{
				pUpdateMatrix();
				_pMatrixInvalid = false;
			}
			return _pMatrix;
		}
		
		public function set matrix(value:Matrix3D):void
		{
			_pMatrix = value;
			pInvalidateMatrix();
		}
		
		public function get near():Number
		{
			return _pNear;
		}
		
		public function set near(value:Number):void
		{
			if( value == _pNear )
			{
				return;
			}
			_pNear = value;
			pInvalidateMatrix();
		}
		
		public function get far():Number
		{
			return _pFar;
		}
		
		public function set far(value:Number):void
		{
			if( value == _pFar)
			{
				return;
			}
			_pFar = value;
			pInvalidateMatrix();
		}
		
		public function project(point3d:Vector3D):Vector3D
		{
			var v:Vector3D = matrix.transformVector(point3d);
			v.x = v.x/v.w;
			v.y = -v.y/v.w;
			
			//z is unaffected by transform
			v.z = point3d.z;
			
			return v;
		}
		
		public function get unprojectionMatrix():Matrix3D
		{
			if( _unprojectionInvalid )
			{
				if( !_unprojection )
				{
					_unprojection = new Matrix3D();
				}
				_unprojection.copyFrom( matrix );
				_unprojection.invert();
				_unprojectionInvalid = false;
			}
			return _unprojection;
		}
		
		public function unproject(nX:Number, nY:Number, sZ:Number):Vector3D
		{
			throw new AbstractMethodError();
		}
		
		public function clone():LensBase
		{
			throw new AbstractMethodError();
		}
		
		public function get iAspectRatio():Number
		{
			return _pAspectRatio;
		}
		
		public function set iAspectRatio(value:Number):void
		{
			if ( _pAspectRatio == value )
			{
				return;
			}
			_pAspectRatio = value;
			pInvalidateMatrix();
		}
		
		public function pInvalidateMatrix():void
		{
			_pMatrixInvalid = true;
			_unprojectionInvalid = true;
			dispatchEvent( new LensEvent(LensEvent.MATRIX_CHANGED, this) );
		}
		
		public function pUpdateMatrix():void
		{
			throw new AbstractMethodError();
		}
		
		public function iUpdateScissorRect(x:Number, y:Number, width:Number, height:Number):void
		{
			_pScissorRect.x = x;
			_pScissorRect.y = y;
			_pScissorRect.width = width;
			_pScissorRect.height = height;
			pInvalidateMatrix();
		}
		
		public function iUpdateViewport(x:Number, y:Number, width:Number, height:Number):void
		{
			_pViewPort.x = x;
			_pViewPort.y = y;
			_pViewPort.width = width;
			_pViewPort.height = height;
			pInvalidateMatrix();
		}
	}
}