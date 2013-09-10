///<reference path="../_definitions.ts"/>
package away.materials
{
	import away.display.BlendMode;

	/**
	 * ColorMaterial is a single-pass material that uses a flat color as the surface's diffuse reflection value.
	 */
	public class ColorMaterial extends SinglePassMaterialBase
	{
		private var _diffuseAlpha:Number = 1;
		
		/**
		 * Creates a new ColorMaterial object.
		 * @param color The material's diffuse surface color.
		 * @param alpha The material's surface alpha.
		 */
		public function ColorMaterial(color:Number = 0xcccccc, alpha:Number = 1):void
		{

			super();

			color = color;
			alpha = alpha;

		}
		
		/**
		 * The alpha of the surface.
		 */
		public function get alpha():Number
		{
			return _pScreenPass.diffuseMethod.diffuseAlpha;
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

			_pScreenPass.diffuseMethod.diffuseAlpha = _diffuseAlpha = value;
            _pScreenPass.preserveAlpha = requiresBlending;
            _pScreenPass.setBlendMode( getBlendMode() == BlendMode.NORMAL && requiresBlending? BlendMode.LAYER : getBlendMode());
		}
		
		/**
		 * The diffuse reflectivity color of the surface.
		 */
		public function get color():Number
		{
			return _pScreenPass.diffuseMethod.diffuseColor;
		}
		
		public function set color(value:Number):void
		{
            _pScreenPass.diffuseMethod.diffuseColor = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get requiresBlending():Boolean
		{
			return getRequiresBlending() || _diffuseAlpha < 1;
		}
	}
}
