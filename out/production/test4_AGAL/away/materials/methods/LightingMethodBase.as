/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.materials.methods
{
	import away.materials.compilation.ShaderRegisterCache;
	import away.materials.compilation.ShaderRegisterElement;
	//import away3d.arcane;
	//import away3d.materials.compilation.ShaderRegisterCache;
	//import away3d.materials.compilation.ShaderRegisterElement;
	
	//use namespace arcane;
	
	/**	 * LightingMethodBase provides an abstract base method for shading methods that uses lights.	 * Used for diffuse and specular shaders only.	 */
	public class LightingMethodBase extends ShadingMethodBase
	{
		/**		 * A method that is exposed to wrappers in case the strength needs to be controlled		 */
        public var _iModulateMethod;
        public var _iModulateMethodScope:Object;

		/**		 * Creates a new LightingMethodBase.		 */
		public function LightingMethodBase():void
		{
			super();
		}
		
		/**		 * Get the fragment shader code that will be needed before any per-light code is added.		 * @param vo The MethodVO object containing the method data for the currently compiled material pass.		 * @param regCache The register cache used during the compilation.		 * @private		 */
		public function iGetFragmentPreLightingCode(vo:MethodVO, regCache:ShaderRegisterCache):String
		{
			return "";
		}
		
		/**		 * Get the fragment shader code that will generate the code relevant to a single light.		 *		 * @param vo The MethodVO object containing the method data for the currently compiled material pass.		 * @param lightDirReg The register containing the light direction vector.		 * @param lightColReg The register containing the light colour.		 * @param regCache The register cache used during the compilation.		 */
		public function iGetFragmentCodePerLight(vo:MethodVO, lightDirReg:ShaderRegisterElement, lightColReg:ShaderRegisterElement, regCache:ShaderRegisterCache):String
		{
			return "";
		}
		
		/**		 * Get the fragment shader code that will generate the code relevant to a single light probe object.		 *		 * @param vo The MethodVO object containing the method data for the currently compiled material pass.		 * @param cubeMapReg The register containing the cube map for the current probe		 * @param weightRegister A string representation of the register + component containing the current weight		 * @param regCache The register cache providing any necessary registers to the shader		 */
		public function iGetFragmentCodePerProbe(vo:MethodVO, cubeMapReg:ShaderRegisterElement, weightRegister:String, regCache:ShaderRegisterCache):String
		{
			return "";
		}
		
		/**		 * Get the fragment shader code that should be added after all per-light code. Usually composits everything to the target register.		 *		 * @param vo The MethodVO object containing the method data for the currently compiled material pass.		 * @param regCache The register cache used during the compilation.		 * @param targetReg The register containing the final shading output.		 * @private		 */
		public function iGetFragmentPostLightingCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement):String
		{
			return "";
		}
	}
}
