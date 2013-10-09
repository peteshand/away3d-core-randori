/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:41 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.lights == "undefined")
	away.lights = {};

away.lights.LightProbe = function(diffuseMap, specularMap) {
	this._specularMap = null;
	this._diffuseMap = null;
	specularMap = specularMap || null;
	away.lights.LightBase.call(this);
	this._diffuseMap = diffuseMap;
	this._specularMap = specularMap;
};

away.lights.LightProbe.prototype.pCreateEntityPartitionNode = function() {
	return new away.core.partition.LightProbeNode(this);
};

away.lights.LightProbe.prototype.get_diffuseMap = function() {
	return this._diffuseMap;
};

away.lights.LightProbe.prototype.set_diffuseMap = function(value) {
	this._diffuseMap = value;
};

away.lights.LightProbe.prototype.get_specularMap = function() {
	return this._specularMap;
};

away.lights.LightProbe.prototype.set_specularMap = function(value) {
	this._specularMap = value;
};

away.lights.LightProbe.prototype.pUpdateBounds = function() {
	this._pBoundsInvalid = false;
};

away.lights.LightProbe.prototype.pGetDefaultBoundingVolume = function() {
	return new away.bounds.NullBounds(true);
};

away.lights.LightProbe.prototype.iGetObjectProjectionMatrix = function(renderable, target) {
	target = target || null;
	renderable = renderable;
	target = target;
	throw new away.errors.away.errors.Error("Object projection matrices are not supported for LightProbe objects!", 0, "");
	return null;
};

$inherit(away.lights.LightProbe, away.lights.LightBase);

away.lights.LightProbe.className = "away.lights.LightProbe";

away.lights.LightProbe.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.bounds.NullBounds');
	p.push('away.core.partition.LightProbeNode');
	return p;
};

away.lights.LightProbe.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.lights.LightProbe.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'diffuseMap', t:'away.textures.CubeTextureBase'});
			p.push({n:'specularMap', t:'away.textures.CubeTextureBase'});
			break;
		case 1:
			p = away.lights.LightBase.injectionPoints(t);
			break;
		case 2:
			p = away.lights.LightBase.injectionPoints(t);
			break;
		case 3:
			p = away.lights.LightBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

