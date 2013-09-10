/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 10 22:28:15 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};
if (typeof away.materials.lightpickers == "undefined")
	away.materials.lightpickers = {};

away.materials.lightpickers.LightPickerBase = function() {
	this._pNumLightProbes = 0;
	this._pLightProbeWeights = null;
	this._pLightProbes = null;
	this._pCastingPointLights = null;
	this._pNumPointLights = 0;
	this._pAllPickedLights = null;
	this._pNumCastingPointLights = 0;
	this._pCastingDirectionalLights = null;
	this._pNumDirectionalLights = 0;
	this._pDirectionalLights = null;
	this._pPointLights = null;
	this._pNumCastingDirectionalLights = 0;
	away.library.assets.NamedAssetBase.call(this);
};

away.materials.lightpickers.LightPickerBase.prototype.dispose = function() {
};

away.materials.lightpickers.LightPickerBase.prototype.get_assetType = function() {
	return away.library.assets.AssetType.LIGHT_PICKER;
};

away.materials.lightpickers.LightPickerBase.prototype.get_numDirectionalLights = function() {
	return this._pNumDirectionalLights;
};

away.materials.lightpickers.LightPickerBase.prototype.get_numPointLights = function() {
	return this._pNumPointLights;
};

away.materials.lightpickers.LightPickerBase.prototype.get_numCastingDirectionalLights = function() {
	return this._pNumCastingDirectionalLights;
};

away.materials.lightpickers.LightPickerBase.prototype.get_numCastingPointLights = function() {
	return this._pNumCastingPointLights;
};

away.materials.lightpickers.LightPickerBase.prototype.get_numLightProbes = function() {
	return this._pNumLightProbes;
};

away.materials.lightpickers.LightPickerBase.prototype.get_pointLights = function() {
	return this._pPointLights;
};

away.materials.lightpickers.LightPickerBase.prototype.get_directionalLights = function() {
	return this._pDirectionalLights;
};

away.materials.lightpickers.LightPickerBase.prototype.get_castingPointLights = function() {
	return this._pCastingPointLights;
};

away.materials.lightpickers.LightPickerBase.prototype.get_castingDirectionalLights = function() {
	return this._pCastingDirectionalLights;
};

away.materials.lightpickers.LightPickerBase.prototype.get_lightProbes = function() {
	return this._pLightProbes;
};

away.materials.lightpickers.LightPickerBase.prototype.get_lightProbeWeights = function() {
	return this._pLightProbeWeights;
};

away.materials.lightpickers.LightPickerBase.prototype.get_allPickedLights = function() {
	return this._pAllPickedLights;
};

away.materials.lightpickers.LightPickerBase.prototype.collectLights = function(renderable, entityCollector) {
	this.updateProbeWeights(renderable);
};

away.materials.lightpickers.LightPickerBase.prototype.updateProbeWeights = function(renderable) {
	var objectPos = renderable.get_sourceEntity().get_scenePosition();
	var lightPos;
	var rx = objectPos.x, ry = objectPos.y, rz = objectPos.z;
	var dx, dy, dz;
	var w, total = 0;
	var i;
	for (i = 0; i < this._pNumLightProbes; ++i) {
		lightPos = this._pLightProbes[i].scenePosition;
		dx = rx - lightPos.x;
		dy = ry - lightPos.y;
		dz = rz - lightPos.z;
		w = dx * dx + dy * dy + dz * dz;
		w = w > .00001 ? 1 / w : 50000000;
		this._pLightProbeWeights[i] = w;
		total += w;
	}
	total = 1 / total;
	for (i = 0; i < this._pNumLightProbes; ++i) {
		this._pLightProbeWeights[i] *= total;
	}
};

$inherit(away.materials.lightpickers.LightPickerBase, away.library.assets.NamedAssetBase);

away.materials.lightpickers.LightPickerBase.className = "away.materials.lightpickers.LightPickerBase";

away.materials.lightpickers.LightPickerBase.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.library.assets.AssetType');
	return p;
};

away.materials.lightpickers.LightPickerBase.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.materials.lightpickers.LightPickerBase.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 1:
			p = away.library.assets.NamedAssetBase.injectionPoints(t);
			break;
		case 2:
			p = away.library.assets.NamedAssetBase.injectionPoints(t);
			break;
		case 3:
			p = away.library.assets.NamedAssetBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

