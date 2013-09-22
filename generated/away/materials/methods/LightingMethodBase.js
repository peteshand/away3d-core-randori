/** Compiled by the Randori compiler v0.2.6.2 on Sun Sep 22 12:28:45 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};
if (typeof away.materials.methods == "undefined")
	away.materials.methods = {};

away.materials.methods.LightingMethodBase = function() {
	this._iModulateMethodScope = null;
	this._iModulateMethod = undefined;
	away.materials.methods.ShadingMethodBase.call(this);
};

away.materials.methods.LightingMethodBase.prototype.iGetFragmentPreLightingCode = function(vo, regCache) {
	return "";
};

away.materials.methods.LightingMethodBase.prototype.iGetFragmentCodePerLight = function(vo, lightDirReg, lightColReg, regCache) {
	return "";
};

away.materials.methods.LightingMethodBase.prototype.iGetFragmentCodePerProbe = function(vo, cubeMapReg, weightRegister, regCache) {
	return "";
};

away.materials.methods.LightingMethodBase.prototype.iGetFragmentPostLightingCode = function(vo, regCache, targetReg) {
	return "";
};

$inherit(away.materials.methods.LightingMethodBase, away.materials.methods.ShadingMethodBase);

away.materials.methods.LightingMethodBase.className = "away.materials.methods.LightingMethodBase";

away.materials.methods.LightingMethodBase.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.materials.methods.LightingMethodBase.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.materials.methods.LightingMethodBase.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 1:
			p = away.materials.methods.ShadingMethodBase.injectionPoints(t);
			break;
		case 2:
			p = away.materials.methods.ShadingMethodBase.injectionPoints(t);
			break;
		case 3:
			p = away.materials.methods.ShadingMethodBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

