/** Compiled by the Randori compiler v0.2.6.2 on Thu Sep 05 22:19:26 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};

away.materials.TextureMaterial = function(texture, smooth, repeat, mipmap) {
	away.materials.SinglePassMaterialBase.call(this);
	texture = texture;
	smooth = smooth;
	repeat = repeat;
	mipmap = mipmap;
};

away.materials.TextureMaterial.prototype.get_animateUVs = function() {
	return this._pScreenPass.get_animateUVs();
};

away.materials.TextureMaterial.prototype.set_animateUVs = function(value) {
	this._pScreenPass.set_animateUVs(value);
};

away.materials.TextureMaterial.prototype.get_alpha = function() {
	return this._pScreenPass.get_colorTransform() ? this._pScreenPass.get_colorTransform().alphaMultiplier : 1;
};

away.materials.TextureMaterial.prototype.set_alpha = function(value) {
	if (value > 1)
		value = 1;
	else if (value < 0)
		value = 0;
	if (this.get_colorTransform() == null) {
		this.set_colorTransform(new away.geom.ColorTransform(1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0));
	}
	this.get_colorTransform().alphaMultiplier = value;
	this._pScreenPass.set_preserveAlpha(this.getRequiresBlending());
	this._pScreenPass.setBlendMode(this.getBlendMode() == away.display.BlendMode.NORMAL && this.getRequiresBlending() ? away.display.BlendMode.LAYER : this.getBlendMode());
};

away.materials.TextureMaterial.prototype.get_texture = function() {
	return this._pScreenPass.get_diffuseMethod().get_texture();
};

away.materials.TextureMaterial.prototype.set_texture = function(value) {
	this._pScreenPass.get_diffuseMethod().set_texture(value);
};

away.materials.TextureMaterial.prototype.get_ambientTexture = function() {
	return this._pScreenPass.get_ambientMethod().get_texture();
};

away.materials.TextureMaterial.prototype.set_ambientTexture = function(value) {
	this._pScreenPass.get_ambientMethod().set_texture(value);
	this._pScreenPass.get_diffuseMethod().set_iUseAmbientTexture(!(value == null));
};

$inherit(away.materials.TextureMaterial, away.materials.SinglePassMaterialBase);

away.materials.TextureMaterial.className = "away.materials.TextureMaterial";

away.materials.TextureMaterial.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.ColorTransform');
	p.push('away.display.BlendMode');
	return p;
};

away.materials.TextureMaterial.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.materials.TextureMaterial.injectionPoints = function(t) {
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
			p = away.materials.SinglePassMaterialBase.injectionPoints(t);
			break;
		case 2:
			p = away.materials.SinglePassMaterialBase.injectionPoints(t);
			break;
		case 3:
			p = away.materials.SinglePassMaterialBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

