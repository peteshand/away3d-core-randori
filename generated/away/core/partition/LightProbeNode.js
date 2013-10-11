/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:06 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.partition == "undefined")
	away.core.partition = {};

away.core.partition.LightProbeNode = function(light) {
	this._light = null;
	away.core.partition.EntityNode.call(this, light);
	this._light = light;
};

away.core.partition.LightProbeNode.prototype.get_light = function() {
	return this._light;
};

away.core.partition.LightProbeNode.prototype.acceptTraverser = function(traverser) {
	if (traverser.enterNode(this)) {
		away.core.partition.EntityNode.prototype.acceptTraverser.call(this,traverser);
		traverser.applyLightProbe(this._light);
	}
};

$inherit(away.core.partition.LightProbeNode, away.core.partition.EntityNode);

away.core.partition.LightProbeNode.className = "away.core.partition.LightProbeNode";

away.core.partition.LightProbeNode.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.core.partition.LightProbeNode.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.core.partition.LightProbeNode.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'light', t:'away.lights.LightProbe'});
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

