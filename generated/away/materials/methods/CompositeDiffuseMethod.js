/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:05 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};
if (typeof away.materials.methods == "undefined")
	away.materials.methods = {};

away.materials.methods.CompositeDiffuseMethod = function(modulateMethod, baseDiffuseMethod) {
	this.pBaseMethod = null;
	modulateMethod = modulateMethod || null;
	baseDiffuseMethod = baseDiffuseMethod || null;
	away.materials.methods.BasicDiffuseMethod.call(this);
	this.pBaseMethod = baseDiffuseMethod || new away.materials.methods.BasicDiffuseMethod();
	this.pBaseMethod._iModulateMethod = modulateMethod;
	this.pBaseMethod.addEventListener(away.events.ShadingMethodEvent.SHADER_INVALIDATED, $createStaticDelegate(this, this.onShaderInvalidated), this);
};

away.materials.methods.CompositeDiffuseMethod.prototype.get_baseMethod = function() {
	return this.pBaseMethod;
};

away.materials.methods.CompositeDiffuseMethod.prototype.set_baseMethod = function(value) {
	if (this.pBaseMethod == value)
		return;
	this.pBaseMethod.removeEventListener(away.events.ShadingMethodEvent.SHADER_INVALIDATED, $createStaticDelegate(this, this.onShaderInvalidated), this);
	this.pBaseMethod = value;
	this.pBaseMethod.addEventListener(away.events.ShadingMethodEvent.SHADER_INVALIDATED, $createStaticDelegate(this, this.onShaderInvalidated), this);
	this.iInvalidateShaderProgram();
};

away.materials.methods.CompositeDiffuseMethod.prototype.iInitVO = function(vo) {
	this.pBaseMethod.iInitVO(vo);
};

away.materials.methods.CompositeDiffuseMethod.prototype.iInitConstants = function(vo) {
	this.pBaseMethod.iInitConstants(vo);
};

away.materials.methods.CompositeDiffuseMethod.prototype.dispose = function() {
	this.pBaseMethod.removeEventListener(away.events.ShadingMethodEvent.SHADER_INVALIDATED, $createStaticDelegate(this, this.onShaderInvalidated), this);
	this.pBaseMethod.dispose();
};

away.materials.methods.CompositeDiffuseMethod.prototype.get_alphaThreshold = function() {
	return this.pBaseMethod.get_alphaThreshold();
};

away.materials.methods.CompositeDiffuseMethod.prototype.set_alphaThreshold = function(value) {
	this.pBaseMethod.set_alphaThreshold(value);
};

away.materials.methods.CompositeDiffuseMethod.prototype.get_texture = function() {
	return this.pBaseMethod.get_texture();
};

away.materials.methods.CompositeDiffuseMethod.prototype.set_texture = function(value) {
	this.pBaseMethod.set_texture(value);
};

away.materials.methods.CompositeDiffuseMethod.prototype.get_diffuseAlpha = function() {
	return this.pBaseMethod.get_diffuseAlpha();
};

away.materials.methods.CompositeDiffuseMethod.prototype.get_diffuseColor = function() {
	return this.pBaseMethod.get_diffuseColor();
};

away.materials.methods.CompositeDiffuseMethod.prototype.set_diffuseColor = function(diffuseColor) {
	this.pBaseMethod.set_diffuseColor(diffuseColor);
};

away.materials.methods.CompositeDiffuseMethod.prototype.set_diffuseAlpha = function(value) {
	this.pBaseMethod.set_diffuseAlpha(value);
};

away.materials.methods.CompositeDiffuseMethod.prototype.iGetFragmentPreLightingCode = function(vo, regCache) {
	return this.pBaseMethod.iGetFragmentPreLightingCode(vo, regCache);
};

away.materials.methods.CompositeDiffuseMethod.prototype.iGetFragmentCodePerLight = function(vo, lightDirReg, lightColReg, regCache) {
	var code = this.pBaseMethod.iGetFragmentCodePerLight(vo, lightDirReg, lightColReg, regCache);
	this.pTotalLightColorReg = this.pBaseMethod.pTotalLightColorReg;
	return code;
};

away.materials.methods.CompositeDiffuseMethod.prototype.iGetFragmentCodePerProbe = function(vo, cubeMapReg, weightRegister, regCache) {
	var code = this.pBaseMethod.iGetFragmentCodePerProbe(vo, cubeMapReg, weightRegister, regCache);
	this.pTotalLightColorReg = this.pBaseMethod.pTotalLightColorReg;
	return code;
};

away.materials.methods.CompositeDiffuseMethod.prototype.iActivate = function(vo, stage3DProxy) {
	this.pBaseMethod.iActivate(vo, stage3DProxy);
};

away.materials.methods.CompositeDiffuseMethod.prototype.iDeactivate = function(vo, stage3DProxy) {
	this.pBaseMethod.iDeactivate(vo, stage3DProxy);
};

away.materials.methods.CompositeDiffuseMethod.prototype.iGetVertexCode = function(vo, regCache) {
	return this.pBaseMethod.iGetVertexCode(vo, regCache);
};

away.materials.methods.CompositeDiffuseMethod.prototype.iGetFragmentPostLightingCode = function(vo, regCache, targetReg) {
	return this.pBaseMethod.iGetFragmentPostLightingCode(vo, regCache, targetReg);
};

away.materials.methods.CompositeDiffuseMethod.prototype.iReset = function() {
	this.pBaseMethod.iReset();
};

away.materials.methods.CompositeDiffuseMethod.prototype.iCleanCompilationData = function() {
	away.materials.methods.BasicDiffuseMethod.prototype.iCleanCompilationData.call(this);
	this.pBaseMethod.iCleanCompilationData();
};

away.materials.methods.CompositeDiffuseMethod.prototype.set_iSharedRegisters = function(value) {
	this.pBaseMethod.setISharedRegisters(value);
	away.materials.methods.BasicDiffuseMethod.prototype.setISharedRegisters.call(this,value);
};

away.materials.methods.CompositeDiffuseMethod.prototype.setISharedRegisters = function(value) {
	this.pBaseMethod.setISharedRegisters(value);
	away.materials.methods.BasicDiffuseMethod.prototype.setISharedRegisters.call(this,value);
};

away.materials.methods.CompositeDiffuseMethod.prototype.set_iShadowRegister = function(value) {
	away.materials.methods.BasicDiffuseMethod.prototype.setIShadowRegister.call(this,value);
	this.pBaseMethod.setIShadowRegister(value);
};

away.materials.methods.CompositeDiffuseMethod.prototype.onShaderInvalidated = function(event) {
	this.iInvalidateShaderProgram();
};

$inherit(away.materials.methods.CompositeDiffuseMethod, away.materials.methods.BasicDiffuseMethod);

away.materials.methods.CompositeDiffuseMethod.className = "away.materials.methods.CompositeDiffuseMethod";

away.materials.methods.CompositeDiffuseMethod.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.materials.methods.BasicDiffuseMethod');
	p.push('away.events.ShadingMethodEvent');
	return p;
};

away.materials.methods.CompositeDiffuseMethod.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.materials.methods.CompositeDiffuseMethod.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'modulateMethod', t:'Function'});
			p.push({n:'baseDiffuseMethod', t:'away.materials.methods.BasicDiffuseMethod'});
			break;
		case 1:
			p = away.materials.methods.BasicDiffuseMethod.injectionPoints(t);
			break;
		case 2:
			p = away.materials.methods.BasicDiffuseMethod.injectionPoints(t);
			break;
		case 3:
			p = away.materials.methods.BasicDiffuseMethod.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

