///<reference path="../../_definitions.ts"/>

package away.materials.compilation
{
	import away.materials.methods.ShaderMethodSetup;
	import away.materials.methods.MethodVOSet;
	import away.materials.methods.ShadingMethodBase;
	import away.materials.methods.MethodVO;
	import away.materials.LightSources;
	import away.materials.methods.EffectMethodBase;

	/**	 * ShaderCompiler is an abstract base class for shader compilers that use modular shader methods to assemble a	 * material. Concrete subclasses are used by the default materials.	 *	 * @see away3d.materials.methods.ShadingMethodBase	 */
	public class ShaderCompiler
	{
        public var _pSharedRegisters:ShaderRegisterData;// PROTECTED        public var _pRegisterCache:ShaderRegisterCache;// PROTECTED		public var _pDependencyCounter:MethodDependencyCounter; // PROTECTED        public var _pMethodSetup:ShaderMethodSetup;// PROTECTED
		private var _smooth:Boolean;
		private var _repeat:Boolean;
		private var _mipmap:Boolean;
		public var _pEnableLightFallOff:Boolean;
		private var _preserveAlpha:Boolean = true;
		private var _animateUVs:Boolean;
		public var _pAlphaPremultiplied:Boolean; // PROTECTED		private var _vertexConstantData:Vector.<Number>;
		private var _fragmentConstantData:Vector.<Number>;

		public var _pVertexCode:String = ''; // Changed to emtpy string- AwayTS        public var _pFragmentCode:String = '';// Changed to emtpy string - AwayTS		private var _fragmentLightCode:String;
		private var _fragmentPostLightCode:String;
		private var _commonsDataIndex:Number = -1;

		public var _pAnimatableAttributes:Vector.<String>; // PROTECTED		public var _pAnimationTargetRegisters:Vector.<String>; // PROTECTED
		public var _pLightProbeDiffuseIndices:Vector.<Number>/*uint*/;
        public var _pLightProbeSpecularIndices:Vector.<Number>/*uint*/;
		private var _uvBufferIndex:Number = -1;
		private var _uvTransformIndex:Number = -1;
		private var _secondaryUVBufferIndex:Number = -1;
		public var _pNormalBufferIndex:Number = -1; // PROTECTED		public var _pTangentBufferIndex:Number = -1; // PROTECTED		public var _pLightFragmentConstantIndex:Number = -1; //PROTECTED		private var _sceneMatrixIndex:Number = -1;
		public var _pSceneNormalMatrixIndex:Number = -1; //PROTECTED		public var _pCameraPositionIndex:Number = -1; // PROTECTED		public var _pProbeWeightsIndex:Number = -1; // PROTECTED
		private var _specularLightSources:Number;
		private var _diffuseLightSources:Number;

		public var _pNumLights:Number;  // PROTECTED		public var _pNumLightProbes:Number; // PROTECTED		public var _pNumPointLights:Number; // PROTECTED		public var _pNumDirectionalLights:Number; // PROTECTED
		public var _pNumProbeRegisters:Number; // PROTECTED		private var _combinedLightSources:Number;

		public var _usingSpecularMethod:Boolean;

		private var _needUVAnimation:Boolean;
		private var _UVTarget:String;
		private var _UVSource:String;

		public var _pProfile:String;

		private var _forceSeperateMVP:Boolean;

		/**		 * Creates a new ShaderCompiler object.		 * @param profile The compatibility profile of the renderer.		 */
		public function ShaderCompiler(profile:String):void
		{
			_pSharedRegisters = new ShaderRegisterData();
            _pDependencyCounter = new MethodDependencyCounter();
            _pProfile = profile;
            initRegisterCache(profile);
		}

		/**		 * Whether or not to use fallOff and radius properties for lights. This can be used to improve performance and		 * compatibility for constrained mode.		 */
		public function get enableLightFallOff():Boolean
		{
			return _pEnableLightFallOff;
		}

		public function set enableLightFallOff(value:Boolean):void
		{
            _pEnableLightFallOff = value;
		}

		/**		 * Indicates whether the compiled code needs UV animation.		 */
		public function get needUVAnimation():Boolean
		{
			return _needUVAnimation;
		}

		/**		 * The target register to place the animated UV coordinate.		 */
		public function get UVTarget():String
		{
			return _UVTarget;
		}

		/**		 * The souce register providing the UV coordinate to animate.		 */
		public function get UVSource():String
		{
			return _UVSource;
		}

		/**		 * Indicates whether the screen projection should be calculated by forcing a separate scene matrix and		 * view-projection matrix. This is used to prevent rounding errors when using multiple passes with different		 * projection code.		 */
		public function get forceSeperateMVP():Boolean
		{
			return _forceSeperateMVP;
		}

		public function set forceSeperateMVP(value:Boolean):void
		{
            _forceSeperateMVP = value;
		}

		/**		 * Initialized the register cache.		 * @param profile The compatibility profile of the renderer.		 */
		private function initRegisterCache(profile:String):void
		{
            _pRegisterCache = new ShaderRegisterCache(profile);
            _pRegisterCache.vertexAttributesOffset = 1;
            _pRegisterCache.reset();
		}

		/**		 * Indicate whether UV coordinates need to be animated using the renderable's transformUV matrix.		 */
		public function get animateUVs():Boolean
		{
			return _animateUVs;
		}

		public function set animateUVs(value:Boolean):void
		{
            _animateUVs = value;
		}

		/**		 * Indicates whether visible textures (or other pixels) used by this material have		 * already been premultiplied.		 */
		public function get alphaPremultiplied():Boolean
		{
			return _pAlphaPremultiplied;
		}

		public function set alphaPremultiplied(value:Boolean):void
		{
            _pAlphaPremultiplied = value;
		}

		/**		 * Indicates whether the output alpha value should remain unchanged compared to the material's original alpha.		 */
		public function get preserveAlpha():Boolean
		{
			return _preserveAlpha;
		}

		public function set preserveAlpha(value:Boolean):void
		{
            _preserveAlpha = value;
		}

		/**		 * Sets the default texture sampling properties.		 * @param smooth Indicates whether the texture should be filtered when sampled. Defaults to true.		 * @param repeat Indicates whether the texture should be tiled when sampled. Defaults to true.		 * @param mipmap Indicates whether or not any used textures should use mipmapping. Defaults to true.		 */
		public function setTextureSampling(smooth:Boolean, repeat:Boolean, mipmap:Boolean):void
		{
            _smooth = smooth;
            _repeat = repeat;
            _mipmap = mipmap;
		}

		/**		 * Sets the constant buffers allocated by the material. This allows setting constant data during compilation.		 * @param vertexConstantData The vertex constant data buffer.		 * @param fragmentConstantData The fragment constant data buffer.		 */
		public function setConstantDataBuffers(vertexConstantData:Vector.<Number>, fragmentConstantData:Vector.<Number>):void
		{
            _vertexConstantData = vertexConstantData;
            _fragmentConstantData = fragmentConstantData;
		}

		/**		 * The shader method setup object containing the method configuration and their value objects for the material being compiled.		 */
		public function get methodSetup():ShaderMethodSetup
		{
			return _pMethodSetup;
		}

		public function set methodSetup(value:ShaderMethodSetup):void
		{
            _pMethodSetup = value;
		}

		/**		 * Compiles the code after all setup on the compiler has finished.		 */
		public function compile():void
		{
			pInitRegisterIndices();
			pInitLightData();

			_pAnimatableAttributes = new Vector.<String>( "va0" );//Vector.<String>(["va0"]);
            _pAnimationTargetRegisters = new Vector.<String>( "vt0" );//Vector.<String>(["vt0"]);
            _pVertexCode = "";
            _pFragmentCode = "";

            _pSharedRegisters.localPosition = _pRegisterCache.getFreeVertexVectorTemp();
            _pRegisterCache.addVertexTempUsages( _pSharedRegisters.localPosition, 1);

            createCommons();
            pCalculateDependencies();
            updateMethodRegisters();

			for (var i:Number = 0; i < 4; ++i)
                _pRegisterCache.getFreeVertexConstant();

            pCreateNormalRegisters();

			if (_pDependencyCounter.globalPosDependencies > 0 || _forceSeperateMVP)
                pCompileGlobalPositionCode();

            compileProjectionCode();
            pCompileMethodsCode();
            compileFragmentOutput();
            _fragmentPostLightCode = fragmentCode;
		}

		/**		 * Creates the registers to contain the normal data.		 */
		public function pCreateNormalRegisters():void
		{

		}

		/**		 * Compile the code for the methods.		 */
		public function pCompileMethodsCode():void
		{
			if (_pDependencyCounter.uvDependencies > 0)
                compileUVCode();

			if (_pDependencyCounter.secondaryUVDependencies > 0)
                compileSecondaryUVCode();

			if (_pDependencyCounter.normalDependencies > 0)
                pCompileNormalCode();

			if (_pDependencyCounter.viewDirDependencies > 0)
                pCompileViewDirCode();

            pCompileLightingCode();
            _fragmentLightCode = _pFragmentCode;
            _pFragmentCode = "";
            pCompileMethods();
		}

		/**		 * Compile the lighting code.		 */
		public function pCompileLightingCode():void
		{

		}

		/**		 * Calculate the view direction.		 */
		public function pCompileViewDirCode():void
		{

		}

		/**		 * Calculate the normal.		 */
		public function pCompileNormalCode():void
		{

		}

		/**		 * Calculate the (possibly animated) UV coordinates.		 */
		private function compileUVCode():void
		{
			var uvAttributeReg:ShaderRegisterElement = _pRegisterCache.getFreeVertexAttribute();
			_uvBufferIndex = uvAttributeReg.index;

			var varying:ShaderRegisterElement = _pRegisterCache.getFreeVarying();

			_pSharedRegisters.uvVarying = varying;

			if (animateUVs)
            {

				// a, b, 0, tx
				// c, d, 0, ty
				var uvTransform1:ShaderRegisterElement = _pRegisterCache.getFreeVertexConstant();
				var uvTransform2:ShaderRegisterElement = _pRegisterCache.getFreeVertexConstant();
                _uvTransformIndex = uvTransform1.index*4;

                // TODO: AGAL <> GLSL

                _pVertexCode += "dp4 " + varying.toString() + ".x, " + uvAttributeReg.toString() + ", " + uvTransform1.toString() + "\n" +
					"dp4 " + varying.toString() + ".y, " + uvAttributeReg.toString() + ", " + uvTransform2.toString() + "\n" +
					"mov " + varying.toString() + ".zw, " + uvAttributeReg.toString() + ".zw \n";

			}
            else
            {

				_uvTransformIndex = -1;
                _needUVAnimation = true;
                _UVTarget = varying.toString();
                _UVSource = uvAttributeReg.toString();

			}
		}

		/**		 * Provide the secondary UV coordinates.		 */
		private function compileSecondaryUVCode():void
		{
            // TODO: AGAL <> GLSL

			var uvAttributeReg:ShaderRegisterElement = _pRegisterCache.getFreeVertexAttribute();
            _secondaryUVBufferIndex = uvAttributeReg.index;
            _pSharedRegisters.secondaryUVVarying = _pRegisterCache.getFreeVarying();
            _pVertexCode += "mov " + _pSharedRegisters.secondaryUVVarying.toString() + ", " + uvAttributeReg.toString() + "\n";
		}

		/**		 * Compile the world-space position.		 */
		public function pCompileGlobalPositionCode():void
		{

            // TODO: AGAL <> GLSL

			_pSharedRegisters.globalPositionVertex = _pRegisterCache.getFreeVertexVectorTemp();
            _pRegisterCache.addVertexTempUsages(_pSharedRegisters.globalPositionVertex, _pDependencyCounter.globalPosDependencies);
			var positionMatrixReg:ShaderRegisterElement = _pRegisterCache.getFreeVertexConstant();
            _pRegisterCache.getFreeVertexConstant();
            _pRegisterCache.getFreeVertexConstant();
            _pRegisterCache.getFreeVertexConstant();
            _sceneMatrixIndex = positionMatrixReg.index*4;

            _pVertexCode += "m44 " + _pSharedRegisters.globalPositionVertex.toString() + ", " + _pSharedRegisters.localPosition.toString() + ", " + positionMatrixReg.toString() + "\n";

			if (_pDependencyCounter.usesGlobalPosFragment)
            {

                _pSharedRegisters.globalPositionVarying = _pRegisterCache.getFreeVarying();
                _pVertexCode += "mov " + _pSharedRegisters.globalPositionVarying.toString() + ", " + _pSharedRegisters.globalPositionVertex.toString() + "\n";

			}
		}

		/**		 * Get the projection coordinates.		 */
		private function compileProjectionCode():void
		{
			var pos:String = _pDependencyCounter.globalPosDependencies > 0 || _forceSeperateMVP? _pSharedRegisters.globalPositionVertex.toString() : _pAnimationTargetRegisters[0];
			var code:String;

            // TODO: AGAL <> GLSL

			if (_pDependencyCounter.projectionDependencies > 0)
            {

                _pSharedRegisters.projectionFragment = _pRegisterCache.getFreeVarying();

				code = "m44 vt5, " + pos + ", vc0		\n" +
					"mov " + _pSharedRegisters.projectionFragment.toString() + ", vt5\n" +
					"mov op, vt5\n";
			}
            else
            {

                code = "m44 op, " + pos + ", vc0		\n";

            }


            _pVertexCode += code;

		}

		/**		 * Assign the final output colour the the output register.		 */
		private function compileFragmentOutput():void
		{
            // TODO: AGAL <> GLSL

			_pFragmentCode += "mov " + _pRegisterCache.fragmentOutputRegister.toString() + ", " + _pSharedRegisters.shadedTarget.toString() + "\n";
            _pRegisterCache.removeFragmentTempUsage(_pSharedRegisters.shadedTarget);
		}

		/**		 * Reset all the indices to "unused".		 */
		public function pInitRegisterIndices():void
		{
			_commonsDataIndex = -1;
            _pCameraPositionIndex = -1;
            _uvBufferIndex = -1;
            _uvTransformIndex = -1;
            _secondaryUVBufferIndex = -1;
            _pNormalBufferIndex = -1;
            _pTangentBufferIndex = -1;
            _pLightFragmentConstantIndex = -1;
            _sceneMatrixIndex = -1;
            _pSceneNormalMatrixIndex = -1;
            _pProbeWeightsIndex = -1;

		}

		/**		 * Prepares the setup for the light code.		 */
		public function pInitLightData():void
		{
            _pNumLights = _pNumPointLights + _pNumDirectionalLights;
            _pNumProbeRegisters = Math.ceil(_pNumLightProbes/4);


			if (_pMethodSetup._iSpecularMethod)
            {

                _combinedLightSources = _specularLightSources | _diffuseLightSources;

            }
			else
            {

                _combinedLightSources = _diffuseLightSources;

            }

            _usingSpecularMethod = Boolean(_pMethodSetup._iSpecularMethod && (
                pUsesLightsForSpecular() ||
                pUsesProbesForSpecular()));

		}

		/**		 * Create the commonly shared constant register.		 */
		private function createCommons():void
		{
			_pSharedRegisters.commons = _pRegisterCache.getFreeFragmentConstant();
            _commonsDataIndex = _pSharedRegisters.commons.index*4;
		}

		/**		 * Figure out which named registers are required, and how often.		 */
		public function pCalculateDependencies():void
		{
            _pDependencyCounter.reset();



			var methods:Vector.<MethodVOSet> = _pMethodSetup._iMethods;//Vector.<MethodVOSet>
			var len:Number;

			setupAndCountMethodDependencies(_pMethodSetup._iDiffuseMethod, _pMethodSetup._iDiffuseMethodVO);


			if (_pMethodSetup._iShadowMethod)
				setupAndCountMethodDependencies(_pMethodSetup._iShadowMethod, _pMethodSetup._iShadowMethodVO);


			setupAndCountMethodDependencies(_pMethodSetup._iAmbientMethod, _pMethodSetup._iAmbientMethodVO);

			if (_usingSpecularMethod)
				setupAndCountMethodDependencies(_pMethodSetup._iSpecularMethod, _pMethodSetup._iSpecularMethodVO);

			if (_pMethodSetup._iColorTransformMethod)
				setupAndCountMethodDependencies(_pMethodSetup._iColorTransformMethod, _pMethodSetup._iColorTransformMethodVO);

			len = methods.length;

			for (var i:Number = 0; i < len; ++i)
				setupAndCountMethodDependencies(methods[i].method, methods[i].data);

			if (usesNormals)
				setupAndCountMethodDependencies(_pMethodSetup._iNormalMethod, _pMethodSetup._iNormalMethodVO);

			// todo: add spotlights to count check
			_pDependencyCounter.setPositionedLights(_pNumPointLights, _combinedLightSources);

		}

		/**		 * Counts the dependencies for a given method.		 * @param method The method to count the dependencies for.		 * @param methodVO The method's data for this material.		 */
		private function setupAndCountMethodDependencies(method:ShadingMethodBase, methodVO:MethodVO):void
		{
			setupMethod(method, methodVO);
			_pDependencyCounter.includeMethodVO(methodVO);
		}

		/**		 * Assigns all prerequisite data for the methods, so we can calculate dependencies for them.		 */
		private function setupMethod(method:ShadingMethodBase, methodVO:MethodVO):void
		{
			method.iReset();
			methodVO.reset();

			methodVO.vertexData = _vertexConstantData;
			methodVO.fragmentData = _fragmentConstantData;
			methodVO.useSmoothTextures = _smooth;
			methodVO.repeatTextures = _repeat;
			methodVO.useMipmapping = _mipmap;
			methodVO.useLightFallOff = _pEnableLightFallOff && _pProfile != "baselineConstrained";
			methodVO.numLights = _pNumLights + _pNumLightProbes;

			method.iInitVO(methodVO);
		}

		/**		 * The index for the common data register.		 */
		public function get commonsDataIndex():Number
		{
			return _commonsDataIndex;
		}

		/**		 * Assigns the shared register data to all methods.		 */
		private function updateMethodRegisters():void
		{
			_pMethodSetup._iNormalMethod.iSharedRegisters= _pSharedRegisters;
            _pMethodSetup._iDiffuseMethod.iSharedRegisters = _pSharedRegisters;

			if (_pMethodSetup._iShadowMethod)
                _pMethodSetup._iShadowMethod.iSharedRegisters = _pSharedRegisters;

            _pMethodSetup._iAmbientMethod.iSharedRegisters = _pSharedRegisters;

			if (_pMethodSetup._iSpecularMethod)
                _pMethodSetup._iSpecularMethod.iSharedRegisters = _pSharedRegisters;

			if (_pMethodSetup._iColorTransformMethod)
                _pMethodSetup._iColorTransformMethod.iSharedRegisters = _pSharedRegisters;


            var methods : Vector.<MethodVOSet> = _pMethodSetup._iMethods;//var methods:Vector.<MethodVOSet> = _pMethodSetup._methods;

			var len:Number = methods.length;

			for (var i:Number = 0; i < len; ++i)
            {

                methods[i].method.iSharedRegisters = _pSharedRegisters;

            }


		}

		/**		 * The amount of vertex constants used by the material. Any animation code to be added can append its vertex		 * constant data after this.		 */
		public function get numUsedVertexConstants():Number
		{
			return _pRegisterCache.numUsedVertexConstants;
		}

		/**		 * The amount of fragment constants used by the material. Any animation code to be added can append its vertex		 * constant data after this.		 */
		public function get numUsedFragmentConstants():Number
		{
			return _pRegisterCache.numUsedFragmentConstants;
		}

		/**		 * The amount of vertex attribute streams used by the material. Any animation code to be added can add its		 * streams after this. Also used to automatically disable attribute slots on pass deactivation.		 */
		public function get numUsedStreams():Number
		{
			return _pRegisterCache.numUsedStreams;
		}

		/**		 * The amount of textures used by the material. Used to automatically disable texture slots on pass deactivation.		 */
		public function get numUsedTextures():Number
		{
			return _pRegisterCache.numUsedTextures;
		}

		/**		 * Number of used varyings. Any animation code to be added can add its used varyings after this.		 */
		public function get numUsedVaryings():Number
		{
			return _pRegisterCache.numUsedVaryings;
		}

		/**		 * Indicates whether lights are used for specular reflections.		 */
		public function pUsesLightsForSpecular():Boolean
		{
			return _pNumLights > 0 && ( _specularLightSources & LightSources.LIGHTS) != 0;
		}

		/**		 * Indicates whether lights are used for diffuse reflections.		 */
		public function pUsesLightsForDiffuse():Boolean
		{
			return _pNumLights > 0 && ( _diffuseLightSources & LightSources.LIGHTS) != 0;
		}

		/**		 * Disposes all resources used by the compiler.		 */
		public function dispose():void
		{
			cleanUpMethods();
			_pRegisterCache.dispose();
			_pRegisterCache = null;
			_pSharedRegisters = null;
		}

		/**		 * Clean up method's compilation data after compilation finished.		 */
		private function cleanUpMethods():void
		{
			if (_pMethodSetup._iNormalMethod)
                _pMethodSetup._iNormalMethod.iCleanCompilationData();

			if (_pMethodSetup._iDiffuseMethod)
                _pMethodSetup._iDiffuseMethod.iCleanCompilationData();

			if (_pMethodSetup._iAmbientMethod)
                _pMethodSetup._iAmbientMethod.iCleanCompilationData();

			if (_pMethodSetup._iSpecularMethod)
                _pMethodSetup._iSpecularMethod.iCleanCompilationData();

			if (_pMethodSetup._iShadowMethod)
                _pMethodSetup._iShadowMethod.iCleanCompilationData();

			if (_pMethodSetup._iColorTransformMethod)
                _pMethodSetup._iColorTransformMethod.iCleanCompilationData();

            var methods:Vector.<MethodVOSet>= _pMethodSetup._iMethods;//var methods:Vector.<MethodVOSet> = _pMethodSetup._methods;

			var len:Number = methods.length;

			for (var i:Number = 0; i < len; ++i)
            {

                methods[i].method.iCleanCompilationData();

            }

		}

		/**		 * Define which light source types to use for specular reflections. This allows choosing between regular lights		 * and/or light probes for specular reflections.		 *		 * @see away3d.materials.LightSources		 */
		public function get specularLightSources():Number
		{
			return _specularLightSources;
		}

		public function set specularLightSources(value:Number):void
		{
            _specularLightSources = value;
		}

		/**		 * Define which light source types to use for diffuse reflections. This allows choosing between regular lights		 * and/or light probes for diffuse reflections.		 *		 * @see away3d.materials.LightSources		 */
		public function get diffuseLightSources():Number
		{
			return _diffuseLightSources;
		}

		public function set diffuseLightSources(value:Number):void
		{
			_diffuseLightSources = value;
		}

		/**		 * Indicates whether light probes are being used for specular reflections.		 */
		public function pUsesProbesForSpecular():Boolean
		{
			return _pNumLightProbes > 0 && (_specularLightSources & LightSources.PROBES) != 0;
		}

		/**		 * Indicates whether light probes are being used for diffuse reflections.		 */
		public function pUsesProbesForDiffuse():Boolean
		{
			return _pNumLightProbes > 0 && (_diffuseLightSources & LightSources.PROBES) != 0;
		}

		/**		 * Indicates whether any light probes are used.		 */
		public function pUsesProbes():Boolean
		{
			return _pNumLightProbes > 0 && ((_diffuseLightSources | _specularLightSources) & LightSources.PROBES) != 0;
		}

		/**		 * The index for the UV vertex attribute stream.		 */
		public function get uvBufferIndex():Number
		{
			return _uvBufferIndex;
		}

		/**		 * The index for the UV transformation matrix vertex constant.		 */
		public function get uvTransformIndex():Number
		{
			return _uvTransformIndex;
		}

		/**		 * The index for the secondary UV vertex attribute stream.		 */
		public function get secondaryUVBufferIndex():Number
		{
			return _secondaryUVBufferIndex;
		}

		/**		 * The index for the vertex normal attribute stream.		 */
		public function get normalBufferIndex():Number
		{
			return _pNormalBufferIndex;
		}

		/**		 * The index for the vertex tangent attribute stream.		 */
		public function get tangentBufferIndex():Number
		{
			return _pTangentBufferIndex;
		}

		/**		 * The first index for the fragment constants containing the light data.		 */
		public function get lightFragmentConstantIndex():Number
		{
			return _pLightFragmentConstantIndex;
		}

		/**		 * The index of the vertex constant containing the camera position.		 */
		public function get cameraPositionIndex():Number
		{
			return _pCameraPositionIndex;
		}

		/**		 * The index of the vertex constant containing the scene matrix.		 */
		public function get sceneMatrixIndex():Number
		{
			return _sceneMatrixIndex;
		}

		/**		 * The index of the vertex constant containing the uniform scene matrix (the inverse transpose).		 */
		public function get sceneNormalMatrixIndex():Number
		{
			return _pSceneNormalMatrixIndex;
		}

		/**		 * The index of the fragment constant containing the weights for the light probes.		 */
		public function get probeWeightsIndex():Number
		{
			return _pProbeWeightsIndex;
		}

		/**		 * The generated vertex code.		 */
		public function get vertexCode():String
		{
			return _pVertexCode;
		}

		/**		 * The generated fragment code.		 */
		public function get fragmentCode():String
		{
			return _pFragmentCode;
		}

		/**		 * The code containing the lighting calculations.		 */
		public function get fragmentLightCode():String
		{
			return _fragmentLightCode;
		}

		/**		 * The code containing the post-lighting calculations.		 */
		public function get fragmentPostLightCode():String
		{
			return _fragmentPostLightCode;
		}

		/**		 * The register name containing the final shaded colour.		 */
		public function get shadedTarget():String
		{
			return _pSharedRegisters.shadedTarget.toString();
		}

		/**		 * The amount of point lights that need to be supported.		 */
		public function get numPointLights():Number
		{
			return _pNumPointLights;
		}

		public function set numPointLights(numPointLights:Number):void
		{
            _pNumPointLights = numPointLights;
		}

		/**		 * The amount of directional lights that need to be supported.		 */
		public function get numDirectionalLights():Number
		{
			return _pNumDirectionalLights;
		}

		public function set numDirectionalLights(value:Number):void
		{
            _pNumDirectionalLights = value;
		}

		/**		 * The amount of light probes that need to be supported.		 */
		public function get numLightProbes():Number
		{
			return _pNumLightProbes;
		}

		public function set numLightProbes(value:Number):void
		{
            _pNumLightProbes = value;
		}

		/**		 * Indicates whether the specular method is used.		 */
		public function get usingSpecularMethod():Boolean
		{
			return _usingSpecularMethod;
		}

		/**		 * The attributes that need to be animated by animators.		 */
		public function get animatableAttributes():Vector.<String>
		{
			return _pAnimatableAttributes;
		}

		/**		 * The target registers for animated properties, written to by the animators.		 */
		public function get animationTargetRegisters():Vector.<String>
		{
			return _pAnimationTargetRegisters;
		}

		/**		 * Indicates whether the compiled shader uses normals.		 */
		public function get usesNormals():Boolean
		{
			return _pDependencyCounter.normalDependencies > 0 && _pMethodSetup._iNormalMethod.iHasOutput;
		}

		/**		 * Indicates whether the compiled shader uses lights.		 */
		public function pUsesLights():Boolean
		{
			return _pNumLights > 0 && (_combinedLightSources & LightSources.LIGHTS) != 0;
		}

		/**		 * Compiles the code for the methods.		 */
		public function pCompileMethods():void
		{
            var methods:Vector.<MethodVOSet> = _pMethodSetup._iMethods;//var methods:Vector.<MethodVOSet> = this._pMethodSetup._iMethods;

			var numMethods:Number = methods.length;
			var method:EffectMethodBase;
			var data:MethodVO;
			var alphaReg:ShaderRegisterElement;

            // TODO: AGAL <> GLSL

			if (_preserveAlpha)
            {
				alphaReg = _pRegisterCache.getFreeFragmentSingleTemp();
                _pRegisterCache.addFragmentTempUsages(alphaReg, 1);
                _pFragmentCode += "mov " + alphaReg.toString() + ", " + _pSharedRegisters.shadedTarget.toString() + ".w\n";
			}

			for (var i:Number = 0; i < numMethods; ++i)
            {

				method = methods[i].method;
				data = methods[i].data;

				_pVertexCode += method.iGetVertexCode( data, _pRegisterCache);

				if (data.needsGlobalVertexPos || data.needsGlobalFragmentPos)
                    _pRegisterCache.removeVertexTempUsage(_pSharedRegisters.globalPositionVertex);

                _pFragmentCode += method.iGetFragmentCode(data, _pRegisterCache, _pSharedRegisters.shadedTarget);

				if (data.needsNormals)
					_pRegisterCache.removeFragmentTempUsage(_pSharedRegisters.normalFragment);

				if (data.needsView)
                    _pRegisterCache.removeFragmentTempUsage(_pSharedRegisters.viewDirFragment);
			}

			if (_preserveAlpha)
            {

                _pFragmentCode += "mov " + _pSharedRegisters.shadedTarget.toString() + ".w, " + alphaReg.toString() + "\n";

                _pRegisterCache.removeFragmentTempUsage(alphaReg);

			}

			if (_pMethodSetup._iColorTransformMethod)
            {

                _pVertexCode += _pMethodSetup._iColorTransformMethod.iGetVertexCode(_pMethodSetup._iColorTransformMethodVO, _pRegisterCache);
                _pFragmentCode += _pMethodSetup._iColorTransformMethod.iGetFragmentCode(_pMethodSetup._iColorTransformMethodVO, _pRegisterCache, _pSharedRegisters.shadedTarget);

			}
		}

		/**		 * Indices for the light probe diffuse textures.		 */
		public function get lightProbeDiffuseIndices():Vector.<Number> /*uint*/		{
			return _pLightProbeDiffuseIndices;
		}

		/**		 * Indices for the light probe specular textures.		 */
		public function get lightProbeSpecularIndices():Vector.<Number> /*uint*/		{
			return _pLightProbeSpecularIndices;
		}
	}
}
