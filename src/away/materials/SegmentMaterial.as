///<reference path="../_definitions.ts"/>

package away.materials
{
	import away.materials.passes.SegmentPass;

	/**
	public class SegmentMaterial extends MaterialBase
	{
		private var _screenPass:SegmentPass;
		
		/**
		public function SegmentMaterial(thickness:Number = 1.25):void
		{
			super();
			
			this.bothSides = true;
			this.pAddPass(this._screenPass = new SegmentPass(thickness));
			this._screenPass.material = this;
		}
	}
}