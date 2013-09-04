/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 04 21:18:42 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};

away.materials.MultiPassMaterialBase = function() {
	this._diffuseLightSources = 0x03;
	this._alphaThreshold = 0;
	this._screenPassesInvalid = true;
	this._casterLightPass = null;
	this._ambientMethod = new away.materials.methods.BasicAmbientMethod();
	this._normalMethod = new away.materials.methods.BasicNormalMethod();
	this._specularMethod = new away.materials.methods.BasicSpecularMethod();
	this._enableLightFallOff = true;
	this._diffuseMethod = new away.materials.methods.BasicDiffuseMethod();
	this._specularLightSources = 0x01;
	this._pEffectsPass = null;
	this._shadowMethod = null;
	this._nonCasterLightPasses = null;
	away.materials.MaterialBase.call(this);
};

away.materials.MultiPassMaterialBase.prototype.get_enableLightFallOff = function() {
	return this._enableLightFallOff;
};

away.materials.MultiPassMaterialBase.prototype.set_enableLightFallOff = function(value) {
	if (this._enableLightFallOff != value)
		this.pInvalidateScreenPasses();
	this._enableLightFallOff = value;
};

away.materials.MultiPassMaterialBase.prototype.get_alphaThreshold = function() {
	return this._alphaThreshold;
};

away.materials.MultiPassMaterialBase.prototype.set_alphaThreshold = function(value) {
	this._alphaThreshold = value;
	this._diffuseMethod.set_alphaThreshold(value);
	this._pDepthPass.set_alphaThreshold(value);
	this._pDistancePass.set_alphaThreshold(value);
};

away.materials.MultiPassMaterialBase.prototype.set_depthCompareMode = function(value) {
	away.materials.MaterialBase.prototype.setDepthCompareMode.call(this,value);
	this.pInvalidateScreenPasses();
};

away.materials.MultiPassMaterialBase.prototype.set_blendMode = function(value) {
	away.materials.MaterialBase.prototype.setBlendMode.call(this,value);
	this.pInvalidateScreenPasses();
};

away.materials.MultiPassMaterialBase.prototype.iActivateForDepth = function(stage3DProxy, camera, distanceBased) {
	if (distanceBased) {
		this._pDistancePass.set_alphaMask(this._diffuseMethod.get_texture());
	} else {
		this._pDepthPass.set_alphaMask(this._diffuseMethod.get_texture());
	}
	away.materials.MaterialBase.prototype.iActivateForDepth.call(this,stage3DProxy, camera, distanceBased);
};

away.materials.MultiPassMaterialBase.prototype.get_specularLightSources = function() {
	return this._specularLightSources;
};

away.materials.MultiPassMaterialBase.prototype.set_specularLightSources = function(value) {
	this._specularLightSources = value;
};

away.materials.MultiPassMaterialBase.prototype.get_diffuseLightSources = function() {
	return this._diffuseLightSources;
};

away.materials.MultiPassMaterialBase.prototype.set_diffuseLightSources = function(value) {
	this._diffuseLightSources = value;
};

away.materials.MultiPassMaterialBase.prototype.set_lightPicker = function(value) {
	if (this._pLightPicker)
		this._pLightPicker.removeEventListener(away.events.Event.CHANGE, $createStaticDelegate(, this.onLightsChange), this);
	away.materials.MaterialBase.prototype.setLightPicker.call(this,value);
	if (this._pLightPicker)
		this._pLightPicker.addEventListener(away.events.Event.CHANGE, $createStaticDelegate(, this.onLightsChange), this);
	this.pInvalidateScreenPasses();
};

away.materials.MultiPassMaterialBase.prototype.get_requiresBlending = function() {
	return false;
};

away.materials.MultiPassMaterialBase.prototype.get_ambientMethod = function() {
	return this._ambientMethod;
};

away.materials.MultiPassMaterialBase.prototype.set_ambientMethod = function(value) {
	value.copyFrom(this._ambientMethod);
	this._ambientMethod = value;
	this.pInvalidateScreenPasses();
};

away.materials.MultiPassMaterialBase.prototype.get_shadowMethod = function() {
	return this._shadowMethod;
};

away.materials.MultiPassMaterialBase.prototype.set_shadowMethod = function(value) {
	if (value && this._shadowMethod)
		value.copyFrom(this._shadowMethod);
	this._shadowMethod = value;
	this.pInvalidateScreenPasses();
};

away.materials.MultiPassMaterialBase.prototype.get_diffuseMethod = function() {
	return this._diffuseMethod;
};

away.materials.MultiPassMaterialBase.prototype.set_diffuseMethod = function(value) {
	value.copyFrom(this._diffuseMethod);
	this._diffuseMethod = value;
	this.pInvalidateScreenPasses();
};

away.materials.MultiPassMaterialBase.prototype.get_specularMethod = function() {
	return this._specularMethod;
};

away.materials.MultiPassMaterialBase.prototype.set_specularMethod = function(value) {
	if (value && this._specularMethod)
		value.copyFrom(this._specularMethod);
	this._specularMethod = value;
	this.pInvalidateScreenPasses();
};

away.materials.MultiPassMaterialBase.prototype.get_normalMethod = function() {
	return this._normalMethod;
};

away.materials.MultiPassMaterialBase.prototype.set_normalMethod = function(value) {
	value.copyFrom(this._normalMethod);
	this._normalMethod = value;
	this.pInvalidateScreenPasses();
};

away.materials.MultiPassMaterialBase.prototype.addMethod = function(method) {
	if (this._pEffectsPass == null) {
		this._pEffectsPass = new away.materials.passes.SuperShaderPass(this);
	}
	this._pEffectsPass.addMethod(method);
	this.pInvalidateScreenPasses();
};

away.materials.MultiPassMaterialBase.prototype.get_numMethods = function() {
	return this._pEffectsPass ? this._pEffectsPass.get_numMethods() : 0;
};

away.materials.MultiPassMaterialBase.prototype.hasMethod = function(method) {
	return this._pEffectsPass ? this._pEffectsPass.hasMethod(method) : false;
};

away.materials.MultiPassMaterialBase.prototype.getMethodAt = function(index) {
	return this._pEffectsPass.getMethodAt(index);
};

away.materials.MultiPassMaterialBase.prototype.addMethodAt = function(method, index) {
	if (this._pEffectsPass == null) {
		this._pEffectsPass = new away.materials.passes.SuperShaderPass(this);
	}
	this._pEffectsPass.addMethodAt(method, index);
	this.pInvalidateScreenPasses();
};

away.materials.MultiPassMaterialBase.prototype.removeMethod = function(method) {
	if (this._pEffectsPass)
		return;
	this._pEffectsPass.removeMethod(method);
	if (this._pEffectsPass.get_numMethods() == 0)
		this.pInvalidateScreenPasses();
};

away.materials.MultiPassMaterialBase.prototype.set_mipmap = function(value) {
	if (this._pMipmap == value)
		return;
	away.materials.MaterialBase.prototype.setMipMap.call(this,value);
};

away.materials.MultiPassMaterialBase.prototype.get_normalMap = function() {
	return this._normalMethod.get_normalMap();
};

away.materials.MultiPassMaterialBase.prototype.set_normalMap = function(value) {
	this._normalMethod.set_normalMap(value);
};

away.materials.MultiPassMaterialBase.prototype.get_specularMap = function() {
	return this._specularMethod.get_texture();
};

away.materials.MultiPassMaterialBase.prototype.set_specularMap = function(value) {
	if (this._specularMethod)
		this._specularMethod.set_texture(value);
	else
		throw new Error("No specular method was set to assign the specularGlossMap to", 0);
};

away.materials.MultiPassMaterialBase.prototype.get_gloss = function() {
	return this._specularMethod ? this._specularMethod.get_gloss() : 0;
};

away.materials.MultiPassMaterialBase.prototype.set_gloss = function(value) {
	if (this._specularMethod)
		this._specularMethod.set_gloss(value);
};

away.materials.MultiPassMaterialBase.prototype.get_ambient = function() {
	return this._ambientMethod.get_ambient();
};

away.materials.MultiPassMaterialBase.prototype.set_ambient = function(value) {
	this._ambientMethod.set_ambient(value);
};

away.materials.MultiPassMaterialBase.prototype.get_specular = function() {
	return this._specularMethod ? this._specularMethod.get_specular() : 0;
};

away.materials.MultiPassMaterialBase.prototype.set_specular = function(value) {
	if (this._specularMethod)
		this._specularMethod.set_specular(value);
};

away.materials.MultiPassMaterialBase.prototype.get_ambientColor = function() {
	return this._ambientMethod.get_ambientColor();
};

away.materials.MultiPassMaterialBase.prototype.set_ambientColor = function(value) {
	this._ambientMethod.set_ambientColor(value);
};

away.materials.MultiPassMaterialBase.prototype.get_specularColor = function() {
	return this._specularMethod.get_specularColor();
};

away.materials.MultiPassMaterialBase.prototype.set_specularColor = function(value) {
	this._specularMethod.set_specularColor(value);
};

away.materials.MultiPassMaterialBase.prototype.iUpdateMaterial = function(context) {
	var passesInvalid;
	if (this._screenPassesInvalid) {
		this.pUpdateScreenPasses();
		passesInvalid = true;
	}
	if (passesInvalid || this.isAnyScreenPassInvalid()) {
		this.pClearPasses();
		this.addChildPassesFor(this._casterLightPass);
		if (this._nonCasterLightPasses) {
			for (var i = 0; i < this._nonCasterLightPasses.length; ++i)
				this.addChildPassesFor(this._nonCasterLightPasses[i]);
		}
		this.addChildPassesFor(this._pEffectsPass);
		this.addScreenPass(this._casterLightPass);
		if (this._nonCasterLightPasses) {
			for (i = 0; i < this._nonCasterLightPasses.length; ++i) {
				this.addScreenPass(this._nonCasterLightPasses[i]);
			}
		}
		this.addScreenPass(this._pEffectsPass);
	}
};

away.materials.MultiPassMaterialBase.prototype.addScreenPass = function(pass) {
	if (pass) {
		this.pAddPass(pass);
		pass._iPassesDirty = false;
	}
};

away.materials.MultiPassMaterialBase.prototype.isAnyScreenPassInvalid = function() {
	if ((this._casterLightPass && this._casterLightPass._iPassesDirty) || (this._pEffectsPass && this._pEffectsPass._iPassesDirty)) {
		return true;
	}
	if (this._nonCasterLightPasses) {
		for (var i = 0; i < this._nonCasterLightPasses.length; ++i) {
			if (this._nonCasterLightPasses[i]._iPassesDirty)
				return true;
		}
	}
	return false;
};

away.materials.MultiPassMaterialBase.prototype.addChildPassesFor = function(pass) {
	if (!pass)
		return;
	if (pass._iPasses) {
		var len = pass._iPasses.length;
		for (var i = 0; i < len; ++i) {
			this.pAddPass(pass._iPasses[i]);
		}
	}
};

away.materials.MultiPassMaterialBase.prototype.iActivatePass = function(index, stage3DProxy, camera) {
	if (index == 0) {
		stage3DProxy._iContext3D.setBlendFactors(away.display3D.Context3DBlendFactor.ONE, away.display3D.Context3DBlendFactor.ZERO);
	}
	away.materials.MaterialBase.prototype.iActivatePass.call(this,index, stage3DProxy, camera);
};

away.materials.MultiPassMaterialBase.prototype.iDeactivate = function(stage3DProxy) {
	away.materials.MaterialBase.prototype.iDeactivate.call(this,stage3DProxy);
	stage3DProxy._iContext3D.setBlendFactors(away.display3D.Context3DBlendFactor.ONE, away.display3D.Context3DBlendFactor.ZERO);
};

away.materials.MultiPassMaterialBase.prototype.pUpdateScreenPasses = function() {
	this.initPasses();
	this.setBlendAndCompareModes();
	this._screenPassesInvalid = false;
};

away.materials.MultiPassMaterialBase.prototype.initPasses = function() {
	if (this.get_numLights() == 0 || this.get_numMethods() > 0) {
		this.initEffectsPass();
	} else if (this._pEffectsPass && this.get_numMethods() == 0) {
		this.removeEffectsPass();
	}
	if (this._shadowMethod) {
		this.initCasterLightPass();
	} else {
		this.removeCasterLightPass();
	}
	if (this.get_numNonCasters() > 0)
		this.initNonCasterLightPasses();
	else
		this.removeNonCasterLightPasses();
};

away.materials.MultiPassMaterialBase.prototype.setBlendAndCompareModes = function() {
	var forceSeparateMVP = (this._casterLightPass || this._pEffectsPass);
	if (this._casterLightPass) {
		this._casterLightPass.setBlendMode(away.display.BlendMode.NORMAL);
		this._casterLightPass.set_depthCompareMode(this._pDepthCompareMode);
		this._casterLightPass.set_forceSeparateMVP(forceSeparateMVP);
	}
	if (this._nonCasterLightPasses) {
		var firstAdditiveIndex = 0;
		if (!this._casterLightPass) {
			this._nonCasterLightPasses[0].forceSeparateMVP = forceSeparateMVP;
			this._nonCasterLightPasses[0].setBlendMode(away.display.BlendMode.NORMAL);
			this._nonCasterLightPasses[0].depthCompareMode = this._pDepthCompareMode;
			firstAdditiveIndex = 1;
		}
		for (var i = firstAdditiveIndex; i < this._nonCasterLightPasses.length; ++i) {
			this._nonCasterLightPasses[i].forceSeparateMVP = forceSeparateMVP;
			this._nonCasterLightPasses[i].setBlendMode(away.display.BlendMode.ADD);
			this._nonCasterLightPasses[i].depthCompareMode = away.display3D.Context3DCompareMode.LESS_EQUAL;
		}
	}
	if (this._casterLightPass || this._nonCasterLightPasses) {
		if (this._pEffectsPass) {
			this._pEffectsPass.set_iIgnoreLights(true);
			this._pEffectsPass.set_depthCompareMode(away.display3D.Context3DCompareMode.LESS_EQUAL);
			this._pEffectsPass.setBlendMode(away.display.BlendMode.LAYER);
			this._pEffectsPass.set_forceSeparateMVP(forceSeparateMVP);
		}
	} else if (this._pEffectsPass) {
		this._pEffectsPass.set_iIgnoreLights(false);
		this._pEffectsPass.set_depthCompareMode(this._pDepthCompareMode);
		this.get_depthCompareMode();
		this._pEffectsPass.setBlendMode(away.display.BlendMode.NORMAL);
		this._pEffectsPass.set_forceSeparateMVP(false);
	}
};

away.materials.MultiPassMaterialBase.prototype.initCasterLightPass = function() {
	if (this._casterLightPass == null) {
		this._casterLightPass = new away.materials.passes.ShadowCasterPass(this);
	}
	this._casterLightPass.set_diffuseMethod(null);
	this._casterLightPass.set_ambientMethod(null);
	this._casterLightPass.set_normalMethod(null);
	this._casterLightPass.set_specularMethod(null);
	this._casterLightPass.set_shadowMethod(null);
	this._casterLightPass.set_enableLightFallOff(this._enableLightFallOff);
	this._casterLightPass.set_lightPicker(new away.materials.lightpickers.StaticLightPicker([this._shadowMethod.get_castingLight()]));
	this._casterLightPass.set_shadowMethod(this._shadowMethod);
	this._casterLightPass.set_diffuseMethod(this._diffuseMethod);
	this._casterLightPass.set_ambientMethod(this._ambientMethod);
	this._casterLightPass.set_normalMethod(this._normalMethod);
	this._casterLightPass.set_specularMethod(this._specularMethod);
	this._casterLightPass.set_diffuseLightSources(this._diffuseLightSources);
	this._casterLightPass.set_specularLightSources(this._specularLightSources);
};

away.materials.MultiPassMaterialBase.prototype.removeCasterLightPass = function() {
	if (!this._casterLightPass)
		return;
	this._casterLightPass.dispose();
	this.pRemovePass(this._casterLightPass);
	this._casterLightPass = null;
};

away.materials.MultiPassMaterialBase.prototype.initNonCasterLightPasses = function() {
	this.removeNonCasterLightPasses();
	var pass;
	var numDirLights = this._pLightPicker.get_numDirectionalLights();
	var numPointLights = this._pLightPicker.get_numPointLights();
	var numLightProbes = this._pLightPicker.get_numLightProbes();
	var dirLightOffset = 0;
	var pointLightOffset = 0;
	var probeOffset = 0;
	if (!this._casterLightPass) {
		numDirLights += this._pLightPicker.get_numCastingDirectionalLights();
		numPointLights += this._pLightPicker.get_numCastingPointLights();
	}
	this._nonCasterLightPasses = [];
	while (dirLightOffset < numDirLights || pointLightOffset < numPointLights || probeOffset < numLightProbes) {
		pass = new away.materials.passes.LightingPass(this);
		pass.set_enableLightFallOff(this._enableLightFallOff);
		pass.set_includeCasters(this._shadowMethod == null);
		pass.set_directionalLightsOffset(dirLightOffset);
		pass.set_pointLightsOffset(pointLightOffset);
		pass.set_lightProbesOffset(probeOffset);
		pass.set_diffuseMethod(null);
		pass.set_ambientMethod(null);
		pass.set_normalMethod(null);
		pass.set_specularMethod(null);
		pass.set_lightPicker(this._pLightPicker);
		pass.set_diffuseMethod(this._diffuseMethod);
		pass.set_ambientMethod(this._ambientMethod);
		pass.set_normalMethod(this._normalMethod);
		pass.set_specularMethod(this._specularMethod);
		pass.set_diffuseLightSources(this._diffuseLightSources);
		pass.set_specularLightSources(this._specularLightSources);
		this._nonCasterLightPasses.push(pass);
		dirLightOffset += pass.get_iNumDirectionalLights();
		pointLightOffset += pass.get_iNumPointLights();
		probeOffset += pass.get_iNumLightProbes();
	}
};

away.materials.MultiPassMaterialBase.prototype.removeNonCasterLightPasses = function() {
	if (!this._nonCasterLightPasses)
		return;
	for (var i = 0; i < this._nonCasterLightPasses.length; ++i) {
		this.pRemovePass(this._nonCasterLightPasses[i]);
		this._nonCasterLightPasses[i].dispose();
	}
	this._nonCasterLightPasses = null;
};

away.materials.MultiPassMaterialBase.prototype.removeEffectsPass = function() {
	if (this._pEffectsPass.get_diffuseMethod() != this._diffuseMethod)
		this._pEffectsPass.get_diffuseMethod().dispose();
	this.pRemovePass(this._pEffectsPass);
	this._pEffectsPass.dispose();
	this._pEffectsPass = null;
};

away.materials.MultiPassMaterialBase.prototype.initEffectsPass = function() {
	if (this._pEffectsPass == null) {
		this._pEffectsPass = new away.materials.passes.SuperShaderPass(this);
	}
	this._pEffectsPass.set_enableLightFallOff(this._enableLightFallOff);
	if (this.get_numLights() == 0) {
		this._pEffectsPass.set_diffuseMethod(null);
		this._pEffectsPass.set_diffuseMethod(this._diffuseMethod);
	} else {
		this._pEffectsPass.set_diffuseMethod(null);
		this._pEffectsPass.set_diffuseMethod(new away.materials.methods.BasicDiffuseMethod());
		this._pEffectsPass.get_diffuseMethod().set_diffuseColor(0x000000);
		this._pEffectsPass.get_diffuseMethod().set_diffuseAlpha(0);
	}
	this._pEffectsPass.set_preserveAlpha(false);
	this._pEffectsPass.set_normalMethod(null);
	this._pEffectsPass.set_normalMethod(this._normalMethod);
	return this._pEffectsPass;
};

away.materials.MultiPassMaterialBase.prototype.get_numLights = function() {
	return this._pLightPicker ? this._pLightPicker.get_numLightProbes() + this._pLightPicker.get_numDirectionalLights() + this._pLightPicker.get_numPointLights() + this._pLightPicker.get_numCastingDirectionalLights() + this._pLightPicker.get_numCastingPointLights() : 0;
};

away.materials.MultiPassMaterialBase.prototype.get_numNonCasters = function() {
	return this._pLightPicker ? this._pLightPicker.get_numLightProbes() + this._pLightPicker.get_numDirectionalLights() + this._pLightPicker.get_numPointLights() : 0;
};

away.materials.MultiPassMaterialBase.prototype.pInvalidateScreenPasses = function() {
	this._screenPassesInvalid = true;
};

away.materials.MultiPassMaterialBase.prototype.onLightsChange = function(event) {
	this.pInvalidateScreenPasses();
};

$inherit(away.materials.MultiPassMaterialBase, away.materials.MaterialBase);

away.materials.MultiPassMaterialBase.className = "away.materials.MultiPassMaterialBase";

away.materials.MultiPassMaterialBase.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.materials.methods.BasicDiffuseMethod');
	p.push('away.events.Event');
	p.push('away.display3D.Context3DBlendFactor');
	p.push('away.materials.passes.LightingPass');
	p.push('away.materials.lightpickers.StaticLightPicker');
	p.push('away.materials.passes.ShadowCasterPass');
	p.push('away.display.BlendMode');
	p.push('away.display3D.Context3DCompareMode');
	p.push('away.materials.passes.SuperShaderPass');
	return p;
};

away.materials.MultiPassMaterialBase.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('away.materials.methods.BasicDiffuseMethod');
	p.push('away.materials.methods.BasicSpecularMethod');
	p.push('away.materials.methods.BasicNormalMethod');
	p.push('away.materials.methods.BasicAmbientMethod');
	return p;
};

away.materials.MultiPassMaterialBase.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 1:
			p = away.materials.MaterialBase.injectionPoints(t);
			break;
		case 2:
			p = away.materials.MaterialBase.injectionPoints(t);
			break;
		case 3:
			p = away.materials.MaterialBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

