/** Compiled by the Randori compiler v0.2.6.2 on Mon Sep 02 23:32:29 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.partition == "undefined")
	away.partition = {};

away.partition.MeshNode = function(mesh) {
	this._mesh = null;
	away.partition.EntityNode.call(this, mesh);
	this._mesh = mesh;
};

away.partition.MeshNode.prototype.get_mesh = function() {
	return this._mesh;
};

away.partition.MeshNode.prototype.acceptTraverser = function(traverser) {
	if (traverser.enterNode(this)) {
		away.partition.EntityNode.prototype.acceptTraverser.call(this,traverser);
		var subs = this._mesh.get_subMeshes();
		var i = 0;
		var len = subs.length;
		while (i < len) {
			traverser.applyRenderable(subs[i++]);
		}
	}
};

$inherit(away.partition.MeshNode, away.partition.EntityNode);

away.partition.MeshNode.className = "away.partition.MeshNode";

away.partition.MeshNode.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.partition.MeshNode.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.partition.MeshNode.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'mesh', t:'away.entities.Mesh'});
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

