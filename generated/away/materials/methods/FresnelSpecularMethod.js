/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 28 11:54:51 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};
if (typeof away.materials.methods == "undefined")
	away.materials.methods = {};

away.materials.methods.FresnelSpecularMethod = function(basedOnSurface, baseSpecularMethod) {
	this._normalReflectance = 028;
	this._fresnelPower = 5;
	this._incidentLight = false;
	this._dataReg = null;
	basedOnSurface = basedOnSurface || true;
	baseSpecularMethod = baseSpecularMethod || null;
	away.materials.methods.CompositeSpecularMethod.call(this);
	this.initCompositeSpecularMethod(this, $createStaticDelegate(this, this.modulateSpecular), baseSpecularMethod);
	this._incidentLight = !basedOnSurface;
};

away.materials.methods.FresnelSpecularMethod.prototype.iInitConstants = function(vo) {
	var index = vo.secondaryFragmentConstantsIndex;
	vo.fragmentData[index + 2] = 1;
	vo.fragmentData[index + 3] = 0;
};

away.materials.methods.FresnelSpecularMethod.prototype.get_basedOnSurface = function() {
	return !this._incidentLight;
};

away.materials.methods.FresnelSpecularMethod.prototype.set_basedOnSurface = function(value) {
	if (this._incidentLight != value)
		return;
	this._incidentLight = !value;
	this.iInvalidateShaderProgram();
};

away.materials.methods.FresnelSpecularMethod.prototype.get_fresnelPower = function() {
	return this._fresnelPower;
};

away.materials.methods.FresnelSpecularMethod.prototype.set_fresnelPower = function(value) {
	this._fresnelPower = value;
};

away.materials.methods.FresnelSpecularMethod.prototype.iCleanCompilationData = function() {
	away.materials.methods.CompositeSpecularMethod.prototype.iCleanCompilationData.call(this);
	this._dataReg = null;
};

away.materials.methods.FresnelSpecularMethod.prototype.get_normalReflectance = function() {
	return this._normalReflectance;
};

away.materials.methods.FresnelSpecularMethod.prototype.set_normalReflectance = function(value) {
	this._normalReflectance = value;
};

away.materials.methods.FresnelSpecularMethod.prototype.iActivate = function(vo, stage3DProxy) {
	away.materials.methods.CompositeSpecularMethod.prototype.iActivate.call(this,vo, stage3DProxy);
	var fragmentData = vo.fragmentData;
	var index = vo.secondaryFragmentConstantsIndex;
	fragmentData[index] = this._normalReflectance;
	fragmentData[index + 1] = this._fresnelPower;
};

away.materials.methods.FresnelSpecularMethod.prototype.iGetFragmentPreLightingCode = function(vo, regCache) {
	this._dataReg = regCache.getFreeFragmentConstant();
	console.log("FresnelSpecularMethod", "iGetFragmentPreLightingCode", this._dataReg);
	vo.secondaryFragmentConstantsIndex = this._dataReg.get_index() * 4;
	return away.materials.methods.CompositeSpecularMethod.prototype.iGetFragmentPreLightingCode.call(this,vo, regCache);
};

away.materials.methods.FresnelSpecularMethod.prototype.modulateSpecular = function(vo, target, regCache, sharedRegisters) {
	var code;
	code = "dp3 " + target + ".y, " + sharedRegisters.viewDirFragment + ".xyz, " + this._incidentLight ? target + ".xyz\n" : sharedRegisters.normalFragment + ".xyz\n" + "sub " + target + ".y, " + this._dataReg + ".z, " + target + ".y\n" + "pow " + target + ".x, " + target + ".y, " + this._dataReg + ".y\n" + "sub " + target + ".y, " + this._dataReg + ".z, " + target + ".y\n" + "mul " + target + ".y, " + this._dataReg + ".x, " + target + ".y\n" + "add " + target + ".y, " + target + ".x, " + target + ".y\n" + "mul " + target + ".w, " + target + ".w, " + target + ".y\n";
	console.log("FresnelSpecularMethod", "modulateSpecular", code);
	return code;
};

$inherit(away.materials.methods.FresnelSpecularMethod, away.materials.methods.CompositeSpecularMethod);

away.materials.methods.FresnelSpecularMethod.className = "away.materials.methods.FresnelSpecularMethod";

away.materials.methods.FresnelSpecularMethod.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.materials.methods.FresnelSpecularMethod.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.materials.methods.FresnelSpecularMethod.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'basedOnSurface', t:'Boolean'});
			p.push({n:'baseSpecularMethod', t:'away.materials.methods.BasicSpecularMethod'});
			break;
		case 1:
			p = away.materials.methods.CompositeSpecularMethod.injectionPoints(t);
			break;
		case 2:
			p = away.materials.methods.CompositeSpecularMethod.injectionPoints(t);
			break;
		case 3:
			p = away.materials.methods.CompositeSpecularMethod.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

