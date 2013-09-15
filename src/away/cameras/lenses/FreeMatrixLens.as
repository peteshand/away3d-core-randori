/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../../_definitions.ts"/>

package away.cameras.lenses
{
	public class FreeMatrixLens extends LensBase
	{
		public function FreeMatrixLens():void
		{
			super();
			this._pMatrix.copyFrom( new PerspectiveLens().matrix );
		}
		
		//@override
		override public function set near(value:Number):void
		{
			this._pNear = value;
		}
		
		//@override
		override public function set far(value:Number):void
		{
			this._pFar = value;
		}
		
		//@override
		override public function set iAspectRatio(value:Number):void
		{
			this._pAspectRatio = value;
		}
		
		//@override
		override public function clone():LensBase
		{
			var clone:FreeMatrixLens = new FreeMatrixLens();
			clone._pMatrix.copyFrom( this._pMatrix );
			clone._pNear = this._pNear;
			clone._pFar = this._pFar;
			clone._pAspectRatio = this._pAspectRatio;
			clone.pInvalidateMatrix();
			return clone;
		}
		
		//@override
		override public function pUpdateMatrix():void
		{
			this._pMatrixInvalid = false;
		}
	}
}