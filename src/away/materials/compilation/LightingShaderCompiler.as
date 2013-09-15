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
			return this._lightVertexConstantIndex;
		}

		/**		 * @inheritDoc		 */
		override public function pInitRegisterIndices():void
		{
			super.pInitRegisterIndices();
            this._lightVertexConstantIndex = -1;
		}

		/**		 * @inheritDoc		 */
		override public function pCreateNormalRegisters():void
		{
			// need to be created FIRST and in this order
			if (this.tangentSpace)
            {

				this._pSharedRegisters.animatedTangent = this._pRegisterCache.getFreeVertexVectorTemp();
                this._pRegisterCache.addVertexTempUsages(this._pSharedRegisters.animatedTangent, 1);
                this._pSharedRegisters.bitangent = this._pRegisterCache.getFreeVertexVectorTemp();
                this._pRegisterCache.addVertexTempUsages(this._pSharedRegisters.bitangent, 1);
				
				this._pSharedRegisters.tangentInput = this._pRegisterCache.getFreeVertexAttribute();
                this._pTangentBufferIndex = this._pSharedRegisters.tangentInput.index;
				
				this._pAnimatableAttributes.push( this._pSharedRegisters.tangentInput.toString());
				this._pAnimationTargetRegisters.push(this._pSharedRegisters.animatedTangent.toString());
			}
			
			this._pSharedRegisters.normalInput = this._pRegisterCache.getFreeVertexAttribute();
			this._pNormalBufferIndex = this._pSharedRegisters.normalInput.index;
			
			this._pSharedRegisters.animatedNormal = this._pRegisterCache.getFreeVertexVectorTemp();
			this._pRegisterCache.addVertexTempUsages(this._pSharedRegisters.animatedNormal, 1);
			
			this._pAnimatableAttributes.push(this._pSharedRegisters.normalInput.toString());
			this._pAnimationTargetRegisters.push(this._pSharedRegisters.animatedNormal.toString());
		}

		/**		 * Indicates whether or not lighting happens in tangent space. This is only the case if no world-space		 * dependencies exist.		 */
		public function get tangentSpace():Boolean
		{
			return this._pNumLightProbes == 0 && this._pMethodSetup._iNormalMethod.iHasOutput && this._pMethodSetup._iNormalMethod.iTangentSpace;
		}

		/**		 * @inheritDoc		 */
		override public function pInitLightData():void
		{
			super.pInitLightData();
			
			this._pointLightVertexConstants = new Vector.<ShaderRegisterElement>(this._pNumPointLights );
			this._pointLightFragmentConstants = new Vector.<ShaderRegisterElement>(this._pNumPointLights*2 );

			if ( this.tangentSpace )
            {
				this._dirLightVertexConstants = new Vector.<ShaderRegisterElement>(this._pNumDirectionalLights );
				this._dirLightFragmentConstants = new Vector.<ShaderRegisterElement>(this._pNumDirectionalLights*2 );
			}
            else
            {
				this._dirLightFragmentConstants = new Vector.<ShaderRegisterElement>(this._pNumDirectionalLights*3);
            }
		}
		
		/**		 * @inheritDoc		 */
		override public function pCalculateDependencies():void
		{
			super.pCalculateDependencies();

			if (!this.tangentSpace)
            {
				this._pDependencyCounter.addWorldSpaceDependencies(false);
            }
		}

		/**		 * @inheritDoc		 */
		override public function pCompileNormalCode():void
		{
			this._pSharedRegisters.normalFragment = this._pRegisterCache.getFreeFragmentVectorTemp();
			this._pRegisterCache.addFragmentTempUsages(this._pSharedRegisters.normalFragment, this._pDependencyCounter.normalDependencies);
			
			if (this._pMethodSetup._iNormalMethod.iHasOutput && ! this._pMethodSetup._iNormalMethod.iTangentSpace)
            {
				this._pVertexCode += this._pMethodSetup._iNormalMethod.iGetVertexCode(this._pMethodSetup._iNormalMethodVO, this._pRegisterCache);
				this._pFragmentCode += this._pMethodSetup._iNormalMethod.iGetFragmentCode(this._pMethodSetup._iNormalMethodVO, this._pRegisterCache, this._pSharedRegisters.normalFragment);

				return;

			}
			
			if (this.tangentSpace)
            {
				this.compileTangentSpaceNormalMapCode();

            }
			else
            {
				var normalMatrix:Vector.<ShaderRegisterElement> = new Vector.<ShaderRegisterElement>( 3 );
			    	normalMatrix[0] = this._pRegisterCache.getFreeVertexConstant();
				    normalMatrix[1] = this._pRegisterCache.getFreeVertexConstant();
				    normalMatrix[2] = this._pRegisterCache.getFreeVertexConstant();

				this._pRegisterCache.getFreeVertexConstant();

				this._pSceneNormalMatrixIndex = normalMatrix[0].index*4;
				this._pSharedRegisters.normalVarying = this._pRegisterCache.getFreeVarying();


				// no output, world space is enough
                this._pVertexCode += "m33 " + this._pSharedRegisters.normalVarying + ".xyz, " + this._pSharedRegisters.animatedNormal + ", " + normalMatrix[0] + "\n" +
					"mov " + this._pSharedRegisters.normalVarying + ".w, " + this._pSharedRegisters.animatedNormal + ".w	\n";

                this._pFragmentCode += "nrm " + this._pSharedRegisters.normalFragment + ".xyz, " + this._pSharedRegisters.normalVarying + "\n" +
					"mov " + this._pSharedRegisters.normalFragment + ".w, " + this._pSharedRegisters.normalVarying + ".w		\n";
				
			}
			
			if (this._pDependencyCounter.tangentDependencies > 0)
            {
				this._pSharedRegisters.tangentInput = this._pRegisterCache.getFreeVertexAttribute();
				this._pTangentBufferIndex = this._pSharedRegisters.tangentInput.index;
				this._pSharedRegisters.tangentVarying = this._pRegisterCache.getFreeVarying();
			}
		}

		/**		 * Generates code to retrieve the tangent space normal from the normal map		 */
		private function compileTangentSpaceNormalMapCode():void
		{
			// normalize normal + tangent vector and generate (approximated) bitangent
			this._pVertexCode += "nrm " + this._pSharedRegisters.animatedNormal + ".xyz, " + this._pSharedRegisters.animatedNormal + "\n" +
				"nrm " + this._pSharedRegisters.animatedTangent + ".xyz, " + this._pSharedRegisters.animatedTangent + "\n";
			this._pVertexCode += "crs " + this._pSharedRegisters.bitangent + ".xyz, " + this._pSharedRegisters.animatedNormal + ", " + this._pSharedRegisters.animatedTangent + "\n";

			this._pFragmentCode += this._pMethodSetup._iNormalMethod.iGetFragmentCode( this._pMethodSetup._iNormalMethodVO, this._pRegisterCache, this._pSharedRegisters.normalFragment);
			
			if (this._pMethodSetup._iNormalMethodVO.needsView)
            {
				this._pRegisterCache.removeFragmentTempUsage(this._pSharedRegisters.viewDirFragment);
            }

			if (this._pMethodSetup._iNormalMethodVO.needsGlobalFragmentPos || this._pMethodSetup._iNormalMethodVO.needsGlobalVertexPos)
            {
				this._pRegisterCache.removeVertexTempUsage(this._pSharedRegisters.globalPositionVertex);
            }

		}

		/**		 * @inheritDoc		 */
		override public function pCompileViewDirCode():void
		{
			var cameraPositionReg:ShaderRegisterElement = this._pRegisterCache.getFreeVertexConstant();
			this._pSharedRegisters.viewDirVarying = this._pRegisterCache.getFreeVarying();
			this._pSharedRegisters.viewDirFragment = this._pRegisterCache.getFreeFragmentVectorTemp();
			this._pRegisterCache.addFragmentTempUsages(this._pSharedRegisters.viewDirFragment, this._pDependencyCounter.viewDirDependencies);
			
			this._pCameraPositionIndex = cameraPositionReg.index*4;
			
			if (this.tangentSpace)
            {
				var temp:ShaderRegisterElement = this._pRegisterCache.getFreeVertexVectorTemp();
				this._pVertexCode += "sub " + temp + ", " + cameraPositionReg + ", " + this._pSharedRegisters.localPosition + "\n" +
					"m33 " + this._pSharedRegisters.viewDirVarying + ".xyz, " + temp + ", " + this._pSharedRegisters.animatedTangent + "\n" +
					"mov " + this._pSharedRegisters.viewDirVarying + ".w, " + this._pSharedRegisters.localPosition + ".w\n";
			}
            else
            {
				this._pVertexCode += "sub " + this._pSharedRegisters.viewDirVarying + ", " + cameraPositionReg + ", " + this._pSharedRegisters.globalPositionVertex + "\n";
				this._pRegisterCache.removeVertexTempUsage(this._pSharedRegisters.globalPositionVertex);
			}
			
			this._pFragmentCode += "nrm " + this._pSharedRegisters.viewDirFragment + ".xyz, " + this._pSharedRegisters.viewDirVarying + "\n" +
				"mov " + this._pSharedRegisters.viewDirFragment + ".w,   " + this._pSharedRegisters.viewDirVarying + ".w 		\n";
		}

		/**		 * @inheritDoc		 */
		override public function pCompileLightingCode():void
		{
			if (this._pMethodSetup._iShadowMethod)
				this.compileShadowCode();
			
			this._pMethodSetup._iDiffuseMethod.iShadowRegister= this._shadowRegister;
			
			this._pSharedRegisters.shadedTarget = this._pRegisterCache.getFreeFragmentVectorTemp();
			this._pRegisterCache.addFragmentTempUsages( this._pSharedRegisters.shadedTarget, 1);
			
			this._pVertexCode += this._pMethodSetup._iDiffuseMethod.iGetVertexCode( this._pMethodSetup._iDiffuseMethodVO, this._pRegisterCache);
			this._pFragmentCode += this._pMethodSetup._iDiffuseMethod.iGetFragmentPreLightingCode(this._pMethodSetup._iDiffuseMethodVO, this._pRegisterCache);
			
			if (this._usingSpecularMethod)
            {
				this._pVertexCode += this._pMethodSetup._iSpecularMethod.iGetVertexCode(this._pMethodSetup._iSpecularMethodVO, this._pRegisterCache);
				this._pFragmentCode += this._pMethodSetup._iSpecularMethod.iGetFragmentPreLightingCode(this._pMethodSetup._iSpecularMethodVO, this._pRegisterCache);
			}
			
			if (this.pUsesLights() )
            {
				this.initLightRegisters();
				this.compileDirectionalLightCode();
                this.compilePointLightCode();
			}
			
			if (this.pUsesProbes())
				this.compileLightProbeCode();
			
			// only need to create and reserve _shadedTargetReg here, no earlier?
			this._pVertexCode += this._pMethodSetup._iAmbientMethod.iGetVertexCode(this._pMethodSetup._iAmbientMethodVO, this._pRegisterCache);
			this._pFragmentCode += this._pMethodSetup._iAmbientMethod.iGetFragmentCode(this._pMethodSetup._iAmbientMethodVO, this._pRegisterCache, this._pSharedRegisters.shadedTarget);

			if (this._pMethodSetup._iAmbientMethodVO.needsNormals)
            {
				this._pRegisterCache.removeFragmentTempUsage(this._pSharedRegisters.normalFragment);
            }

			if (this._pMethodSetup._iAmbientMethodVO.needsView)
            {
				this._pRegisterCache.removeFragmentTempUsage(this._pSharedRegisters.viewDirFragment);
            }

			this._pFragmentCode += this._pMethodSetup._iDiffuseMethod.iGetFragmentPostLightingCode(this._pMethodSetup._iDiffuseMethodVO, this._pRegisterCache, this._pSharedRegisters.shadedTarget);
			
			if (this._pAlphaPremultiplied)
            {
				this._pFragmentCode += "add " + this._pSharedRegisters.shadedTarget + ".w, " + this._pSharedRegisters.shadedTarget + ".w, " + this._pSharedRegisters.commons + ".z\n" +
					"div " + this._pSharedRegisters.shadedTarget + ".xyz, " + this._pSharedRegisters.shadedTarget + ", " + this._pSharedRegisters.shadedTarget + ".w\n" +
					"sub " + this._pSharedRegisters.shadedTarget + ".w, " + this._pSharedRegisters.shadedTarget + ".w, " + this._pSharedRegisters.commons + ".z\n" +
					"sat " + this._pSharedRegisters.shadedTarget + ".xyz, " + this._pSharedRegisters.shadedTarget + "\n";
			}
			
			// resolve other dependencies as well?
			if (this._pMethodSetup._iDiffuseMethodVO.needsNormals)
				this._pRegisterCache.removeFragmentTempUsage( this._pSharedRegisters.normalFragment);
			if (this._pMethodSetup._iDiffuseMethodVO.needsView)
				this._pRegisterCache.removeFragmentTempUsage(this._pSharedRegisters.viewDirFragment);
			
			if (this._usingSpecularMethod)
            {
				this._pMethodSetup._iSpecularMethod.iShadowRegister= this._shadowRegister;
				this._pFragmentCode += this._pMethodSetup._iSpecularMethod.iGetFragmentPostLightingCode(this._pMethodSetup._iSpecularMethodVO, this._pRegisterCache, this._pSharedRegisters.shadedTarget);
				if (this._pMethodSetup._iSpecularMethodVO.needsNormals)
					this._pRegisterCache.removeFragmentTempUsage(this._pSharedRegisters.normalFragment);
				if (this._pMethodSetup._iSpecularMethodVO.needsView)
					this._pRegisterCache.removeFragmentTempUsage(this._pSharedRegisters.viewDirFragment);
			}
			
			if (this._pMethodSetup._iShadowMethod)
            {
				this._pRegisterCache.removeFragmentTempUsage(this._shadowRegister);

            }
		}

		/**		 * Provides the code to provide shadow mapping.		 */
		private function compileShadowCode():void
		{
			if (this._pSharedRegisters.normalFragment)
				this._shadowRegister = this._pSharedRegisters.normalFragment;
			else
				this._shadowRegister = this._pRegisterCache.getFreeFragmentVectorTemp();

            this._pRegisterCache.addFragmentTempUsages( this._shadowRegister, 1);
			
			this._pVertexCode += this._pMethodSetup._iShadowMethod.iGetVertexCode(this._pMethodSetup._iShadowMethodVO, this._pRegisterCache);
			this._pFragmentCode += this._pMethodSetup._iShadowMethod.iGetFragmentCode(this._pMethodSetup._iShadowMethodVO, this._pRegisterCache, this._shadowRegister);
		}

		/**		 * Initializes constant registers to contain light data.		 */
		private function initLightRegisters():void
		{
			// init these first so we're sure they're in sequence
			var i:Number, len:Number;
			
			if (this._dirLightVertexConstants)
            {
				len = this._dirLightVertexConstants.length;

				for (i = 0; i < len; ++i)
                {
					this._dirLightVertexConstants[i] = this._pRegisterCache.getFreeVertexConstant();

					if (this._lightVertexConstantIndex == -1)
                    {
						this._lightVertexConstantIndex = this._dirLightVertexConstants[i].index*4;
                    }

				}
			}
			
			len = this._pointLightVertexConstants.length;
			for (i = 0; i < len; ++i)
            {
				this._pointLightVertexConstants[i] = this._pRegisterCache.getFreeVertexConstant();

				if (this._lightVertexConstantIndex == -1)
                {
					this._lightVertexConstantIndex = this._pointLightVertexConstants[i].index*4;
                }
			}
			
			len = this._dirLightFragmentConstants.length;
			for (i = 0; i < len; ++i)
            {
				this._dirLightFragmentConstants[i] = this._pRegisterCache.getFreeFragmentConstant();

				if (this._pLightFragmentConstantIndex == -1){
					this._pLightFragmentConstantIndex = this._dirLightFragmentConstants[i].index*4;

                }
			}
			
			len = this._pointLightFragmentConstants.length;

			for (i = 0; i < len; ++i)
            {
				this._pointLightFragmentConstants[i] = this._pRegisterCache.getFreeFragmentConstant();
				if (this._pLightFragmentConstantIndex == -1)
                {
					this._pLightFragmentConstantIndex = this._pointLightFragmentConstants[i].index*4;

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
			var addSpec:Boolean = this._usingSpecularMethod && this.pUsesLightsForSpecular();
			var addDiff:Boolean = this.pUsesLightsForDiffuse();
			
			if (!(addSpec || addDiff))
				return;
			
			for (var i:Number = 0; i <this._pNumDirectionalLights; ++i)
            {
				
				if (this.tangentSpace) {
					lightDirReg = this._dirLightVertexConstants[vertexRegIndex++];

                    var lightVarying:ShaderRegisterElement = this._pRegisterCache.getFreeVarying();
					
					this._pVertexCode += "m33 " + lightVarying + ".xyz, " + lightDirReg + ", " + this._pSharedRegisters.animatedTangent + "\n" +
						"mov " + lightVarying + ".w, " + lightDirReg + ".w\n";
					
					lightDirReg = this._pRegisterCache.getFreeFragmentVectorTemp();
					this._pRegisterCache.addVertexTempUsages(lightDirReg, 1);
					this._pFragmentCode += "nrm " + lightDirReg + ".xyz, " + lightVarying + "\n";
					this._pFragmentCode += "mov " + lightDirReg + ".w, " + lightVarying + ".w\n";

				}
                else
                {
					lightDirReg = this._dirLightFragmentConstants[fragmentRegIndex++];
                }

				diffuseColorReg = this._dirLightFragmentConstants[fragmentRegIndex++];
				specularColorReg = this._dirLightFragmentConstants[fragmentRegIndex++];
				if (addDiff)
                {
					this._pFragmentCode += this._pMethodSetup._iDiffuseMethod.iGetFragmentCodePerLight(this._pMethodSetup._iDiffuseMethodVO, lightDirReg, diffuseColorReg, this._pRegisterCache);
                }

				if (addSpec)
                {
					this._pFragmentCode += this._pMethodSetup._iSpecularMethod.iGetFragmentCodePerLight(this._pMethodSetup._iSpecularMethodVO, lightDirReg, specularColorReg, this._pRegisterCache);

                }

				if (this.tangentSpace)
					this._pRegisterCache.removeVertexTempUsage(lightDirReg);
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
			var addSpec:Boolean = this._usingSpecularMethod && this.pUsesLightsForSpecular();
			var addDiff:Boolean = this.pUsesLightsForDiffuse();
			
			if (!(addSpec || addDiff))
            {
				return;
            }

			for (var i:Number = 0; i < this._pNumPointLights; ++i)
            {
				lightPosReg = this._pointLightVertexConstants[vertexRegIndex++];
				diffuseColorReg = this._pointLightFragmentConstants[fragmentRegIndex++];
				specularColorReg = this._pointLightFragmentConstants[fragmentRegIndex++];
				lightDirReg = this._pRegisterCache.getFreeFragmentVectorTemp();

				this._pRegisterCache.addFragmentTempUsages(lightDirReg, 1);
				
				var lightVarying:ShaderRegisterElement = this._pRegisterCache.getFreeVarying();
				if (this.tangentSpace)
                {

					var temp:ShaderRegisterElement = this._pRegisterCache.getFreeVertexVectorTemp();
					this._pVertexCode += "sub " + temp + ", " + lightPosReg + ", " + this._pSharedRegisters.localPosition + "\n" +
						"m33 " + lightVarying + ".xyz, " + temp + ", " + this._pSharedRegisters.animatedTangent + "\n" +
						"mov " + lightVarying + ".w, " + this._pSharedRegisters.localPosition + ".w\n";
				}
                else
                {
					this._pVertexCode += "sub " + lightVarying + ", " + lightPosReg + ", " + this._pSharedRegisters.globalPositionVertex + "\n";
                }

				if (this._pEnableLightFallOff && this._pProfile != "baselineConstrained") {
					// calculate attenuation

					this._pFragmentCode +=
						// attenuate
						"dp3 " + lightDirReg + ".w, " + lightVarying + ", " + lightVarying + "\n" +
						// w = d - radius
						"sub " + lightDirReg + ".w, " + lightDirReg + ".w, " + diffuseColorReg + ".w\n" +
						// w = (d - radius)/(max-min)
						"mul " + lightDirReg + ".w, " + lightDirReg + ".w, " + specularColorReg + ".w\n" +
						// w = clamp(w, 0, 1)
						"sat " + lightDirReg + ".w, " + lightDirReg + ".w\n" +
						// w = 1-w
						"sub " + lightDirReg + ".w, " + this._pSharedRegisters.commons + ".w, " + lightDirReg + ".w\n" +
						// normalize
						"nrm " + lightDirReg + ".xyz, " + lightVarying + "\n";
				}
                else
                {
					this._pFragmentCode += "nrm " + lightDirReg + ".xyz, " + lightVarying + "\n" +
						"mov " + lightDirReg + ".w, " + lightVarying + ".w\n";
				}

				if (this._pLightFragmentConstantIndex == -1)
                {
					this._pLightFragmentConstantIndex = lightPosReg.index*4;
                }

				if (addDiff)
                {
					this._pFragmentCode += this._pMethodSetup._iDiffuseMethod.iGetFragmentCodePerLight(this._pMethodSetup._iDiffuseMethodVO, lightDirReg, diffuseColorReg, this._pRegisterCache);
                }

				if (addSpec)
                {
					this._pFragmentCode += this._pMethodSetup._iSpecularMethod.iGetFragmentCodePerLight(this._pMethodSetup._iSpecularMethodVO, lightDirReg, specularColorReg, this._pRegisterCache);
                }

				this._pRegisterCache.removeFragmentTempUsage(lightDirReg);
				
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
			var addSpec:Boolean = this._usingSpecularMethod && this.pUsesProbesForSpecular();
			var addDiff:Boolean = this.pUsesProbesForDiffuse();
			
			if (!(addSpec || addDiff))
            {
				return;
            }

			if (addDiff)
            {
				this._pLightProbeDiffuseIndices = new Vector.<Number>();

            }
			if (addSpec)
            {
				this._pLightProbeSpecularIndices = new Vector.<Number>();
            }

			for (i = 0; i < this._pNumProbeRegisters; ++i)
            {
				weightRegisters[i] = this._pRegisterCache.getFreeFragmentConstant();
				if (i == 0)
                {
					this._pProbeWeightsIndex = weightRegisters[i].index*4;

                }
			}
			
			for (i = 0; i < this._pNumLightProbes; ++i)
            {

				weightReg = weightRegisters[Math.floor(i/4)].toString() + weightComponents[i%4];
				
				if (addDiff)
                {
					texReg = this._pRegisterCache.getFreeTextureReg();
					this._pLightProbeDiffuseIndices[i] = texReg.index;
					this._pFragmentCode += this._pMethodSetup._iDiffuseMethod.iGetFragmentCodePerProbe(this._pMethodSetup._iDiffuseMethodVO, texReg, weightReg, this._pRegisterCache);
				}
				
				if (addSpec)
                {
					texReg = this._pRegisterCache.getFreeTextureReg();
					this._pLightProbeSpecularIndices[i] = texReg.index;
					this._pFragmentCode += this._pMethodSetup._iSpecularMethod.iGetFragmentCodePerProbe(this._pMethodSetup._iSpecularMethodVO, texReg, weightReg, this._pRegisterCache);
				}
			}
		}
	
	}
}
