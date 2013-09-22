/** Compiled by the Randori compiler v0.2.6.2 on Sun Sep 22 11:20:01 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};
if (typeof away.materials.methods == "undefined")
	away.materials.methods = {};

away.materials.methods.ShaderMethodSetup = function() {
	this._iAmbientMethodVO = null;
	this._iMethods = null;
	this._iDiffuseMethodVO = null;
	this._iColorTransformMethod = null;
	this._iDiffuseMethod = null;
	this._iNormalMethod = null;
	this._iShadowMethodVO = null;
	this._iShadowMethod = null;
	this._iNormalMethodVO = null;
	this._iColorTransformMethodVO = null;
	this._iSpecularMethodVO = null;
	this._iAmbientMethod = null;
	this._iSpecularMethod = null;
	away.events.EventDispatcher.call(this);
	this._iMethods = [];
	this._iNormalMethod = new away.materials.methods.BasicNormalMethod();
	this._iAmbientMethod = new away.materials.methods.BasicAmbientMethod();
	this._iDiffuseMethod = new away.materials.methods.BasicDiffuseMethod();
	this._iSpecularMethod = new away.materials.methods.BasicSpecularMethod();
	this._iNormalMethod.addEventListener(away.events.ShadingMethodEvent.SHADER_INVALIDATED, $createStaticDelegate(this, this.onShaderInvalidated), this);
	this._iDiffuseMethod.addEventListener(away.events.ShadingMethodEvent.SHADER_INVALIDATED, $createStaticDelegate(this, this.onShaderInvalidated), this);
	this._iSpecularMethod.addEventListener(away.events.ShadingMethodEvent.SHADER_INVALIDATED, $createStaticDelegate(this, this.onShaderInvalidated), this);
	this._iAmbientMethod.addEventListener(away.events.ShadingMethodEvent.SHADER_INVALIDATED, $createStaticDelegate(this, this.onShaderInvalidated), this);
	this._iNormalMethodVO = this._iNormalMethod.iCreateMethodVO();
	this._iAmbientMethodVO = this._iAmbientMethod.iCreateMethodVO();
	this._iDiffuseMethodVO = this._iDiffuseMethod.iCreateMethodVO();
	this._iSpecularMethodVO = this._iSpecularMethod.iCreateMethodVO();
};

away.materials.methods.ShaderMethodSetup.prototype.onShaderInvalidated = function(event) {
	this.invalidateShaderProgram();
};

away.materials.methods.ShaderMethodSetup.prototype.invalidateShaderProgram = function() {
	this.dispatchEvent(new away.events.ShadingMethodEvent(away.events.ShadingMethodEvent.SHADER_INVALIDATED));
};

away.materials.methods.ShaderMethodSetup.prototype.get_normalMethod = function() {
	return this._iNormalMethod;
};

away.materials.methods.ShaderMethodSetup.prototype.set_normalMethod = function(value) {
	if (this._iNormalMethod) {
		this._iNormalMethod.removeEventListener(away.events.ShadingMethodEvent.SHADER_INVALIDATED, $createStaticDelegate(this, this.onShaderInvalidated), this);
	}
	if (value) {
		if (this._iNormalMethod) {
			value.copyFrom(this._iNormalMethod);
		}
		this._iNormalMethodVO = value.iCreateMethodVO();
		value.addEventListener(away.events.ShadingMethodEvent.SHADER_INVALIDATED, $createStaticDelegate(this, this.onShaderInvalidated), this);
	}
	this._iNormalMethod = value;
	if (value)
		this.invalidateShaderProgram();
};

away.materials.methods.ShaderMethodSetup.prototype.get_ambientMethod = function() {
	return this._iAmbientMethod;
};

away.materials.methods.ShaderMethodSetup.prototype.set_ambientMethod = function(value) {
	if (this._iAmbientMethod)
		this._iAmbientMethod.removeEventListener(away.events.ShadingMethodEvent.SHADER_INVALIDATED, $createStaticDelegate(this, this.onShaderInvalidated), this);
	if (value) {
		if (this._iAmbientMethod)
			value.copyFrom(this._iAmbientMethod);
		value.addEventListener(away.events.ShadingMethodEvent.SHADER_INVALIDATED, $createStaticDelegate(this, this.onShaderInvalidated), this);
		this._iAmbientMethodVO = value.iCreateMethodVO();
	}
	this._iAmbientMethod = value;
	if (value)
		this.invalidateShaderProgram();
};

away.materials.methods.ShaderMethodSetup.prototype.get_shadowMethod = function() {
	return this._iShadowMethod;
};

away.materials.methods.ShaderMethodSetup.prototype.set_shadowMethod = function(value) {
	if (this._iShadowMethod) {
		this._iShadowMethod.removeEventListener(away.events.ShadingMethodEvent.SHADER_INVALIDATED, $createStaticDelegate(this, this.onShaderInvalidated), this);
	}
	this._iShadowMethod = value;
	if (this._iShadowMethod) {
		this._iShadowMethod.addEventListener(away.events.ShadingMethodEvent.SHADER_INVALIDATED, $createStaticDelegate(this, this.onShaderInvalidated), this);
		this._iShadowMethodVO = this._iShadowMethod.iCreateMethodVO();
	} else {
		this._iShadowMethodVO = null;
	}
	this.invalidateShaderProgram();
};

away.materials.methods.ShaderMethodSetup.prototype.get_diffuseMethod = function() {
	return this._iDiffuseMethod;
};

away.materials.methods.ShaderMethodSetup.prototype.set_diffuseMethod = function(value) {
	if (this._iDiffuseMethod)
		this._iDiffuseMethod.removeEventListener(away.events.ShadingMethodEvent.SHADER_INVALIDATED, $createStaticDelegate(this, this.onShaderInvalidated), this);
	if (value) {
		if (this._iDiffuseMethod)
			value.copyFrom(this._iDiffuseMethod);
		value.addEventListener(away.events.ShadingMethodEvent.SHADER_INVALIDATED, $createStaticDelegate(this, this.onShaderInvalidated), this);
		this._iDiffuseMethodVO = value.iCreateMethodVO();
	}
	this._iDiffuseMethod = value;
	if (value)
		this.invalidateShaderProgram();
};

away.materials.methods.ShaderMethodSetup.prototype.get_specularMethod = function() {
	return this._iSpecularMethod;
};

away.materials.methods.ShaderMethodSetup.prototype.set_specularMethod = function(value) {
	if (this._iSpecularMethod) {
		this._iSpecularMethod.removeEventListener(away.events.ShadingMethodEvent.SHADER_INVALIDATED, $createStaticDelegate(this, this.onShaderInvalidated), this);
		if (value)
			value.copyFrom(this._iSpecularMethod);
	}
	this._iSpecularMethod = value;
	if (this._iSpecularMethod) {
		this._iSpecularMethod.addEventListener(away.events.ShadingMethodEvent.SHADER_INVALIDATED, $createStaticDelegate(this, this.onShaderInvalidated), this);
		this._iSpecularMethodVO = this._iSpecularMethod.iCreateMethodVO();
	} else {
		this._iSpecularMethodVO = null;
	}
	this.invalidateShaderProgram();
};

away.materials.methods.ShaderMethodSetup.prototype.get_iColorTransformMethod = function() {
	return this._iColorTransformMethod;
};

away.materials.methods.ShaderMethodSetup.prototype.set_iColorTransformMethod = function(value) {
	if (this._iColorTransformMethod == value)
		return;
	if (this._iColorTransformMethod)
		this._iColorTransformMethod.removeEventListener(away.events.ShadingMethodEvent.SHADER_INVALIDATED, $createStaticDelegate(this, this.onShaderInvalidated), this);
	if (!this._iColorTransformMethod || !value) {
		this.invalidateShaderProgram();
	}
	this._iColorTransformMethod = value;
	if (this._iColorTransformMethod) {
		this._iColorTransformMethod.addEventListener(away.events.ShadingMethodEvent.SHADER_INVALIDATED, $createStaticDelegate(this, this.onShaderInvalidated), this);
		this._iColorTransformMethodVO = this._iColorTransformMethod.iCreateMethodVO();
	} else {
		this._iColorTransformMethodVO = null;
	}
};

away.materials.methods.ShaderMethodSetup.prototype.dispose = function() {
	this.clearListeners(this._iNormalMethod);
	this.clearListeners(this._iDiffuseMethod);
	this.clearListeners(this._iShadowMethod);
	this.clearListeners(this._iAmbientMethod);
	this.clearListeners(this._iSpecularMethod);
	for (var i = 0; i < this._iMethods.length; ++i) {
		this.clearListeners(this._iMethods[i].method);
	}
	this._iMethods = null;
};

away.materials.methods.ShaderMethodSetup.prototype.clearListeners = function(method) {
	if (method)
		method.removeEventListener(away.events.ShadingMethodEvent.SHADER_INVALIDATED, $createStaticDelegate(this, this.onShaderInvalidated), this);
};

away.materials.methods.ShaderMethodSetup.prototype.addMethod = function(method) {
	this._iMethods.push(new away.materials.methods.MethodVOSet(method));
	method.addEventListener(away.events.ShadingMethodEvent.SHADER_INVALIDATED, $createStaticDelegate(this, this.onShaderInvalidated), this);
	this.invalidateShaderProgram();
};

away.materials.methods.ShaderMethodSetup.prototype.hasMethod = function(method) {
	return this.getMethodSetForMethod(method) != null;
};

away.materials.methods.ShaderMethodSetup.prototype.addMethodAt = function(method, index) {
	this._iMethods.splice(index, 0, new away.materials.methods.MethodVOSet(method));
	method.addEventListener(away.events.ShadingMethodEvent.SHADER_INVALIDATED, $createStaticDelegate(this, this.onShaderInvalidated), this);
	this.invalidateShaderProgram();
};

away.materials.methods.ShaderMethodSetup.prototype.getMethodAt = function(index) {
	if (index > this._iMethods.length - 1)
		return null;
	return this._iMethods[index].method;
};

away.materials.methods.ShaderMethodSetup.prototype.get_numMethods = function() {
	return this._iMethods.length;
};

away.materials.methods.ShaderMethodSetup.prototype.removeMethod = function(method) {
	var methodSet = this.getMethodSetForMethod(method);
	if (methodSet != null) {
		var index = this._iMethods.indexOf(methodSet, 0);
		this._iMethods.splice(index, 1);
		method.removeEventListener(away.events.ShadingMethodEvent.SHADER_INVALIDATED, $createStaticDelegate(this, this.onShaderInvalidated), this);
		this.invalidateShaderProgram();
	}
};

away.materials.methods.ShaderMethodSetup.prototype.getMethodSetForMethod = function(method) {
	var len = this._iMethods.length;
	for (var i = 0; i < len; ++i) {
		if (this._iMethods[i].method == method)
			return this._iMethods[i];
	}
	return null;
};

$inherit(away.materials.methods.ShaderMethodSetup, away.events.EventDispatcher);

away.materials.methods.ShaderMethodSetup.className = "away.materials.methods.ShaderMethodSetup";

away.materials.methods.ShaderMethodSetup.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.materials.methods.BasicDiffuseMethod');
	p.push('away.materials.methods.MethodVOSet');
	p.push('Object');
	p.push('away.materials.methods.BasicSpecularMethod');
	p.push('away.events.ShadingMethodEvent');
	p.push('away.materials.methods.BasicAmbientMethod');
	p.push('away.materials.methods.BasicNormalMethod');
	return p;
};

away.materials.methods.ShaderMethodSetup.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.materials.methods.ShaderMethodSetup.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 1:
			p = away.events.EventDispatcher.injectionPoints(t);
			break;
		case 2:
			p = away.events.EventDispatcher.injectionPoints(t);
			break;
		case 3:
			p = away.events.EventDispatcher.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

