///<reference path="../../_definitions.ts"/>
package away.materials.methods
{
	import away.library.assets.IAsset;
	import away.library.assets.AssetType;
	import away.materials.compilation.ShaderRegisterCache;
	import away.materials.compilation.ShaderRegisterElement;
	import away.errors.AbstractMethodError;

	/**
	 * EffectMethodBase forms an abstract base class for shader methods that are not dependent on light sources,
	 * and are in essence post-process effects on the materials.
	 */
	public class EffectMethodBase extends ShadingMethodBase implements IAsset
	{
		public function EffectMethodBase():void
		{
			super();
		}

		/**
		 * @inheritDoc
		 */
		override public function get assetType():String
		{
			return AssetType.EFFECTS_METHOD;
		}

		/**
		 * Get the fragment shader code that should be added after all per-light code. Usually composits everything to the target register.
		 * @param vo The MethodVO object containing the method data for the currently compiled material pass.
		 * @param regCache The register cache used during the compilation.
		 * @param targetReg The register that will be containing the method's output.
		 * @private
		 */
		public function iGetFragmentCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement):String
		{
			throw new AbstractMethodError();
			return "";
		}
	}
}
