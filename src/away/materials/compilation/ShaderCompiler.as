///<reference path="../../_definitions.ts"/>

package away.materials.compilation
{
	import away.materials.methods.ShaderMethodSetup;
	import away.materials.methods.MethodVOSet;
	import away.materials.methods.ShadingMethodBase;
	import away.materials.methods.MethodVO;
	import away.materials.LightSources;
	import away.materials.methods.EffectMethodBase;

	/**
	public class ShaderCompiler
	{
        public var _pSharedRegisters:ShaderRegisterData;// PROTECTED
		private var _smooth:Boolean;
		private var _repeat:Boolean;
		private var _mipmap:Boolean;
		public var _pEnableLightFallOff:Boolean;
		private var _preserveAlpha:Boolean = true;
		private var _animateUVs:Boolean;
		public var _pAlphaPremultiplied:Boolean; // PROTECTED
		private var _fragmentConstantData:Vector.<Number>;

		public var _pVertexCode:String = ''; // Changed to emtpy string- AwayTS
		private var _fragmentPostLightCode:String;
		private var _commonsDataIndex:Number = -1;

		public var _pAnimatableAttributes:Vector.<String>; // PROTECTED
		public var _pLightProbeDiffuseIndices:Vector.<Number>/*uint*/;
        public var _pLightProbeSpecularIndices:Vector.<Number>/*uint*/;
		private var _uvBufferIndex:Number = -1;
		private var _uvTransformIndex:Number = -1;
		private var _secondaryUVBufferIndex:Number = -1;
		public var _pNormalBufferIndex:Number = -1; // PROTECTED
		public var _pSceneNormalMatrixIndex:Number = -1; //PROTECTED
		private var _specularLightSources:Number;
		private var _diffuseLightSources:Number;

		public var _pNumLights:Number;  // PROTECTED
		public var _pNumProbeRegisters:Number; // PROTECTED

		public var _usingSpecularMethod:Boolean;

		private var _needUVAnimation:Boolean;
		private var _UVTarget:String;
		private var _UVSource:String;

		public var _pProfile:String;

		private var _forceSeperateMVP:Boolean;

		/**
		public function ShaderCompiler(profile:String):void
		{
			this._pSharedRegisters = new ShaderRegisterData();
            this._pDependencyCounter = new MethodDependencyCounter();
            this._pProfile = profile;
            this.initRegisterCache(profile);
		}

		/**
		public function get enableLightFallOff():Boolean
		{
			return _pEnableLightFallOff;
		}

		public function set enableLightFallOff(value:Boolean):void
		{
            this._pEnableLightFallOff = value;
		}

		/**
		public function get needUVAnimation():Boolean
		{
			return _needUVAnimation;
		}

		/**
		public function get UVTarget():String
		{
			return _UVTarget;
		}

		/**
		public function get UVSource():String
		{
			return _UVSource;
		}

		/**
		public function get forceSeperateMVP():Boolean
		{
			return _forceSeperateMVP;
		}

		public function set forceSeperateMVP(value:Boolean):void
		{
            this._forceSeperateMVP = value;
		}

		/**
		private function initRegisterCache(profile:String):void
		{
            _pRegisterCache = new ShaderRegisterCache(profile);
            _pRegisterCache.vertexAttributesOffset = 1;
            _pRegisterCache.reset();
		}

		/**
		public function get animateUVs():Boolean
		{
			return _animateUVs;
		}

		public function set animateUVs(value:Boolean):void
		{
            this._animateUVs = value;
		}

		/**
		public function get alphaPremultiplied():Boolean
		{
			return _pAlphaPremultiplied;
		}

		public function set alphaPremultiplied(value:Boolean):void
		{
            this._pAlphaPremultiplied = value;
		}

		/**
		public function get preserveAlpha():Boolean
		{
			return _preserveAlpha;
		}

		public function set preserveAlpha(value:Boolean):void
		{
            this._preserveAlpha = value;
		}

		/**
		public function setTextureSampling(smooth:Boolean, repeat:Boolean, mipmap:Boolean):void
		{
            _smooth = smooth;
            _repeat = repeat;
            _mipmap = mipmap;
		}

		/**
		public function setConstantDataBuffers(vertexConstantData:Vector.<Number>, fragmentConstantData:Vector.<Number>):void
		{
            _vertexConstantData = vertexConstantData;
            _fragmentConstantData = fragmentConstantData;
		}

		/**
		public function get methodSetup():ShaderMethodSetup
		{
			return _pMethodSetup;
		}

		public function set methodSetup(value:ShaderMethodSetup):void
		{
            this._pMethodSetup = value;
		}

		/**
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

		/**
		public function pCreateNormalRegisters():void
		{

		}

		/**
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

		/**
		public function pCompileLightingCode():void
		{

		}

		/**
		public function pCompileViewDirCode():void
		{

		}

		/**
		public function pCompileNormalCode():void
		{

		}

		/**
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

		/**
		private function compileSecondaryUVCode():void
		{
            // TODO: AGAL <> GLSL

			var uvAttributeReg:ShaderRegisterElement = _pRegisterCache.getFreeVertexAttribute();
            _secondaryUVBufferIndex = uvAttributeReg.index;
            _pSharedRegisters.secondaryUVVarying = _pRegisterCache.getFreeVarying();
            _pVertexCode += "mov " + _pSharedRegisters.secondaryUVVarying.toString() + ", " + uvAttributeReg.toString() + "\n";
		}

		/**
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

		/**
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

		/**
		private function compileFragmentOutput():void
		{
            // TODO: AGAL <> GLSL

			_pFragmentCode += "mov " + _pRegisterCache.fragmentOutputRegister.toString() + ", " + _pSharedRegisters.shadedTarget.toString() + "\n";
            _pRegisterCache.removeFragmentTempUsage(_pSharedRegisters.shadedTarget);
		}

		/**
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

		/**
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

		/**
		private function createCommons():void
		{
			_pSharedRegisters.commons = _pRegisterCache.getFreeFragmentConstant();
            _commonsDataIndex = _pSharedRegisters.commons.index*4;
		}

		/**
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

		/**
		private function setupAndCountMethodDependencies(method:ShadingMethodBase, methodVO:MethodVO):void
		{
			setupMethod(method, methodVO);
			_pDependencyCounter.includeMethodVO(methodVO);
		}

		/**
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

		/**
		public function get commonsDataIndex():Number
		{
			return _commonsDataIndex;
		}

		/**
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

		/**
		public function get numUsedVertexConstants():Number
		{
			return _pRegisterCache.numUsedVertexConstants;
		}

		/**
		public function get numUsedFragmentConstants():Number
		{
			return _pRegisterCache.numUsedFragmentConstants;
		}

		/**
		public function get numUsedStreams():Number
		{
			return _pRegisterCache.numUsedStreams;
		}

		/**
		public function get numUsedTextures():Number
		{
			return _pRegisterCache.numUsedTextures;
		}

		/**
		public function get numUsedVaryings():Number
		{
			return _pRegisterCache.numUsedVaryings;
		}

		/**
		public function pUsesLightsForSpecular():Boolean
		{
			return _pNumLights > 0 && ( _specularLightSources & LightSources.LIGHTS) != 0;
		}

		/**
		public function pUsesLightsForDiffuse():Boolean
		{
			return _pNumLights > 0 && ( _diffuseLightSources & LightSources.LIGHTS) != 0;
		}

		/**
		public function dispose():void
		{
			cleanUpMethods();
			_pRegisterCache.dispose();
			_pRegisterCache = null;
			_pSharedRegisters = null;
		}

		/**
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

		/**
		public function get specularLightSources():Number
		{
			return _specularLightSources;
		}

		public function set specularLightSources(value:Number):void
		{
            this._specularLightSources = value;
		}

		/**
		public function get diffuseLightSources():Number
		{
			return _diffuseLightSources;
		}

		public function set diffuseLightSources(value:Number):void
		{
			this._diffuseLightSources = value;
		}

		/**
		public function pUsesProbesForSpecular():Boolean
		{
			return _pNumLightProbes > 0 && (_specularLightSources & LightSources.PROBES) != 0;
		}

		/**
		public function pUsesProbesForDiffuse():Boolean
		{
			return _pNumLightProbes > 0 && (_diffuseLightSources & LightSources.PROBES) != 0;
		}

		/**
		public function pUsesProbes():Boolean
		{
			return _pNumLightProbes > 0 && ((_diffuseLightSources | _specularLightSources) & LightSources.PROBES) != 0;
		}

		/**
		public function get uvBufferIndex():Number
		{
			return _uvBufferIndex;
		}

		/**
		public function get uvTransformIndex():Number
		{
			return _uvTransformIndex;
		}

		/**
		public function get secondaryUVBufferIndex():Number
		{
			return _secondaryUVBufferIndex;
		}

		/**
		public function get normalBufferIndex():Number
		{
			return _pNormalBufferIndex;
		}

		/**
		public function get tangentBufferIndex():Number
		{
			return _pTangentBufferIndex;
		}

		/**
		public function get lightFragmentConstantIndex():Number
		{
			return _pLightFragmentConstantIndex;
		}

		/**
		public function get cameraPositionIndex():Number
		{
			return _pCameraPositionIndex;
		}

		/**
		public function get sceneMatrixIndex():Number
		{
			return _sceneMatrixIndex;
		}

		/**
		public function get sceneNormalMatrixIndex():Number
		{
			return _pSceneNormalMatrixIndex;
		}

		/**
		public function get probeWeightsIndex():Number
		{
			return _pProbeWeightsIndex;
		}

		/**
		public function get vertexCode():String
		{
			return _pVertexCode;
		}

		/**
		public function get fragmentCode():String
		{
			return _pFragmentCode;
		}

		/**
		public function get fragmentLightCode():String
		{
			return _fragmentLightCode;
		}

		/**
		public function get fragmentPostLightCode():String
		{
			return _fragmentPostLightCode;
		}

		/**
		public function get shadedTarget():String
		{
			return _pSharedRegisters.shadedTarget.toString();
		}

		/**
		public function get numPointLights():Number
		{
			return _pNumPointLights;
		}

		public function set numPointLights(numPointLights:Number):void
		{
            this._pNumPointLights = numPointLights;
		}

		/**
		public function get numDirectionalLights():Number
		{
			return _pNumDirectionalLights;
		}

		public function set numDirectionalLights(value:Number):void
		{
            this._pNumDirectionalLights = value;
		}

		/**
		public function get numLightProbes():Number
		{
			return _pNumLightProbes;
		}

		public function set numLightProbes(value:Number):void
		{
            this._pNumLightProbes = value;
		}

		/**
		public function get usingSpecularMethod():Boolean
		{
			return _usingSpecularMethod;
		}

		/**
		public function get animatableAttributes():Vector.<String>
		{
			return _pAnimatableAttributes;
		}

		/**
		public function get animationTargetRegisters():Vector.<String>
		{
			return _pAnimationTargetRegisters;
		}

		/**
		public function get usesNormals():Boolean
		{
			return _pDependencyCounter.normalDependencies > 0 && _pMethodSetup._iNormalMethod.iHasOutput;
		}

		/**
		public function pUsesLights():Boolean
		{
			return _pNumLights > 0 && (_combinedLightSources & LightSources.LIGHTS) != 0;
		}

		/**
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

		/**
		public function get lightProbeDiffuseIndices():Vector.<Number> /*uint*/		{
			return _pLightProbeDiffuseIndices;
		}

		/**
		public function get lightProbeSpecularIndices():Vector.<Number> /*uint*/		{
			return _pLightProbeSpecularIndices;
		}
	}
}