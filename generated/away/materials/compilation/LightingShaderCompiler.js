/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:04 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};
if (typeof away.materials.compilation == "undefined")
	away.materials.compilation = {};

away.materials.compilation.LightingShaderCompiler = function(profile) {
	this._shadowRegister = null;
	this._pointLightFragmentConstants = null;
	this._pointLightVertexConstants = null;
	this._lightVertexConstantIndex = 0;
	this._dirLightVertexConstants = null;
	this._dirLightFragmentConstants = null;
	away.materials.compilation.ShaderCompiler.call(this, profile);
};

away.materials.compilation.LightingShaderCompiler.prototype.get_lightVertexConstantIndex = function() {
	return this._lightVertexConstantIndex;
};

away.materials.compilation.LightingShaderCompiler.prototype.pInitRegisterIndices = function() {
	away.materials.compilation.ShaderCompiler.prototype.pInitRegisterIndices.call(this);
	this._lightVertexConstantIndex = -1;
};

away.materials.compilation.LightingShaderCompiler.prototype.pCreateNormalRegisters = function() {
	if (this.get_tangentSpace()) {
		this._pSharedRegisters.animatedTangent = this._pRegisterCache.getFreeVertexVectorTemp();
		this._pRegisterCache.addVertexTempUsages(this._pSharedRegisters.animatedTangent, 1);
		this._pSharedRegisters.bitangent = this._pRegisterCache.getFreeVertexVectorTemp();
		this._pRegisterCache.addVertexTempUsages(this._pSharedRegisters.bitangent, 1);
		this._pSharedRegisters.tangentInput = this._pRegisterCache.getFreeVertexAttribute();
		this._pTangentBufferIndex = this._pSharedRegisters.tangentInput.get_index();
		this._pAnimatableAttributes.push(this._pSharedRegisters.tangentInput.toString());
		this._pAnimationTargetRegisters.push(this._pSharedRegisters.animatedTangent.toString());
	}
	this._pSharedRegisters.normalInput = this._pRegisterCache.getFreeVertexAttribute();
	this._pNormalBufferIndex = this._pSharedRegisters.normalInput.get_index();
	this._pSharedRegisters.animatedNormal = this._pRegisterCache.getFreeVertexVectorTemp();
	this._pRegisterCache.addVertexTempUsages(this._pSharedRegisters.animatedNormal, 1);
	this._pAnimatableAttributes.push(this._pSharedRegisters.normalInput.toString());
	this._pAnimationTargetRegisters.push(this._pSharedRegisters.animatedNormal.toString());
};

away.materials.compilation.LightingShaderCompiler.prototype.get_tangentSpace = function() {
	return this._pNumLightProbes == 0 && this._pMethodSetup._iNormalMethod.get_iHasOutput() && this._pMethodSetup._iNormalMethod.get_iTangentSpace();
};

away.materials.compilation.LightingShaderCompiler.prototype.pInitLightData = function() {
	away.materials.compilation.ShaderCompiler.prototype.pInitLightData.call(this);
	this._pointLightVertexConstants = away.utils.VectorInit.AnyClass(this._pNumPointLights);
	this._pointLightFragmentConstants = away.utils.VectorInit.AnyClass(this._pNumPointLights * 2);
	if (this.get_tangentSpace()) {
		this._dirLightVertexConstants = away.utils.VectorInit.AnyClass(this._pNumDirectionalLights);
		this._dirLightFragmentConstants = away.utils.VectorInit.AnyClass(this._pNumDirectionalLights * 2);
	} else {
		this._dirLightFragmentConstants = away.utils.VectorInit.AnyClass(this._pNumDirectionalLights * 3);
	}
};

away.materials.compilation.LightingShaderCompiler.prototype.pCalculateDependencies = function() {
	away.materials.compilation.ShaderCompiler.prototype.pCalculateDependencies.call(this);
	if (!this.get_tangentSpace()) {
		this._pDependencyCounter.addWorldSpaceDependencies(false);
	}
};

away.materials.compilation.LightingShaderCompiler.prototype.pCompileNormalCode = function() {
	this._pSharedRegisters.normalFragment = this._pRegisterCache.getFreeFragmentVectorTemp();
	this._pRegisterCache.addFragmentTempUsages(this._pSharedRegisters.normalFragment, this._pDependencyCounter.get_normalDependencies());
	if (this._pMethodSetup._iNormalMethod.get_iHasOutput() && !this._pMethodSetup._iNormalMethod.get_iTangentSpace()) {
		this._pVertexCode += this._pMethodSetup._iNormalMethod.iGetVertexCode(this._pMethodSetup._iNormalMethodVO, this._pRegisterCache);
		this._pFragmentCode += this._pMethodSetup._iNormalMethod.iGetFragmentCode(this._pMethodSetup._iNormalMethodVO, this._pRegisterCache, this._pSharedRegisters.normalFragment);
		return;
	}
	if (this.get_tangentSpace()) {
		this.compileTangentSpaceNormalMapCode();
	} else {
		var normalMatrix = away.utils.VectorInit.AnyClass(3);
		normalMatrix[0] = this._pRegisterCache.getFreeVertexConstant();
		normalMatrix[1] = this._pRegisterCache.getFreeVertexConstant();
		normalMatrix[2] = this._pRegisterCache.getFreeVertexConstant();
		this._pRegisterCache.getFreeVertexConstant();
		this._pSceneNormalMatrixIndex = normalMatrix[0].index * 4;
		this._pSharedRegisters.normalVarying = this._pRegisterCache.getFreeVarying();
		this._pVertexCode += "m33 " + this._pSharedRegisters.normalVarying + ".xyz, " + this._pSharedRegisters.animatedNormal + ", " + normalMatrix[0] + "\n" + "mov " + this._pSharedRegisters.normalVarying + ".w, " + this._pSharedRegisters.animatedNormal + ".w\t\n";
		this._pFragmentCode += "nrm " + this._pSharedRegisters.normalFragment + ".xyz, " + this._pSharedRegisters.normalVarying + "\n" + "mov " + this._pSharedRegisters.normalFragment + ".w, " + this._pSharedRegisters.normalVarying + ".w\t\t\n";
	}
	if (this._pDependencyCounter.get_tangentDependencies() > 0) {
		this._pSharedRegisters.tangentInput = this._pRegisterCache.getFreeVertexAttribute();
		this._pTangentBufferIndex = this._pSharedRegisters.tangentInput.get_index();
		this._pSharedRegisters.tangentVarying = this._pRegisterCache.getFreeVarying();
	}
};

away.materials.compilation.LightingShaderCompiler.prototype.compileTangentSpaceNormalMapCode = function() {
	this._pVertexCode += "nrm " + this._pSharedRegisters.animatedNormal + ".xyz, " + this._pSharedRegisters.animatedNormal + "\n" + "nrm " + this._pSharedRegisters.animatedTangent + ".xyz, " + this._pSharedRegisters.animatedTangent + "\n";
	this._pVertexCode += "crs " + this._pSharedRegisters.bitangent + ".xyz, " + this._pSharedRegisters.animatedNormal + ", " + this._pSharedRegisters.animatedTangent + "\n";
	this._pFragmentCode += this._pMethodSetup._iNormalMethod.iGetFragmentCode(this._pMethodSetup._iNormalMethodVO, this._pRegisterCache, this._pSharedRegisters.normalFragment);
	if (this._pMethodSetup._iNormalMethodVO.needsView) {
		this._pRegisterCache.removeFragmentTempUsage(this._pSharedRegisters.viewDirFragment);
	}
	if (this._pMethodSetup._iNormalMethodVO.needsGlobalFragmentPos || this._pMethodSetup._iNormalMethodVO.needsGlobalVertexPos) {
		this._pRegisterCache.removeVertexTempUsage(this._pSharedRegisters.globalPositionVertex);
	}
};

away.materials.compilation.LightingShaderCompiler.prototype.pCompileViewDirCode = function() {
	var cameraPositionReg = this._pRegisterCache.getFreeVertexConstant();
	this._pSharedRegisters.viewDirVarying = this._pRegisterCache.getFreeVarying();
	this._pSharedRegisters.viewDirFragment = this._pRegisterCache.getFreeFragmentVectorTemp();
	this._pRegisterCache.addFragmentTempUsages(this._pSharedRegisters.viewDirFragment, this._pDependencyCounter.get_viewDirDependencies());
	this._pCameraPositionIndex = cameraPositionReg.get_index() * 4;
	if (this.get_tangentSpace()) {
		var temp = this._pRegisterCache.getFreeVertexVectorTemp();
		this._pVertexCode += "sub " + temp + ", " + cameraPositionReg + ", " + this._pSharedRegisters.localPosition + "\n" + "m33 " + this._pSharedRegisters.viewDirVarying + ".xyz, " + temp + ", " + this._pSharedRegisters.animatedTangent + "\n" + "mov " + this._pSharedRegisters.viewDirVarying + ".w, " + this._pSharedRegisters.localPosition + ".w\n";
	} else {
		this._pVertexCode += "sub " + this._pSharedRegisters.viewDirVarying + ", " + cameraPositionReg + ", " + this._pSharedRegisters.globalPositionVertex + "\n";
		this._pRegisterCache.removeVertexTempUsage(this._pSharedRegisters.globalPositionVertex);
	}
	this._pFragmentCode += "nrm " + this._pSharedRegisters.viewDirFragment + ".xyz, " + this._pSharedRegisters.viewDirVarying + "\n" + "mov " + this._pSharedRegisters.viewDirFragment + ".w,   " + this._pSharedRegisters.viewDirVarying + ".w \t\t\n";
};

away.materials.compilation.LightingShaderCompiler.prototype.pCompileLightingCode = function() {
	if (this._pMethodSetup._iShadowMethod)
		this.compileShadowCode();
	this._pMethodSetup._iDiffuseMethod.set_iShadowRegister(this._shadowRegister);
	this._pSharedRegisters.shadedTarget = this._pRegisterCache.getFreeFragmentVectorTemp();
	this._pRegisterCache.addFragmentTempUsages(this._pSharedRegisters.shadedTarget, 1);
	this._pVertexCode += this._pMethodSetup._iDiffuseMethod.iGetVertexCode(this._pMethodSetup._iDiffuseMethodVO, this._pRegisterCache);
	this._pFragmentCode += this._pMethodSetup._iDiffuseMethod.iGetFragmentPreLightingCode(this._pMethodSetup._iDiffuseMethodVO, this._pRegisterCache);
	if (this._usingSpecularMethod) {
		this._pVertexCode += this._pMethodSetup._iSpecularMethod.iGetVertexCode(this._pMethodSetup._iSpecularMethodVO, this._pRegisterCache);
		this._pFragmentCode += this._pMethodSetup._iSpecularMethod.iGetFragmentPreLightingCode(this._pMethodSetup._iSpecularMethodVO, this._pRegisterCache);
	}
	if (this.pUsesLights()) {
		this.initLightRegisters();
		this.compileDirectionalLightCode();
		this.compilePointLightCode();
	}
	if (this.pUsesProbes())
		this.compileLightProbeCode();
	this._pVertexCode += this._pMethodSetup._iAmbientMethod.iGetVertexCode(this._pMethodSetup._iAmbientMethodVO, this._pRegisterCache);
	this._pFragmentCode += this._pMethodSetup._iAmbientMethod.iGetFragmentCode(this._pMethodSetup._iAmbientMethodVO, this._pRegisterCache, this._pSharedRegisters.shadedTarget);
	if (this._pMethodSetup._iAmbientMethodVO.needsNormals) {
		this._pRegisterCache.removeFragmentTempUsage(this._pSharedRegisters.normalFragment);
	}
	if (this._pMethodSetup._iAmbientMethodVO.needsView) {
		this._pRegisterCache.removeFragmentTempUsage(this._pSharedRegisters.viewDirFragment);
	}
	this._pFragmentCode += this._pMethodSetup._iDiffuseMethod.iGetFragmentPostLightingCode(this._pMethodSetup._iDiffuseMethodVO, this._pRegisterCache, this._pSharedRegisters.shadedTarget);
	if (this._pAlphaPremultiplied) {
		this._pFragmentCode += "add " + this._pSharedRegisters.shadedTarget + ".w, " + this._pSharedRegisters.shadedTarget + ".w, " + this._pSharedRegisters.commons + ".z\n" + "div " + this._pSharedRegisters.shadedTarget + ".xyz, " + this._pSharedRegisters.shadedTarget + ", " + this._pSharedRegisters.shadedTarget + ".w\n" + "sub " + this._pSharedRegisters.shadedTarget + ".w, " + this._pSharedRegisters.shadedTarget + ".w, " + this._pSharedRegisters.commons + ".z\n" + "sat " + this._pSharedRegisters.shadedTarget + ".xyz, " + this._pSharedRegisters.shadedTarget + "\n";
	}
	if (this._pMethodSetup._iDiffuseMethodVO.needsNormals)
		this._pRegisterCache.removeFragmentTempUsage(this._pSharedRegisters.normalFragment);
	if (this._pMethodSetup._iDiffuseMethodVO.needsView)
		this._pRegisterCache.removeFragmentTempUsage(this._pSharedRegisters.viewDirFragment);
	if (this._usingSpecularMethod) {
		this._pMethodSetup._iSpecularMethod.set_iShadowRegister(this._shadowRegister);
		this._pFragmentCode += this._pMethodSetup._iSpecularMethod.iGetFragmentPostLightingCode(this._pMethodSetup._iSpecularMethodVO, this._pRegisterCache, this._pSharedRegisters.shadedTarget);
		if (this._pMethodSetup._iSpecularMethodVO.needsNormals)
			this._pRegisterCache.removeFragmentTempUsage(this._pSharedRegisters.normalFragment);
		if (this._pMethodSetup._iSpecularMethodVO.needsView)
			this._pRegisterCache.removeFragmentTempUsage(this._pSharedRegisters.viewDirFragment);
	}
	if (this._pMethodSetup._iShadowMethod) {
		this._pRegisterCache.removeFragmentTempUsage(this._shadowRegister);
	}
};

away.materials.compilation.LightingShaderCompiler.prototype.compileShadowCode = function() {
	if (this._pSharedRegisters.normalFragment)
		this._shadowRegister = this._pSharedRegisters.normalFragment;
	else
		this._shadowRegister = this._pRegisterCache.getFreeFragmentVectorTemp();
	this._pRegisterCache.addFragmentTempUsages(this._shadowRegister, 1);
	this._pVertexCode += this._pMethodSetup._iShadowMethod.iGetVertexCode(this._pMethodSetup._iShadowMethodVO, this._pRegisterCache);
	this._pFragmentCode += this._pMethodSetup._iShadowMethod.iGetFragmentCode(this._pMethodSetup._iShadowMethodVO, this._pRegisterCache, this._shadowRegister);
};

away.materials.compilation.LightingShaderCompiler.prototype.initLightRegisters = function() {
	var i, len;
	if (this._dirLightVertexConstants) {
		len = this._dirLightVertexConstants.length;
		for (i = 0; i < len; ++i) {
			this._dirLightVertexConstants[i] = this._pRegisterCache.getFreeVertexConstant();
			if (this._lightVertexConstantIndex == -1) {
				this._lightVertexConstantIndex = this._dirLightVertexConstants[i].index * 4;
			}
		}
	}
	len = this._pointLightVertexConstants.length;
	for (i = 0; i < len; ++i) {
		this._pointLightVertexConstants[i] = this._pRegisterCache.getFreeVertexConstant();
		if (this._lightVertexConstantIndex == -1) {
			this._lightVertexConstantIndex = this._pointLightVertexConstants[i].index * 4;
		}
	}
	len = this._dirLightFragmentConstants.length;
	for (i = 0; i < len; ++i) {
		this._dirLightFragmentConstants[i] = this._pRegisterCache.getFreeFragmentConstant();
		if (this._pLightFragmentConstantIndex == -1) {
			this._pLightFragmentConstantIndex = this._dirLightFragmentConstants[i].index * 4;
		}
	}
	len = this._pointLightFragmentConstants.length;
	for (i = 0; i < len; ++i) {
		this._pointLightFragmentConstants[i] = this._pRegisterCache.getFreeFragmentConstant();
		if (this._pLightFragmentConstantIndex == -1) {
			this._pLightFragmentConstantIndex = this._pointLightFragmentConstants[i].index * 4;
		}
	}
};

away.materials.compilation.LightingShaderCompiler.prototype.compileDirectionalLightCode = function() {
	var diffuseColorReg;
	var specularColorReg;
	var lightDirReg;
	var vertexRegIndex = 0;
	var fragmentRegIndex = 0;
	var addSpec = this._usingSpecularMethod && this.pUsesLightsForSpecular();
	var addDiff = this.pUsesLightsForDiffuse();
	if (!(addSpec || addDiff))
		return;
	for (var i = 0; i < this._pNumDirectionalLights; ++i) {
		if (this.get_tangentSpace()) {
			lightDirReg = this._dirLightVertexConstants[vertexRegIndex++];
			var lightVarying = this._pRegisterCache.getFreeVarying();
			this._pVertexCode += "m33 " + lightVarying + ".xyz, " + lightDirReg + ", " + this._pSharedRegisters.animatedTangent + "\n" + "mov " + lightVarying + ".w, " + lightDirReg + ".w\n";
			lightDirReg = this._pRegisterCache.getFreeFragmentVectorTemp();
			this._pRegisterCache.addVertexTempUsages(lightDirReg, 1);
			this._pFragmentCode += "nrm " + lightDirReg + ".xyz, " + lightVarying + "\n";
			this._pFragmentCode += "mov " + lightDirReg + ".w, " + lightVarying + ".w\n";
		} else {
			lightDirReg = this._dirLightFragmentConstants[fragmentRegIndex++];
		}
		diffuseColorReg = this._dirLightFragmentConstants[fragmentRegIndex++];
		specularColorReg = this._dirLightFragmentConstants[fragmentRegIndex++];
		if (addDiff) {
			this._pFragmentCode += this._pMethodSetup._iDiffuseMethod.iGetFragmentCodePerLight(this._pMethodSetup._iDiffuseMethodVO, lightDirReg, diffuseColorReg, this._pRegisterCache);
		}
		if (addSpec) {
			this._pFragmentCode += this._pMethodSetup._iSpecularMethod.iGetFragmentCodePerLight(this._pMethodSetup._iSpecularMethodVO, lightDirReg, specularColorReg, this._pRegisterCache);
		}
		if (this.get_tangentSpace())
			this._pRegisterCache.removeVertexTempUsage(lightDirReg);
	}
};

away.materials.compilation.LightingShaderCompiler.prototype.compilePointLightCode = function() {
	var diffuseColorReg;
	var specularColorReg;
	var lightPosReg;
	var lightDirReg;
	var vertexRegIndex = 0;
	var fragmentRegIndex = 0;
	var addSpec = this._usingSpecularMethod && this.pUsesLightsForSpecular();
	var addDiff = this.pUsesLightsForDiffuse();
	if (!(addSpec || addDiff)) {
		return;
	}
	for (var i = 0; i < this._pNumPointLights; ++i) {
		lightPosReg = this._pointLightVertexConstants[vertexRegIndex++];
		diffuseColorReg = this._pointLightFragmentConstants[fragmentRegIndex++];
		specularColorReg = this._pointLightFragmentConstants[fragmentRegIndex++];
		lightDirReg = this._pRegisterCache.getFreeFragmentVectorTemp();
		this._pRegisterCache.addFragmentTempUsages(lightDirReg, 1);
		var lightVarying = this._pRegisterCache.getFreeVarying();
		if (this.get_tangentSpace()) {
			var temp = this._pRegisterCache.getFreeVertexVectorTemp();
			this._pVertexCode += "sub " + temp + ", " + lightPosReg + ", " + this._pSharedRegisters.localPosition + "\n" + "m33 " + lightVarying + ".xyz, " + temp + ", " + this._pSharedRegisters.animatedTangent + "\n" + "mov " + lightVarying + ".w, " + this._pSharedRegisters.localPosition + ".w\n";
		} else {
			this._pVertexCode += "sub " + lightVarying + ", " + lightPosReg + ", " + this._pSharedRegisters.globalPositionVertex + "\n";
		}
		if (this._pEnableLightFallOff && this._pProfile != "baselineConstrained") {
			this._pFragmentCode += "dp3 " + lightDirReg + ".w, " + lightVarying + ", " + lightVarying + "\n" + "sub " + lightDirReg + ".w, " + lightDirReg + ".w, " + diffuseColorReg + ".w\n" + "mul " + lightDirReg + ".w, " + lightDirReg + ".w, " + specularColorReg + ".w\n" + "sat " + lightDirReg + ".w, " + lightDirReg + ".w\n" + "sub " + lightDirReg + ".w, " + this._pSharedRegisters.commons + ".w, " + lightDirReg + ".w\n" + "nrm " + lightDirReg + ".xyz, " + lightVarying + "\n";
		} else {
			this._pFragmentCode += "nrm " + lightDirReg + ".xyz, " + lightVarying + "\n" + "mov " + lightDirReg + ".w, " + lightVarying + ".w\n";
		}
		if (this._pLightFragmentConstantIndex == -1) {
			this._pLightFragmentConstantIndex = lightPosReg.get_index() * 4;
		}
		if (addDiff) {
			this._pFragmentCode += this._pMethodSetup._iDiffuseMethod.iGetFragmentCodePerLight(this._pMethodSetup._iDiffuseMethodVO, lightDirReg, diffuseColorReg, this._pRegisterCache);
		}
		if (addSpec) {
			this._pFragmentCode += this._pMethodSetup._iSpecularMethod.iGetFragmentCodePerLight(this._pMethodSetup._iSpecularMethodVO, lightDirReg, specularColorReg, this._pRegisterCache);
		}
		this._pRegisterCache.removeFragmentTempUsage(lightDirReg);
	}
};

away.materials.compilation.LightingShaderCompiler.prototype.compileLightProbeCode = function() {
	var weightReg;
	var weightComponents = [".x", ".y", ".z", ".w"];
	var weightRegisters = [];
	var i;
	var texReg;
	var addSpec = this._usingSpecularMethod && this.pUsesProbesForSpecular();
	var addDiff = this.pUsesProbesForDiffuse();
	if (!(addSpec || addDiff)) {
		return;
	}
	if (addDiff) {
		this._pLightProbeDiffuseIndices = away.utils.VectorInit.Num(0, 0);
	}
	if (addSpec) {
		this._pLightProbeSpecularIndices = away.utils.VectorInit.Num(0, 0);
	}
	for (i = 0; i < this._pNumProbeRegisters; ++i) {
		weightRegisters[i] = this._pRegisterCache.getFreeFragmentConstant();
		if (i == 0) {
			this._pProbeWeightsIndex = weightRegisters[i].index * 4;
		}
	}
	for (i = 0; i < this._pNumLightProbes; ++i) {
		weightReg = weightRegisters[Math.floor(i / 4)].toString() + weightComponents[i % 4];
		if (addDiff) {
			texReg = this._pRegisterCache.getFreeTextureReg();
			this._pLightProbeDiffuseIndices[i] = texReg.get_index();
			this._pFragmentCode += this._pMethodSetup._iDiffuseMethod.iGetFragmentCodePerProbe(this._pMethodSetup._iDiffuseMethodVO, texReg, weightReg, this._pRegisterCache);
		}
		if (addSpec) {
			texReg = this._pRegisterCache.getFreeTextureReg();
			this._pLightProbeSpecularIndices[i] = texReg.get_index();
			this._pFragmentCode += this._pMethodSetup._iSpecularMethod.iGetFragmentCodePerProbe(this._pMethodSetup._iSpecularMethodVO, texReg, weightReg, this._pRegisterCache);
		}
	}
};

$inherit(away.materials.compilation.LightingShaderCompiler, away.materials.compilation.ShaderCompiler);

away.materials.compilation.LightingShaderCompiler.className = "away.materials.compilation.LightingShaderCompiler";

away.materials.compilation.LightingShaderCompiler.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.materials.compilation.ShaderRegisterData');
	p.push('away.materials.compilation.MethodDependencyCounter');
	p.push('away.utils.VectorInit');
	p.push('away.materials.methods.ShaderMethodSetup');
	return p;
};

away.materials.compilation.LightingShaderCompiler.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.materials.compilation.LightingShaderCompiler.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'profile', t:'String'});
			break;
		case 1:
			p = away.materials.compilation.ShaderCompiler.injectionPoints(t);
			break;
		case 2:
			p = away.materials.compilation.ShaderCompiler.injectionPoints(t);
			break;
		case 3:
			p = away.materials.compilation.ShaderCompiler.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

