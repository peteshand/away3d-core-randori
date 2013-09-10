///<reference path="../_definitions.ts"/>

package away.materials
{
	import away.materials.passes.SegmentPass;

	/**	 * SegmentMaterial is a material exclusively used to render wireframe objects	 *	 * @see away3d.entities.Lines	 */
	public class SegmentMaterial extends MaterialBase
	{
		private var _screenPass:SegmentPass;
		
		/**		 * Creates a new SegmentMaterial object.		 *		 * @param thickness The thickness of the wireframe lines.		 */
		public function SegmentMaterial(thickness:Number = 1.25):void
		{
			super();
			
			bothSides = true;
			pAddPass(_screenPass = new SegmentPass(thickness));
			_screenPass.material = this;
		}
	}
}
