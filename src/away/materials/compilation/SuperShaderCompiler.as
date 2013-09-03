///<reference path="../../_definitions.ts"/>

package away.materials.compilation
{
	//import away3d.arcane;

	/**	 * SuperShaderCompiler is a compiler that generates shaders that perform both lighting and "effects" through methods.	 * This is used by the single-pass materials.	 */
	public class SuperShaderCompiler extends ShaderCompiler
	{
		public var _pointLightRegisters:Vector.<ShaderRegisterElement>;//Vector.<ShaderRegisterElement>;		public var _dirLightRegisters:Vector.<ShaderRegisterElement>;//Vector.<ShaderRegisterElement>;
		/**		 * Creates a new SuperShaderCompiler object.		 * @param profile The compatibility profile used by the renderer.		 */
		public function SuperShaderCompiler(profile:String):void
		{
			super(profile);
		}

		/**		 * @inheritDoc		 */
		override public function pInitLightData():void
		{
			super.pInitLightData();
			
			_pointLightRegisters = new Vector.<ShaderRegisterElement>(_pNumPointLights*3);//Vector.<ShaderRegisterElement>(_numPointLights*3, true);
            _dirLightRegisters = new Vector.<ShaderRegisterElement>(_pNumDirectionalLights*3);//Vector.<ShaderRegisterElement>(_numDirectionalLights*3, true);


		}

		/**		 * @inheritDoc		 */
		override public function pCalculateDependencies():void
		{

			super.pCalculateDependencies();
			_pDependencyCounter.addWorldSpaceDependencies(true);

		}

		/**		 * @inheritDoc		 */
		override public function pCompileNormalCode():void
		{
			var normalMatrix:Vector.<ShaderRegisterElement> = new Vector.<ShaderRegisterElement>(3);//Vector.<ShaderRegisterElement> = new Vector.<ShaderRegisterElement>(3, true);
			
			_pSharedRegisters.normalFragment = _pRegisterCache.getFreeFragmentVectorTemp();
            _pRegisterCache.addFragmentTempUsages(_pSharedRegisters.normalFragment, _pDependencyCounter.normalDependencies);

			if (_pMethodSetup._iNormalMethod.iHasOutput && !_pMethodSetup._iNormalMethod.iTangentSpace)
            {

                _pVertexCode += _pMethodSetup._iNormalMethod.iGetVertexCode(_pMethodSetup._iNormalMethodVO, _pRegisterCache);
                _pFragmentCode += _pMethodSetup._iNormalMethod.iGetFragmentCode(_pMethodSetup._iNormalMethodVO, _pRegisterCache, _pSharedRegisters.normalFragment);

				return;

			}
			
			_pSharedRegisters.normalVarying = _pRegisterCache.getFreeVarying();
			
			normalMatrix[0] = _pRegisterCache.getFreeVertexConstant();
			normalMatrix[1] = _pRegisterCache.getFreeVertexConstant();
			normalMatrix[2] = _pRegisterCache.getFreeVertexConstant();

			_pRegisterCache.getFreeVertexConstant();
			_pSceneNormalMatrixIndex = normalMatrix[0].index*4;
			
			if (_pMethodSetup._iNormalMethod.iHasOutput)
            {

				// tangent stream required
				compileTangentVertexCode(normalMatrix);
                compileTangentNormalMapFragmentCode();

			}
            else
            {
                // TODO: AGAL <> GLSL

                //*
				_pVertexCode += "m33 " + _pSharedRegisters.normalVarying.toString() + ".xyz, " + _pSharedRegisters.animatedNormal.toString() + ", " + normalMatrix[0].toString() + "\n" +
					"mov " + _pSharedRegisters.normalVarying.toString() + ".w, " + _pSharedRegisters.animatedNormal.toString() + ".w	\n";

                _pFragmentCode += "nrm " + _pSharedRegisters.normalFragment.toString() + ".xyz, " + _pSharedRegisters.normalVarying.toString() + "\n" +
					"mov " + _pSharedRegisters.normalFragment.toString() + ".w, " + _pSharedRegisters.normalVarying.toString() + ".w		\n";
				
				if (_pDependencyCounter.tangentDependencies > 0)
                {

                    _pSharedRegisters.tangentInput = _pRegisterCache.getFreeVertexAttribute();
                    _pTangentBufferIndex = _pSharedRegisters.tangentInput.index;
                    _pSharedRegisters.tangentVarying = _pRegisterCache.getFreeVarying();

                    _pVertexCode += "mov " + _pSharedRegisters.tangentVarying.toString() + ", " + _pSharedRegisters.tangentInput.toString() + "\n";
				}
				//*/
			}
			
			_pRegisterCache.removeVertexTempUsage(_pSharedRegisters.animatedNormal);

		}

		/**		 * @inheritDoc		 */
		override public function pCreateNormalRegisters():void
		{
			if (_pDependencyCounter.normalDependencies > 0)
            {

                _pSharedRegisters.normalInput = _pRegisterCache.getFreeVertexAttribute();
                _pNormalBufferIndex = _pSharedRegisters.normalInput.index;
                _pSharedRegisters.animatedNormal = _pRegisterCache.getFreeVertexVectorTemp();
                _pRegisterCache.addVertexTempUsages(_pSharedRegisters.animatedNormal, 1);
                _pAnimatableAttributes.push(_pSharedRegisters.normalInput.toString());
                _pAnimationTargetRegisters.push(_pSharedRegisters.animatedNormal.toString());

			}
			
			if (_pMethodSetup._iNormalMethod.iHasOutput)
            {

                _pSharedRegisters.tangentInput = _pRegisterCache.getFreeVertexAttribute();
                _pTangentBufferIndex = _pSharedRegisters.tangentInput.index;

                _pSharedRegisters.animatedTangent = _pRegisterCache.getFreeVertexVectorTemp();
                _pRegisterCache.addVertexTempUsages(_pSharedRegisters.animatedTangent, 1);

                _pAnimatableAttributes.push(_pSharedRegisters.tangentInput.toString());
                _pAnimationTargetRegisters.push(_pSharedRegisters.animatedTangent.toString());

			}
		}

		/**		 * Compiles the vertex shader code for tangent-space normal maps.		 * @param matrix The register containing the scene transformation matrix for normals.		 */
		private function compileTangentVertexCode(matrix:Vector.<ShaderRegisterElement>):void//Vector.<ShaderRegisterElement>)		{
			_pSharedRegisters.tangentVarying = _pRegisterCache.getFreeVarying();
            _pSharedRegisters.bitangentVarying = _pRegisterCache.getFreeVarying();

            //TODO: AGAL <> GLSL

			_pVertexCode += "m33 " + _pSharedRegisters.animatedNormal.toString() + ".xyz, " + _pSharedRegisters.animatedNormal.toString() + ", " + matrix[0].toString() + "\n" +
				"nrm " + _pSharedRegisters.animatedNormal.toString() + ".xyz, " + _pSharedRegisters.animatedNormal.toString() + "\n";
			
			_pVertexCode += "m33 " + _pSharedRegisters.animatedTangent.toString() + ".xyz, " + _pSharedRegisters.animatedTangent.toString() + ", " + matrix[0].toString() + "\n" +
				"nrm " + _pSharedRegisters.animatedTangent.toString() + ".xyz, " + _pSharedRegisters.animatedTangent.toString() + "\n";
			
			var bitanTemp:ShaderRegisterElement = _pRegisterCache.getFreeVertexVectorTemp();
			_pVertexCode += "mov " + _pSharedRegisters.tangentVarying.toString() + ".x, " + _pSharedRegisters.animatedTangent.toString() + ".x  \n" +
				"mov " + _pSharedRegisters.tangentVarying.toString() + ".z, " + _pSharedRegisters.animatedNormal.toString() + ".x  \n" +
				"mov " + _pSharedRegisters.tangentVarying.toString() + ".w, " + _pSharedRegisters.normalInput.toString() + ".w  \n" +
				"mov " + _pSharedRegisters.bitangentVarying.toString() + ".x, " + _pSharedRegisters.animatedTangent.toString() + ".y  \n" +
				"mov " + _pSharedRegisters.bitangentVarying.toString() + ".z, " + _pSharedRegisters.animatedNormal.toString() + ".y  \n" +
				"mov " + _pSharedRegisters.bitangentVarying.toString() + ".w, " + _pSharedRegisters.normalInput.toString() + ".w  \n" +
				"mov " + _pSharedRegisters.normalVarying.toString() + ".x, " + _pSharedRegisters.animatedTangent.toString() + ".z  \n" +
				"mov " + _pSharedRegisters.normalVarying.toString() + ".z, " + _pSharedRegisters.animatedNormal.toString() + ".z  \n" +
				"mov " + _pSharedRegisters.normalVarying.toString() + ".w, " + _pSharedRegisters.normalInput.toString() + ".w  \n" +
				"crs " + bitanTemp.toString() + ".xyz, " + _pSharedRegisters.animatedNormal.toString() + ", " + _pSharedRegisters.animatedTangent.toString() + "\n" +
				"mov " + _pSharedRegisters.tangentVarying.toString() + ".y, " + bitanTemp.toString() + ".x    \n" +
				"mov " + _pSharedRegisters.bitangentVarying.toString() + ".y, " + bitanTemp.toString() + ".y  \n" +
				"mov " + _pSharedRegisters.normalVarying.toString() + ".y, " + bitanTemp.toString() + ".z    \n";

            _pRegisterCache.removeVertexTempUsage(_pSharedRegisters.animatedTangent);

		}

		/**		 * Compiles the fragment shader code for tangent-space normal maps.		 */
		private function compileTangentNormalMapFragmentCode():void
		{
			var t:ShaderRegisterElement;
			var b:ShaderRegisterElement;
			var n:ShaderRegisterElement;
			
			t = _pRegisterCache.getFreeFragmentVectorTemp();
            _pRegisterCache.addFragmentTempUsages(t, 1);
			b = _pRegisterCache.getFreeFragmentVectorTemp();
            _pRegisterCache.addFragmentTempUsages(b, 1);
			n = _pRegisterCache.getFreeFragmentVectorTemp();
            _pRegisterCache.addFragmentTempUsages(n, 1);


            //TODO: AGAL <> GLSL

            _pFragmentCode += "nrm " + t.toString() + ".xyz, " + _pSharedRegisters.tangentVarying.toString() + "\n" +
				"mov " + t.toString() + ".w, " + _pSharedRegisters.tangentVarying.toString() + ".w	\n" +
				"nrm " + b.toString() + ".xyz, " + _pSharedRegisters.bitangentVarying.toString() + "\n" +
				"nrm " + n.toString() + ".xyz, " + _pSharedRegisters.normalVarying.toString() + "\n";

			var temp:ShaderRegisterElement = _pRegisterCache.getFreeFragmentVectorTemp();



            _pRegisterCache.addFragmentTempUsages(temp, 1);

            //TODO: AGAL <> GLSL

            _pFragmentCode += _pMethodSetup._iNormalMethod.iGetFragmentCode(_pMethodSetup._iNormalMethodVO, _pRegisterCache, temp) +
				"m33 " + _pSharedRegisters.normalFragment.toString() + ".xyz, " + temp.toString() + ", " + t.toString() + "	\n" +
				"mov " + _pSharedRegisters.normalFragment.toString() + ".w,   " + _pSharedRegisters.normalVarying.toString() + ".w			\n";


            _pRegisterCache.removeFragmentTempUsage(temp);
			
			if (_pMethodSetup._iNormalMethodVO.needsView)
            {

                _pRegisterCache.removeFragmentTempUsage(_pSharedRegisters.viewDirFragment);

            }

			if (_pMethodSetup._iNormalMethodVO.needsGlobalVertexPos || _pMethodSetup._iNormalMethodVO.needsGlobalFragmentPos)
            {

                _pRegisterCache.removeVertexTempUsage(_pSharedRegisters.globalPositionVertex);

            }

            _pRegisterCache.removeFragmentTempUsage(b);
            _pRegisterCache.removeFragmentTempUsage(t);
            _pRegisterCache.removeFragmentTempUsage(n);

		}

		/**		 * @inheritDoc		 */
		override public function pCompileViewDirCode():void
		{
			var cameraPositionReg:ShaderRegisterElement = _pRegisterCache.getFreeVertexConstant();

			_pSharedRegisters.viewDirVarying = _pRegisterCache.getFreeVarying();
            _pSharedRegisters.viewDirFragment = _pRegisterCache.getFreeFragmentVectorTemp();
            _pRegisterCache.addFragmentTempUsages(_pSharedRegisters.viewDirFragment, _pDependencyCounter.viewDirDependencies);

            _pCameraPositionIndex = cameraPositionReg.index*4;

            //TODO: AGAL <> GLSL

            _pVertexCode += "sub " + _pSharedRegisters.viewDirVarying.toString() + ", " + cameraPositionReg.toString() + ", " + _pSharedRegisters.globalPositionVertex.toString() + "\n";
            _pFragmentCode += "nrm " + _pSharedRegisters.viewDirFragment.toString() + ".xyz, " + _pSharedRegisters.viewDirVarying.toString() + "\n" +
				"mov " + _pSharedRegisters.viewDirFragment.toString() + ".w,   " + _pSharedRegisters.viewDirVarying.toString() + ".w 		\n";

            _pRegisterCache.removeVertexTempUsage(_pSharedRegisters.globalPositionVertex);
		}

		/**		 * @inheritDoc		 */
		override public function pCompileLightingCode():void
		{
			var shadowReg:ShaderRegisterElement;
			
			_pSharedRegisters.shadedTarget = _pRegisterCache.getFreeFragmentVectorTemp();
            _pRegisterCache.addFragmentTempUsages(_pSharedRegisters.shadedTarget, 1);


            _pVertexCode += _pMethodSetup._iDiffuseMethod.iGetVertexCode(_pMethodSetup._iDiffuseMethodVO, _pRegisterCache);
            _pFragmentCode += _pMethodSetup._iDiffuseMethod.iGetFragmentPreLightingCode(_pMethodSetup._iDiffuseMethodVO, _pRegisterCache);

			
			if (_usingSpecularMethod)
            {

                _pVertexCode += _pMethodSetup._iSpecularMethod.iGetVertexCode(_pMethodSetup._iSpecularMethodVO, _pRegisterCache);
                _pFragmentCode += _pMethodSetup._iSpecularMethod.iGetFragmentPreLightingCode(_pMethodSetup._iSpecularMethodVO, _pRegisterCache);

			}

			if (pUsesLights())
            {

                initLightRegisters();
                compileDirectionalLightCode();
                compilePointLightCode();

			}

			if (pUsesProbes())
            {

                compileLightProbeCode();

            }

			
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

			
			if (_pMethodSetup._iShadowMethod)
            {

				_pVertexCode += _pMethodSetup._iShadowMethod.iGetVertexCode(_pMethodSetup._iShadowMethodVO, _pRegisterCache);

				// using normal to contain shadow data if available is perhaps risky :s
				// todo: improve compilation with lifetime analysis so this isn't necessary?

				if (_pDependencyCounter.normalDependencies == 0)
                {

					shadowReg = _pRegisterCache.getFreeFragmentVectorTemp();
					_pRegisterCache.addFragmentTempUsages(shadowReg, 1);

				}
                else
                {

                    shadowReg = _pSharedRegisters.normalFragment;

                }

				
				_pMethodSetup._iDiffuseMethod.iShadowRegister = shadowReg;
				_pFragmentCode += _pMethodSetup._iShadowMethod.iGetFragmentCode(_pMethodSetup._iShadowMethodVO, _pRegisterCache, shadowReg);

			}

			_pFragmentCode += _pMethodSetup._iDiffuseMethod.iGetFragmentPostLightingCode(_pMethodSetup._iDiffuseMethodVO, _pRegisterCache, _pSharedRegisters.shadedTarget);

			if (_pAlphaPremultiplied)
            {

                //TODO: AGAL <> GLSL

				_pFragmentCode += "add " + _pSharedRegisters.shadedTarget.toString() + ".w, " + _pSharedRegisters.shadedTarget.toString() + ".w, " + _pSharedRegisters.commons.toString() + ".z\n" +
					"div " + _pSharedRegisters.shadedTarget.toString() + ".xyz, " + _pSharedRegisters.shadedTarget.toString() + ", " + _pSharedRegisters.shadedTarget.toString() + ".w\n" +
					"sub " + _pSharedRegisters.shadedTarget.toString() + ".w, " + _pSharedRegisters.shadedTarget.toString() + ".w, " + _pSharedRegisters.commons.toString() + ".z\n" +
					"sat " + _pSharedRegisters.shadedTarget.toString() + ".xyz, " + _pSharedRegisters.shadedTarget.toString() + "\n";

			}
			
			// resolve other dependencies as well?
			if (_pMethodSetup._iDiffuseMethodVO.needsNormals)
            {

                _pRegisterCache.removeFragmentTempUsage(_pSharedRegisters.normalFragment);

            }

			if (_pMethodSetup._iDiffuseMethodVO.needsView)
            {

                _pRegisterCache.removeFragmentTempUsage(_pSharedRegisters.viewDirFragment);

            }

			
			if (_usingSpecularMethod)
            {

                _pMethodSetup._iSpecularMethod.iShadowRegister = shadowReg;
                _pFragmentCode += _pMethodSetup._iSpecularMethod.iGetFragmentPostLightingCode(_pMethodSetup._iSpecularMethodVO, _pRegisterCache, _pSharedRegisters.shadedTarget);

				if (_pMethodSetup._iSpecularMethodVO.needsNormals)
                {

                    _pRegisterCache.removeFragmentTempUsage(_pSharedRegisters.normalFragment);

                }

				if (_pMethodSetup._iSpecularMethodVO.needsView)
                {

                    _pRegisterCache.removeFragmentTempUsage(_pSharedRegisters.viewDirFragment);

                }

			}
		}

		/**		 * Initializes the registers containing the lighting data.		 */
		private function initLightRegisters():void
		{
			// init these first so we're sure they're in sequence
			var i:Number, len:Number;
			
			len = _dirLightRegisters.length;

			for (i = 0; i < len; ++i)
            {

				_dirLightRegisters[i] = _pRegisterCache.getFreeFragmentConstant();

				if (_pLightFragmentConstantIndex == -1)
                {

                    _pLightFragmentConstantIndex = _dirLightRegisters[i].index*4;

                }

			}
			
			len = _pointLightRegisters.length;

			for (i = 0; i < len; ++i)
            {

				_pointLightRegisters[i] = _pRegisterCache.getFreeFragmentConstant();

				if (_pLightFragmentConstantIndex == -1)
                {

                    _pLightFragmentConstantIndex = _pointLightRegisters[i].index*4;

                }

			}
		}

		private function compileDirectionalLightCode():void
		{
			var diffuseColorReg:ShaderRegisterElement;
			var specularColorReg:ShaderRegisterElement;
			var lightDirReg:ShaderRegisterElement;
			var regIndex:Number = 0;
			var addSpec:Boolean = _usingSpecularMethod && pUsesLightsForSpecular();
			var addDiff:Boolean = pUsesLightsForDiffuse();

			if (!(addSpec || addDiff))
            {

                return;

            }

			
			for (var i:Number = 0; i < _pNumDirectionalLights; ++i)
            {

				lightDirReg = _dirLightRegisters[regIndex++];

				diffuseColorReg = _dirLightRegisters[regIndex++];

				specularColorReg = _dirLightRegisters[regIndex++];

				if (addDiff)
                {

                    _pFragmentCode += _pMethodSetup._iDiffuseMethod.iGetFragmentCodePerLight(_pMethodSetup._iDiffuseMethodVO, lightDirReg, diffuseColorReg, _pRegisterCache);

                }

				if (addSpec)
                {

                    _pFragmentCode += _pMethodSetup._iSpecularMethod.iGetFragmentCodePerLight(_pMethodSetup._iSpecularMethodVO, lightDirReg, specularColorReg, _pRegisterCache);

                }

			}
		}
		
		private function compilePointLightCode():void
		{
			var diffuseColorReg:ShaderRegisterElement;
			var specularColorReg:ShaderRegisterElement;
			var lightPosReg:ShaderRegisterElement;
			var lightDirReg:ShaderRegisterElement;
			var regIndex:Number = 0;
			var addSpec:Boolean = _usingSpecularMethod && pUsesLightsForSpecular();

			var addDiff:Boolean = pUsesLightsForDiffuse();

			
			if (!(addSpec || addDiff))
            {

                return;

            }

			
			for (var i:Number = 0; i < _pNumPointLights; ++i)
            {
				lightPosReg = _pointLightRegisters[regIndex++];
				diffuseColorReg = _pointLightRegisters[regIndex++];
				specularColorReg = _pointLightRegisters[regIndex++];
				lightDirReg = _pRegisterCache.getFreeFragmentVectorTemp();
                _pRegisterCache.addFragmentTempUsages(lightDirReg, 1);
				
				// calculate attenuation
                _pFragmentCode += "sub " + lightDirReg.toString() + ", " + lightPosReg.toString() + ", " + _pSharedRegisters.globalPositionVarying.toString() + "\n" +
					// attenuate
					"dp3 " + lightDirReg.toString() + ".w, " + lightDirReg.toString() + ", " + lightDirReg.toString() + "\n" +
					// w = d - radis
					"sub " + lightDirReg.toString() + ".w, " + lightDirReg.toString() + ".w, " + diffuseColorReg.toString() + ".w\n" +
					// w = (d - radius)/(max-min)
					"mul " + lightDirReg.toString() + ".w, " + lightDirReg.toString() + ".w, " + specularColorReg.toString() + ".w\n" +
					// w = clamp(w, 0, 1)
					"sat " + lightDirReg.toString() + ".w, " + lightDirReg.toString() + ".w\n" +
					// w = 1-w
					"sub " + lightDirReg.toString() + ".w, " + lightPosReg.toString() + ".w, " + lightDirReg.toString() + ".w\n" +
					// normalize
					"nrm " + lightDirReg.toString() + ".xyz, " + lightDirReg.toString() + "\n";
				
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
		
		private function compileLightProbeCode():void
		{
			var weightReg:String;
			var weightComponents = [ ".x", ".y", ".z", ".w" ];
			var weightRegisters:Vector.<ShaderRegisterElement> = new Vector.<ShaderRegisterElement>();//Vector.<ShaderRegisterElement> = new Vector.<ShaderRegisterElement>();
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

                _pLightProbeDiffuseIndices = new Vector.<Number>();//Vector.<uint>();

            }

			if (addSpec)
            {

                _pLightProbeSpecularIndices = new Vector.<Number>();//Vector.<uint>();

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
