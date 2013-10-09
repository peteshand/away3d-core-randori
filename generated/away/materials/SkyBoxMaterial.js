/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:38 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};

away.materials.SkyBoxMaterial = function(cubeMap) {
	this._cubeMap = null;
	this._skyboxPass = null;
	away.materials.MaterialBase.call(this);
	this._cubeMap = cubeMap;
	this.pAddPass(this._skyboxPass = new away.materials.passes.SkyBoxPass());
	this._skyboxPass.set_cubeTexture(this._cubeMap);
};

away.materials.SkyBoxMaterial.prototype.get_cubeMap = function() {
	return this._cubeMap;
};

away.materials.SkyBoxMaterial.prototype.set_cubeMap = function(value) {
	if (value && this._cubeMap && (value.get_hasMipMaps() != this._cubeMap.get_hasMipMaps() || value.get_format() != this._cubeMap.get_format()))
		this.iInvalidatePasses(null);
	this._cubeMap = value;
	this._skyboxPass.set_cubeTexture(this._cubeMap);
};

$inherit(away.materials.SkyBoxMaterial, away.materials.MaterialBase);

away.materials.SkyBoxMaterial.className = "away.materials.SkyBoxMaterial";

away.materials.SkyBoxMaterial.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.materials.passes.SkyBoxPass');
	return p;
};

away.materials.SkyBoxMaterial.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.materials.SkyBoxMaterial.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'cubeMap', t:'away.textures.CubeTextureBase'});
			break;
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

