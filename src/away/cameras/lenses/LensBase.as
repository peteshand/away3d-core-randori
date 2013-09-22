/** * ... * @author Gary Paluk - http://www.plugin.io */

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
			this._pMatrix = new Matrix3D();
		}
		
		public function get frustumCorners():Vector.<Number>
		{
			return this._pFrustumCorners;
		}
		
		public function set frustumCorners(frustumCorners:Vector.<Number>):void
		{
			this._pFrustumCorners = frustumCorners;
		}
		
		public function get matrix():Matrix3D
		{
			if( this._pMatrixInvalid )
			{
				this.pUpdateMatrix();
				this._pMatrixInvalid = false;
			}
			return this._pMatrix;
		}
		
		public function set matrix(value:Matrix3D):void
		{
			this._pMatrix = value;
			this.pInvalidateMatrix();
		}
		
		public function get near():Number
		{
			return this._pNear;
		}
		
		public function set near(value:Number):void
		{
			if( value == this._pNear )
			{
				return;
			}
			this._pNear = value;
			this.pInvalidateMatrix();
		}
		
		public function get far():Number
		{
			return this._pFar;
		}
		
		public function set far(value:Number):void
		{
			if( value == this._pFar)
			{
				return;
			}
			this._pFar = value;
			this.pInvalidateMatrix();
		}
		
		public function project(point3d:Vector3D):Vector3D
		{
			var v:Vector3D = this.matrix.transformVector(point3d);
			v.x = v.x/v.w;
			v.y = -v.y/v.w;
			
			//z is unaffected by transform
			v.z = point3d.z;
			
			return v;
		}
		
		public function get unprojectionMatrix():Matrix3D
		{
			if( this._unprojectionInvalid )
			{
				if( !this._unprojection )
				{
					this._unprojection = new Matrix3D();
				}
				this._unprojection.copyFrom( this.matrix );
				this._unprojection.invert();
				this._unprojectionInvalid = false;
			}
			return this._unprojection;
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
			return this._pAspectRatio;
		}
		
		public function set iAspectRatio(value:Number):void
		{
			if ( this._pAspectRatio == value )
			{
				return;
			}
			this._pAspectRatio = value;
			this.pInvalidateMatrix();
		}
		
		public function pInvalidateMatrix():void
		{
			this._pMatrixInvalid = true;
			this._unprojectionInvalid = true;
			this.dispatchEvent( new LensEvent(LensEvent.MATRIX_CHANGED, this) );
		}
		
		public function pUpdateMatrix():void
		{
			throw new AbstractMethodError();
		}
		
		public function iUpdateScissorRect(x:Number, y:Number, width:Number, height:Number):void
		{
			this._pScissorRect.x = x;
			this._pScissorRect.y = y;
			this._pScissorRect.width = width;
			this._pScissorRect.height = height;
			this.pInvalidateMatrix();
		}
		
		public function iUpdateViewport(x:Number, y:Number, width:Number, height:Number):void
		{
			this._pViewPort.x = x;
			this._pViewPort.y = y;
			this._pViewPort.width = width;
			this._pViewPort.height = height;
			this.pInvalidateMatrix();
		}
	}
}