/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 04 21:18:30 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};

away.materials.ColorMultiPassMaterial = function(color) {
	away.materials.MultiPassMaterialBase.call(this);
	this.set_color(color);
};

away.materials.ColorMultiPassMaterial.prototype.get_color = function() {
	return this.get_diffuseMethod().get_diffuseColor();
};

away.materials.ColorMultiPassMaterial.prototype.set_color = function(value) {
	this.get_diffuseMethod().set_diffuseColor(value);
};

$inherit(away.materials.ColorMultiPassMaterial, away.materials.MultiPassMaterialBase);

away.materials.ColorMultiPassMaterial.className = "away.materials.ColorMultiPassMaterial";

away.materials.ColorMultiPassMaterial.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.materials.ColorMultiPassMaterial.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.materials.ColorMultiPassMaterial.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'color', t:'Number'});
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

