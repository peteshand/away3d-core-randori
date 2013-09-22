///<reference path="../_definitions.ts"/>

package away.materials
{
	import away.textures.Texture2DBase;

	/**	 * TextureMultiPassMaterial is a multi-pass material that uses a texture to define the surface's diffuse reflection colour (albedo).	 */
	public class TextureMultiPassMaterial extends MultiPassMaterialBase
	{
		private var _animateUVs:Boolean = false;

		/**		 * Creates a new TextureMultiPassMaterial.		 * @param texture The texture used for the material's albedo color.		 * @param smooth Indicates whether the texture should be filtered when sampled. Defaults to true.		 * @param repeat Indicates whether the texture should be tiled when sampled. Defaults to true.		 * @param mipmap Indicates whether or not any used textures should use mipmapping. Defaults to true.		 */
		public function TextureMultiPassMaterial(texture:Texture2DBase = null, smooth:Boolean = true, repeat:Boolean = false, mipmap:Boolean = true):void
		{
			texture = texture || null;
			smooth = smooth || true;
			repeat = repeat || false;
			mipmap = mipmap || true;

			super();
			this.texture = texture;
			this.smooth = smooth;
			this.repeat = repeat;
			this.mipmap = mipmap;
		}

		/**		 * Specifies whether or not the UV coordinates should be animated using a transformation matrix.		 */
		public function get animateUVs():Boolean
		{
			return this._animateUVs;
		}
		
		public function set animateUVs(value:Boolean):void
		{
			this._animateUVs = value;
		}
		
		/**		 * The texture object to use for the albedo colour.		 */
		public function get texture():Texture2DBase
		{
			return this.diffuseMethod.texture;
		}
		
		public function set texture(value:Texture2DBase):void
		{
			this.diffuseMethod.texture = value;
		}
		
		/**		 * The texture object to use for the ambient colour.		 */
		public function get ambientTexture():Texture2DBase
		{
			return this.ambientMethod.texture;
		}
		
		public function set ambientTexture(value:Texture2DBase):void
		{
			this.ambientMethod.texture = value;
            this.diffuseMethod.iUseAmbientTexture = (value != null );
		}
		
		override public function pUpdateScreenPasses():void
		{
			super.pUpdateScreenPasses();

			if (this._pEffectsPass)
                this._pEffectsPass.animateUVs = this._animateUVs;
		}
	}
}
