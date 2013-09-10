/**
 * ...
 * @author Gary Paluk - http://www.plugin.io
 */
///<reference path="../../_definitions.ts"/>

package away.cameras.lenses
{
	public class FreeMatrixLens extends LensBase
	{
		public function FreeMatrixLens():void
		{
			super();
			_pMatrix.copyFrom( new PerspectiveLens().matrix );
		}
		
		//@override
		override public function set near(value:Number):void
		{
			_pNear = value;
		}
		
		//@override
		override public function set far(value:Number):void
		{
			_pFar = value;
		}
		
		//@override
		override public function set iAspectRatio(value:Number):void
		{
			_pAspectRatio = value;
		}
		
		//@override
		override public function clone():LensBase
		{
			var clone:FreeMatrixLens = new FreeMatrixLens();
			clone._pMatrix.copyFrom( _pMatrix );
			clone._pNear = _pNear;
			clone._pFar = _pFar;
			clone._pAspectRatio = _pAspectRatio;
			clone.pInvalidateMatrix();
			return clone;
		}
		
		//@override
		override public function pUpdateMatrix():void
		{
			_pMatrixInvalid = false;
		}
	}
}