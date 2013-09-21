/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 21 16:02:31 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.partition == "undefined")
	away.partition = {};

away.partition.Partition3D = function(rootNode) {
	this._rootNode = null;
	this._updatesMade = false;
	this._updateQueue = null;
	this._rootNode = rootNode || new away.partition.NullNode();
};

away.partition.Partition3D.prototype.get_showDebugBounds = function() {
	return this._rootNode.get_showDebugBounds();
};

away.partition.Partition3D.prototype.set_showDebugBounds = function(value) {
	this._rootNode.set_showDebugBounds(value);
};

away.partition.Partition3D.prototype.traverse = function(traverser) {
	if (this._updatesMade) {
		this.updateEntities();
	}
	++away.traverse.PartitionTraverser._iCollectionMark;
	this._rootNode.acceptTraverser(traverser);
};

away.partition.Partition3D.prototype.iMarkForUpdate = function(entity) {
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

away.partition.Partition3D.prototype.iRemoveEntity = function(entity) {
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

away.partition.Partition3D.prototype.updateEntities = function() {
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

away.partition.Partition3D.className = "away.partition.Partition3D";

away.partition.Partition3D.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.partition.NullNode');
	p.push('away.partition.EntityNode');
	p.push('away.traverse.PartitionTraverser');
	return p;
};

away.partition.Partition3D.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.partition.Partition3D.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'rootNode', t:'away.partition.NodeBase'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

