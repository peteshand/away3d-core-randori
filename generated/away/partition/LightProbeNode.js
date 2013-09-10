/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 10 22:28:10 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.partition == "undefined")
	away.partition = {};

away.partition.LightProbeNode = function(light) {
	this._light = null;
	away.partition.EntityNode.call(this, light);
	this._light = light;
};

away.partition.LightProbeNode.prototype.get_light = function() {
	return this._light;
};

away.partition.LightProbeNode.prototype.acceptTraverser = function(traverser) {
	if (traverser.enterNode(this)) {
		away.partition.EntityNode.prototype.acceptTraverser.call(this,traverser);
		traverser.applyLightProbe(this._light);
	}
};

$inherit(away.partition.LightProbeNode, away.partition.EntityNode);

away.partition.LightProbeNode.className = "away.partition.LightProbeNode";

away.partition.LightProbeNode.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.partition.LightProbeNode.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.partition.LightProbeNode.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'light', t:'away.lights.LightProbe'});
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

