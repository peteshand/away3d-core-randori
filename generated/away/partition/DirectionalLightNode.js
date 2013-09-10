/** Compiled by the Randori compiler v0.2.6.2 on Thu Sep 05 22:19:16 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.partition == "undefined")
	away.partition = {};

away.partition.DirectionalLightNode = function(light) {
	this._light = null;
	away.partition.EntityNode.call(this, light);
	this._light = light;
};

away.partition.DirectionalLightNode.prototype.get_light = function() {
	return this._light;
};

away.partition.DirectionalLightNode.prototype.acceptTraverser = function(traverser) {
	if (traverser.enterNode(this)) {
		away.partition.EntityNode.prototype.acceptTraverser.call(this,traverser);
		traverser.applyDirectionalLight(this._light);
	}
};

$inherit(away.partition.DirectionalLightNode, away.partition.EntityNode);

away.partition.DirectionalLightNode.className = "away.partition.DirectionalLightNode";

away.partition.DirectionalLightNode.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.partition.DirectionalLightNode.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.partition.DirectionalLightNode.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'light', t:'away.lights.DirectionalLight'});
			break;
		case 1:
			p = away.partition.EntityNode.injectionPoints(t);
			break;
		case 2:
			p = away.partition.EntityNode.injectionPoints(t);
			break;
		case 3:
			p = away.partition.EntityNode.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

