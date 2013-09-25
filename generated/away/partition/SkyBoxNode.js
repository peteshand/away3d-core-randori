/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 25 08:00:55 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.partition == "undefined")
	away.partition = {};

away.partition.SkyBoxNode = function(skyBox) {
	this._skyBox = null;
	away.partition.EntityNode.call(this, skyBox);
	this._skyBox = skyBox;
};

away.partition.SkyBoxNode.prototype.acceptTraverser = function(traverser) {
	if (traverser.enterNode(this)) {
		away.partition.EntityNode.prototype.acceptTraverser.call(this,traverser);
		traverser.applySkyBox(this._skyBox);
	}
};

away.partition.SkyBoxNode.prototype.isInFrustum = function(planes, numPlanes) {
	planes = planes;
	numPlanes = numPlanes;
	return true;
};

$inherit(away.partition.SkyBoxNode, away.partition.EntityNode);

away.partition.SkyBoxNode.className = "away.partition.SkyBoxNode";

away.partition.SkyBoxNode.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.partition.SkyBoxNode.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.partition.SkyBoxNode.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'skyBox', t:'away.primitives.SkyBox'});
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

