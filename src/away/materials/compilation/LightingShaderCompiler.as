///<reference path="../../_definitions.ts"/>

package away.materials.compilation
{
	//import away3d.arcane;

	/**	 * LightingShaderCompiler is a ShaderCompiler that generates code for passes performing shading only (no effect passes)	 */
	public class LightingShaderCompiler extends ShaderCompiler
	{
		public var _pointLightFragmentConstants:Vector.<ShaderRegisterElement>;
		public var _pointLightVertexConstants:Vector.<ShaderRegisterElement>;
		public var _dirLightFragmentConstants:Vector.<ShaderRegisterElement>;
		public var _dirLightVertexConstants:Vector.<ShaderRegisterElement>;
		private var _lightVertexConstantIndex:Number;
		private var _shadowRegister:ShaderRegisterElement;
		
		//use namespace arcane;

		/**		 * Create a new LightingShaderCompiler object.		 * @param profile The compatibility profile of the renderer.		 */
		public function LightingShaderCompiler(profile:String):void
		{
			super(profile);
		}

		/**		 * The starting index if the vertex constant to which light data needs to be uploaded.		 */
		public function get lightVertexConstantIndex():Number
		{
			return _lightVertexConstantIndex;
		}

		/**		 * @inheritDoc		 */
		override public function pInitRegisterIndices():void
		{
			super.pInitRegisterIndices();
            _lightVertexConstantIndex = -1;
		}

		/**		 * @inheritDoc		 */
		override public function pCreateNormalRegisters():void
		{
			// need to be created FIRST and in this order
			if (tangentSpace)
            {

				_pSharedRegisters.animatedTangent = _pRegisterCache.getFreeVertexVectorTemp();
                _pRegisterCache.addVertexTempUsages(_pSharedRegisters.animatedTangent, 1);
                _pSharedRegisters.bitangent = _pRegisterCache.getFreeVertexVectorTemp();
                _pRegisterCache.addVertexTempUsages(_pSharedRegisters.bitangent, 1);
				
				_pSharedRegisters.tangentInput = _pRegisterCache.getFreeVertexAttribute();
                _pTangentBufferIndex = _pSharedRegisters.tangentInput.index;
				
				_pAnimatableAttributes.push( _pSharedRegisters.tangentInput.toString());
				_pAnimationTargetRegisters.push(_pSharedRegisters.animatedTangent.toString());
			}
			
			_pSharedRegisters.normalInput = _pRegisterCache.getFreeVertexAttribute();
			_pNormalBufferIndex = _pSharedRegisters.normalInput.index;
			
			_pSharedRegisters.animatedNormal = _pRegisterCache.getFreeVertexVectorTemp();
			_pRegisterCache.addVertexTempUsages(_pSharedRegisters.animatedNormal, 1);
			
			_pAnimatableAttributes.push(_pSharedRegisters.normalInput.toString());
			_pAnimationTargetRegisters.push(_pSharedRegisters.animatedNormal.toString());
		}

		/**		 * Indicates whether or not lighting happens in tangent space. This is only the case if no world-space		 * dependencies exist.		 */
		public function get tangentSpace():Boolean
		{
			return _pNumLightProbes == 0 && _pMethodSetup._iNormalMethod.iHasOutput && _pMethodSetup._iNormalMethod.iTangentSpace;
		}

		/**		 * @inheritDoc		 */
		override public function pInitLightData():void
		{
			super.pInitLightData();
			
			_pointLightVertexConstants = new Vector.<ShaderRegisterElement>(_pNumPointLights );
			_pointLightFragmentConstants = new Vector.<ShaderRegisterElement>(_pNumPointLights*2 );

			if ( tangentSpace )
            {
				_dirLightVertexConstants = new Vector.<ShaderRegisterElement>(_pNumDirectionalLights );
				_dirLightFragmentConstants = new Vector.<ShaderRegisterElement>(_pNumDirectionalLights*2 );
			}
            else
            {
				_dirLightFragmentConstants = new Vector.<ShaderRegisterElement>(_pNumDirectionalLights*3);
            }
		}
		
		/**		 * @inheritDoc		 */
		override public function pCalculateDependencies():void
		{
			super.pCalculateDependencies();

			if (!tangentSpace)
            {
				_pDependencyCounter.addWorldSpaceDependencies(false);
            }
		}

		/**		 * @inheritDoc		 */
		override public function pCompileNormalCode():void
		{
			_pSharedRegisters.normalFragment = _pRegisterCache.getFreeFragmentVectorTemp();
			_pRegisterCache.addFragmentTempUsages(_pSharedRegisters.normalFragment, _pDependencyCounter.normalDependencies);
			
			if (_pMethodSetup._iNormalMethod.iHasOutput && ! _pMethodSetup._iNormalMethod.iTangentSpace)
            {
				_pVertexCode += _pMethodSetup._iNormalMethod.iGetVertexCode(_pMethodSetup._iNormalMethodVO, _pRegisterCache);
				_pFragmentCode += _pMethodSetup._iNormalMethod.iGetFragmentCode(_pMethodSetup._iNormalMethodVO, _pRegisterCache, _pSharedRegisters.normalFragment);

				return;

			}
			
			if (tangentSpace)
            {
				compileTangentSpaceNormalMapCode();

            }
			else
            {
				var normalMatrix:Vector.<ShaderRegisterElement> = new Vector.<ShaderRegisterElement>( 3 );
			    	normalMatrix[0] = _pRegisterCache.getFreeVertexConstant();
				    normalMatrix[1] = _pRegisterCache.getFreeVertexConstant();
				    normalMatrix[2] = _pRegisterCache.getFreeVertexConstant();

				_pRegisterCache.getFreeVertexConstant();

				_pSceneNormalMatrixIndex = normalMatrix[0].index*4;
				_pSharedRegisters.normalVarying = _pRegisterCache.getFreeVarying();


				// no output, world space is enough
                _pVertexCode += "m33 " + _pSharedRegisters.normalVarying + ".xyz, " + _pSharedRegisters.animatedNormal + ", " + normalMatrix[0] + "\n" +
					"mov " + _pSharedRegisters.normalVarying + ".w, " + _pSharedRegisters.animatedNormal + ".w	\n";

                _pFragmentCode += "nrm " + _pSharedRegisters.normalFragment + ".xyz, " + _pSharedRegisters.normalVarying + "\n" +
					"mov " + _pSharedRegisters.normalFragment + ".w, " + _pSharedRegisters.normalVarying + ".w		\n";
				
			}
			
			if (_pDependencyCounter.tangentDependencies > 0)
            {
				_pSharedRegisters.tangentInput = _pRegisterCache.getFreeVertexAttribute();
				_pTangentBufferIndex = _pSharedRegisters.tangentInput.index;
				_pSharedRegisters.tangentVarying = _pRegisterCache.getFreeVarying();
			}
		}

		/**		 * Generates code to retrieve the tangent space normal from the normal map		 */
		private function compileTangentSpaceNormalMapCode():void
		{
			// normalize normal + tangent vector and generate (approximated) bitangent
			_pVertexCode += "nrm " + _pSharedRegisters.animatedNormal + ".xyz, " + _pSharedRegisters.animatedNormal + "\n" +
				"nrm " + _pSharedRegisters.animatedTangent + ".xyz, " + _pSharedRegisters.animatedTangent + "\n";
			_pVertexCode += "crs " + _pSharedRegisters.bitangent + ".xyz, " + _pSharedRegisters.animatedNormal + ", " + _pSharedRegisters.animatedTangent + "\n";

			_pFragmentCode += _pMethodSetup._iNormalMethod.iGetFragmentCode( _pMethodSetup._iNormalMethodVO, _pRegisterCache, _pSharedRegisters.normalFragment);
			
			if (_pMethodSetup._iNormalMethodVO.needsView)
            {
				_pRegisterCache.removeFragmentTempUsage(_pSharedRegisters.viewDirFragment);
            }

			if (_pMethodSetup._iNormalMethodVO.needsGlobalFragmentPos || _pMethodSetup._iNormalMethodVO.needsGlobalVertexPos)
            {
				_pRegisterCache.removeVertexTempUsage(_pSharedRegisters.globalPositionVertex);
            }

		}

		/**		 * @inheritDoc		 */
		override public function pCompileViewDirCode():void
		{
			var cameraPositionReg:ShaderRegisterElement = _pRegisterCache.getFreeVertexConstant();
			_pSharedRegisters.viewDirVarying = _pRegisterCache.getFreeVarying();
			_pSharedRegisters.viewDirFragment = _pRegisterCache.getFreeFragmentVectorTemp();
			_pRegisterCache.addFragmentTempUsages(_pSharedRegisters.viewDirFragment, _pDependencyCounter.viewDirDependencies);
			
			_pCameraPositionIndex = cameraPositionReg.index*4;
			
			if (tangentSpace)
            {
				var temp:ShaderRegisterElement = _pRegisterCache.getFreeVertexVectorTemp();
				_pVertexCode += "sub " + temp + ", " + cameraPositionReg + ", " + _pSharedRegisters.localPosition + "\n" +
					"m33 " + _pSharedRegisters.viewDirVarying + ".xyz, " + temp + ", " + _pSharedRegisters.animatedTangent + "\n" +
					"mov " + _pSharedRegisters.viewDirVarying + ".w, " + _pSharedRegisters.localPosition + ".w\n";
			}
            else
            {
				_pVertexCode += "sub " + _pSharedRegisters.viewDirVarying + ", " + cameraPositionReg + ", " + _pSharedRegisters.globalPositionVertex + "\n";
				_pRegisterCache.removeVertexTempUsage(_pSharedRegisters.globalPositionVertex);
			}
			
			_pFragmentCode += "nrm " + _pSharedRegisters.viewDirFragment + ".xyz, " + _pSharedRegisters.viewDirVarying + "\n" +
				"mov " + _pSharedRegisters.viewDirFragment + ".w,   " + _pSharedRegisters.viewDirVarying + ".w 		\n";
		}

		/**		 * @inheritDoc		 */
		override public function pCompileLightingCode():void
		{
			if (_pMethodSetup._iShadowMethod)
				compileShadowCode();
			
			_pMethodSetup._iDiffuseMethod.iShadowRegister= _shadowRegister;
			
			_pSharedRegisters.shadedTarget = _pRegisterCache.getFreeFragmentVectorTemp();
			_pRegisterCache.addFragmentTempUsages( _pSharedRegisters.shadedTarget, 1);
			
			_pVertexCode += _pMethodSetup._iDiffuseMethod.iGetVertexCode( _pMethodSetup._iDiffuseMethodVO, _pRegisterCache);
			_pFragmentCode += _pMethodSetup._iDiffuseMethod.iGetFragmentPreLightingCode(_pMethodSetup._iDiffuseMethodVO, _pRegisterCache);
			
			if (_usingSpecularMethod)
            {
				_pVertexCode += _pMethodSetup._iSpecularMethod.iGetVertexCode(_pMethodSetup._iSpecularMethodVO, _pRegisterCache);
				_pFragmentCode += _pMethodSetup._iSpecularMethod.iGetFragmentPreLightingCode(_pMethodSetup._iSpecularMethodVO, _pRegisterCache);
			}
			
			if (pUsesLights() )
            {
				initLightRegisters();
				compileDirectionalLightCode();
                compilePointLightCode();
			}
			
			if (pUsesProbes())
				compileLightProbeCode();
			
			// only need to create and reserve _shadedTargetReg here, no earlier?
			_pVertexCode += _pMethodSetup._iAmbientMethod.iGetVertexCode(_pMethodSetup._iAmbientMethodVO, _pRegisterCache);
			_pFragmentCode += _pMethodSetup._iAmbientMethod.iGetFragmentCode(_pMethodSetup._iAmbientMethodVO, _pRegisterCache, _pSharedRegisters.shadedTarget);

			if (_pMethodSetup._iAmbientMethodVO.needsNormals)
            {
				_pRegisterCache.removeFragmentTempUsage(_pSharedRegisters.normalFragment);
            }

			if (_pMethodSetup._iAmbientMethodVO.needsView)
            {
				_pRegisterCache.removeFragmentTempUsage(_pSharedRegisters.viewDirFragment);
            }

			_pFragmentCode += _pMethodSetup._iDiffuseMethod.iGetFragmentPostLightingCode(_pMethodSetup._iDiffuseMethodVO, _pRegisterCache, _pSharedRegisters.shadedTarget);
			
			if (_pAlphaPremultiplied)
            {
				_pFragmentCode += "add " + _pSharedRegisters.shadedTarget + ".w, " + _pSharedRegisters.shadedTarget + ".w, " + _pSharedRegisters.commons + ".z\n" +
					"div " + _pSharedRegisters.shadedTarget + ".xyz, " + _pSharedRegisters.shadedTarget + ", " + _pSharedRegisters.shadedTarget + ".w\n" +
					"sub " + _pSharedRegisters.shadedTarget + ".w, " + _pSharedRegisters.shadedTarget + ".w, " + _pSharedRegisters.commons + ".z\n" +
					"sat " + _pSharedRegisters.shadedTarget + ".xyz, " + _pSharedRegisters.shadedTarget + "\n";
			}
			
			// resolve other dependencies as well?
			if (_pMethodSetup._iDiffuseMethodVO.needsNormals)
				_pRegisterCache.removeFragmentTempUsage( _pSharedRegisters.normalFragment);
			if (_pMethodSetup._iDiffuseMethodVO.needsView)
				_pRegisterCache.removeFragmentTempUsage(_pSharedRegisters.viewDirFragment);
			
			if (_usingSpecularMethod)
            {
				_pMethodSetup._iSpecularMethod.iShadowRegister= _shadowRegister;
				_pFragmentCode += _pMethodSetup._iSpecularMethod.iGetFragmentPostLightingCode(_pMethodSetup._iSpecularMethodVO, _pRegisterCache, _pSharedRegisters.shadedTarget);
				if (_pMethodSetup._iSpecularMethodVO.needsNormals)
					_pRegisterCache.removeFragmentTempUsage(_pSharedRegisters.normalFragment);
				if (_pMethodSetup._iSpecularMethodVO.needsView)
					_pRegisterCache.removeFragmentTempUsage(_pSharedRegisters.viewDirFragment);
			}
			
			if (_pMethodSetup._iShadowMethod)
            {
				_pRegisterCache.removeFragmentTempUsage(_shadowRegister);

            }
		}

		/**		 * Provides the code to provide shadow mapping.		 */
		private function compileShadowCode():void
		{
			if (_pSharedRegisters.normalFragment)
				_shadowRegister = _pSharedRegisters.normalFragment;
			else
				_shadowRegister = _pRegisterCache.getFreeFragmentVectorTemp();

            _pRegisterCache.addFragmentTempUsages( _shadowRegister, 1);
			
			_pVertexCode += _pMethodSetup._iShadowMethod.iGetVertexCode(_pMethodSetup._iShadowMethodVO, _pRegisterCache);
			_pFragmentCode += _pMethodSetup._iShadowMethod.iGetFragmentCode(_pMethodSetup._iShadowMethodVO, _pRegisterCache, _shadowRegister);
		}

		/**		 * Initializes constant registers to contain light data.		 */
		private function initLightRegisters():void
		{
			// init these first so we're sure they're in sequence
			var i:Number, len:Number;
			
			if (_dirLightVertexConstants)
            {
				len = _dirLightVertexConstants.length;

				for (i = 0; i < len; ++i)
                {
					_dirLightVertexConstants[i] = _pRegisterCache.getFreeVertexConstant();

					if (_lightVertexConstantIndex == -1)
                    {
						_lightVertexConstantIndex = _dirLightVertexConstants[i].index*4;
                    }

				}
			}
			
			len = _pointLightVertexConstants.length;
			for (i = 0; i < len; ++i)
            {
				_pointLightVertexConstants[i] = _pRegisterCache.getFreeVertexConstant();

				if (_lightVertexConstantIndex == -1)
                {
					_lightVertexConstantIndex = _pointLightVertexConstants[i].index*4;
                }
			}
			
			len = _dirLightFragmentConstants.length;
			for (i = 0; i < len; ++i)
            {
				_dirLightFragmentConstants[i] = _pRegisterCache.getFreeFragmentConstant();

				if (_pLightFragmentConstantIndex == -1){
					_pLightFragmentConstantIndex = _dirLightFragmentConstants[i].index*4;

                }
			}
			
			len = _pointLightFragmentConstants.length;

			for (i = 0; i < len; ++i)
            {
				_pointLightFragmentConstants[i] = _pRegisterCache.getFreeFragmentConstant();
				if (_pLightFragmentConstantIndex == -1)
                {
					_pLightFragmentConstantIndex = _pointLightFragmentConstants[i].index*4;

                }
			}
		}

		/**		 * Compiles the shading code for directional lights.		 */
		private function compileDirectionalLightCode():void
		{
			var diffuseColorReg:ShaderRegisterElement;
			var specularColorReg:ShaderRegisterElement;
			var lightDirReg:ShaderRegisterElement;
			var vertexRegIndex:Number = 0;
			var fragmentRegIndex:Number = 0;
			var addSpec:Boolean = _usingSpecularMethod && pUsesLightsForSpecular();
			var addDiff:Boolean = pUsesLightsForDiffuse();
			
			if (!(addSpec || addDiff))
				return;
			
			for (var i:Number = 0; i <_pNumDirectionalLights; ++i)
            {
				
				if (tangentSpace) {
					lightDirReg = _dirLightVertexConstants[vertexRegIndex++];

                    var lightVarying:ShaderRegisterElement = _pRegisterCache.getFreeVarying();
					
					_pVertexCode += "m33 " + lightVarying + ".xyz, " + lightDirReg + ", " + _pSharedRegisters.animatedTangent + "\n" +
						"mov " + lightVarying + ".w, " + lightDirReg + ".w\n";
					
					lightDirReg = _pRegisterCache.getFreeFragmentVectorTemp();
					_pRegisterCache.addVertexTempUsages(lightDirReg, 1);
					_pFragmentCode += "nrm " + lightDirReg + ".xyz, " + lightVarying + "\n";
					_pFragmentCode += "mov " + lightDirReg + ".w, " + lightVarying + ".w\n";

				}
                else
                {
					lightDirReg = _dirLightFragmentConstants[fragmentRegIndex++];
                }

				diffuseColorReg = _dirLightFragmentConstants[fragmentRegIndex++];
				specularColorReg = _dirLightFragmentConstants[fragmentRegIndex++];
				if (addDiff)
                {
					_pFragmentCode += _pMethodSetup._iDiffuseMethod.iGetFragmentCodePerLight(_pMethodSetup._iDiffuseMethodVO, lightDirReg, diffuseColorReg, _pRegisterCache);
                }

				if (addSpec)
                {
					_pFragmentCode += _pMethodSetup._iSpecularMethod.iGetFragmentCodePerLight(_pMethodSetup._iSpecularMethodVO, lightDirReg, specularColorReg, _pRegisterCache);

                }

				if (tangentSpace)
					_pRegisterCache.removeVertexTempUsage(lightDirReg);
			}
		}

		/**		 * Compiles the shading code for point lights.		 */
		private function compilePointLightCode():void
		{
			var diffuseColorReg:ShaderRegisterElement;
			var specularColorReg:ShaderRegisterElement;
			var lightPosReg:ShaderRegisterElement;
			var lightDirReg:ShaderRegisterElement;
			var vertexRegIndex:Number = 0;
			var fragmentRegIndex:Number = 0;
			var addSpec:Boolean = _usingSpecularMethod && pUsesLightsForSpecular();
			var addDiff:Boolean = pUsesLightsForDiffuse();
			
			if (!(addSpec || addDiff))
            {
				return;
            }

			for (var i:Number = 0; i < _pNumPointLights; ++i)
            {
				lightPosReg = _pointLightVertexConstants[vertexRegIndex++];
				diffuseColorReg = _pointLightFragmentConstants[fragmentRegIndex++];
				specularColorReg = _pointLightFragmentConstants[fragmentRegIndex++];
				lightDirReg = _pRegisterCache.getFreeFragmentVectorTemp();

				_pRegisterCache.addFragmentTempUsages(lightDirReg, 1);
				
				var lightVarying:ShaderRegisterElement = _pRegisterCache.getFreeVarying();
				if (tangentSpace)
                {

					var temp:ShaderRegisterElement = _pRegisterCache.getFreeVertexVectorTemp();
					_pVertexCode += "sub " + temp + ", " + lightPosReg + ", " + _pSharedRegisters.localPosition + "\n" +
						"m33 " + lightVarying + ".xyz, " + temp + ", " + _pSharedRegisters.animatedTangent + "\n" +
						"mov " + lightVarying + ".w, " + _pSharedRegisters.localPosition + ".w\n";
				}
                else
                {
					_pVertexCode += "sub " + lightVarying + ", " + lightPosReg + ", " + _pSharedRegisters.globalPositionVertex + "\n";
                }

				if (_pEnableLightFallOff && _pProfile != "baselineConstrained") {
					// calculate attenuation

					_pFragmentCode +=
						// attenuate
						"dp3 " + lightDirReg + ".w, " + lightVarying + ", " + lightVarying + "\n" +
						// w = d - radius
						"sub " + lightDirReg + ".w, " + lightDirReg + ".w, " + diffuseColorReg + ".w\n" +
						// w = (d - radius)/(max-min)
						"mul " + lightDirReg + ".w, " + lightDirReg + ".w, " + specularColorReg + ".w\n" +
						// w = clamp(w, 0, 1)
						"sat " + lightDirReg + ".w, " + lightDirReg + ".w\n" +
						// w = 1-w
						"sub " + lightDirReg + ".w, " + _pSharedRegisters.commons + ".w, " + lightDirReg + ".w\n" +
						// normalize
						"nrm " + lightDirReg + ".xyz, " + lightVarying + "\n";
				}
                else
                {
					_pFragmentCode += "nrm " + lightDirReg + ".xyz, " + lightVarying + "\n" +
						"mov " + lightDirReg + ".w, " + lightVarying + ".w\n";
				}

				if (_pLightFragmentConstantIndex == -1)
                {
					_pLightFragmentConstantIndex = lightPosReg.index*4;
                }

				if (addDiff)
                {
					_pFragmentCode += _pMethodSetup._iDiffuseMethod.iGetFragmentCodePerLight(_pMethodSetup._iDiffuseMethodVO, lightDirReg, diffuseColorReg, _pRegisterCache);
                }

				if (addSpec)
                {
					_pFragmentCode += _pMethodSetup._iSpecularMethod.iGetFragmentCodePerLight(_pMethodSetup._iSpecularMethodVO, lightDirReg, specularColorReg, _pRegisterCache);
                }

				_pRegisterCache.removeFragmentTempUsage(lightDirReg);
				
			}
		}

		/**		 * Compiles shading code for light probes.		 */
		private function compileLightProbeCode():void
		{
			var weightReg:String;
			var weightComponents = [ ".x", ".y", ".z", ".w" ];
			var weightRegisters:Vector.<ShaderRegisterElement> = new Vector.<ShaderRegisterElement>();
			var i:Number;
			var texReg:ShaderRegisterElement;
			var addSpec:Boolean = _usingSpecularMethod && pUsesProbesForSpecular();
			var addDiff:Boolean = pUsesProbesForDiffuse();
			
			if (!(addSpec || addDiff))
            {
				return;
            }

			if (addDiff)
            {
				_pLightProbeDiffuseIndices = new Vector.<Number>();

            }
			if (addSpec)
            {
				_pLightProbeSpecularIndices = new Vector.<Number>();
            }

			for (i = 0; i < _pNumProbeRegisters; ++i)
            {
				weightRegisters[i] = _pRegisterCache.getFreeFragmentConstant();
				if (i == 0)
                {
					_pProbeWeightsIndex = weightRegisters[i].index*4;

                }
			}
			
			for (i = 0; i < _pNumLightProbes; ++i)
            {

				weightReg = weightRegisters[Math.floor(i/4)].toString() + weightComponents[i%4];
				
				if (addDiff)
                {
					texReg = _pRegisterCache.getFreeTextureReg();
					_pLightProbeDiffuseIndices[i] = texReg.index;
					_pFragmentCode += _pMethodSetup._iDiffuseMethod.iGetFragmentCodePerProbe(_pMethodSetup._iDiffuseMethodVO, texReg, weightReg, _pRegisterCache);
				}
				
				if (addSpec)
                {
					texReg = _pRegisterCache.getFreeTextureReg();
					_pLightProbeSpecularIndices[i] = texReg.index;
					_pFragmentCode += _pMethodSetup._iSpecularMethod.iGetFragmentCodePerProbe(_pMethodSetup._iSpecularMethodVO, texReg, weightReg, _pRegisterCache);
				}
			}
		}
	
	}
}
