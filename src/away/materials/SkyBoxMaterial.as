///<reference path="../_definitions.ts"/>

package away.materials
{
	import away.textures.CubeTextureBase;
	import away.materials.passes.SkyBoxPass;

	/**
	 * SkyBoxMaterial is a material exclusively used to render skyboxes
	 *
	 * @see away3d.primitives.SkyBox
	 */
	public class SkyBoxMaterial extends MaterialBase
	{
		private var _cubeMap:CubeTextureBase;
		private var _skyboxPass:SkyBoxPass;
		
		/**
		 * Creates a new SkyBoxMaterial object.
		 * @param cubeMap The CubeMap to use as the skybox.
		 */
		public function SkyBoxMaterial(cubeMap:CubeTextureBase):void
		{

            super();

			_cubeMap = cubeMap;
			pAddPass(_skyboxPass = new SkyBoxPass());
			_skyboxPass.cubeTexture = _cubeMap;
		}
		
		/**
		 * The cube texture to use as the skybox.
		 */
		public function get cubeMap():CubeTextureBase
		{
			return _cubeMap;
		}
		
		public function set cubeMap(value:CubeTextureBase):void
		{
			if (value && _cubeMap && (value.hasMipMaps != _cubeMap.hasMipMaps || value.format != _cubeMap.format))
				iInvalidatePasses(null);
			
			_cubeMap = value;
			_skyboxPass.cubeTexture = _cubeMap;

		}
	}
}
