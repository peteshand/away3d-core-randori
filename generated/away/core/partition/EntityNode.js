/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:37 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.partition == "undefined")
	away.core.partition = {};

away.core.partition.EntityNode = function(entity) {
	this._iUpdateQueueNext = null;
	this._entity = null;
	away.core.partition.NodeBase.call(this);
	this._entity = entity;
	this._iNumEntities = 1;
};

away.core.partition.EntityNode.prototype.get_entity = function() {
	return this._entity;
};

away.core.partition.EntityNode.prototype.removeFromParent = function() {
	if (this._iParent) {
		this._iParent.iRemoveNode(this);
	}
	this._iParent = null;
};

away.core.partition.EntityNode.prototype.isInFrustum = function(planes, numPlanes) {
	if (!this._entity.get__iIsVisible()) {
		return false;
	}
	return this._entity.get_worldBounds().isInFrustum(planes, numPlanes);
};

away.core.partition.EntityNode.prototype.acceptTraverser = function(traverser) {
	traverser.applyEntity(this._entity);
};

away.core.partition.EntityNode.prototype.isIntersectingRay = function(rayPosition, rayDirection) {
	if (!this._entity.get__iIsVisible())
		return false;
	return this._entity.isIntersectingRay(rayPosition, rayDirection);
};

$inherit(away.core.partition.EntityNode, away.core.partition.NodeBase);

away.core.partition.EntityNode.className = "away.core.partition.EntityNode";

away.core.partition.EntityNode.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.core.partition.EntityNode.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.core.partition.EntityNode.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'entity', t:'away.entities.Entity'});
			break;
		case 1:
			p = away.core.partition.NodeBase.injectionPoints(t);
			break;
		case 2:
			p = away.core.partition.NodeBase.injectionPoints(t);
			break;
		case 3:
			p = away.core.partition.NodeBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

