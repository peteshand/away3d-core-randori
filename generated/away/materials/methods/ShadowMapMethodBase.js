/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:42 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};
if (typeof away.materials.methods == "undefined")
	away.materials.methods = {};

away.materials.methods.ShadowMapMethodBase = function(castingLight) {
	this._shadowMapper = null;
	this._castingLight = null;
	this._alpha = 1;
	this._epsilon = 02;
	away.materials.methods.ShadingMethodBase.call(this);
	this._castingLight = castingLight;
	castingLight.set_castsShadows(true);
	this._shadowMapper = castingLight.get_shadowMapper();
};

away.materials.methods.ShadowMapMethodBase.prototype.get_assetType = function() {
	return away.library.assets.AssetType.SHADOW_MAP_METHOD;
};

away.materials.methods.ShadowMapMethodBase.prototype.get_alpha = function() {
	return this._alpha;
};

away.materials.methods.ShadowMapMethodBase.prototype.set_alpha = function(value) {
	this._alpha = value;
};

away.materials.methods.ShadowMapMethodBase.prototype.get_castingLight = function() {
	return this._castingLight;
};

away.materials.methods.ShadowMapMethodBase.prototype.get_epsilon = function() {
	return this._epsilon;
};

away.materials.methods.ShadowMapMethodBase.prototype.set_epsilon = function(value) {
	this._epsilon = value;
};

away.materials.methods.ShadowMapMethodBase.prototype.iGetFragmentCode = function(vo, regCache, targetReg) {
	throw new away.errors.AbstractMethodError(null, 0);
	return null;
};

$inherit(away.materials.methods.ShadowMapMethodBase, away.materials.methods.ShadingMethodBase);

away.materials.methods.ShadowMapMethodBase.className = "away.materials.methods.ShadowMapMethodBase";

away.materials.methods.ShadowMapMethodBase.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.errors.AbstractMethodError');
	p.push('away.library.assets.AssetType');
	return p;
};

away.materials.methods.ShadowMapMethodBase.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.materials.methods.ShadowMapMethodBase.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'castingLight', t:'away.lights.LightBase'});
			break;
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

