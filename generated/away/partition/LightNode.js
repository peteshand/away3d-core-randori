/** Compiled by the Randori compiler v0.2.6.2 on Thu Sep 05 22:19:15 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.partition == "undefined")
	away.partition = {};

away.partition.LightNode = function(light) {
	this._light = null;
	away.partition.EntityNode.call(this, light);
	this._light = light;
};

away.partition.LightNode.prototype.get_light = function() {
	return this._light;
};

away.partition.LightNode.prototype.acceptTraverser = function(traverser) {
	if (traverser.enterNode(this)) {
		away.partition.EntityNode.prototype.acceptTraverser.call(this,traverser);
		traverser.applyUnknownLight(this._light);
	}
};

$inherit(away.partition.LightNode, away.partition.EntityNode);

away.partition.LightNode.className = "away.partition.LightNode";

away.partition.LightNode.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.partition.LightNode.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.partition.LightNode.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'light', t:'away.lights.LightBase'});
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

