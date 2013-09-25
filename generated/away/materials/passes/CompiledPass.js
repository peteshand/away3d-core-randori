/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 25 20:35:40 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};
if (typeof away.materials.passes == "undefined")
	away.materials.passes = {};

away.materials.passes.CompiledPass = function(material) {
	this._iPassesDirty = false;
	this._forceSeparateMVP = false;
	this._normalBufferIndex = 0;
	this._pAmbientLightR = 0;
	this._pCompiler = null;
	this._pNumPointLights = 0;
	this._pCameraPositionIndex = 0;
	this._usingSpecularMethod = false;
	this._usesNormals = false;
	this._vertexCode = null;
	this._pLightFragmentConstantIndex = 0;
	this._uvBufferIndex = 0;
	this._pVertexConstantData = away.utils.VectorInit.Num(0, 0);
	this._secondaryUVBufferIndex = 0;
	this._tangentBufferIndex = 0;
	this._pNumDirectionalLights = 0;
	this._enableLightFallOff = true;
	this._pProbeWeightsIndex = 0;
	this._commonsDataIndex = 0;
	this._framentPostLightCode = null;
	this._pLightProbeDiffuseIndices = null;
	this._pNumLightProbes = 0;
	this._pDiffuseLightSources = 0x03;
	this._pFragmentConstantData = away.utils.VectorInit.Num(0, 0);
	this._pMethodSetup = null;
	this._preserveAlpha = true;
	this._animateUVs = false;
	this._sceneMatrixIndex = 0;
	this._uvTransformIndex = 0;
	this._pAmbientLightG = 0;
	this._fragmentLightCode = null;
	this._pLightProbeSpecularIndices = null;
	this._pAmbientLightB = 0;
	this._iPasses = null;
	this._pSpecularLightSources = 0x01;
	this._sceneNormalMatrixIndex = 0;
	away.materials.passes.MaterialPassBase.call(this, false);
	this._pMaterial = material;
	this.init();
};

away.materials.passes.CompiledPass.prototype.get_enableLightFallOff = function() {
	return this._enableLightFallOff;
};

away.materials.passes.CompiledPass.prototype.set_enableLightFallOff = function(value) {
	if (value != this._enableLightFallOff) {
		this.iInvalidateShaderProgram(true);
	}
	this._enableLightFallOff = value;
};

away.materials.passes.CompiledPass.prototype.get_forceSeparateMVP = function() {
	return this._forceSeparateMVP;
};

away.materials.passes.CompiledPass.prototype.set_forceSeparateMVP = function(value) {
	this._forceSeparateMVP = value;
};

away.materials.passes.CompiledPass.prototype.get_iNumPointLights = function() {
	return this._pNumPointLights;
};

away.materials.passes.CompiledPass.prototype.get_iNumDirectionalLights = function() {
	return this._pNumDirectionalLights;
};

away.materials.passes.CompiledPass.prototype.get_iNumLightProbes = function() {
	return this._pNumLightProbes;
};

away.materials.passes.CompiledPass.prototype.iUpdateProgram = function(stage3DProxy) {
	this.reset(stage3DProxy.get_profile());
	away.materials.passes.MaterialPassBase.prototype.iUpdateProgram.call(this,stage3DProxy);
};

away.materials.passes.CompiledPass.prototype.reset = function(profile) {
	this.iInitCompiler(profile);
	this.pUpdateShaderProperties();
	this.initConstantData();
	this.pCleanUp();
};

away.materials.passes.CompiledPass.prototype.updateUsedOffsets = function() {
	this._pNumUsedVertexConstants = this._pCompiler.get_numUsedVertexConstants();
	this._pNumUsedFragmentConstants = this._pCompiler.get_numUsedFragmentConstants();
	this._pNumUsedStreams = this._pCompiler.get_numUsedStreams();
	this._pNumUsedTextures = this._pCompiler.get_numUsedTextures();
	this._pNumUsedVaryings = this._pCompiler.get_numUsedVaryings();
	this._pNumUsedFragmentConstants = this._pCompiler.get_numUsedFragmentConstants();
};

away.materials.passes.CompiledPass.prototype.initConstantData = function() {
	this._pVertexConstantData.length = this._pNumUsedVertexConstants * 4;
	this._pFragmentConstantData.length = this._pNumUsedFragmentConstants * 4;
	this.pInitCommonsData();
	if (this._uvTransformIndex >= 0) {
		this.pInitUVTransformData();
	}
	if (this._pCameraPositionIndex >= 0) {
		this._pVertexConstantData[this._pCameraPositionIndex + 3] = 1;
	}
	this.pUpdateMethodConstants();
};

away.materials.passes.CompiledPass.prototype.iInitCompiler = function(profile) {
	this._pCompiler = this.pCreateCompiler(profile);
	this._pCompiler.set_forceSeperateMVP(this._forceSeparateMVP);
	this._pCompiler.set_numPointLights(this._pNumPointLights);
	this._pCompiler.set_numDirectionalLights(this._pNumDirectionalLights);
	this._pCompiler.set_numLightProbes(this._pNumLightProbes);
	this._pCompiler.set_methodSetup(this._pMethodSetup);
	this._pCompiler.set_diffuseLightSources(this._pDiffuseLightSources);
	this._pCompiler.set_specularLightSources(this._pSpecularLightSources);
	this._pCompiler.setTextureSampling(this._pSmooth, this._pRepeat, this._pMipmap);
	this._pCompiler.setConstantDataBuffers(this._pVertexConstantData, this._pFragmentConstantData);
	this._pCompiler.set_animateUVs(this._animateUVs);
	this._pCompiler.set_alphaPremultiplied(this._pAlphaPremultiplied && this._pEnableBlending);
	this._pCompiler.set_preserveAlpha(this._preserveAlpha && this._pEnableBlending);
	this._pCompiler.set_enableLightFallOff(this._enableLightFallOff);
	this._pCompiler.compile();
};

away.materials.passes.CompiledPass.prototype.pCreateCompiler = function(profile) {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.materials.passes.CompiledPass.prototype.pUpdateShaderProperties = function() {
	this._pAnimatableAttributes = this._pCompiler.get_animatableAttributes();
	this._pAnimationTargetRegisters = this._pCompiler.get_animationTargetRegisters();
	this._vertexCode = this._pCompiler.get_vertexCode();
	this._fragmentLightCode = this._pCompiler.get_fragmentLightCode();
	this._framentPostLightCode = this._pCompiler.get_fragmentPostLightCode();
	this._pShadedTarget = this._pCompiler.get_shadedTarget();
	this._usingSpecularMethod = this._pCompiler.get_usingSpecularMethod();
	this._usesNormals = this._pCompiler.get_usesNormals();
	this._pNeedUVAnimation = this._pCompiler.get_needUVAnimation();
	this._pUVSource = this._pCompiler.get_UVSource();
	this._pUVTarget = this._pCompiler.get_UVTarget();
	this.pUpdateRegisterIndices();
	this.updateUsedOffsets();
};

away.materials.passes.CompiledPass.prototype.pUpdateRegisterIndices = function() {
	this._uvBufferIndex = this._pCompiler.get_uvBufferIndex();
	this._uvTransformIndex = this._pCompiler.get_uvTransformIndex();
	this._secondaryUVBufferIndex = this._pCompiler.get_secondaryUVBufferIndex();
	this._normalBufferIndex = this._pCompiler.get_normalBufferIndex();
	this._tangentBufferIndex = this._pCompiler.get_tangentBufferIndex();
	this._pLightFragmentConstantIndex = this._pCompiler.get_lightFragmentConstantIndex();
	this._pCameraPositionIndex = this._pCompiler.get_cameraPositionIndex();
	this._commonsDataIndex = this._pCompiler.get_commonsDataIndex();
	this._sceneMatrixIndex = this._pCompiler.get_sceneMatrixIndex();
	this._sceneNormalMatrixIndex = this._pCompiler.get_sceneNormalMatrixIndex();
	this._pProbeWeightsIndex = this._pCompiler.get_probeWeightsIndex();
	this._pLightProbeDiffuseIndices = this._pCompiler.get_lightProbeDiffuseIndices();
	this._pLightProbeSpecularIndices = this._pCompiler.get_lightProbeSpecularIndices();
};

away.materials.passes.CompiledPass.prototype.get_preserveAlpha = function() {
	return this._preserveAlpha;
};

away.materials.passes.CompiledPass.prototype.set_preserveAlpha = function(value) {
	if (this._preserveAlpha == value) {
		return;
	}
	this._preserveAlpha = value;
	this.iInvalidateShaderProgram(true);
};

away.materials.passes.CompiledPass.prototype.get_animateUVs = function() {
	return this._animateUVs;
};

away.materials.passes.CompiledPass.prototype.set_animateUVs = function(value) {
	this._animateUVs = value;
	if ((value && !this._animateUVs) || (!value && this._animateUVs)) {
		this.iInvalidateShaderProgram(true);
	}
};

away.materials.passes.CompiledPass.prototype.set_mipmap = function(value) {
	if (this._pMipmap == value)
		return;
	away.materials.passes.MaterialPassBase.prototype.setMipMap.call(this,value);
};

away.materials.passes.CompiledPass.prototype.get_normalMap = function() {
	return this._pMethodSetup._iNormalMethod.get_normalMap();
};

away.materials.passes.CompiledPass.prototype.set_normalMap = function(value) {
	this._pMethodSetup._iNormalMethod.set_normalMap(value);
};

away.materials.passes.CompiledPass.prototype.get_normalMethod = function() {
	return this._pMethodSetup.get_normalMethod();
};

away.materials.passes.CompiledPass.prototype.set_normalMethod = function(value) {
	this._pMethodSetup.set_normalMethod(value);
};

away.materials.passes.CompiledPass.prototype.get_ambientMethod = function() {
	return this._pMethodSetup.get_ambientMethod();
};

away.materials.passes.CompiledPass.prototype.set_ambientMethod = function(value) {
	this._pMethodSetup.set_ambientMethod(value);
};

away.materials.passes.CompiledPass.prototype.get_shadowMethod = function() {
	return this._pMethodSetup.get_shadowMethod();
};

away.materials.passes.CompiledPass.prototype.set_shadowMethod = function(value) {
	this._pMethodSetup.set_shadowMethod(value);
};

away.materials.passes.CompiledPass.prototype.get_diffuseMethod = function() {
	return this._pMethodSetup.get_diffuseMethod();
};

away.materials.passes.CompiledPass.prototype.set_diffuseMethod = function(value) {
	this._pMethodSetup.set_diffuseMethod(value);
};

away.materials.passes.CompiledPass.prototype.get_specularMethod = function() {
	return this._pMethodSetup.get_specularMethod();
};

away.materials.passes.CompiledPass.prototype.set_specularMethod = function(value) {
	this._pMethodSetup.set_specularMethod(value);
};

away.materials.passes.CompiledPass.prototype.init = function() {
	this._pMethodSetup = new away.materials.methods.ShaderMethodSetup();
	this._pMethodSetup.addEventListener(away.events.ShadingMethodEvent.SHADER_INVALIDATED, $createStaticDelegate(this, this.onShaderInvalidated), this);
};

away.materials.passes.CompiledPass.prototype.dispose = function() {
	away.materials.passes.MaterialPassBase.prototype.dispose.call(this);
	this._pMethodSetup.removeEventListener(away.events.ShadingMethodEvent.SHADER_INVALIDATED, $createStaticDelegate(this, this.onShaderInvalidated), this);
	this._pMethodSetup.dispose();
	this._pMethodSetup = null;
};

away.materials.passes.CompiledPass.prototype.iInvalidateShaderProgram = function(updateMaterial) {
	updateMaterial = updateMaterial || true;
	var oldPasses = this._iPasses;
	this._iPasses = [];
	if (this._pMethodSetup) {
		this.pAddPassesFromMethods();
	}
	if (!oldPasses || this._iPasses.length != oldPasses.length) {
		this._iPassesDirty = true;
		return;
	}
	for (var i = 0; i < this._iPasses.length; ++i) {
		if (this._iPasses[i] != oldPasses[i]) {
			this._iPassesDirty = true;
			return;
		}
	}
	away.materials.passes.MaterialPassBase.prototype.iInvalidateShaderProgram.call(this,updateMaterial);
};

away.materials.passes.CompiledPass.prototype.pAddPassesFromMethods = function() {
	if (this._pMethodSetup._iNormalMethod && this._pMethodSetup._iNormalMethod.get_iHasOutput())
		this.pAddPasses(this._pMethodSetup._iNormalMethod.get_passes());
	if (this._pMethodSetup._iAmbientMethod)
		this.pAddPasses(this._pMethodSetup._iAmbientMethod.get_passes());
	if (this._pMethodSetup._iShadowMethod)
		this.pAddPasses(this._pMethodSetup._iShadowMethod.get_passes());
	if (this._pMethodSetup._iDiffuseMethod)
		this.pAddPasses(this._pMethodSetup._iDiffuseMethod.get_passes());
	if (this._pMethodSetup._iSpecularMethod)
		this.pAddPasses(this._pMethodSetup._iSpecularMethod.get_passes());
};

away.materials.passes.CompiledPass.prototype.pAddPasses = function(passes) {
	if (!passes) {
		return;
	}
	var len = passes.length;
	for (var i = 0; i < len; ++i) {
		passes[i].material = this.get_material();
		passes[i].lightPicker = this._pLightPicker;
		this._iPasses.push(passes[i]);
	}
};

away.materials.passes.CompiledPass.prototype.pInitUVTransformData = function() {
	this._pVertexConstantData[this._uvTransformIndex] = 1;
	this._pVertexConstantData[this._uvTransformIndex + 1] = 0;
	this._pVertexConstantData[this._uvTransformIndex + 2] = 0;
	this._pVertexConstantData[this._uvTransformIndex + 3] = 0;
	this._pVertexConstantData[this._uvTransformIndex + 4] = 0;
	this._pVertexConstantData[this._uvTransformIndex + 5] = 1;
	this._pVertexConstantData[this._uvTransformIndex + 6] = 0;
	this._pVertexConstantData[this._uvTransformIndex + 7] = 0;
};

away.materials.passes.CompiledPass.prototype.pInitCommonsData = function() {
	this._pFragmentConstantData[this._commonsDataIndex] = .5;
	this._pFragmentConstantData[this._commonsDataIndex + 1] = 0;
	this._pFragmentConstantData[this._commonsDataIndex + 2] = 1 / 255;
	this._pFragmentConstantData[this._commonsDataIndex + 3] = 1;
};

away.materials.passes.CompiledPass.prototype.pCleanUp = function() {
	this._pCompiler.dispose();
	this._pCompiler = null;
};

away.materials.passes.CompiledPass.prototype.pUpdateMethodConstants = function() {
	if (this._pMethodSetup._iNormalMethod)
		this._pMethodSetup._iNormalMethod.iInitConstants(this._pMethodSetup._iNormalMethodVO);
	if (this._pMethodSetup._iDiffuseMethod)
		this._pMethodSetup._iDiffuseMethod.iInitConstants(this._pMethodSetup._iDiffuseMethodVO);
	if (this._pMethodSetup._iAmbientMethod)
		this._pMethodSetup._iAmbientMethod.iInitConstants(this._pMethodSetup._iAmbientMethodVO);
	if (this._usingSpecularMethod)
		this._pMethodSetup._iSpecularMethod.iInitConstants(this._pMethodSetup._iSpecularMethodVO);
	if (this._pMethodSetup._iShadowMethod)
		this._pMethodSetup._iShadowMethod.iInitConstants(this._pMethodSetup._iShadowMethodVO);
};

away.materials.passes.CompiledPass.prototype.pUpdateLightConstants = function() {
};

away.materials.passes.CompiledPass.prototype.pUpdateProbes = function(stage3DProxy) {
};

away.materials.passes.CompiledPass.prototype.onShaderInvalidated = function(event) {
	this.iInvalidateShaderProgram(true);
};

away.materials.passes.CompiledPass.prototype.iGetVertexCode = function() {
	return this._vertexCode;
};

away.materials.passes.CompiledPass.prototype.iGetFragmentCode = function(animatorCode) {
	return this._fragmentLightCode + animatorCode + this._framentPostLightCode;
};

away.materials.passes.CompiledPass.prototype.iActivate = function(stage3DProxy, camera) {
	away.materials.passes.MaterialPassBase.prototype.iActivate.call(this,stage3DProxy, camera);
	if (this._usesNormals) {
		this._pMethodSetup._iNormalMethod.iActivate(this._pMethodSetup._iNormalMethodVO, stage3DProxy);
	}
	this._pMethodSetup._iAmbientMethod.iActivate(this._pMethodSetup._iAmbientMethodVO, stage3DProxy);
	if (this._pMethodSetup._iShadowMethod) {
		this._pMethodSetup._iShadowMethod.iActivate(this._pMethodSetup._iShadowMethodVO, stage3DProxy);
	}
	this._pMethodSetup._iDiffuseMethod.iActivate(this._pMethodSetup._iDiffuseMethodVO, stage3DProxy);
	if (this._usingSpecularMethod) {
		this._pMethodSetup._iSpecularMethod.iActivate(this._pMethodSetup._iSpecularMethodVO, stage3DProxy);
	}
};

away.materials.passes.CompiledPass.prototype.iRender = function(renderable, stage3DProxy, camera, viewProjection) {
	var i;
	var context = stage3DProxy._iContext3D;
	if (this._uvBufferIndex >= 0)
		renderable.activateUVBuffer(this._uvBufferIndex, stage3DProxy);
	if (this._secondaryUVBufferIndex >= 0)
		renderable.activateSecondaryUVBuffer(this._secondaryUVBufferIndex, stage3DProxy);
	if (this._normalBufferIndex >= 0)
		renderable.activateVertexNormalBuffer(this._normalBufferIndex, stage3DProxy);
	if (this._tangentBufferIndex >= 0)
		renderable.activateVertexTangentBuffer(this._tangentBufferIndex, stage3DProxy);
	if (this._animateUVs) {
		var uvTransform = renderable.get_uvTransform();
		if (uvTransform) {
			this._pVertexConstantData[this._uvTransformIndex] = uvTransform.a;
			this._pVertexConstantData[this._uvTransformIndex + 1] = uvTransform.b;
			this._pVertexConstantData[this._uvTransformIndex + 3] = uvTransform.tx;
			this._pVertexConstantData[this._uvTransformIndex + 4] = uvTransform.c;
			this._pVertexConstantData[this._uvTransformIndex + 5] = uvTransform.d;
			this._pVertexConstantData[this._uvTransformIndex + 7] = uvTransform.ty;
		} else {
			this._pVertexConstantData[this._uvTransformIndex] = 1;
			this._pVertexConstantData[this._uvTransformIndex + 1] = 0;
			this._pVertexConstantData[this._uvTransformIndex + 3] = 0;
			this._pVertexConstantData[this._uvTransformIndex + 4] = 0;
			this._pVertexConstantData[this._uvTransformIndex + 5] = 1;
			this._pVertexConstantData[this._uvTransformIndex + 7] = 0;
		}
	}
	this._pAmbientLightR = 0;
	this._pAmbientLightG = 0;
	this._pAmbientLightB = 0;
	if (this.pUsesLights()) {
		this.pUpdateLightConstants();
	}
	if (this.pUsesProbes()) {
		this.pUpdateProbes(stage3DProxy);
	}
	if (this._sceneMatrixIndex >= 0) {
		renderable.getRenderSceneTransform(camera).copyRawDataTo(this._pVertexConstantData, this._sceneMatrixIndex, true);
		viewProjection.copyRawDataTo(this._pVertexConstantData, 0, true);
	} else {
		var matrix3D = away.math.Matrix3DUtils.CALCULATION_MATRIX;
		matrix3D.copyFrom(renderable.getRenderSceneTransform(camera));
		matrix3D.append(viewProjection);
		matrix3D.copyRawDataTo(this._pVertexConstantData, 0, true);
	}
	if (this._sceneNormalMatrixIndex >= 0) {
		renderable.get_inverseSceneTransform().copyRawDataTo(this._pVertexConstantData, this._sceneNormalMatrixIndex, false);
	}
	if (this._usesNormals) {
		this._pMethodSetup._iNormalMethod.iSetRenderState(this._pMethodSetup._iNormalMethodVO, renderable, stage3DProxy, camera);
	}
	var ambientMethod = this._pMethodSetup._iAmbientMethod;
	ambientMethod._iLightAmbientR = this._pAmbientLightR;
	ambientMethod._iLightAmbientG = this._pAmbientLightG;
	ambientMethod._iLightAmbientB = this._pAmbientLightB;
	ambientMethod.iSetRenderState(this._pMethodSetup._iAmbientMethodVO, renderable, stage3DProxy, camera);
	if (this._pMethodSetup._iShadowMethod)
		this._pMethodSetup._iShadowMethod.iSetRenderState(this._pMethodSetup._iShadowMethodVO, renderable, stage3DProxy, camera);
	this._pMethodSetup._iDiffuseMethod.iSetRenderState(this._pMethodSetup._iDiffuseMethodVO, renderable, stage3DProxy, camera);
	if (this._usingSpecularMethod)
		this._pMethodSetup._iSpecularMethod.iSetRenderState(this._pMethodSetup._iSpecularMethodVO, renderable, stage3DProxy, camera);
	if (this._pMethodSetup._iColorTransformMethod)
		this._pMethodSetup._iColorTransformMethod.iSetRenderState(this._pMethodSetup._iColorTransformMethodVO, renderable, stage3DProxy, camera);
	var methods = this._pMethodSetup._iMethods;
	var len = methods.length;
	for (i = 0; i < len; ++i) {
		var aset = methods[i];
		aset.method.iSetRenderState(aset.data, renderable, stage3DProxy, camera);
	}
	context.setProgramConstantsFromArray(away.display3D.Context3DProgramType.VERTEX, 0, this._pVertexConstantData, this._pNumUsedVertexConstants);
	context.setProgramConstantsFromArray(away.display3D.Context3DProgramType.FRAGMENT, 0, this._pFragmentConstantData, this._pNumUsedFragmentConstants);
	renderable.activateVertexBuffer(0, stage3DProxy);
	context.drawTriangles(renderable.getIndexBuffer(stage3DProxy), 0, renderable.get_numTriangles());
};

away.materials.passes.CompiledPass.prototype.pUsesProbes = function() {
	return this._pNumLightProbes > 0 && ((this._pDiffuseLightSources | this._pSpecularLightSources) & away.materials.LightSources.PROBES) != 0;
};

away.materials.passes.CompiledPass.prototype.pUsesLights = function() {
	return (this._pNumPointLights > 0 || this._pNumDirectionalLights > 0) && ((this._pDiffuseLightSources | this._pSpecularLightSources) & away.materials.LightSources.LIGHTS) != 0;
};

away.materials.passes.CompiledPass.prototype.iDeactivate = function(stage3DProxy) {
	away.materials.passes.MaterialPassBase.prototype.iDeactivate.call(this,stage3DProxy);
	if (this._usesNormals) {
		this._pMethodSetup._iNormalMethod.iDeactivate(this._pMethodSetup._iNormalMethodVO, stage3DProxy);
	}
	this._pMethodSetup._iAmbientMethod.iDeactivate(this._pMethodSetup._iAmbientMethodVO, stage3DProxy);
	if (this._pMethodSetup._iShadowMethod) {
		this._pMethodSetup._iShadowMethod.iDeactivate(this._pMethodSetup._iShadowMethodVO, stage3DProxy);
	}
	this._pMethodSetup._iDiffuseMethod.iDeactivate(this._pMethodSetup._iDiffuseMethodVO, stage3DProxy);
	if (this._usingSpecularMethod) {
		this._pMethodSetup._iSpecularMethod.iDeactivate(this._pMethodSetup._iSpecularMethodVO, stage3DProxy);
	}
};

away.materials.passes.CompiledPass.prototype.get_specularLightSources = function() {
	return this._pSpecularLightSources;
};

away.materials.passes.CompiledPass.prototype.set_specularLightSources = function(value) {
	this._pSpecularLightSources = value;
};

away.materials.passes.CompiledPass.prototype.get_diffuseLightSources = function() {
	return this._pDiffuseLightSources;
};

away.materials.passes.CompiledPass.prototype.set_diffuseLightSources = function(value) {
	this._pDiffuseLightSources = value;
};

$inherit(away.materials.passes.CompiledPass, away.materials.passes.MaterialPassBase);

away.materials.passes.CompiledPass.className = "away.materials.passes.CompiledPass";

away.materials.passes.CompiledPass.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.materials.methods.BasicDiffuseMethod');
	p.push('*away.base.IRenderable');
	p.push('away.errors.AbstractMethodError');
	p.push('away.math.Matrix3DUtils');
	p.push('away.display3D.Context3DProgramType');
	p.push('away.managers.Stage3DProxy');
	p.push('away.materials.methods.MethodVOSet');
	p.push('away.materials.methods.BasicSpecularMethod');
	p.push('away.events.ShadingMethodEvent');
	p.push('away.materials.methods.BasicNormalMethod');
	p.push('away.materials.methods.BasicAmbientMethod');
	p.push('away.materials.methods.ShadowMapMethodBase');
	p.push('away.materials.LightSources');
	p.push('away.materials.methods.ShaderMethodSetup');
	return p;
};

away.materials.passes.CompiledPass.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('away.utils.VectorInit');
	return p;
};

away.materials.passes.CompiledPass.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'material', t:'away.materials.MaterialBase'});
			break;
		case 1:
			p = away.materials.passes.MaterialPassBase.injectionPoints(t);
			break;
		case 2:
			p = away.materials.passes.MaterialPassBase.injectionPoints(t);
			break;
		case 3:
			p = away.materials.passes.MaterialPassBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

