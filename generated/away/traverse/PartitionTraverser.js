/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 21 16:02:32 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.traverse == "undefined")
	away.traverse = {};

away.traverse.PartitionTraverser = function() {
this._iEntryPoint = null;
this.scene = null;
};

away.traverse.PartitionTraverser._iCollectionMark = 0;

away.traverse.PartitionTraverser.prototype.enterNode = function(node) {
	node = node;
	return true;
};

away.traverse.PartitionTraverser.prototype.applySkyBox = function(renderable) {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.traverse.PartitionTraverser.prototype.applyRenderable = function(renderable) {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.traverse.PartitionTraverser.prototype.applyUnknownLight = function(light) {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.traverse.PartitionTraverser.prototype.applyDirectionalLight = function(light) {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.traverse.PartitionTraverser.prototype.applyPointLight = function(light) {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.traverse.PartitionTraverser.prototype.applyLightProbe = function(light) {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.traverse.PartitionTraverser.prototype.applyEntity = function(entity) {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.traverse.PartitionTraverser.prototype.get_entryPoint = function() {
	return this._iEntryPoint;
};

away.traverse.PartitionTraverser.className = "away.traverse.PartitionTraverser";

away.traverse.PartitionTraverser.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.errors.AbstractMethodError');
	return p;
};

away.traverse.PartitionTraverser.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.traverse.PartitionTraverser.injectionPoints = function(t) {
	return [];
};
