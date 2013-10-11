/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:03 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};
if (typeof away.materials.methods == "undefined")
	away.materials.methods = {};

away.materials.methods.EffectMethodBase = function() {
	away.materials.methods.ShadingMethodBase.call(this);
};

away.materials.methods.EffectMethodBase.prototype.get_assetType = function() {
	return away.library.assets.AssetType.EFFECTS_METHOD;
};

away.materials.methods.EffectMethodBase.prototype.iGetFragmentCode = function(vo, regCache, targetReg) {
	throw new away.errors.AbstractMethodError(null, 0);
	return "";
};

$inherit(away.materials.methods.EffectMethodBase, away.materials.methods.ShadingMethodBase);

away.materials.methods.EffectMethodBase.className = "away.materials.methods.EffectMethodBase";

away.materials.methods.EffectMethodBase.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.errors.AbstractMethodError');
	p.push('away.library.assets.AssetType');
	return p;
};

away.materials.methods.EffectMethodBase.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.materials.methods.EffectMethodBase.injectionPoints = function(t) {
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

