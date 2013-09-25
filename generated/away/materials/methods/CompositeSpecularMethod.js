/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 25 08:00:45 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};
if (typeof away.materials.methods == "undefined")
	away.materials.methods = {};

away.materials.methods.CompositeSpecularMethod = function() {
	this._baseMethod = null;
	away.materials.methods.BasicSpecularMethod.call(this);
};

away.materials.methods.CompositeSpecularMethod.prototype.initCompositeSpecularMethod = function(scope, modulateMethod, baseSpecularMethod) {
	baseSpecularMethod = baseSpecularMethod || null;
	this._baseMethod = baseSpecularMethod || new away.materials.methods.BasicSpecularMethod();
	this._baseMethod._iModulateMethod = modulateMethod;
	this._baseMethod._iModulateMethodScope = scope;
	this._baseMethod.addEventListener(away.events.ShadingMethodEvent.SHADER_INVALIDATED, $createStaticDelegate(this, this.onShaderInvalidated), this);
};

away.materials.methods.CompositeSpecularMethod.prototype.iInitVO = function(vo) {
	this._baseMethod.iInitVO(vo);
};

away.materials.methods.CompositeSpecularMethod.prototype.iInitConstants = function(vo) {
	this._baseMethod.iInitConstants(vo);
};

away.materials.methods.CompositeSpecularMethod.prototype.get_baseMethod = function() {
	return this._baseMethod;
};

away.materials.methods.CompositeSpecularMethod.prototype.set_baseMethod = function(value) {
	if (this._baseMethod == value)
		return;
	this._baseMethod.removeEventListener(away.events.ShadingMethodEvent.SHADER_INVALIDATED, $createStaticDelegate(this, this.onShaderInvalidated), this);
	this._baseMethod = value;
	this._baseMethod.addEventListener(away.events.ShadingMethodEvent.SHADER_INVALIDATED, $createStaticDelegate(this, this.onShaderInvalidated), this);
	this.iInvalidateShaderProgram();
};

away.materials.methods.CompositeSpecularMethod.prototype.get_gloss = function() {
	return this._baseMethod.get_gloss();
};

away.materials.methods.CompositeSpecularMethod.prototype.set_gloss = function(value) {
	this._baseMethod.set_gloss(value);
};

away.materials.methods.CompositeSpecularMethod.prototype.get_specular = function() {
	return this._baseMethod.get_specular();
};

away.materials.methods.CompositeSpecularMethod.prototype.set_specular = function(value) {
	this._baseMethod.set_specular(value);
};

away.materials.methods.CompositeSpecularMethod.prototype.get_passes = function() {
	return this._baseMethod.get_passes();
};

away.materials.methods.CompositeSpecularMethod.prototype.dispose = function() {
	this._baseMethod.removeEventListener(away.events.ShadingMethodEvent.SHADER_INVALIDATED, $createStaticDelegate(this, this.onShaderInvalidated), this);
	this._baseMethod.dispose();
};

away.materials.methods.CompositeSpecularMethod.prototype.get_texture = function() {
	return this._baseMethod.get_texture();
};

away.materials.methods.CompositeSpecularMethod.prototype.set_texture = function(value) {
	this._baseMethod.set_texture(value);
};

away.materials.methods.CompositeSpecularMethod.prototype.iActivate = function(vo, stage3DProxy) {
	this._baseMethod.iActivate(vo, stage3DProxy);
};

away.materials.methods.CompositeSpecularMethod.prototype.iDeactivate = function(vo, stage3DProxy) {
	this._baseMethod.iDeactivate(vo, stage3DProxy);
};

away.materials.methods.CompositeSpecularMethod.prototype.set_iSharedRegisters = function(value) {
	away.materials.methods.BasicSpecularMethod.prototype.setISharedRegisters.call(this,value);
	this._baseMethod.setISharedRegisters(value);
};

away.materials.methods.CompositeSpecularMethod.prototype.setISharedRegisters = function(value) {
	away.materials.methods.BasicSpecularMethod.prototype.setISharedRegisters.call(this,value);
	this._baseMethod.setISharedRegisters(value);
};

away.materials.methods.CompositeSpecularMethod.prototype.iGetVertexCode = function(vo, regCache) {
	return this._baseMethod.iGetVertexCode(vo, regCache);
};

away.materials.methods.CompositeSpecularMethod.prototype.iGetFragmentPreLightingCode = function(vo, regCache) {
	return this._baseMethod.iGetFragmentPreLightingCode(vo, regCache);
};

away.materials.methods.CompositeSpecularMethod.prototype.iGetFragmentCodePerLight = function(vo, lightDirReg, lightColReg, regCache) {
	return this._baseMethod.iGetFragmentCodePerLight(vo, lightDirReg, lightColReg, regCache);
};

away.materials.methods.CompositeSpecularMethod.prototype.iGetFragmentCodePerProbe = function(vo, cubeMapReg, weightRegister, regCache) {
	return this._baseMethod.iGetFragmentCodePerProbe(vo, cubeMapReg, weightRegister, regCache);
};

away.materials.methods.CompositeSpecularMethod.prototype.iGetFragmentPostLightingCode = function(vo, regCache, targetReg) {
	return this._baseMethod.iGetFragmentPostLightingCode(vo, regCache, targetReg);
};

away.materials.methods.CompositeSpecularMethod.prototype.iReset = function() {
	this._baseMethod.iReset();
};

away.materials.methods.CompositeSpecularMethod.prototype.iCleanCompilationData = function() {
	away.materials.methods.BasicSpecularMethod.prototype.iCleanCompilationData.call(this);
	this._baseMethod.iCleanCompilationData();
};

away.materials.methods.CompositeSpecularMethod.prototype.set_iShadowRegister = function(value) {
	this.setIShadowRegister(value);
	this._baseMethod.setIShadowRegister(value);
};

away.materials.methods.CompositeSpecularMethod.prototype.onShaderInvalidated = function(event) {
	this.iInvalidateShaderProgram();
};

$inherit(away.materials.methods.CompositeSpecularMethod, away.materials.methods.BasicSpecularMethod);

away.materials.methods.CompositeSpecularMethod.className = "away.materials.methods.CompositeSpecularMethod";

away.materials.methods.CompositeSpecularMethod.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.materials.methods.BasicSpecularMethod');
	p.push('away.events.ShadingMethodEvent');
	return p;
};

away.materials.methods.CompositeSpecularMethod.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.materials.methods.CompositeSpecularMethod.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 1:
			p = away.materials.methods.BasicSpecularMethod.injectionPoints(t);
			break;
		case 2:
			p = away.materials.methods.BasicSpecularMethod.injectionPoints(t);
			break;
		case 3:
			p = away.materials.methods.BasicSpecularMethod.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

