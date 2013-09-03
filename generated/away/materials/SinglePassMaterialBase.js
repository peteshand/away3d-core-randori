/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 03 00:11:46 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};

away.materials.SinglePassMaterialBase = function() {
	this._alphaBlending = false;
	this._pScreenPass = null;
	away.materials.MaterialBase.call(this);
	this.pAddPass(this._pScreenPass = new away.materials.passes.SuperShaderPass(this));
};

away.materials.SinglePassMaterialBase.prototype.get_enableLightFallOff = function() {
	return this._pScreenPass.get_enableLightFallOff();
};

away.materials.SinglePassMaterialBase.prototype.set_enableLightFallOff = function(value) {
	this._pScreenPass.set_enableLightFallOff(value);
};

away.materials.SinglePassMaterialBase.prototype.get_alphaThreshold = function() {
	return this._pScreenPass.get_diffuseMethod().get_alphaThreshold();
};

away.materials.SinglePassMaterialBase.prototype.set_alphaThreshold = function(value) {
	this._pScreenPass.get_diffuseMethod().set_alphaThreshold(value);
	this._pDepthPass.set_alphaThreshold(value);
	this._pDistancePass.set_alphaThreshold(value);
};

away.materials.SinglePassMaterialBase.prototype.set_blendMode = function(value) {
	away.materials.MaterialBase.prototype.setBlendMode.call(this,value);
	this._pScreenPass.setBlendMode((this._pBlendMode == away.display.BlendMode.NORMAL) && this.get_requiresBlending() ? away.display.BlendMode.LAYER : this._pBlendMode);
};

away.materials.SinglePassMaterialBase.prototype.set_depthCompareMode = function(value) {
	this._pDepthCompareMode = value;
	this._pScreenPass.set_depthCompareMode(value);
};

away.materials.SinglePassMaterialBase.prototype.iActivateForDepth = function(stage3DProxy, camera, distanceBased) {
	if (distanceBased) {
		this._pDistancePass.set_alphaMask(this._pScreenPass.get_diffuseMethod().get_texture());
	} else {
		this._pDepthPass.set_alphaMask(this._pScreenPass.get_diffuseMethod().get_texture());
	}
	away.materials.MaterialBase.prototype.iActivateForDepth.call(this,stage3DProxy, camera, distanceBased);
};

away.materials.SinglePassMaterialBase.prototype.get_specularLightSources = function() {
	return this._pScreenPass.get_specularLightSources();
};

away.materials.SinglePassMaterialBase.prototype.set_specularLightSources = function(value) {
	this._pScreenPass.set_specularLightSources(value);
};

away.materials.SinglePassMaterialBase.prototype.get_diffuseLightSources = function() {
	return this._pScreenPass.get_diffuseLightSources();
};

away.materials.SinglePassMaterialBase.prototype.set_diffuseLightSources = function(value) {
	this._pScreenPass.set_diffuseLightSources(value);
};

away.materials.SinglePassMaterialBase.prototype.get_requiresBlending = function() {
	return this.getRequiresBlending();
};

away.materials.SinglePassMaterialBase.prototype.getRequiresBlending = function() {
	var ct = this._pScreenPass.get_colorTransform();
	if (ct) {
		return (this._pBlendMode != away.display.BlendMode.NORMAL) || this._alphaBlending || (ct.alphaMultiplier < 1);
	}
	return (this._pBlendMode != away.display.BlendMode.NORMAL) || this._alphaBlending;
};

away.materials.SinglePassMaterialBase.prototype.get_colorTransform = function() {
	return this._pScreenPass.get_colorTransform();
};

away.materials.SinglePassMaterialBase.prototype.set_colorTransform = function(value) {
	this.setColorTransform(value);
};

away.materials.SinglePassMaterialBase.prototype.setColorTransform = function(value) {
	this._pScreenPass.set_colorTransform(value);
};

away.materials.SinglePassMaterialBase.prototype.get_ambientMethod = function() {
	return this._pScreenPass.get_ambientMethod();
};

away.materials.SinglePassMaterialBase.prototype.set_ambientMethod = function(value) {
	this._pScreenPass.set_ambientMethod(value);
};

away.materials.SinglePassMaterialBase.prototype.get_shadowMethod = function() {
	return this._pScreenPass.get_shadowMethod();
};

away.materials.SinglePassMaterialBase.prototype.set_shadowMethod = function(value) {
	this._pScreenPass.set_shadowMethod(value);
};

away.materials.SinglePassMaterialBase.prototype.get_diffuseMethod = function() {
	return this._pScreenPass.get_diffuseMethod();
};

away.materials.SinglePassMaterialBase.prototype.set_diffuseMethod = function(value) {
	this._pScreenPass.set_diffuseMethod(value);
};

away.materials.SinglePassMaterialBase.prototype.get_normalMethod = function() {
	return this._pScreenPass.get_normalMethod();
};

away.materials.SinglePassMaterialBase.prototype.set_normalMethod = function(value) {
	this._pScreenPass.set_normalMethod(value);
};

away.materials.SinglePassMaterialBase.prototype.get_specularMethod = function() {
	return this._pScreenPass.get_specularMethod();
};

away.materials.SinglePassMaterialBase.prototype.set_specularMethod = function(value) {
	this._pScreenPass.set_specularMethod(value);
};

away.materials.SinglePassMaterialBase.prototype.addMethod = function(method) {
	this._pScreenPass.addMethod(method);
};

away.materials.SinglePassMaterialBase.prototype.get_numMethods = function() {
	return this._pScreenPass.get_numMethods();
};

away.materials.SinglePassMaterialBase.prototype.hasMethod = function(method) {
	return this._pScreenPass.hasMethod(method);
};

away.materials.SinglePassMaterialBase.prototype.getMethodAt = function(index) {
	return this._pScreenPass.getMethodAt(index);
};

away.materials.SinglePassMaterialBase.prototype.addMethodAt = function(method, index) {
	this._pScreenPass.addMethodAt(method, index);
};

away.materials.SinglePassMaterialBase.prototype.removeMethod = function(method) {
	this._pScreenPass.removeMethod(method);
};

away.materials.SinglePassMaterialBase.prototype.set_mipmap = function(value) {
	if (this._pMipmap == value)
		return;
	this.setMipMap(value);
};

away.materials.SinglePassMaterialBase.prototype.get_normalMap = function() {
	return this._pScreenPass.get_normalMap();
};

away.materials.SinglePassMaterialBase.prototype.set_normalMap = function(value) {
	this._pScreenPass.set_normalMap(value);
};

away.materials.SinglePassMaterialBase.prototype.get_specularMap = function() {
	return this._pScreenPass.get_specularMethod().get_texture();
};

away.materials.SinglePassMaterialBase.prototype.set_specularMap = function(value) {
	if (this._pScreenPass.get_specularMethod()) {
		this._pScreenPass.get_specularMethod().set_texture(value);
	} else {
		throw new away.errors.Error("No specular method was set to assign the specularGlossMap to", 0, "");
	}
};

away.materials.SinglePassMaterialBase.prototype.get_gloss = function() {
	return this._pScreenPass.get_specularMethod() ? this._pScreenPass.get_specularMethod().get_gloss() : 0;
};

away.materials.SinglePassMaterialBase.prototype.set_gloss = function(value) {
	if (this._pScreenPass.get_specularMethod())
		this._pScreenPass.get_specularMethod().set_gloss(value);
};

away.materials.SinglePassMaterialBase.prototype.get_ambient = function() {
	return this._pScreenPass.get_ambientMethod().get_ambient();
};

away.materials.SinglePassMaterialBase.prototype.set_ambient = function(value) {
	this._pScreenPass.get_ambientMethod().set_ambient(value);
};

away.materials.SinglePassMaterialBase.prototype.get_specular = function() {
	return this._pScreenPass.get_specularMethod() ? this._pScreenPass.get_specularMethod().get_specular() : 0;
};

away.materials.SinglePassMaterialBase.prototype.set_specular = function(value) {
	if (this._pScreenPass.get_specularMethod())
		this._pScreenPass.get_specularMethod().set_specular(value);
};

away.materials.SinglePassMaterialBase.prototype.get_ambientColor = function() {
	return this._pScreenPass.get_ambientMethod().get_ambientColor();
};

away.materials.SinglePassMaterialBase.prototype.set_ambientColor = function(value) {
	this._pScreenPass.get_ambientMethod().set_ambientColor(value);
};

away.materials.SinglePassMaterialBase.prototype.get_specularColor = function() {
	return this._pScreenPass.get_specularMethod().get_specularColor();
};

away.materials.SinglePassMaterialBase.prototype.set_specularColor = function(value) {
	this._pScreenPass.get_specularMethod().set_specularColor(value);
};

away.materials.SinglePassMaterialBase.prototype.get_alphaBlending = function() {
	return this._alphaBlending;
};

away.materials.SinglePassMaterialBase.prototype.set_alphaBlending = function(value) {
	this._alphaBlending = value;
	this._pScreenPass.setBlendMode(this.getBlendMode() == away.display.BlendMode.NORMAL && this.get_requiresBlending() ? away.display.BlendMode.LAYER : this.getBlendMode());
	this._pScreenPass.set_preserveAlpha(this.get_requiresBlending());
};

away.materials.SinglePassMaterialBase.prototype.iUpdateMaterial = function(context) {
	if (this._pScreenPass._iPassesDirty) {
		this.pClearPasses();
		if (this._pScreenPass._iPasses) {
			var len = this._pScreenPass._iPasses.length;
			for (var i = 0; i < len; ++i) {
				this.pAddPass(this._pScreenPass._iPasses[i]);
			}
		}
		this.pAddPass(this._pScreenPass);
		this._pScreenPass._iPassesDirty = false;
	}
};

away.materials.SinglePassMaterialBase.prototype.set_lightPicker = function(value) {
	away.materials.MaterialBase.prototype.setLightPicker.call(this,value);
	this._pScreenPass.set_lightPicker(value);
};

$inherit(away.materials.SinglePassMaterialBase, away.materials.MaterialBase);

away.materials.SinglePassMaterialBase.className = "away.materials.SinglePassMaterialBase";

away.materials.SinglePassMaterialBase.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.display.BlendMode');
	p.push('away.materials.passes.SuperShaderPass');
	return p;
};

away.materials.SinglePassMaterialBase.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.materials.SinglePassMaterialBase.injectionPoints = function(t) {
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

