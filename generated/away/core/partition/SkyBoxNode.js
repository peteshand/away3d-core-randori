/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:05 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.partition == "undefined")
	away.core.partition = {};

away.core.partition.SkyBoxNode = function(skyBox) {
	this._skyBox = null;
	away.core.partition.EntityNode.call(this, skyBox);
	this._skyBox = skyBox;
};

away.core.partition.SkyBoxNode.prototype.acceptTraverser = function(traverser) {
	if (traverser.enterNode(this)) {
		away.core.partition.EntityNode.prototype.acceptTraverser.call(this,traverser);
		traverser.applySkyBox(this._skyBox);
	}
};

away.core.partition.SkyBoxNode.prototype.isInFrustum = function(planes, numPlanes) {
	planes = planes;
	numPlanes = numPlanes;
	return true;
};

$inherit(away.core.partition.SkyBoxNode, away.core.partition.EntityNode);

away.core.partition.SkyBoxNode.className = "away.core.partition.SkyBoxNode";

away.core.partition.SkyBoxNode.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.core.partition.SkyBoxNode.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.core.partition.SkyBoxNode.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'skyBox', t:'away.primitives.SkyBox'});
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

