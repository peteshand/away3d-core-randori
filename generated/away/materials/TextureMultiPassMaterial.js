/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:04 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};

away.materials.TextureMultiPassMaterial = function(texture, smooth, repeat, mipmap) {
	this._animateUVs = false;
	texture = texture || null;
	away.materials.MultiPassMaterialBase.call(this);
	this.set_texture(texture);
	this.set_smooth(smooth);
	this.set_repeat(repeat);
	this.set_mipmap(mipmap);
};

away.materials.TextureMultiPassMaterial.prototype.get_animateUVs = function() {
	return this._animateUVs;
};

away.materials.TextureMultiPassMaterial.prototype.set_animateUVs = function(value) {
	this._animateUVs = value;
};

away.materials.TextureMultiPassMaterial.prototype.get_texture = function() {
	return this.get_diffuseMethod().get_texture();
};

away.materials.TextureMultiPassMaterial.prototype.set_texture = function(value) {
	this.get_diffuseMethod().set_texture(value);
};

away.materials.TextureMultiPassMaterial.prototype.get_ambientTexture = function() {
	return this.get_ambientMethod().get_texture();
};

away.materials.TextureMultiPassMaterial.prototype.set_ambientTexture = function(value) {
	this.get_ambientMethod().set_texture(value);
	this.get_diffuseMethod().set_iUseAmbientTexture((value != null));
};

away.materials.TextureMultiPassMaterial.prototype.pUpdateScreenPasses = function() {
	away.materials.MultiPassMaterialBase.prototype.pUpdateScreenPasses.call(this);
	if (this._pEffectsPass)
		this._pEffectsPass.set_animateUVs(this._animateUVs);
};

$inherit(away.materials.TextureMultiPassMaterial, away.materials.MultiPassMaterialBase);

away.materials.TextureMultiPassMaterial.className = "away.materials.TextureMultiPassMaterial";

away.materials.TextureMultiPassMaterial.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.materials.TextureMultiPassMaterial.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.materials.TextureMultiPassMaterial.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'texture', t:'away.textures.Texture2DBase'});
			p.push({n:'smooth', t:'Boolean'});
			p.push({n:'repeat', t:'Boolean'});
			p.push({n:'mipmap', t:'Boolean'});
			break;
		case 1:
			p = away.materials.MultiPassMaterialBase.injectionPoints(t);
			break;
		case 2:
			p = away.materials.MultiPassMaterialBase.injectionPoints(t);
			break;
		case 3:
			p = away.materials.MultiPassMaterialBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

