/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 24 23:06:55 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.partition == "undefined")
	away.partition = {};

away.partition.EntityNode = function(entity) {
	this._iUpdateQueueNext = null;
	this._entity = null;
	away.partition.NodeBase.call(this);
	this._entity = entity;
	this._iNumEntities = 1;
};

away.partition.EntityNode.prototype.get_entity = function() {
	return this._entity;
};

away.partition.EntityNode.prototype.removeFromParent = function() {
	if (this._iParent) {
		this._iParent.iRemoveNode(this);
	}
	this._iParent = null;
};

away.partition.EntityNode.prototype.isInFrustum = function(planes, numPlanes) {
	if (!this._entity.get__iIsVisible()) {
		return false;
	}
	return this._entity.get_worldBounds().isInFrustum(planes, numPlanes);
};

away.partition.EntityNode.prototype.acceptTraverser = function(traverser) {
	traverser.applyEntity(this._entity);
};

away.partition.EntityNode.prototype.isIntersectingRay = function(rayPosition, rayDirection) {
	if (!this._entity.get__iIsVisible())
		return false;
	return this._entity.isIntersectingRay(rayPosition, rayDirection);
};

$inherit(away.partition.EntityNode, away.partition.NodeBase);

away.partition.EntityNode.className = "away.partition.EntityNode";

away.partition.EntityNode.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.partition.EntityNode.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.partition.EntityNode.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'entity', t:'away.entities.Entity'});
			break;
		case 1:
			p = away.partition.NodeBase.injectionPoints(t);
			break;
		case 2:
			p = away.partition.NodeBase.injectionPoints(t);
			break;
		case 3:
			p = away.partition.NodeBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

