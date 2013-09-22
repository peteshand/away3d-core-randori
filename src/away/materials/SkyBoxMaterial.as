///<reference path="../_definitions.ts"/>


package away.materials
{
	import away.textures.CubeTextureBase;
	import away.materials.passes.SkyBoxPass;

	/**	 * SkyBoxMaterial is a material exclusively used to render skyboxes	 *	 * @see away3d.primitives.SkyBox	 */
	public class SkyBoxMaterial extends MaterialBase
	{
		private var _cubeMap:CubeTextureBase;
		private var _skyboxPass:SkyBoxPass;
		
		/**		 * Creates a new SkyBoxMaterial object.		 * @param cubeMap The CubeMap to use as the skybox.		 */
		public function SkyBoxMaterial(cubeMap:CubeTextureBase):void
		{

            super();

			this._cubeMap = cubeMap;
			this.pAddPass(this._skyboxPass = new SkyBoxPass());
			this._skyboxPass.cubeTexture = this._cubeMap;
		}
		
		/**		 * The cube texture to use as the skybox.		 */
		public function get cubeMap():CubeTextureBase
		{
			return this._cubeMap;
		}
		
		public function set cubeMap(value:CubeTextureBase):void
		{
			if (value && this._cubeMap && (value.hasMipMaps != this._cubeMap.hasMipMaps || value.format != this._cubeMap.format))
				this.iInvalidatePasses(null);
			
			this._cubeMap = value;
			this._skyboxPass.cubeTexture = this._cubeMap;

		}
	}
}
