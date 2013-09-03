///<reference path="../../_definitions.ts"/>

package away.materials.methods
{
	import away.library.assets.IAsset;
	import away.library.assets.AssetType;
	import away.materials.compilation.ShaderRegisterCache;
	import away.materials.compilation.ShaderRegisterElement;
	import away.errors.AbstractMethodError;

	/**
	public class EffectMethodBase extends ShadingMethodBase implements IAsset
	{
		public function EffectMethodBase():void
		{
			super();
		}

		/**
		override public function get assetType():String
		{
			return AssetType.EFFECTS_METHOD;
		}

		/**
		public function iGetFragmentCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement):String
		{
			throw new AbstractMethodError();
			return "";
		}
	}
}