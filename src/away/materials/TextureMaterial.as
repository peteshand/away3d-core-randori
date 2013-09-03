///<reference path="../_definitions.ts"/>

package away.materials
{
	import away.textures.Texture2DBase;
	import away.geom.ColorTransform;
	import away.display.BlendMode;
	//import away3d.*;
	//import away3d.textures.*;
	
	//import flash.display.*;
	//import flash.geom.*;
	
	//use namespace arcane;
	
	/**	 * TextureMaterial is a single-pass material that uses a texture to define the surface's diffuse reflection colour (albedo).	 */
	public class TextureMaterial extends SinglePassMaterialBase
	{
		/**		 * Creates a new TextureMaterial.		 * @param texture The texture used for the material's albedo color.		 * @param smooth Indicates whether the texture should be filtered when sampled. Defaults to true.		 * @param repeat Indicates whether the texture should be tiled when sampled. Defaults to true.		 * @param mipmap Indicates whether or not any used textures should use mipmapping. Defaults to true.		 */
		public function TextureMaterial(texture:Texture2DBase = null, smooth:Boolean = true, repeat:Boolean = false, mipmap:Boolean = false):void
		{
			super();


			this.texture = texture;

			this.smooth = smooth;
			this.repeat = repeat;
			this.mipmap = mipmap;

		}

		/**		 * Specifies whether or not the UV coordinates should be animated using IRenderable's uvTransform matrix.		 *		 * @see IRenderable.uvTransform		 */
		public function get animateUVs():Boolean
		{
			return _pScreenPass.animateUVs;
		}
		
		public function set animateUVs(value:Boolean):void
		{
			this._pScreenPass.animateUVs = value;
		}
		
		/**		 * The alpha of the surface.		 */
		public function get alpha():Number
		{
			return _pScreenPass.colorTransform? _pScreenPass.colorTransform.alphaMultiplier : 1;
		}
		
		public function set alpha(value:Number):void
		{
			if (value > 1)
				value = 1;
			else if (value < 0)
				value = 0;

            if ( this.colorTransform == null )
            {
                    //colorTransform ||= new ColorTransform();
                this.colorTransform = new ColorTransform();
            }

			this.colorTransform.alphaMultiplier = value;

            this._pScreenPass.preserveAlpha = this.getRequiresBlending();

            this._pScreenPass.setBlendMode( this.getBlendMode() == BlendMode.NORMAL && this.getRequiresBlending() ? BlendMode.LAYER : this.getBlendMode() );

		}
		
		/**		 * The texture object to use for the albedo colour.		 */

		public function get texture():Texture2DBase
		{
			return _pScreenPass.diffuseMethod.texture;
		}
		
		public function set texture(value:Texture2DBase):void
		{
            this._pScreenPass.diffuseMethod.texture = value;
		}
		/**		 * The texture object to use for the ambient colour.		 */
		public function get ambientTexture():Texture2DBase
		{
			return _pScreenPass.ambientMethod.texture;
		}
		
		public function set ambientTexture(value:Texture2DBase):void
		{
            this._pScreenPass.ambientMethod.texture = value;
            this._pScreenPass.diffuseMethod.iUseAmbientTexture = ! (value == null ); // Boolean( value ) //<-------- TODO: Check this works as expected
		}

	}
}
