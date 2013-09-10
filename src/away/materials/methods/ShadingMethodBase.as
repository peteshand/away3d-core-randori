///<reference path="../../_definitions.ts"/>

package away.materials.methods
{
	import away.library.assets.NamedAssetBase;
	import away.materials.compilation.ShaderRegisterData;
	import away.materials.passes.MaterialPassBase;
	import away.materials.compilation.ShaderRegisterCache;
	import away.managers.Stage3DProxy;
	import away.base.IRenderable;
	import away.cameras.Camera3D;
	import away.materials.compilation.ShaderRegisterElement;
	import away.textures.TextureProxyBase;
	import away.display3D.Context3DTextureFormat;
	import away.events.ShadingMethodEvent;
	//import away3d.*;
	//import away3d.cameras.*;
	//import away3d.core.base.*;
	//import away3d.managers.*;
	//import away3d.events.*;
	//import away3d.library.assets.*;
	//import away3d.materials.compilation.*;
	//import away3d.materials.passes.*;
	//import away3d.textures.*;
	
	//import flash.display3D.*;
	
	//use namespace arcane;
	
	/**	 * ShadingMethodBase provides an abstract base method for shading methods, used by compiled passes to compile	 * the final shading program.	 */
	public class ShadingMethodBase extends NamedAssetBase
	{
		public var _sharedRegisters:ShaderRegisterData; // should be protected		private var _passes:Vector.<MaterialPassBase>;//Vector.<MaterialPassBase>;		
		/**		 * Create a new ShadingMethodBase object.		 * @param needsNormals Defines whether or not the method requires normals.		 * @param needsView Defines whether or not the method requires the view direction.		 */
		public function ShadingMethodBase():void // needsNormals : boolean, needsView : boolean, needsGlobalPos : boolean		{
            super();
		}

		/**		 * Initializes the properties for a MethodVO, including register and texture indices.		 * @param vo The MethodVO object linking this method with the pass currently being compiled.		 */
		public function iInitVO(vo:MethodVO):void
		{
		
		}

		/**		 * Initializes unchanging shader constants using the data from a MethodVO.		 * @param vo The MethodVO object linking this method with the pass currently being compiled.		 */
		public function iInitConstants(vo:MethodVO):void
		{



		}

		/**		 * The shared registers created by the compiler and possibly used by methods.		 */
		public function get iSharedRegisters():ShaderRegisterData
		{
			return _sharedRegisters;
		}
		
		public function set iSharedRegisters(value:ShaderRegisterData):void
		{
			_sharedRegisters = value;
		}
		
		/**		 * Any passes required that render to a texture used by this method.		 */
		public function get passes():Vector.<MaterialPassBase>//Vector.<MaterialPassBase>		{
			return _passes;
		}
		
		/**		 * Cleans up any resources used by the current object.		 */
		override public function dispose():void
		{
		
		}
		
		/**		 * Creates a data container that contains material-dependent data. Provided as a factory method so a custom subtype can be overridden when needed.		 */
		public function iCreateMethodVO():MethodVO
		{
			return new MethodVO();
		}

		/**		 * Resets the compilation state of the method.		 */
		public function iReset():void
		{
			iCleanCompilationData();
		}
		
		/**		 * Resets the method's state for compilation.		 * @private		 */
		public function iCleanCompilationData():void
		{
		}
		
		/**		 * Get the vertex shader code for this method.		 * @param vo The MethodVO object linking this method with the pass currently being compiled.		 * @param regCache The register cache used during the compilation.		 * @private		 */
		public function iGetVertexCode(vo:MethodVO, regCache:ShaderRegisterCache):String
		{
			return "";
		}
		
		/**		 * Sets the render state for this method.		 *		 * @param vo The MethodVO object linking this method with the pass currently being compiled.		 * @param stage3DProxy The Stage3DProxy object currently used for rendering.		 * @private		 */
		public function iActivate(vo:MethodVO, stage3DProxy:Stage3DProxy):void
		{
		
		}
		
		/**		 * Sets the render state for a single renderable.		 *		 * @param vo The MethodVO object linking this method with the pass currently being compiled.		 * @param renderable The renderable currently being rendered.		 * @param stage3DProxy The Stage3DProxy object currently used for rendering.		 * @param camera The camera from which the scene is currently rendered.		 */
		public function iSetRenderState(vo:MethodVO, renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D):void
		{
		
		}
		
		/**		 * Clears the render state for this method.		 * @param vo The MethodVO object linking this method with the pass currently being compiled.		 * @param stage3DProxy The Stage3DProxy object currently used for rendering.		 */
		public function iDeactivate(vo:MethodVO, stage3DProxy:Stage3DProxy):void
		{
		
		}
		
		/**		 * A helper method that generates standard code for sampling from a texture using the normal uv coordinates.		 * @param vo The MethodVO object linking this method with the pass currently being compiled.		 * @param targetReg The register in which to store the sampled colour.		 * @param inputReg The texture stream register.		 * @param texture The texture which will be assigned to the given slot.		 * @param uvReg An optional uv register if coordinates different from the primary uv coordinates are to be used.		 * @param forceWrap If true, texture wrapping is enabled regardless of the material setting.		 * @return The fragment code that performs the sampling.		 */
		public function pGetTex2DSampleCode(vo:MethodVO, targetReg:ShaderRegisterElement, inputReg:ShaderRegisterElement, texture:TextureProxyBase, uvReg:ShaderRegisterElement = null, forceWrap:String = null):String
		{
			var wrap:String = forceWrap || (vo.repeatTextures? "wrap" : "clamp");
			var filter:String;

			var format:String = getFormatStringForTexture(texture);
			var enableMipMaps:Boolean = vo.useMipmapping && texture.hasMipMaps;
			
			if (vo.useSmoothTextures)
				filter = enableMipMaps? "linear,miplinear" : "linear";
			else
				filter = enableMipMaps? "nearest,mipnearest" : "nearest";

            //uvReg ||= _sharedRegisters.uvVarying;
            if ( uvReg == null )
            {

                uvReg = _sharedRegisters.uvVarying;

            }

			return "tex " + targetReg.toString() + ", " + uvReg.toString() + ", " + inputReg.toString() + " <2d," + filter + "," + format + wrap + ">\n";

		}

		/**		 * A helper method that generates standard code for sampling from a cube texture.		 * @param vo The MethodVO object linking this method with the pass currently being compiled.		 * @param targetReg The register in which to store the sampled colour.		 * @param inputReg The texture stream register.		 * @param texture The cube map which will be assigned to the given slot.		 * @param uvReg The direction vector with which to sample the cube map.		 */
		public function pGetTexCubeSampleCode(vo:MethodVO, targetReg:ShaderRegisterElement, inputReg:ShaderRegisterElement, texture:TextureProxyBase, uvReg:ShaderRegisterElement):String
		{
			var filter:String;
			var format:String = getFormatStringForTexture(texture);
			var enableMipMaps:Boolean = vo.useMipmapping && texture.hasMipMaps;
			
			if (vo.useSmoothTextures)
				filter = enableMipMaps? "linear,miplinear" : "linear";
			else
				filter = enableMipMaps? "nearest,mipnearest" : "nearest";
			
			return "tex " + targetReg.toString() + ", " + uvReg.toString() + ", " + inputReg.toString() + " <cube," + format + filter + ">\n";
		}

		/**		 * Generates a texture format string for the sample instruction.		 * @param texture The texture for which to get the format string.		 * @return		 */
		private function getFormatStringForTexture(texture:TextureProxyBase):String
		{
			switch (texture.format) {
				case Context3DTextureFormat.COMPRESSED:
					return "dxt1,";
					break;
				case "compressedAlpha":
					return "dxt5,";
					break;
				default:
					return "";
			}
		}
		
		/**		 * Marks the shader program as invalid, so it will be recompiled before the next render.		 */
		public function iInvalidateShaderProgram():void
		{
			dispatchEvent(new ShadingMethodEvent(ShadingMethodEvent.SHADER_INVALIDATED));
		}
		
		/**		 * Copies the state from a ShadingMethodBase object into the current object.		 */
		public function copyFrom(method:ShadingMethodBase):void
		{
		}
	}
}
