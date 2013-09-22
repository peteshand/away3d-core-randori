/** Compiled by the Randori compiler v0.2.6.2 on Sun Sep 22 12:28:45 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};
if (typeof away.materials.compilation == "undefined")
	away.materials.compilation = {};

away.materials.compilation.ShaderCompiler = function(profile) {
	this._diffuseLightSources = 0;
	this._pEnableLightFallOff = null;
	this._combinedLightSources = 0;
	this._UVTarget = null;
	this._pNumPointLights = 0;
	this._vertexConstantData = null;
	this._pCameraPositionIndex = -1;
	this._usingSpecularMethod = null;
	this._secondaryUVBufferIndex = -1;
	this._mipmap = null;
	this._pAnimationTargetRegisters = null;
	this._pSceneNormalMatrixIndex = -1;
	this._specularLightSources = 0;
	this._commonsDataIndex = -1;
	this._pNormalBufferIndex = -1;
	this._pNumLightProbes = 0;
	this._fragmentPostLightCode = null;
	this._smooth = null;
	this._pMethodSetup = null;
	this._preserveAlpha = true;
	this._animateUVs = null;
	this._sceneMatrixIndex = -1;
	this._uvTransformIndex = -1;
	this._fragmentLightCode = null;
	this._UVSource = null;
	this._pVertexCode = "";
	this._pNumLights = 0;
	this._pAlphaPremultiplied = null;
	this._pLightFragmentConstantIndex = -1;
	this._uvBufferIndex = -1;
	this._pNumDirectionalLights = 0;
	this._pProbeWeightsIndex = -1;
	this._pAnimatableAttributes = null;
	this._pProfile = null;
	this._pLightProbeDiffuseIndices = null;
	this._pTangentBufferIndex = -1;
	this._pSharedRegisters = null;
	this._fragmentConstantData = null;
	this._pRegisterCache = null;
	this._pNumProbeRegisters = 0;
	this._needUVAnimation = null;
	this._forceSeperateMVP = null;
	this._pFragmentCode = "";
	this._repeat = null;
	this._pLightProbeSpecularIndices = null;
	this._pDependencyCounter = null;
	this._pSharedRegisters = new away.materials.compilation.ShaderRegisterData();
	this._pDependencyCounter = new away.materials.compilation.MethodDependencyCounter();
	this._pProfile = profile;
	this.initRegisterCache(profile);
};

away.materials.compilation.ShaderCompiler.prototype.get_enableLightFallOff = function() {
	return this._pEnableLightFallOff;
};

away.materials.compilation.ShaderCompiler.prototype.set_enableLightFallOff = function(value) {
	this._pEnableLightFallOff = value;
};

away.materials.compilation.ShaderCompiler.prototype.get_needUVAnimation = function() {
	return this._needUVAnimation;
};

away.materials.compilation.ShaderCompiler.prototype.get_UVTarget = function() {
	return this._UVTarget;
};

away.materials.compilation.ShaderCompiler.prototype.get_UVSource = function() {
	return this._UVSource;
};

away.materials.compilation.ShaderCompiler.prototype.get_forceSeperateMVP = function() {
	return this._forceSeperateMVP;
};

away.materials.compilation.ShaderCompiler.prototype.set_forceSeperateMVP = function(value) {
	this._forceSeperateMVP = value;
};

away.materials.compilation.ShaderCompiler.prototype.initRegisterCache = function(profile) {
	this._pRegisterCache = new away.materials.compilation.ShaderRegisterCache(profile);
	this._pRegisterCache.set_vertexAttributesOffset(1);
	this._pRegisterCache.reset();
};

away.materials.compilation.ShaderCompiler.prototype.get_animateUVs = function() {
	return this._animateUVs;
};

away.materials.compilation.ShaderCompiler.prototype.set_animateUVs = function(value) {
	this._animateUVs = value;
};

away.materials.compilation.ShaderCompiler.prototype.get_alphaPremultiplied = function() {
	return this._pAlphaPremultiplied;
};

away.materials.compilation.ShaderCompiler.prototype.set_alphaPremultiplied = function(value) {
	this._pAlphaPremultiplied = value;
};

away.materials.compilation.ShaderCompiler.prototype.get_preserveAlpha = function() {
	return this._preserveAlpha;
};

away.materials.compilation.ShaderCompiler.prototype.set_preserveAlpha = function(value) {
	this._preserveAlpha = value;
};

away.materials.compilation.ShaderCompiler.prototype.setTextureSampling = function(smooth, repeat, mipmap) {
	this._smooth = smooth;
	this._repeat = repeat;
	this._mipmap = mipmap;
};

away.materials.compilation.ShaderCompiler.prototype.setConstantDataBuffers = function(vertexConstantData, fragmentConstantData) {
	this._vertexConstantData = vertexConstantData;
	this._fragmentConstantData = fragmentConstantData;
};

away.materials.compilation.ShaderCompiler.prototype.get_methodSetup = function() {
	return this._pMethodSetup;
};

away.materials.compilation.ShaderCompiler.prototype.set_methodSetup = function(value) {
	this._pMethodSetup = value;
};

away.materials.compilation.ShaderCompiler.prototype.compile = function() {
	this.pInitRegisterIndices();
	this.pInitLightData();
	this._pAnimatableAttributes = ["va0"];
	this._pAnimationTargetRegisters = ["vt0"];
	this._pVertexCode = "";
	this._pFragmentCode = "";
	this._pSharedRegisters.localPosition = this._pRegisterCache.getFreeVertexVectorTemp();
	this._pRegisterCache.addVertexTempUsages(this._pSharedRegisters.localPosition, 1);
	this.createCommons();
	this.pCalculateDependencies();
	this.updateMethodRegisters();
	for (var i = 0; i < 4; ++i)
		this._pRegisterCache.getFreeVertexConstant();
	this.pCreateNormalRegisters();
	if (this._pDependencyCounter.get_globalPosDependencies() > 0 || this._forceSeperateMVP)
		this.pCompileGlobalPositionCode();
	this.compileProjectionCode();
	this.pCompileMethodsCode();
	this.compileFragmentOutput();
	this._fragmentPostLightCode = this.get_fragmentCode();
};

away.materials.compilation.ShaderCompiler.prototype.pCreateNormalRegisters = function() {
};

away.materials.compilation.ShaderCompiler.prototype.pCompileMethodsCode = function() {
	if (this._pDependencyCounter.get_uvDependencies() > 0)
		this.compileUVCode();
	if (this._pDependencyCounter.get_secondaryUVDependencies() > 0)
		this.compileSecondaryUVCode();
	if (this._pDependencyCounter.get_normalDependencies() > 0)
		this.pCompileNormalCode();
	if (this._pDependencyCounter.get_viewDirDependencies() > 0)
		this.pCompileViewDirCode();
	this.pCompileLightingCode();
	this._fragmentLightCode = this._pFragmentCode;
	this._pFragmentCode = "";
	this.pCompileMethods();
};

away.materials.compilation.ShaderCompiler.prototype.pCompileLightingCode = function() {
};

away.materials.compilation.ShaderCompiler.prototype.pCompileViewDirCode = function() {
};

away.materials.compilation.ShaderCompiler.prototype.pCompileNormalCode = function() {
};

away.materials.compilation.ShaderCompiler.prototype.compileUVCode = function() {
	var uvAttributeReg = this._pRegisterCache.getFreeVertexAttribute();
	this._uvBufferIndex = uvAttributeReg.get_index();
	var varying = this._pRegisterCache.getFreeVarying();
	this._pSharedRegisters.uvVarying = varying;
	if (this.get_animateUVs()) {
		var uvTransform1 = this._pRegisterCache.getFreeVertexConstant();
		var uvTransform2 = this._pRegisterCache.getFreeVertexConstant();
		this._uvTransformIndex = uvTransform1.get_index() * 4;
		this._pVertexCode += "dp4 " + varying.toString() + ".x, " + uvAttributeReg.toString() + ", " + uvTransform1.toString() + "\n" + "dp4 " + varying.toString() + ".y, " + uvAttributeReg.toString() + ", " + uvTransform2.toString() + "\n" + "mov " + varying.toString() + ".zw, " + uvAttributeReg.toString() + ".zw \n";
	} else {
		this._uvTransformIndex = -1;
		this._needUVAnimation = true;
		this._UVTarget = varying.toString();
		this._UVSource = uvAttributeReg.toString();
	}
};

away.materials.compilation.ShaderCompiler.prototype.compileSecondaryUVCode = function() {
	var uvAttributeReg = this._pRegisterCache.getFreeVertexAttribute();
	this._secondaryUVBufferIndex = uvAttributeReg.get_index();
	this._pSharedRegisters.secondaryUVVarying = this._pRegisterCache.getFreeVarying();
	this._pVertexCode += "mov " + this._pSharedRegisters.secondaryUVVarying.toString() + ", " + uvAttributeReg.toString() + "\n";
};

away.materials.compilation.ShaderCompiler.prototype.pCompileGlobalPositionCode = function() {
	this._pSharedRegisters.globalPositionVertex = this._pRegisterCache.getFreeVertexVectorTemp();
	this._pRegisterCache.addVertexTempUsages(this._pSharedRegisters.globalPositionVertex, this._pDependencyCounter.get_globalPosDependencies());
	var positionMatrixReg = this._pRegisterCache.getFreeVertexConstant();
	this._pRegisterCache.getFreeVertexConstant();
	this._pRegisterCache.getFreeVertexConstant();
	this._pRegisterCache.getFreeVertexConstant();
	this._sceneMatrixIndex = positionMatrixReg.get_index() * 4;
	this._pVertexCode += "m44 " + this._pSharedRegisters.globalPositionVertex.toString() + ", " + this._pSharedRegisters.localPosition.toString() + ", " + positionMatrixReg.toString() + "\n";
	if (this._pDependencyCounter.get_usesGlobalPosFragment()) {
		this._pSharedRegisters.globalPositionVarying = this._pRegisterCache.getFreeVarying();
		this._pVertexCode += "mov " + this._pSharedRegisters.globalPositionVarying.toString() + ", " + this._pSharedRegisters.globalPositionVertex.toString() + "\n";
	}
};

away.materials.compilation.ShaderCompiler.prototype.compileProjectionCode = function() {
	var pos = this._pDependencyCounter.get_globalPosDependencies() > 0 || this._forceSeperateMVP ? this._pSharedRegisters.globalPositionVertex.toString() : this._pAnimationTargetRegisters[0];
	var code;
	if (this._pDependencyCounter.get_projectionDependencies() > 0) {
		this._pSharedRegisters.projectionFragment = this._pRegisterCache.getFreeVarying();
		code = "m44 vt5, " + pos + ", vc0\t\t\n" + "mov " + this._pSharedRegisters.projectionFragment.toString() + ", vt5\n" + "mov op, vt5\n";
	} else {
		code = "m44 op, " + pos + ", vc0\t\t\n";
	}
	this._pVertexCode += code;
};

away.materials.compilation.ShaderCompiler.prototype.compileFragmentOutput = function() {
	this._pFragmentCode += "mov " + this._pRegisterCache.get_fragmentOutputRegister().toString() + ", " + this._pSharedRegisters.shadedTarget.toString() + "\n";
	this._pRegisterCache.removeFragmentTempUsage(this._pSharedRegisters.shadedTarget);
};

away.materials.compilation.ShaderCompiler.prototype.pInitRegisterIndices = function() {
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
};

away.materials.compilation.ShaderCompiler.prototype.pInitLightData = function() {
	this._pNumLights = this._pNumPointLights + this._pNumDirectionalLights;
	this._pNumProbeRegisters = Math.ceil(this._pNumLightProbes / 4);
	if (this._pMethodSetup._iSpecularMethod) {
		this._combinedLightSources = this._specularLightSources | this._diffuseLightSources;
	} else {
		this._combinedLightSources = this._diffuseLightSources;
	}
	this._usingSpecularMethod = this._pMethodSetup._iSpecularMethod && (this.pUsesLightsForSpecular() || this.pUsesProbesForSpecular());
};

away.materials.compilation.ShaderCompiler.prototype.createCommons = function() {
	this._pSharedRegisters.commons = this._pRegisterCache.getFreeFragmentConstant();
	this._commonsDataIndex = this._pSharedRegisters.commons.get_index() * 4;
};

away.materials.compilation.ShaderCompiler.prototype.pCalculateDependencies = function() {
	this._pDependencyCounter.reset();
	var methods = this._pMethodSetup._iMethods;
	var len;
	this.setupAndCountMethodDependencies(this._pMethodSetup._iDiffuseMethod, this._pMethodSetup._iDiffuseMethodVO);
	if (this._pMethodSetup._iShadowMethod)
		this.setupAndCountMethodDependencies(this._pMethodSetup._iShadowMethod, this._pMethodSetup._iShadowMethodVO);
	this.setupAndCountMethodDependencies(this._pMethodSetup._iAmbientMethod, this._pMethodSetup._iAmbientMethodVO);
	if (this._usingSpecularMethod)
		this.setupAndCountMethodDependencies(this._pMethodSetup._iSpecularMethod, this._pMethodSetup._iSpecularMethodVO);
	if (this._pMethodSetup._iColorTransformMethod)
		this.setupAndCountMethodDependencies(this._pMethodSetup._iColorTransformMethod, this._pMethodSetup._iColorTransformMethodVO);
	len = methods.length;
	for (var i = 0; i < len; ++i)
		this.setupAndCountMethodDependencies(methods[i].method, methods[i].data);
	if (this.get_usesNormals())
		this.setupAndCountMethodDependencies(this._pMethodSetup._iNormalMethod, this._pMethodSetup._iNormalMethodVO);
	this._pDependencyCounter.setPositionedLights(this._pNumPointLights, this._combinedLightSources);
};

away.materials.compilation.ShaderCompiler.prototype.setupAndCountMethodDependencies = function(method, methodVO) {
	this.setupMethod(method, methodVO);
	this._pDependencyCounter.includeMethodVO(methodVO);
};

away.materials.compilation.ShaderCompiler.prototype.setupMethod = function(method, methodVO) {
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
};

away.materials.compilation.ShaderCompiler.prototype.get_commonsDataIndex = function() {
	return this._commonsDataIndex;
};

away.materials.compilation.ShaderCompiler.prototype.updateMethodRegisters = function() {
	this._pMethodSetup._iNormalMethod.set_iSharedRegisters(this._pSharedRegisters);
	this._pMethodSetup._iDiffuseMethod.set_iSharedRegisters(this._pSharedRegisters);
	if (this._pMethodSetup._iShadowMethod)
		this._pMethodSetup._iShadowMethod.set_iSharedRegisters(this._pSharedRegisters);
	this._pMethodSetup._iAmbientMethod.set_iSharedRegisters(this._pSharedRegisters);
	if (this._pMethodSetup._iSpecularMethod)
		this._pMethodSetup._iSpecularMethod.set_iSharedRegisters(this._pSharedRegisters);
	if (this._pMethodSetup._iColorTransformMethod)
		this._pMethodSetup._iColorTransformMethod.set_iSharedRegisters(this._pSharedRegisters);
	var methods = this._pMethodSetup._iMethods;
	var len = methods.length;
	for (var i = 0; i < len; ++i) {
		methods[i].method.iSharedRegisters = this._pSharedRegisters;
	}
};

away.materials.compilation.ShaderCompiler.prototype.get_numUsedVertexConstants = function() {
	return this._pRegisterCache.get_numUsedVertexConstants();
};

away.materials.compilation.ShaderCompiler.prototype.get_numUsedFragmentConstants = function() {
	return this._pRegisterCache.get_numUsedFragmentConstants();
};

away.materials.compilation.ShaderCompiler.prototype.get_numUsedStreams = function() {
	return this._pRegisterCache.get_numUsedStreams();
};

away.materials.compilation.ShaderCompiler.prototype.get_numUsedTextures = function() {
	return this._pRegisterCache.get_numUsedTextures();
};

away.materials.compilation.ShaderCompiler.prototype.get_numUsedVaryings = function() {
	return this._pRegisterCache.get_numUsedVaryings();
};

away.materials.compilation.ShaderCompiler.prototype.pUsesLightsForSpecular = function() {
	return this._pNumLights > 0 && (this._specularLightSources & away.materials.LightSources.LIGHTS) != 0;
};

away.materials.compilation.ShaderCompiler.prototype.pUsesLightsForDiffuse = function() {
	return this._pNumLights > 0 && (this._diffuseLightSources & away.materials.LightSources.LIGHTS) != 0;
};

away.materials.compilation.ShaderCompiler.prototype.dispose = function() {
	this.cleanUpMethods();
	this._pRegisterCache.dispose();
	this._pRegisterCache = null;
	this._pSharedRegisters = null;
};

away.materials.compilation.ShaderCompiler.prototype.cleanUpMethods = function() {
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
	var methods = this._pMethodSetup._iMethods;
	var len = methods.length;
	for (var i = 0; i < len; ++i) {
		methods[i].method.iCleanCompilationData();
	}
};

away.materials.compilation.ShaderCompiler.prototype.get_specularLightSources = function() {
	return this._specularLightSources;
};

away.materials.compilation.ShaderCompiler.prototype.set_specularLightSources = function(value) {
	this._specularLightSources = value;
};

away.materials.compilation.ShaderCompiler.prototype.get_diffuseLightSources = function() {
	return this._diffuseLightSources;
};

away.materials.compilation.ShaderCompiler.prototype.set_diffuseLightSources = function(value) {
	this._diffuseLightSources = value;
};

away.materials.compilation.ShaderCompiler.prototype.pUsesProbesForSpecular = function() {
	return this._pNumLightProbes > 0 && (this._specularLightSources & away.materials.LightSources.PROBES) != 0;
};

away.materials.compilation.ShaderCompiler.prototype.pUsesProbesForDiffuse = function() {
	return this._pNumLightProbes > 0 && (this._diffuseLightSources & away.materials.LightSources.PROBES) != 0;
};

away.materials.compilation.ShaderCompiler.prototype.pUsesProbes = function() {
	return this._pNumLightProbes > 0 && ((this._diffuseLightSources | this._specularLightSources) & away.materials.LightSources.PROBES) != 0;
};

away.materials.compilation.ShaderCompiler.prototype.get_uvBufferIndex = function() {
	return this._uvBufferIndex;
};

away.materials.compilation.ShaderCompiler.prototype.get_uvTransformIndex = function() {
	return this._uvTransformIndex;
};

away.materials.compilation.ShaderCompiler.prototype.get_secondaryUVBufferIndex = function() {
	return this._secondaryUVBufferIndex;
};

away.materials.compilation.ShaderCompiler.prototype.get_normalBufferIndex = function() {
	return this._pNormalBufferIndex;
};

away.materials.compilation.ShaderCompiler.prototype.get_tangentBufferIndex = function() {
	return this._pTangentBufferIndex;
};

away.materials.compilation.ShaderCompiler.prototype.get_lightFragmentConstantIndex = function() {
	return this._pLightFragmentConstantIndex;
};

away.materials.compilation.ShaderCompiler.prototype.get_cameraPositionIndex = function() {
	return this._pCameraPositionIndex;
};

away.materials.compilation.ShaderCompiler.prototype.get_sceneMatrixIndex = function() {
	return this._sceneMatrixIndex;
};

away.materials.compilation.ShaderCompiler.prototype.get_sceneNormalMatrixIndex = function() {
	return this._pSceneNormalMatrixIndex;
};

away.materials.compilation.ShaderCompiler.prototype.get_probeWeightsIndex = function() {
	return this._pProbeWeightsIndex;
};

away.materials.compilation.ShaderCompiler.prototype.get_vertexCode = function() {
	return this._pVertexCode;
};

away.materials.compilation.ShaderCompiler.prototype.get_fragmentCode = function() {
	return this._pFragmentCode;
};

away.materials.compilation.ShaderCompiler.prototype.get_fragmentLightCode = function() {
	return this._fragmentLightCode;
};

away.materials.compilation.ShaderCompiler.prototype.get_fragmentPostLightCode = function() {
	return this._fragmentPostLightCode;
};

away.materials.compilation.ShaderCompiler.prototype.get_shadedTarget = function() {
	return this._pSharedRegisters.shadedTarget.toString();
};

away.materials.compilation.ShaderCompiler.prototype.get_numPointLights = function() {
	return this._pNumPointLights;
};

away.materials.compilation.ShaderCompiler.prototype.set_numPointLights = function(numPointLights) {
	this._pNumPointLights = numPointLights;
};

away.materials.compilation.ShaderCompiler.prototype.get_numDirectionalLights = function() {
	return this._pNumDirectionalLights;
};

away.materials.compilation.ShaderCompiler.prototype.set_numDirectionalLights = function(value) {
	this._pNumDirectionalLights = value;
};

away.materials.compilation.ShaderCompiler.prototype.get_numLightProbes = function() {
	return this._pNumLightProbes;
};

away.materials.compilation.ShaderCompiler.prototype.set_numLightProbes = function(value) {
	this._pNumLightProbes = value;
};

away.materials.compilation.ShaderCompiler.prototype.get_usingSpecularMethod = function() {
	return this._usingSpecularMethod;
};

away.materials.compilation.ShaderCompiler.prototype.get_animatableAttributes = function() {
	return this._pAnimatableAttributes;
};

away.materials.compilation.ShaderCompiler.prototype.get_animationTargetRegisters = function() {
	return this._pAnimationTargetRegisters;
};

away.materials.compilation.ShaderCompiler.prototype.get_usesNormals = function() {
	return this._pDependencyCounter.get_normalDependencies() > 0 && this._pMethodSetup._iNormalMethod.get_iHasOutput();
};

away.materials.compilation.ShaderCompiler.prototype.pUsesLights = function() {
	return this._pNumLights > 0 && (this._combinedLightSources & away.materials.LightSources.LIGHTS) != 0;
};

away.materials.compilation.ShaderCompiler.prototype.pCompileMethods = function() {
	var methods = this._pMethodSetup._iMethods;
	var numMethods = methods.length;
	var method;
	var data;
	var alphaReg;
	if (this._preserveAlpha) {
		alphaReg = this._pRegisterCache.getFreeFragmentSingleTemp();
		this._pRegisterCache.addFragmentTempUsages(alphaReg, 1);
		this._pFragmentCode += "mov " + alphaReg.toString() + ", " + this._pSharedRegisters.shadedTarget.toString() + ".w\n";
	}
	for (var i = 0; i < numMethods; ++i) {
		method = methods[i].method;
		data = methods[i].data;
		this._pVertexCode += method.iGetVertexCode(data, this._pRegisterCache);
		if (data.needsGlobalVertexPos || data.needsGlobalFragmentPos)
			this._pRegisterCache.removeVertexTempUsage(this._pSharedRegisters.globalPositionVertex);
		this._pFragmentCode += method.iGetFragmentCode(data, this._pRegisterCache, this._pSharedRegisters.shadedTarget);
		if (data.needsNormals)
			this._pRegisterCache.removeFragmentTempUsage(this._pSharedRegisters.normalFragment);
		if (data.needsView)
			this._pRegisterCache.removeFragmentTempUsage(this._pSharedRegisters.viewDirFragment);
	}
	if (this._preserveAlpha) {
		this._pFragmentCode += "mov " + this._pSharedRegisters.shadedTarget.toString() + ".w, " + alphaReg.toString() + "\n";
		this._pRegisterCache.removeFragmentTempUsage(alphaReg);
	}
	if (this._pMethodSetup._iColorTransformMethod) {
		this._pVertexCode += this._pMethodSetup._iColorTransformMethod.iGetVertexCode(this._pMethodSetup._iColorTransformMethodVO, this._pRegisterCache);
		this._pFragmentCode += this._pMethodSetup._iColorTransformMethod.iGetFragmentCode(this._pMethodSetup._iColorTransformMethodVO, this._pRegisterCache, this._pSharedRegisters.shadedTarget);
	}
};

away.materials.compilation.ShaderCompiler.prototype.get_lightProbeDiffuseIndices = function() {
	return this._pLightProbeDiffuseIndices;
};

away.materials.compilation.ShaderCompiler.prototype.get_lightProbeSpecularIndices = function() {
	return this._pLightProbeSpecularIndices;
};

away.materials.compilation.ShaderCompiler.className = "away.materials.compilation.ShaderCompiler";

away.materials.compilation.ShaderCompiler.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.materials.compilation.ShaderRegisterData');
	p.push('Object');
	p.push('away.materials.compilation.ShaderRegisterCache');
	p.push('away.materials.compilation.MethodDependencyCounter');
	p.push('away.materials.LightSources');
	p.push('away.materials.methods.ShaderMethodSetup');
	return p;
};

away.materials.compilation.ShaderCompiler.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.materials.compilation.ShaderCompiler.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'profile', t:'String'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

