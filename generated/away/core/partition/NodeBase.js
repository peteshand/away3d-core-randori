/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:37 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.partition == "undefined")
	away.core.partition = {};

away.core.partition.NodeBase = function() {
	this._iParent = null;
	this._pNumChildNodes = 0;
	this._pChildNodes = null;
	this._iCollectionMark = 0;
	this._pDebugPrimitive = null;
	this._iNumEntities = 0;
	this._pChildNodes = [];
};

away.core.partition.NodeBase.prototype.get_showDebugBounds = function() {
	return this._pDebugPrimitive != null;
};

away.core.partition.NodeBase.prototype.set_showDebugBounds = function(value) {
	if (this._pDebugPrimitive && value == true) {
		return;
	}
	if (!this._pDebugPrimitive && value == false) {
		return;
	}
	if (value) {
		throw new away.errors.PartialImplementationError("", 0);
		this._pDebugPrimitive = this.pCreateDebugBounds();
	} else {
		this._pDebugPrimitive.dispose();
		this._pDebugPrimitive = null;
	}
	for (var i = 0; i < this._pNumChildNodes; ++i) {
		this._pChildNodes[i].showDebugBounds = value;
	}
};

away.core.partition.NodeBase.prototype.get_parent = function() {
	return this._iParent;
};

away.core.partition.NodeBase.prototype.iAddNode = function(node) {
	node._iParent = this;
	this._iNumEntities += node.get__pNumEntities();
	this._pChildNodes[this._pNumChildNodes++] = node;
	node.set_showDebugBounds(this._pDebugPrimitive != null);
	var numEntities = node.get__pNumEntities();
	node = this;
	do {
		node._iNumEntities += numEntities;
	} while ((node = node._iParent) != null);
};

away.core.partition.NodeBase.prototype.iRemoveNode = function(node) {
	var index = this._pChildNodes.indexOf(node, 0);
	this._pChildNodes[index] = this._pChildNodes[--this._pNumChildNodes];
	this._pChildNodes.pop();
	var numEntities = node.get__pNumEntities();
	node = this;
	do {
		node.set__pNumEntities(node.get__pNumEntities() - numEntities);
	} while ((node = node._iParent) != null);
};

away.core.partition.NodeBase.prototype.isInFrustum = function(planes, numPlanes) {
	planes = planes;
	numPlanes = numPlanes;
	return true;
};

away.core.partition.NodeBase.prototype.isIntersectingRay = function(rayPosition, rayDirection) {
	rayPosition = rayPosition;
	rayDirection = rayDirection;
	return true;
};

away.core.partition.NodeBase.prototype.findPartitionForEntity = function(entity) {
	entity = entity;
	return this;
};

away.core.partition.NodeBase.prototype.acceptTraverser = function(traverser) {
	if (this.get__pNumEntities() == 0 && !this._pDebugPrimitive) {
		return;
	}
	if (traverser.enterNode(this)) {
		var i = 0;
		while (i < this._pNumChildNodes) {
			this._pChildNodes[i++].acceptTraverser(traverser);
		}
		if (this._pDebugPrimitive) {
			traverser.applyRenderable(this._pDebugPrimitive);
		}
	}
};

away.core.partition.NodeBase.prototype.pCreateDebugBounds = function() {
	return null;
};

away.core.partition.NodeBase.prototype.get__pNumEntities = function() {
	return this._iNumEntities;
};

away.core.partition.NodeBase.prototype.set__pNumEntities = function(value) {
	this._iNumEntities = value;
};

away.core.partition.NodeBase.prototype._pUpdateNumEntities = function(value) {
	var diff = value - this.get__pNumEntities();
	var node = this;
	do {
		node.set__pNumEntities(node.get__pNumEntities() + diff);
	} while ((node = node._iParent) != null);
};

away.core.partition.NodeBase.className = "away.core.partition.NodeBase";

away.core.partition.NodeBase.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.errors.PartialImplementationError');
	return p;
};

away.core.partition.NodeBase.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.core.partition.NodeBase.injectionPoints = function(t) {
	return [];
};
