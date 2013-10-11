/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:01 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.traverse == "undefined")
	away.core.traverse = {};

away.core.traverse.PartitionTraverser = function() {
this._iEntryPoint = null;
this.scene = null;
};

away.core.traverse.PartitionTraverser._iCollectionMark = 0;

away.core.traverse.PartitionTraverser.prototype.enterNode = function(node) {
	node = node;
	return true;
};

away.core.traverse.PartitionTraverser.prototype.applySkyBox = function(renderable) {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.core.traverse.PartitionTraverser.prototype.applyRenderable = function(renderable) {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.core.traverse.PartitionTraverser.prototype.applyUnknownLight = function(light) {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.core.traverse.PartitionTraverser.prototype.applyDirectionalLight = function(light) {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.core.traverse.PartitionTraverser.prototype.applyPointLight = function(light) {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.core.traverse.PartitionTraverser.prototype.applyLightProbe = function(light) {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.core.traverse.PartitionTraverser.prototype.applyEntity = function(entity) {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.core.traverse.PartitionTraverser.prototype.get_entryPoint = function() {
	return this._iEntryPoint;
};

away.core.traverse.PartitionTraverser.className = "away.core.traverse.PartitionTraverser";

away.core.traverse.PartitionTraverser.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.errors.AbstractMethodError');
	return p;
};

away.core.traverse.PartitionTraverser.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.core.traverse.PartitionTraverser.injectionPoints = function(t) {
	return [];
};
