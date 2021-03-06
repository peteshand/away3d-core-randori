/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.materials
{
	import away.core.display.BlendMode;

	/**	 * ColorMaterial is a single-pass material that uses a flat color as the surface's diffuse reflection value.	 */
	public class ColorMaterial extends SinglePassMaterialBase
	{
		private var _diffuseAlpha:Number = 1;
		
		/**		 * Creates a new ColorMaterial object.		 * @param color The material's diffuse surface color.		 * @param alpha The material's surface alpha.		 */
		public function ColorMaterial(color:Number = 0xcccccc, alpha:Number = 1):void
		{
			color = color || 0xcccccc;
			alpha = alpha || 1;


			super();

			this.color = color;
			this.alpha = alpha;

		}
		
		/**		 * The alpha of the surface.		 */
		public function get alpha():Number
		{
			return this._pScreenPass.diffuseMethod.diffuseAlpha;
		}
		
		public function set alpha(value:Number):void
		{
			if (value > 1)
            {

                value = 1;

            }
			else if (value < 0)
            {

                value = 0;
            }

			this._diffuseAlpha =  value;
			this._pScreenPass.diffuseMethod.diffuseAlpha = this._diffuseAlpha
            this._pScreenPass.preserveAlpha = this.requiresBlending;
            this._pScreenPass.setBlendMode( this.getBlendMode() == BlendMode.NORMAL && this.requiresBlending? BlendMode.LAYER : this.getBlendMode());
		}
		
		/**		 * The diffuse reflectivity color of the surface.		 */
		public function get color():Number
		{
			return this._pScreenPass.diffuseMethod.diffuseColor;
		}
		
		public function set color(value:Number):void
		{
            this._pScreenPass.diffuseMethod.diffuseColor = value;
		}
		
		/**		 * @inheritDoc		 */
		override public function get requiresBlending():Boolean
		{
			return this.getRequiresBlending() || this._diffuseAlpha < 1;
		}
	}
}
