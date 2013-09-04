/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 04 21:18:39 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};
if (typeof away.materials.compilation == "undefined")
	away.materials.compilation = {};

away.materials.compilation.SuperShaderCompiler = function(profile) {
	this._pointLightRegisters = null;
	this._dirLightRegisters = null;
	away.materials.compilation.ShaderCompiler.call(this, profile);
};

away.materials.compilation.SuperShaderCompiler.prototype.pInitLightData = function() {
	away.materials.compilation.ShaderCompiler.prototype.pInitLightData.call(this);
	this._pointLightRegisters = [];
	this._dirLightRegisters = [];
};

away.materials.compilation.SuperShaderCompiler.prototype.pCalculateDependencies = function() {
	away.materials.compilation.ShaderCompiler.prototype.pCalculateDependencies.call(this);
	this._pDependencyCounter.addWorldSpaceDependencies(true);
};

away.materials.compilation.SuperShaderCompiler.prototype.pCompileNormalCode = function() {
	var normalMatrix = [null, null, null];
	this._pSharedRegisters.normalFragment = this._pRegisterCache.getFreeFragmentVectorTemp();
	this._pRegisterCache.addFragmentTempUsages(this._pSharedRegisters.normalFragment, this._pDependencyCounter.get_normalDependencies());
	if (this._pMethodSetup._iNormalMethod.get_iHasOutput() && !this._pMethodSetup._iNormalMethod.get_iTangentSpace()) {
		this._pVertexCode += this._pMethodSetup._iNormalMethod.iGetVertexCode(this._pMethodSetup._iNormalMethodVO, this._pRegisterCache);
		this._pFragmentCode += this._pMethodSetup._iNormalMethod.iGetFragmentCode(this._pMethodSetup._iNormalMethodVO, this._pRegisterCache, this._pSharedRegisters.normalFragment);
		return;
	}
	this._pSharedRegisters.normalVarying = this._pRegisterCache.getFreeVarying();
	normalMatrix[0] = this._pRegisterCache.getFreeVertexConstant();
	normalMatrix[1] = this._pRegisterCache.getFreeVertexConstant();
	normalMatrix[2] = this._pRegisterCache.getFreeVertexConstant();
	this._pRegisterCache.getFreeVertexConstant();
	this._pSceneNormalMatrixIndex = normalMatrix[0].index * 4;
	if (this._pMethodSetup._iNormalMethod.get_iHasOutput()) {
		this.compileTangentVertexCode(normalMatrix);
		this.compileTangentNormalMapFragmentCode();
	} else {
		this._pVertexCode += "m33 " + this._pSharedRegisters.normalVarying.toString() + ".xyz, " + this._pSharedRegisters.animatedNormal.toString() + ", " + normalMatrix[0].toString() + "\n" + "mov " + this._pSharedRegisters.normalVarying.toString() + ".w, " + this._pSharedRegisters.animatedNormal.toString() + ".w\t\n";
		this._pFragmentCode += "nrm " + this._pSharedRegisters.normalFragment.toString() + ".xyz, " + this._pSharedRegisters.normalVarying.toString() + "\n" + "mov " + this._pSharedRegisters.normalFragment.toString() + ".w, " + this._pSharedRegisters.normalVarying.toString() + ".w\t\t\n";
		if (this._pDependencyCounter.get_tangentDependencies() > 0) {
			this._pSharedRegisters.tangentInput = this._pRegisterCache.getFreeVertexAttribute();
			this._pTangentBufferIndex = this._pSharedRegisters.tangentInput.get_index();
			this._pSharedRegisters.tangentVarying = this._pRegisterCache.getFreeVarying();
			this._pVertexCode += "mov " + this._pSharedRegisters.tangentVarying.toString() + ", " + this._pSharedRegisters.tangentInput.toString() + "\n";
		}
	}
	this._pRegisterCache.removeVertexTempUsage(this._pSharedRegisters.animatedNormal);
};

away.materials.compilation.SuperShaderCompiler.prototype.pCreateNormalRegisters = function() {
	if (this._pDependencyCounter.get_normalDependencies() > 0) {
		this._pSharedRegisters.normalInput = this._pRegisterCache.getFreeVertexAttribute();
		this._pNormalBufferIndex = this._pSharedRegisters.normalInput.get_index();
		this._pSharedRegisters.animatedNormal = this._pRegisterCache.getFreeVertexVectorTemp();
		this._pRegisterCache.addVertexTempUsages(this._pSharedRegisters.animatedNormal, 1);
		this._pAnimatableAttributes.push(this._pSharedRegisters.normalInput.toString());
		this._pAnimationTargetRegisters.push(this._pSharedRegisters.animatedNormal.toString());
	}
	if (this._pMethodSetup._iNormalMethod.get_iHasOutput()) {
		this._pSharedRegisters.tangentInput = this._pRegisterCache.getFreeVertexAttribute();
		this._pTangentBufferIndex = this._pSharedRegisters.tangentInput.get_index();
		this._pSharedRegisters.animatedTangent = this._pRegisterCache.getFreeVertexVectorTemp();
		this._pRegisterCache.addVertexTempUsages(this._pSharedRegisters.animatedTangent, 1);
		this._pAnimatableAttributes.push(this._pSharedRegisters.tangentInput.toString());
		this._pAnimationTargetRegisters.push(this._pSharedRegisters.animatedTangent.toString());
	}
};

away.materials.compilation.SuperShaderCompiler.prototype.compileTangentVertexCode = function(matrix) {
	this._pSharedRegisters.tangentVarying = this._pRegisterCache.getFreeVarying();
	this._pSharedRegisters.bitangentVarying = this._pRegisterCache.getFreeVarying();
	this._pVertexCode += "m33 " + this._pSharedRegisters.animatedNormal.toString() + ".xyz, " + this._pSharedRegisters.animatedNormal.toString() + ", " + matrix[0].toString() + "\n" + "nrm " + this._pSharedRegisters.animatedNormal.toString() + ".xyz, " + this._pSharedRegisters.animatedNormal.toString() + "\n";
	this._pVertexCode += "m33 " + this._pSharedRegisters.animatedTangent.toString() + ".xyz, " + this._pSharedRegisters.animatedTangent.toString() + ", " + matrix[0].toString() + "\n" + "nrm " + this._pSharedRegisters.animatedTangent.toString() + ".xyz, " + this._pSharedRegisters.animatedTangent.toString() + "\n";
	var bitanTemp = this._pRegisterCache.getFreeVertexVectorTemp();
	this._pVertexCode += "mov " + this._pSharedRegisters.tangentVarying.toString() + ".x, " + this._pSharedRegisters.animatedTangent.toString() + ".x  \n" + "mov " + this._pSharedRegisters.tangentVarying.toString() + ".z, " + this._pSharedRegisters.animatedNormal.toString() + ".x  \n" + "mov " + this._pSharedRegisters.tangentVarying.toString() + ".w, " + this._pSharedRegisters.normalInput.toString() + ".w  \n" + "mov " + this._pSharedRegisters.bitangentVarying.toString() + ".x, " + this._pSharedRegisters.animatedTangent.toString() + ".y  \n" + "mov " + this._pSharedRegisters.bitangentVarying.toString() + ".z, " + this._pSharedRegisters.animatedNormal.toString() + ".y  \n" + "mov " + this._pSharedRegisters.bitangentVarying.toString() + ".w, " + this._pSharedRegisters.normalInput.toString() + ".w  \n" + "mov " + this._pSharedRegisters.normalVarying.toString() + ".x, " + this._pSharedRegisters.animatedTangent.toString() + ".z  \n" + "mov " + this._pSharedRegisters.normalVarying.toString() + ".z, " + this._pSharedRegisters.animatedNormal.toString() + ".z  \n" + "mov " + this._pSharedRegisters.normalVarying.toString() + ".w, " + this._pSharedRegisters.normalInput.toString() + ".w  \n" + "crs " + bitanTemp.toString() + ".xyz, " + this._pSharedRegisters.animatedNormal.toString() + ", " + this._pSharedRegisters.animatedTangent.toString() + "\n" + "mov " + this._pSharedRegisters.tangentVarying.toString() + ".y, " + bitanTemp.toString() + ".x    \n" + "mov " + this._pSharedRegisters.bitangentVarying.toString() + ".y, " + bitanTemp.toString() + ".y  \n" + "mov " + this._pSharedRegisters.normalVarying.toString() + ".y, " + bitanTemp.toString() + ".z    \n";
	this._pRegisterCache.removeVertexTempUsage(this._pSharedRegisters.animatedTangent);
};

away.materials.compilation.SuperShaderCompiler.prototype.compileTangentNormalMapFragmentCode = function() {
	var t;
	var b;
	var n;
	t = this._pRegisterCache.getFreeFragmentVectorTemp();
	this._pRegisterCache.addFragmentTempUsages(t, 1);
	b = this._pRegisterCache.getFreeFragmentVectorTemp();
	this._pRegisterCache.addFragmentTempUsages(b, 1);
	n = this._pRegisterCache.getFreeFragmentVectorTemp();
	this._pRegisterCache.addFragmentTempUsages(n, 1);
	this._pFragmentCode += "nrm " + t.toString() + ".xyz, " + this._pSharedRegisters.tangentVarying.toString() + "\n" + "mov " + t.toString() + ".w, " + this._pSharedRegisters.tangentVarying.toString() + ".w\t\n" + "nrm " + b.toString() + ".xyz, " + this._pSharedRegisters.bitangentVarying.toString() + "\n" + "nrm " + n.toString() + ".xyz, " + this._pSharedRegisters.normalVarying.toString() + "\n";
	var temp = this._pRegisterCache.getFreeFragmentVectorTemp();
	this._pRegisterCache.addFragmentTempUsages(temp, 1);
	this._pFragmentCode += this._pMethodSetup._iNormalMethod.iGetFragmentCode(this._pMethodSetup._iNormalMethodVO, this._pRegisterCache, temp) + "m33 " + this._pSharedRegisters.normalFragment.toString() + ".xyz, " + temp.toString() + ", " + t.toString() + "\t\n" + "mov " + this._pSharedRegisters.normalFragment.toString() + ".w,   " + this._pSharedRegisters.normalVarying.toString() + ".w\t\t\t\n";
	this._pRegisterCache.removeFragmentTempUsage(temp);
	if (this._pMethodSetup._iNormalMethodVO.needsView) {
		this._pRegisterCache.removeFragmentTempUsage(this._pSharedRegisters.viewDirFragment);
	}
	if (this._pMethodSetup._iNormalMethodVO.needsGlobalVertexPos || this._pMethodSetup._iNormalMethodVO.needsGlobalFragmentPos) {
		this._pRegisterCache.removeVertexTempUsage(this._pSharedRegisters.globalPositionVertex);
	}
	this._pRegisterCache.removeFragmentTempUsage(b);
	this._pRegisterCache.removeFragmentTempUsage(t);
	this._pRegisterCache.removeFragmentTempUsage(n);
};

away.materials.compilation.SuperShaderCompiler.prototype.pCompileViewDirCode = function() {
	var cameraPositionReg = this._pRegisterCache.getFreeVertexConstant();
	this._pSharedRegisters.viewDirVarying = this._pRegisterCache.getFreeVarying();
	this._pSharedRegisters.viewDirFragment = this._pRegisterCache.getFreeFragmentVectorTemp();
	this._pRegisterCache.addFragmentTempUsages(this._pSharedRegisters.viewDirFragment, this._pDependencyCounter.get_viewDirDependencies());
	this._pCameraPositionIndex = cameraPositionReg.get_index() * 4;
	this._pVertexCode += "sub " + this._pSharedRegisters.viewDirVarying.toString() + ", " + cameraPositionReg.toString() + ", " + this._pSharedRegisters.globalPositionVertex.toString() + "\n";
	this._pFragmentCode += "nrm " + this._pSharedRegisters.viewDirFragment.toString() + ".xyz, " + this._pSharedRegisters.viewDirVarying.toString() + "\n" + "mov " + this._pSharedRegisters.viewDirFragment.toString() + ".w,   " + this._pSharedRegisters.viewDirVarying.toString() + ".w \t\t\n";
	this._pRegisterCache.removeVertexTempUsage(this._pSharedRegisters.globalPositionVertex);
};

away.materials.compilation.SuperShaderCompiler.prototype.pCompileLightingCode = function() {
	var shadowReg;
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
	if (this.pUsesProbes()) {
		this.compileLightProbeCode();
	}
	this._pVertexCode += this._pMethodSetup._iAmbientMethod.iGetVertexCode(this._pMethodSetup._iAmbientMethodVO, this._pRegisterCache);
	this._pFragmentCode += this._pMethodSetup._iAmbientMethod.iGetFragmentCode(this._pMethodSetup._iAmbientMethodVO, this._pRegisterCache, this._pSharedRegisters.shadedTarget);
	if (this._pMethodSetup._iAmbientMethodVO.needsNormals) {
		this._pRegisterCache.removeFragmentTempUsage(this._pSharedRegisters.normalFragment);
	}
	if (this._pMethodSetup._iAmbientMethodVO.needsView) {
		this._pRegisterCache.removeFragmentTempUsage(this._pSharedRegisters.viewDirFragment);
	}
	if (this._pMethodSetup._iShadowMethod) {
		this._pVertexCode += this._pMethodSetup._iShadowMethod.iGetVertexCode(this._pMethodSetup._iShadowMethodVO, this._pRegisterCache);
		if (this._pDependencyCounter.get_normalDependencies() == 0) {
			shadowReg = this._pRegisterCache.getFreeFragmentVectorTemp();
			this._pRegisterCache.addFragmentTempUsages(shadowReg, 1);
		} else {
			shadowReg = this._pSharedRegisters.normalFragment;
		}
		this._pMethodSetup._iDiffuseMethod.set_iShadowRegister(shadowReg);
		this._pFragmentCode += this._pMethodSetup._iShadowMethod.iGetFragmentCode(this._pMethodSetup._iShadowMethodVO, this._pRegisterCache, shadowReg);
	}
	this._pFragmentCode += this._pMethodSetup._iDiffuseMethod.iGetFragmentPostLightingCode(this._pMethodSetup._iDiffuseMethodVO, this._pRegisterCache, this._pSharedRegisters.shadedTarget);
	if (this._pAlphaPremultiplied) {
		this._pFragmentCode += "add " + this._pSharedRegisters.shadedTarget.toString() + ".w, " + this._pSharedRegisters.shadedTarget.toString() + ".w, " + this._pSharedRegisters.commons.toString() + ".z\n" + "div " + this._pSharedRegisters.shadedTarget.toString() + ".xyz, " + this._pSharedRegisters.shadedTarget.toString() + ", " + this._pSharedRegisters.shadedTarget.toString() + ".w\n" + "sub " + this._pSharedRegisters.shadedTarget.toString() + ".w, " + this._pSharedRegisters.shadedTarget.toString() + ".w, " + this._pSharedRegisters.commons.toString() + ".z\n" + "sat " + this._pSharedRegisters.shadedTarget.toString() + ".xyz, " + this._pSharedRegisters.shadedTarget.toString() + "\n";
	}
	if (this._pMethodSetup._iDiffuseMethodVO.needsNormals) {
		this._pRegisterCache.removeFragmentTempUsage(this._pSharedRegisters.normalFragment);
	}
	if (this._pMethodSetup._iDiffuseMethodVO.needsView) {
		this._pRegisterCache.removeFragmentTempUsage(this._pSharedRegisters.viewDirFragment);
	}
	if (this._usingSpecularMethod) {
		this._pMethodSetup._iSpecularMethod.set_iShadowRegister(shadowReg);
		this._pFragmentCode += this._pMethodSetup._iSpecularMethod.iGetFragmentPostLightingCode(this._pMethodSetup._iSpecularMethodVO, this._pRegisterCache, this._pSharedRegisters.shadedTarget);
		if (this._pMethodSetup._iSpecularMethodVO.needsNormals) {
			this._pRegisterCache.removeFragmentTempUsage(this._pSharedRegisters.normalFragment);
		}
		if (this._pMethodSetup._iSpecularMethodVO.needsView) {
			this._pRegisterCache.removeFragmentTempUsage(this._pSharedRegisters.viewDirFragment);
		}
	}
};

away.materials.compilation.SuperShaderCompiler.prototype.initLightRegisters = function() {
	var i, len;
	len = this._dirLightRegisters.length;
	for (i = 0; i < len; ++i) {
		this._dirLightRegisters[i] = this._pRegisterCache.getFreeFragmentConstant();
		if (this._pLightFragmentConstantIndex == -1) {
			this._pLightFragmentConstantIndex = this._dirLightRegisters[i].index * 4;
		}
	}
	len = this._pointLightRegisters.length;
	for (i = 0; i < len; ++i) {
		this._pointLightRegisters[i] = this._pRegisterCache.getFreeFragmentConstant();
		if (this._pLightFragmentConstantIndex == -1) {
			this._pLightFragmentConstantIndex = this._pointLightRegisters[i].index * 4;
		}
	}
};

away.materials.compilation.SuperShaderCompiler.prototype.compileDirectionalLightCode = function() {
	var diffuseColorReg;
	var specularColorReg;
	var lightDirReg;
	var regIndex = 0;
	var addSpec = this._usingSpecularMethod && this.pUsesLightsForSpecular();
	var addDiff = this.pUsesLightsForDiffuse();
	if (!(addSpec || addDiff)) {
		return;
	}
	for (var i = 0; i < this._pNumDirectionalLights; ++i) {
		lightDirReg = this._dirLightRegisters[regIndex++];
		diffuseColorReg = this._dirLightRegisters[regIndex++];
		specularColorReg = this._dirLightRegisters[regIndex++];
		if (addDiff) {
			this._pFragmentCode += this._pMethodSetup._iDiffuseMethod.iGetFragmentCodePerLight(this._pMethodSetup._iDiffuseMethodVO, lightDirReg, diffuseColorReg, this._pRegisterCache);
		}
		if (addSpec) {
			this._pFragmentCode += this._pMethodSetup._iSpecularMethod.iGetFragmentCodePerLight(this._pMethodSetup._iSpecularMethodVO, lightDirReg, specularColorReg, this._pRegisterCache);
		}
	}
};

away.materials.compilation.SuperShaderCompiler.prototype.compilePointLightCode = function() {
	var diffuseColorReg;
	var specularColorReg;
	var lightPosReg;
	var lightDirReg;
	var regIndex = 0;
	var addSpec = this._usingSpecularMethod && this.pUsesLightsForSpecular();
	var addDiff = this.pUsesLightsForDiffuse();
	if (!(addSpec || addDiff)) {
		return;
	}
	for (var i = 0; i < this._pNumPointLights; ++i) {
		lightPosReg = this._pointLightRegisters[regIndex++];
		diffuseColorReg = this._pointLightRegisters[regIndex++];
		specularColorReg = this._pointLightRegisters[regIndex++];
		lightDirReg = this._pRegisterCache.getFreeFragmentVectorTemp();
		this._pRegisterCache.addFragmentTempUsages(lightDirReg, 1);
		this._pFragmentCode += "sub " + lightDirReg.toString() + ", " + lightPosReg.toString() + ", " + this._pSharedRegisters.globalPositionVarying.toString() + "\n" + "dp3 " + lightDirReg.toString() + ".w, " + lightDirReg.toString() + ", " + lightDirReg.toString() + "\n" + "sub " + lightDirReg.toString() + ".w, " + lightDirReg.toString() + ".w, " + diffuseColorReg.toString() + ".w\n" + "mul " + lightDirReg.toString() + ".w, " + lightDirReg.toString() + ".w, " + specularColorReg.toString() + ".w\n" + "sat " + lightDirReg.toString() + ".w, " + lightDirReg.toString() + ".w\n" + "sub " + lightDirReg.toString() + ".w, " + lightPosReg.toString() + ".w, " + lightDirReg.toString() + ".w\n" + "nrm " + lightDirReg.toString() + ".xyz, " + lightDirReg.toString() + "\n";
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

away.materials.compilation.SuperShaderCompiler.prototype.compileLightProbeCode = function() {
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
		this._pLightProbeDiffuseIndices = [];
	}
	if (addSpec) {
		this._pLightProbeSpecularIndices = [];
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

$inherit(away.materials.compilation.SuperShaderCompiler, away.materials.compilation.ShaderCompiler);

away.materials.compilation.SuperShaderCompiler.className = "away.materials.compilation.SuperShaderCompiler";

away.materials.compilation.SuperShaderCompiler.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.materials.compilation.ShaderRegisterData');
	p.push('away.materials.compilation.MethodDependencyCounter');
	p.push('away.materials.methods.ShaderMethodSetup');
	return p;
};

away.materials.compilation.SuperShaderCompiler.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.materials.compilation.SuperShaderCompiler.injectionPoints = function(t) {
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

