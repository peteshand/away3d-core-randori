/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:42 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.partition == "undefined")
	away.core.partition = {};

away.core.partition.DirectionalLightNode = function(light) {
	this._light = null;
	away.core.partition.EntityNode.call(this, light);
	this._light = light;
};

away.core.partition.DirectionalLightNode.prototype.get_light = function() {
	return this._light;
};

away.core.partition.DirectionalLightNode.prototype.acceptTraverser = function(traverser) {
	if (traverser.enterNode(this)) {
		away.core.partition.EntityNode.prototype.acceptTraverser.call(this,traverser);
		traverser.applyDirectionalLight(this._light);
	}
};

$inherit(away.core.partition.DirectionalLightNode, away.core.partition.EntityNode);

away.core.partition.DirectionalLightNode.className = "away.core.partition.DirectionalLightNode";

away.core.partition.DirectionalLightNode.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.core.partition.DirectionalLightNode.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.core.partition.DirectionalLightNode.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'light', t:'away.lights.DirectionalLight'});
			break;
		case 1:
			p = away.core.partition.EntityNode.injectionPoints(t);
			break;
		case 2:
			p = away.core.partition.EntityNode.injectionPoints(t);
			break;
		case 3:
			p = away.core.partition.EntityNode.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

