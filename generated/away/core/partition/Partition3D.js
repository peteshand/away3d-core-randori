/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:42 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.partition == "undefined")
	away.core.partition = {};

away.core.partition.Partition3D = function(rootNode) {
	this._rootNode = null;
	this._updatesMade = false;
	this._updateQueue = null;
	this._rootNode = rootNode || new away.core.partition.NullNode();
};

away.core.partition.Partition3D.prototype.get_showDebugBounds = function() {
	return this._rootNode.get_showDebugBounds();
};

away.core.partition.Partition3D.prototype.set_showDebugBounds = function(value) {
	this._rootNode.set_showDebugBounds(value);
};

away.core.partition.Partition3D.prototype.traverse = function(traverser) {
	if (this._updatesMade) {
		this.updateEntities();
	}
	++away.core.traverse.PartitionTraverser._iCollectionMark;
	this._rootNode.acceptTraverser(traverser);
};

away.core.partition.Partition3D.prototype.iMarkForUpdate = function(entity) {
	var node = entity.getEntityPartitionNode();
	var t = this._updateQueue;
	while (t) {
		if (node == t) {
			return;
		}
		t = t._iUpdateQueueNext;
	}
	node._iUpdateQueueNext = this._updateQueue;
	this._updateQueue = node;
	this._updatesMade = true;
};

away.core.partition.Partition3D.prototype.iRemoveEntity = function(entity) {
	var node = entity.getEntityPartitionNode();
	var t;
	node.removeFromParent();
	if (node == this._updateQueue) {
		this._updateQueue = node._iUpdateQueueNext;
	} else {
		t = this._updateQueue;
		while (t && t._iUpdateQueueNext != node) {
			t = t._iUpdateQueueNext;
		}
		if (t) {
			t._iUpdateQueueNext = node._iUpdateQueueNext;
		}
	}
	node._iUpdateQueueNext = null;
	if (!this._updateQueue) {
		this._updatesMade = false;
	}
};

away.core.partition.Partition3D.prototype.updateEntities = function() {
	var node = this._updateQueue;
	var targetNode;
	var t;
	this._updateQueue = null;
	this._updatesMade = false;
	do {
		targetNode = this._rootNode.findPartitionForEntity(node.get_entity());
		if (node.get_parent() != targetNode) {
			if (node) {
				node.removeFromParent();
			}
			targetNode.iAddNode(node);
		}
		t = node._iUpdateQueueNext;
		node._iUpdateQueueNext = null;
		node.get_entity().iInternalUpdate();
	} while ((node = t) != null);
};

away.core.partition.Partition3D.className = "away.core.partition.Partition3D";

away.core.partition.Partition3D.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.core.partition.EntityNode');
	p.push('away.core.partition.NullNode');
	p.push('away.core.traverse.PartitionTraverser');
	return p;
};

away.core.partition.Partition3D.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.core.partition.Partition3D.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'rootNode', t:'away.core.partition.NodeBase'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

