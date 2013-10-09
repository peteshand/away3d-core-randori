/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:42 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.containers == "undefined")
	away.containers = {};

away.containers.Scene3D = function() {
	this._partitions = null;
	this._iSceneGraphRoot = null;
	away.events.EventDispatcher.call(this);
	this._partitions = [];
	this._iSceneGraphRoot = new away.containers.ObjectContainer3D();
	this._iSceneGraphRoot.set_scene(this);
	this._iSceneGraphRoot._iIsRoot = true;
	this._iSceneGraphRoot.set_partition(new away.core.partition.Partition3D(new away.core.partition.NodeBase()));
};

away.containers.Scene3D.prototype.traversePartitions = function(traverser) {
	var i = 0;
	var len = this._partitions.length;
	traverser.scene = this;
	while (i < len) {
		this._partitions[i++].traverse(traverser);
	}
};

away.containers.Scene3D.prototype.get_partition = function() {
	return this._iSceneGraphRoot.get_partition();
};

away.containers.Scene3D.prototype.set_partition = function(value) {
	this._iSceneGraphRoot.set_partition(value);
	this.dispatchEvent(new away.events.Scene3DEvent(away.events.Scene3DEvent.PARTITION_CHANGED, this._iSceneGraphRoot));
};

away.containers.Scene3D.prototype.contains = function(child) {
	return this._iSceneGraphRoot.contains(child);
};

away.containers.Scene3D.prototype.addChild = function(child) {
	return this._iSceneGraphRoot.addChild(child);
};

away.containers.Scene3D.prototype.removeChild = function(child) {
	this._iSceneGraphRoot.removeChild(child);
};

away.containers.Scene3D.prototype.removeChildAt = function(index) {
	this._iSceneGraphRoot.removeChildAt(index);
};

away.containers.Scene3D.prototype.getChildAt = function(index) {
	return this._iSceneGraphRoot.getChildAt(index);
};

away.containers.Scene3D.prototype.get_numChildren = function() {
	return this._iSceneGraphRoot.get_numChildren();
};

away.containers.Scene3D.prototype.iRegisterEntity = function(entity) {
	var partition = entity.iGetImplicitPartition();
	this.iAddPartitionUnique(partition);
	this.get_partition().iMarkForUpdate(entity);
};

away.containers.Scene3D.prototype.iUnregisterEntity = function(entity) {
	entity.iGetImplicitPartition().iRemoveEntity(entity);
};

away.containers.Scene3D.prototype.iInvalidateEntityBounds = function(entity) {
	entity.iGetImplicitPartition().iMarkForUpdate(entity);
};

away.containers.Scene3D.prototype.iRegisterPartition = function(entity) {
	this.iAddPartitionUnique(entity.iGetImplicitPartition());
};

away.containers.Scene3D.prototype.iUnregisterPartition = function(entity) {
	entity.iGetImplicitPartition().iRemoveEntity(entity);
};

away.containers.Scene3D.prototype.iAddPartitionUnique = function(partition) {
	if (this._partitions.indexOf(partition, 0) == -1) {
		this._partitions.push(partition);
	}
};

$inherit(away.containers.Scene3D, away.events.EventDispatcher);

away.containers.Scene3D.className = "away.containers.Scene3D";

away.containers.Scene3D.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.core.partition.NodeBase');
	p.push('away.core.partition.Partition3D');
	p.push('away.events.Scene3DEvent');
	p.push('away.containers.ObjectContainer3D');
	return p;
};

away.containers.Scene3D.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.containers.Scene3D.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 1:
			p = away.events.EventDispatcher.injectionPoints(t);
			break;
		case 2:
			p = away.events.EventDispatcher.injectionPoints(t);
			break;
		case 3:
			p = away.events.EventDispatcher.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

