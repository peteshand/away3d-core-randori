/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 24 23:06:55 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.partition == "undefined")
	away.partition = {};

away.partition.PointLightNode = function(light) {
	this._light = null;
	away.partition.EntityNode.call(this, light);
	this._light = light;
};

away.partition.PointLightNode.prototype.get_light = function() {
	return this._light;
};

away.partition.PointLightNode.prototype.acceptTraverser = function(traverser) {
	if (traverser.enterNode(this)) {
		away.partition.EntityNode.prototype.acceptTraverser.call(this,traverser);
		traverser.applyPointLight(this._light);
	}
};

$inherit(away.partition.PointLightNode, away.partition.EntityNode);

away.partition.PointLightNode.className = "away.partition.PointLightNode";

away.partition.PointLightNode.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.partition.PointLightNode.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.partition.PointLightNode.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'light', t:'away.lights.PointLight'});
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

