/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

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
        public var _pSharedRegisters:ShaderRegisterData;// PROTECTED
        public var _pRegisterCache:ShaderRegisterCache;// PROTECTED
		public var _pDependencyCounter:MethodDependencyCounter;// PROTECTED
        public var _pMethodSetup:ShaderMethodSetup;// PROTECTED

		private var _smooth:Boolean = false;
		private var _repeat:Boolean = false;
		private var _mipmap:Boolean = false;
		public var _pEnableLightFallOff:Boolean = false;
		private var _preserveAlpha:Boolean = true;
		private var _animateUVs:Boolean = false;
		public var _pAlphaPremultiplied:Boolean = false;// PROTECTED
		private var _vertexConstantData:Vector.<Number>;
		private var _fragmentConstantData:Vector.<Number>;

		public var _pVertexCode:String = '';
        public var _pFragmentCode:String = '';
		private var _fragmentLightCode:String = null;
		private var _fragmentPostLightCode:String = null;
		private var _commonsDataIndex:Number = -1;

		public var _pAnimatableAttributes:Vector.<String>;// PROTECTED
		public var _pAnimationTargetRegisters:Vector.<String>;// PROTECTED

		public var _pLightProbeDiffuseIndices:Vector.<Number>;/*uint*/
        public var _pLightProbeSpecularIndices:Vector.<Number>;/*uint*/
		private var _uvBufferIndex:Number = -1;
		private var _uvTransformIndex:Number = -1;
		private var _secondaryUVBufferIndex:Number = -1;
		public var _pNormalBufferIndex:Number = -1;// PROTECTED
		public var _pTangentBufferIndex:Number = -1;// PROTECTED
		public var _pLightFragmentConstantIndex:Number = -1;//PROTECTED
		private var _sceneMatrixIndex:Number = -1;
		public var _pSceneNormalMatrixIndex:Number = -1;//PROTECTED
		public var _pCameraPositionIndex:Number = -1;// PROTECTED
		public var _pProbeWeightsIndex:Number = -1;// PROTECTED

		private var _specularLightSources:Number = 0;
		private var _diffuseLightSources:Number = 0;

		public var _pNumLights:Number = 0;// PROTECTED
		public var _pNumLightProbes:Number = 0;// PROTECTED
		public var _pNumPointLights:Number = 0;// PROTECTED
		public var _pNumDirectionalLights:Number = 0;// PROTECTED

		public var _pNumProbeRegisters:Number = 0;// PROTECTED
		private var _combinedLightSources:Number = 0;

		public var _usingSpecularMethod:Boolean = false;

		private var _needUVAnimation:Boolean = false;
		private var _UVTarget:String = null;
		private var _UVSource:String = null;

		public var _pProfile:String = null;

		private var _forceSeperateMVP:Boolean = false;

		/**		 * Creates a new ShaderCompiler object.		 * @param profile The compatibility profile of the renderer.		 */
		public function ShaderCompiler(profile:String):void
		{
			this._pSharedRegisters = new ShaderRegisterData();
            this._pDependencyCounter = new MethodDependencyCounter();
            this._pProfile = profile;
            this.initRegisterCache(profile);
		}

		/**		 * Whether or not to use fallOff and radius properties for lights. This can be used to improve performance and		 * compatibility for constrained mode.		 */
		public function get enableLightFallOff():Boolean
		{
			return this._pEnableLightFallOff;
		}

		public function set enableLightFallOff(value:Boolean):void
		{
            this._pEnableLightFallOff = value;
		}

		/**		 * Indicates whether the compiled code needs UV animation.		 */
		public function get needUVAnimation():Boolean
		{
			return this._needUVAnimation;
		}

		/**		 * The target register to place the animated UV coordinate.		 */
		public function get UVTarget():String
		{
			return this._UVTarget;
		}

		/**		 * The souce register providing the UV coordinate to animate.		 */
		public function get UVSource():String
		{
			return this._UVSource;
		}

		/**		 * Indicates whether the screen projection should be calculated by forcing a separate scene matrix and		 * view-projection matrix. This is used to prevent rounding errors when using multiple passes with different		 * projection code.		 */
		public function get forceSeperateMVP():Boolean
		{
			return this._forceSeperateMVP;
		}

		public function set forceSeperateMVP(value:Boolean):void
		{
            this._forceSeperateMVP = value;
		}

		/**		 * Initialized the register cache.		 * @param profile The compatibility profile of the renderer.		 */
		private function initRegisterCache(profile:String):void
		{
            this._pRegisterCache = new ShaderRegisterCache(profile);
            this._pRegisterCache.vertexAttributesOffset = 1;
            this._pRegisterCache.reset();
		}

		/**		 * Indicate whether UV coordinates need to be animated using the renderable's transformUV matrix.		 */
		public function get animateUVs():Boolean
		{
			return this._animateUVs;
		}

		public function set animateUVs(value:Boolean):void
		{
            this._animateUVs = value;
		}

		/**		 * Indicates whether visible textures (or other pixels) used by this material have		 * already been premultiplied.		 */
		public function get alphaPremultiplied():Boolean
		{
			return this._pAlphaPremultiplied;
		}

		public function set alphaPremultiplied(value:Boolean):void
		{
            this._pAlphaPremultiplied = value;
		}

		/**		 * Indicates whether the output alpha value should remain unchanged compared to the material's original alpha.		 */
		public function get preserveAlpha():Boolean
		{
			return this._preserveAlpha;
		}

		public function set preserveAlpha(value:Boolean):void
		{
            this._preserveAlpha = value;
		}

		/**		 * Sets the default texture sampling properties.		 * @param smooth Indicates whether the texture should be filtered when sampled. Defaults to true.		 * @param repeat Indicates whether the texture should be tiled when sampled. Defaults to true.		 * @param mipmap Indicates whether or not any used textures should use mipmapping. Defaults to true.		 */
		public function setTextureSampling(smooth:Boolean, repeat:Boolean, mipmap:Boolean):void
		{
            this._smooth = smooth;
            this._repeat = repeat;
            this._mipmap = mipmap;
		}

		/**		 * Sets the constant buffers allocated by the material. This allows setting constant data during compilation.		 * @param vertexConstantData The vertex constant data buffer.		 * @param fragmentConstantData The fragment constant data buffer.		 */
		public function setConstantDataBuffers(vertexConstantData:Vector.<Number>, fragmentConstantData:Vector.<Number>):void
		{
            this._vertexConstantData = vertexConstantData;
            this._fragmentConstantData = fragmentConstantData;
		}

		/**		 * The shader method setup object containing the method configuration and their value objects for the material being compiled.		 */
		public function get methodSetup():ShaderMethodSetup
		{
			return this._pMethodSetup;
		}

		public function set methodSetup(value:ShaderMethodSetup):void
		{
            this._pMethodSetup = value;
		}

		/**		 * Compiles the code after all setup on the compiler has finished.		 */
		public function compile():void
		{
			this.pInitRegisterIndices();
			this.pInitLightData();

			this._pAnimatableAttributes = new <String>[ 'va0' ];//Vector.<String>(["va0"]);
            this._pAnimationTargetRegisters = new <String>[ 'vt0' ];//Vector.<String>(["vt0"]);
            this._pVertexCode = "";
            this._pFragmentCode = "";

            this._pSharedRegisters.localPosition = this._pRegisterCache.getFreeVertexVectorTemp();
            this._pRegisterCache.addVertexTempUsages( this._pSharedRegisters.localPosition, 1);

            this.createCommons();
            this.pCalculateDependencies();
            this.updateMethodRegisters();

			for (var i:Number = 0; i < 4; ++i)
                this._pRegisterCache.getFreeVertexConstant();

            this.pCreateNormalRegisters();

			if (this._pDependencyCounter.globalPosDependencies > 0 || this._forceSeperateMVP)
                this.pCompileGlobalPositionCode();

            this.compileProjectionCode();
            this.pCompileMethodsCode();
            this.compileFragmentOutput();
            this._fragmentPostLightCode = this.fragmentCode;
		}

		/**		 * Creates the registers to contain the normal data.		 */
		public function pCreateNormalRegisters():void
		{

		}

		/**		 * Compile the code for the methods.		 */
		public function pCompileMethodsCode():void
		{
			if (this._pDependencyCounter.uvDependencies > 0)
                this.compileUVCode();

			if (this._pDependencyCounter.secondaryUVDependencies > 0)
                this.compileSecondaryUVCode();

			if (this._pDependencyCounter.normalDependencies > 0)
                this.pCompileNormalCode();

			if (this._pDependencyCounter.viewDirDependencies > 0)
                this.pCompileViewDirCode();

            this.pCompileLightingCode();
            this._fragmentLightCode = this._pFragmentCode;
            this._pFragmentCode = "";
            this.pCompileMethods();
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
			var uvAttributeReg:ShaderRegisterElement = this._pRegisterCache.getFreeVertexAttribute();
			this._uvBufferIndex = uvAttributeReg.index;

			var varying:ShaderRegisterElement = this._pRegisterCache.getFreeVarying();

			this._pSharedRegisters.uvVarying = varying;

			if (this.animateUVs)
            {

				// a, b, 0, tx
				// c, d, 0, ty
				var uvTransform1:ShaderRegisterElement = this._pRegisterCache.getFreeVertexConstant();
				var uvTransform2:ShaderRegisterElement = this._pRegisterCache.getFreeVertexConstant();
                this._uvTransformIndex = uvTransform1.index*4;

                // TODO: AGAL <> GLSL

                this._pVertexCode += "dp4 " + varying.toString() + ".x, " + uvAttributeReg.toString() + ", " + uvTransform1.toString() + "\n" +
					"dp4 " + varying.toString() + ".y, " + uvAttributeReg.toString() + ", " + uvTransform2.toString() + "\n" +
					"mov " + varying.toString() + ".zw, " + uvAttributeReg.toString() + ".zw \n";

			}
            else
            {

				this._uvTransformIndex = -1;
                this._needUVAnimation = true;
                this._UVTarget = varying.toString();
                this._UVSource = uvAttributeReg.toString();

			}
		}

		/**		 * Provide the secondary UV coordinates.		 */
		private function compileSecondaryUVCode():void
		{
            // TODO: AGAL <> GLSL

			var uvAttributeReg:ShaderRegisterElement = this._pRegisterCache.getFreeVertexAttribute();
            this._secondaryUVBufferIndex = uvAttributeReg.index;
            this._pSharedRegisters.secondaryUVVarying = this._pRegisterCache.getFreeVarying();
            this._pVertexCode += "mov " + this._pSharedRegisters.secondaryUVVarying.toString() + ", " + uvAttributeReg.toString() + "\n";
		}

		/**		 * Compile the world-space position.		 */
		public function pCompileGlobalPositionCode():void
		{

            // TODO: AGAL <> GLSL

			this._pSharedRegisters.globalPositionVertex = this._pRegisterCache.getFreeVertexVectorTemp();
            this._pRegisterCache.addVertexTempUsages(this._pSharedRegisters.globalPositionVertex, this._pDependencyCounter.globalPosDependencies);
			var positionMatrixReg:ShaderRegisterElement = this._pRegisterCache.getFreeVertexConstant();
            this._pRegisterCache.getFreeVertexConstant();
            this._pRegisterCache.getFreeVertexConstant();
            this._pRegisterCache.getFreeVertexConstant();
            this._sceneMatrixIndex = positionMatrixReg.index*4;

            this._pVertexCode += "m44 " + this._pSharedRegisters.globalPositionVertex.toString() + ", " + this._pSharedRegisters.localPosition.toString() + ", " + positionMatrixReg.toString() + "\n";

			if (this._pDependencyCounter.usesGlobalPosFragment)
            {

                this._pSharedRegisters.globalPositionVarying = this._pRegisterCache.getFreeVarying();
                this._pVertexCode += "mov " + this._pSharedRegisters.globalPositionVarying.toString() + ", " + this._pSharedRegisters.globalPositionVertex.toString() + "\n";

			}
		}

		/**		 * Get the projection coordinates.		 */
		private function compileProjectionCode():void
		{
			var pos:String = this._pDependencyCounter.globalPosDependencies > 0 || this._forceSeperateMVP? this._pSharedRegisters.globalPositionVertex.toString() : this._pAnimationTargetRegisters[0];
			var code:String;

            // TODO: AGAL <> GLSL

			if (this._pDependencyCounter.projectionDependencies > 0)
            {

                this._pSharedRegisters.projectionFragment = this._pRegisterCache.getFreeVarying();

				code = "m44 vt5, " + pos + ", vc0		\n" +
					"mov " + this._pSharedRegisters.projectionFragment.toString() + ", vt5\n" +
					"mov op, vt5\n";
			}
            else
            {

                code = "m44 op, " + pos + ", vc0		\n";

            }


            this._pVertexCode += code;

		}

		/**		 * Assign the final output colour the the output register.		 */
		private function compileFragmentOutput():void
		{
            // TODO: AGAL <> GLSL

			this._pFragmentCode += "mov " + this._pRegisterCache.fragmentOutputRegister.toString() + ", " + this._pSharedRegisters.shadedTarget.toString() + "\n";
            this._pRegisterCache.removeFragmentTempUsage(this._pSharedRegisters.shadedTarget);
		}

		/**		 * Reset all the indices to "unused".		 */
		public function pInitRegisterIndices():void
		{
			this._commonsDataIndex = -1;
            this._pCameraPositionIndex = -1;
            this._uvBufferIndex = -1;
            this._uvTransformIndex = -1;
            this._secondaryUVBufferIndex = -1;
            this._pNormalBufferIndex = -1;
            this._pTangentBufferIndex = -1;
            this._pLightFragmentConstantIndex = -1;
            this._sceneMatrixIndex = -1;
            this._pSceneNormalMatrixIndex = -1;
            this._pProbeWeightsIndex = -1;

		}

		/**		 * Prepares the setup for the light code.		 */
		public function pInitLightData():void
		{
            this._pNumLights = this._pNumPointLights + this._pNumDirectionalLights;
            this._pNumProbeRegisters = Math.ceil(this._pNumLightProbes/4);


			if (this._pMethodSetup._iSpecularMethod)
            {

                this._combinedLightSources = this._specularLightSources | this._diffuseLightSources;

            }
			else
            {

                this._combinedLightSources = this._diffuseLightSources;

            }

            this._usingSpecularMethod = Boolean(this._pMethodSetup._iSpecularMethod && (
                this.pUsesLightsForSpecular() ||
                this.pUsesProbesForSpecular()));

		}

		/**		 * Create the commonly shared constant register.		 */
		private function createCommons():void
		{
			this._pSharedRegisters.commons = this._pRegisterCache.getFreeFragmentConstant();
            this._commonsDataIndex = this._pSharedRegisters.commons.index*4;
		}

		/**		 * Figure out which named registers are required, and how often.		 */
		public function pCalculateDependencies():void
		{
            this._pDependencyCounter.reset();



			var methods:Vector.<MethodVOSet> = this._pMethodSetup._iMethods;//Vector.<MethodVOSet>
			var len:Number;

			this.setupAndCountMethodDependencies(this._pMethodSetup._iDiffuseMethod, this._pMethodSetup._iDiffuseMethodVO);


			if (this._pMethodSetup._iShadowMethod)
				this.setupAndCountMethodDependencies(this._pMethodSetup._iShadowMethod, this._pMethodSetup._iShadowMethodVO);


			this.setupAndCountMethodDependencies(this._pMethodSetup._iAmbientMethod, this._pMethodSetup._iAmbientMethodVO);

			if (this._usingSpecularMethod)
				this.setupAndCountMethodDependencies(this._pMethodSetup._iSpecularMethod, this._pMethodSetup._iSpecularMethodVO);

			if (this._pMethodSetup._iColorTransformMethod)
				this.setupAndCountMethodDependencies(this._pMethodSetup._iColorTransformMethod, this._pMethodSetup._iColorTransformMethodVO);

			len = methods.length;

			for (var i:Number = 0; i < len; ++i)
				this.setupAndCountMethodDependencies(methods[i].method, methods[i].data);

			if (this.usesNormals)
				this.setupAndCountMethodDependencies(this._pMethodSetup._iNormalMethod, this._pMethodSetup._iNormalMethodVO);

			// todo: add spotlights to count check
			this._pDependencyCounter.setPositionedLights(this._pNumPointLights, this._combinedLightSources);

		}

		/**		 * Counts the dependencies for a given method.		 * @param method The method to count the dependencies for.		 * @param methodVO The method's data for this material.		 */
		private function setupAndCountMethodDependencies(method:ShadingMethodBase, methodVO:MethodVO):void
		{
			this.setupMethod(method, methodVO);
			this._pDependencyCounter.includeMethodVO(methodVO);
		}

		/**		 * Assigns all prerequisite data for the methods, so we can calculate dependencies for them.		 */
		private function setupMethod(method:ShadingMethodBase, methodVO:MethodVO):void
		{
			method.iReset();
			methodVO.reset();

			methodVO.vertexData = this._vertexConstantData;
			methodVO.fragmentData = this._fragmentConstantData;
			methodVO.useSmoothTextures = this._smooth;
			methodVO.repeatTextures = this._repeat;
			methodVO.useMipmapping = this._mipmap;
			methodVO.useLightFallOff = this._pEnableLightFallOff && this._pProfile != "baselineConstrained";
			methodVO.numLights = this._pNumLights + this._pNumLightProbes;

			method.iInitVO(methodVO);
		}

		/**		 * The index for the common data register.		 */
		public function get commonsDataIndex():Number
		{
			return this._commonsDataIndex;
		}

		/**		 * Assigns the shared register data to all methods.		 */
		private function updateMethodRegisters():void
		{
			this._pMethodSetup._iNormalMethod.iSharedRegisters= this._pSharedRegisters;
            this._pMethodSetup._iDiffuseMethod.iSharedRegisters = this._pSharedRegisters;

			if (this._pMethodSetup._iShadowMethod)
                this._pMethodSetup._iShadowMethod.iSharedRegisters = this._pSharedRegisters;

            this._pMethodSetup._iAmbientMethod.iSharedRegisters = this._pSharedRegisters;

			if (this._pMethodSetup._iSpecularMethod)
                this._pMethodSetup._iSpecularMethod.iSharedRegisters = this._pSharedRegisters;

			if (this._pMethodSetup._iColorTransformMethod)
                this._pMethodSetup._iColorTransformMethod.iSharedRegisters = this._pSharedRegisters;


            var methods : Vector.<MethodVOSet> = this._pMethodSetup._iMethods;//var methods:Vector.<MethodVOSet> = _pMethodSetup._methods;

			var len:Number = methods.length;

			for (var i:Number = 0; i < len; ++i)
            {

                methods[i].method.iSharedRegisters = this._pSharedRegisters;

            }


		}

		/**		 * The amount of vertex constants used by the material. Any animation code to be added can append its vertex		 * constant data after this.		 */
		public function get numUsedVertexConstants():Number
		{
			return this._pRegisterCache.numUsedVertexConstants;
		}

		/**		 * The amount of fragment constants used by the material. Any animation code to be added can append its vertex		 * constant data after this.		 */
		public function get numUsedFragmentConstants():Number
		{
			return this._pRegisterCache.numUsedFragmentConstants;
		}

		/**		 * The amount of vertex attribute streams used by the material. Any animation code to be added can add its		 * streams after this. Also used to automatically disable attribute slots on pass deactivation.		 */
		public function get numUsedStreams():Number
		{
			return this._pRegisterCache.numUsedStreams;
		}

		/**		 * The amount of textures used by the material. Used to automatically disable texture slots on pass deactivation.		 */
		public function get numUsedTextures():Number
		{
			return this._pRegisterCache.numUsedTextures;
		}

		/**		 * Number of used varyings. Any animation code to be added can add its used varyings after this.		 */
		public function get numUsedVaryings():Number
		{
			return this._pRegisterCache.numUsedVaryings;
		}

		/**		 * Indicates whether lights are used for specular reflections.		 */
		public function pUsesLightsForSpecular():Boolean
		{
			return this._pNumLights > 0 && ( this._specularLightSources & LightSources.LIGHTS) != 0;
		}

		/**		 * Indicates whether lights are used for diffuse reflections.		 */
		public function pUsesLightsForDiffuse():Boolean
		{
			return this._pNumLights > 0 && ( this._diffuseLightSources & LightSources.LIGHTS) != 0;
		}

		/**		 * Disposes all resources used by the compiler.		 */
		public function dispose():void
		{
			this.cleanUpMethods();
			this._pRegisterCache.dispose();
			this._pRegisterCache = null;
			this._pSharedRegisters = null;
		}

		/**		 * Clean up method's compilation data after compilation finished.		 */
		private function cleanUpMethods():void
		{
			if (this._pMethodSetup._iNormalMethod)
                this._pMethodSetup._iNormalMethod.iCleanCompilationData();

			if (this._pMethodSetup._iDiffuseMethod)
                this._pMethodSetup._iDiffuseMethod.iCleanCompilationData();

			if (this._pMethodSetup._iAmbientMethod)
                this._pMethodSetup._iAmbientMethod.iCleanCompilationData();

			if (this._pMethodSetup._iSpecularMethod)
                this._pMethodSetup._iSpecularMethod.iCleanCompilationData();

			if (this._pMethodSetup._iShadowMethod)
                this._pMethodSetup._iShadowMethod.iCleanCompilationData();

			if (this._pMethodSetup._iColorTransformMethod)
                this._pMethodSetup._iColorTransformMethod.iCleanCompilationData();

            var methods:Vector.<MethodVOSet>= this._pMethodSetup._iMethods;//var methods:Vector.<MethodVOSet> = _pMethodSetup._methods;

			var len:Number = methods.length;

			for (var i:Number = 0; i < len; ++i)
            {

                methods[i].method.iCleanCompilationData();

            }

		}

		/**		 * Define which light source types to use for specular reflections. This allows choosing between regular lights		 * and/or light probes for specular reflections.		 *		 * @see away3d.materials.LightSources		 */
		public function get specularLightSources():Number
		{
			return this._specularLightSources;
		}

		public function set specularLightSources(value:Number):void
		{
            this._specularLightSources = value;
		}

		/**		 * Define which light source types to use for diffuse reflections. This allows choosing between regular lights		 * and/or light probes for diffuse reflections.		 *		 * @see away3d.materials.LightSources		 */
		public function get diffuseLightSources():Number
		{
			return this._diffuseLightSources;
		}

		public function set diffuseLightSources(value:Number):void
		{
			this._diffuseLightSources = value;
		}

		/**		 * Indicates whether light probes are being used for specular reflections.		 */
		public function pUsesProbesForSpecular():Boolean
		{
			return this._pNumLightProbes > 0 && (this._specularLightSources & LightSources.PROBES) != 0;
		}

		/**		 * Indicates whether light probes are being used for diffuse reflections.		 */
		public function pUsesProbesForDiffuse():Boolean
		{
			return this._pNumLightProbes > 0 && (this._diffuseLightSources & LightSources.PROBES) != 0;
		}

		/**		 * Indicates whether any light probes are used.		 */
		public function pUsesProbes():Boolean
		{
			return this._pNumLightProbes > 0 && ((this._diffuseLightSources | this._specularLightSources) & LightSources.PROBES) != 0;
		}

		/**		 * The index for the UV vertex attribute stream.		 */
		public function get uvBufferIndex():Number
		{
			return this._uvBufferIndex;
		}

		/**		 * The index for the UV transformation matrix vertex constant.		 */
		public function get uvTransformIndex():Number
		{
			return this._uvTransformIndex;
		}

		/**		 * The index for the secondary UV vertex attribute stream.		 */
		public function get secondaryUVBufferIndex():Number
		{
			return this._secondaryUVBufferIndex;
		}

		/**		 * The index for the vertex normal attribute stream.		 */
		public function get normalBufferIndex():Number
		{
			return this._pNormalBufferIndex;
		}

		/**		 * The index for the vertex tangent attribute stream.		 */
		public function get tangentBufferIndex():Number
		{
			return this._pTangentBufferIndex;
		}

		/**		 * The first index for the fragment constants containing the light data.		 */
		public function get lightFragmentConstantIndex():Number
		{
			return this._pLightFragmentConstantIndex;
		}

		/**		 * The index of the vertex constant containing the camera position.		 */
		public function get cameraPositionIndex():Number
		{
			return this._pCameraPositionIndex;
		}

		/**		 * The index of the vertex constant containing the scene matrix.		 */
		public function get sceneMatrixIndex():Number
		{
			return this._sceneMatrixIndex;
		}

		/**		 * The index of the vertex constant containing the uniform scene matrix (the inverse transpose).		 */
		public function get sceneNormalMatrixIndex():Number
		{
			return this._pSceneNormalMatrixIndex;
		}

		/**		 * The index of the fragment constant containing the weights for the light probes.		 */
		public function get probeWeightsIndex():Number
		{
			return this._pProbeWeightsIndex;
		}

		/**		 * The generated vertex code.		 */
		public function get vertexCode():String
		{
			return this._pVertexCode;
		}

		/**		 * The generated fragment code.		 */
		public function get fragmentCode():String
		{
			return this._pFragmentCode;
		}

		/**		 * The code containing the lighting calculations.		 */
		public function get fragmentLightCode():String
		{
			return this._fragmentLightCode;
		}

		/**		 * The code containing the post-lighting calculations.		 */
		public function get fragmentPostLightCode():String
		{
			return this._fragmentPostLightCode;
		}

		/**		 * The register name containing the final shaded colour.		 */
		public function get shadedTarget():String
		{
			return this._pSharedRegisters.shadedTarget.toString();
		}

		/**		 * The amount of point lights that need to be supported.		 */
		public function get numPointLights():Number
		{
			return this._pNumPointLights;
		}

		public function set numPointLights(numPointLights:Number):void
		{
            this._pNumPointLights = numPointLights;
		}

		/**		 * The amount of directional lights that need to be supported.		 */
		public function get numDirectionalLights():Number
		{
			return this._pNumDirectionalLights;
		}

		public function set numDirectionalLights(value:Number):void
		{
            this._pNumDirectionalLights = value;
		}

		/**		 * The amount of light probes that need to be supported.		 */
		public function get numLightProbes():Number
		{
			return this._pNumLightProbes;
		}

		public function set numLightProbes(value:Number):void
		{
            this._pNumLightProbes = value;
		}

		/**		 * Indicates whether the specular method is used.		 */
		public function get usingSpecularMethod():Boolean
		{
			return this._usingSpecularMethod;
		}

		/**		 * The attributes that need to be animated by animators.		 */
		public function get animatableAttributes():Vector.<String>
		{
			return this._pAnimatableAttributes;
		}

		/**		 * The target registers for animated properties, written to by the animators.		 */
		public function get animationTargetRegisters():Vector.<String>
		{
			return this._pAnimationTargetRegisters;
		}

		/**		 * Indicates whether the compiled shader uses normals.		 */
		public function get usesNormals():Boolean
		{
			return this._pDependencyCounter.normalDependencies > 0 && this._pMethodSetup._iNormalMethod.iHasOutput;
		}

		/**		 * Indicates whether the compiled shader uses lights.		 */
		public function pUsesLights():Boolean
		{
			return this._pNumLights > 0 && (this._combinedLightSources & LightSources.LIGHTS) != 0;
		}

		/**		 * Compiles the code for the methods.		 */
		public function pCompileMethods():void
		{
            var methods:Vector.<MethodVOSet> = this._pMethodSetup._iMethods;//var methods:Vector.<MethodVOSet> = this._pMethodSetup._iMethods;

			var numMethods:Number = methods.length;
			var method:EffectMethodBase;
			var data:MethodVO;
			var alphaReg:ShaderRegisterElement;

            // TODO: AGAL <> GLSL

			if (this._preserveAlpha)
            {
				alphaReg = this._pRegisterCache.getFreeFragmentSingleTemp();
                this._pRegisterCache.addFragmentTempUsages(alphaReg, 1);
                this._pFragmentCode += "mov " + alphaReg.toString() + ", " + this._pSharedRegisters.shadedTarget.toString() + ".w\n";
			}

			for (var i:Number = 0; i < numMethods; ++i)
            {

				method = methods[i].method;
				data = methods[i].data;

				this._pVertexCode += method.iGetVertexCode( data, this._pRegisterCache);

				if (data.needsGlobalVertexPos || data.needsGlobalFragmentPos)
                    this._pRegisterCache.removeVertexTempUsage(this._pSharedRegisters.globalPositionVertex);

                this._pFragmentCode += method.iGetFragmentCode(data, this._pRegisterCache, this._pSharedRegisters.shadedTarget);

				if (data.needsNormals)
					this._pRegisterCache.removeFragmentTempUsage(this._pSharedRegisters.normalFragment);

				if (data.needsView)
                    this._pRegisterCache.removeFragmentTempUsage(this._pSharedRegisters.viewDirFragment);
			}

			if (this._preserveAlpha)
            {

                this._pFragmentCode += "mov " + this._pSharedRegisters.shadedTarget.toString() + ".w, " + alphaReg.toString() + "\n";

                this._pRegisterCache.removeFragmentTempUsage(alphaReg);

			}

			if (this._pMethodSetup._iColorTransformMethod)
            {

                this._pVertexCode += this._pMethodSetup._iColorTransformMethod.iGetVertexCode(this._pMethodSetup._iColorTransformMethodVO, this._pRegisterCache);
                this._pFragmentCode += this._pMethodSetup._iColorTransformMethod.iGetFragmentCode(this._pMethodSetup._iColorTransformMethodVO, this._pRegisterCache, this._pSharedRegisters.shadedTarget);

			}
		}

		/**		 * Indices for the light probe diffuse textures.		 */
		public function get lightProbeDiffuseIndices():Vector.<Number> /*uint*/		{
			return this._pLightProbeDiffuseIndices;
		}

		/**		 * Indices for the light probe specular textures.		 */
		public function get lightProbeSpecularIndices():Vector.<Number> /*uint*/		{
			return this._pLightProbeSpecularIndices;
		}
	}
}
