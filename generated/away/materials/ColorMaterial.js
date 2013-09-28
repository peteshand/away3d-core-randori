/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 28 11:54:30 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};

away.materials.ColorMaterial = function(color, alpha) {
	this._diffuseAlpha = 1;
	color = color || 0xcccccc;
	alpha = alpha || 1;
	away.materials.SinglePassMaterialBase.call(this);
	this.set_color(color);
	this.set_alpha(alpha);
};

away.materials.ColorMaterial.prototype.get_alpha = function() {
	return this._pScreenPass.get_diffuseMethod().get_diffuseAlpha();
};

away.materials.ColorMaterial.prototype.set_alpha = function(value) {
	if (value > 1) {
		value = 1;
	} else if (value < 0) {
		value = 0;
	}
	this._pScreenPass.get_diffuseMethod().set_diffuseAlpha(value);
	this._diffuseAlpha = value;
	this._pScreenPass.set_preserveAlpha(this.get_requiresBlending());
	this._pScreenPass.setBlendMode(this.getBlendMode() == away.display.BlendMode.NORMAL && this.get_requiresBlending() ? away.display.BlendMode.LAYER : this.getBlendMode());
};

away.materials.ColorMaterial.prototype.get_color = function() {
	return this._pScreenPass.get_diffuseMethod().get_diffuseColor();
};

away.materials.ColorMaterial.prototype.set_color = function(value) {
	this._pScreenPass.get_diffuseMethod().set_diffuseColor(value);
};

away.materials.ColorMaterial.prototype.get_requiresBlending = function() {
	return this.getRequiresBlending() || this._diffuseAlpha < 1;
};

$inherit(away.materials.ColorMaterial, away.materials.SinglePassMaterialBase);

away.materials.ColorMaterial.className = "away.materials.ColorMaterial";

away.materials.ColorMaterial.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.display.BlendMode');
	return p;
};

away.materials.ColorMaterial.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.materials.ColorMaterial.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'color', t:'Number'});
			p.push({n:'alpha', t:'Number'});
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

