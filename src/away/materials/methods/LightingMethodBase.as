///<reference path="../../_definitions.ts"/>

package away.materials.methods
{
	import away.materials.compilation.ShaderRegisterCache;
	import away.materials.compilation.ShaderRegisterElement;
	//import away3d.arcane;
	//import away3d.materials.compilation.ShaderRegisterCache;
	//import away3d.materials.compilation.ShaderRegisterElement;
	
	//use namespace arcane;
	
	/**
	public class LightingMethodBase extends ShadingMethodBase
	{
		/**
		public var _iModulateMethod;

		/**
		public function LightingMethodBase():void
		{
			super();
		}
		
		/**
		public function iGetFragmentPreLightingCode(vo:MethodVO, regCache:ShaderRegisterCache):String
		{
			return "";
		}
		
		/**
		public function iGetFragmentCodePerLight(vo:MethodVO, lightDirReg:ShaderRegisterElement, lightColReg:ShaderRegisterElement, regCache:ShaderRegisterCache):String
		{
			return "";
		}
		
		/**
		public function iGetFragmentCodePerProbe(vo:MethodVO, cubeMapReg:ShaderRegisterElement, weightRegister:String, regCache:ShaderRegisterCache):String
		{
			return "";
		}
		
		/**
		public function iGetFragmentPostLightingCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement):String
		{
			return "";
		}
	}
}