/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:38 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.partition == "undefined")
	away.core.partition = {};

away.core.partition.MeshNode = function(mesh) {
	this._mesh = null;
	away.core.partition.EntityNode.call(this, mesh);
	this._mesh = mesh;
};

away.core.partition.MeshNode.prototype.get_mesh = function() {
	return this._mesh;
};

away.core.partition.MeshNode.prototype.acceptTraverser = function(traverser) {
	if (traverser.enterNode(this)) {
		away.core.partition.EntityNode.prototype.acceptTraverser.call(this,traverser);
		var subs = this._mesh.get_subMeshes();
		var i = 0;
		var len = subs.length;
		while (i < len) {
			traverser.applyRenderable(subs[i++]);
		}
	}
};

$inherit(away.core.partition.MeshNode, away.core.partition.EntityNode);

away.core.partition.MeshNode.className = "away.core.partition.MeshNode";

away.core.partition.MeshNode.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.core.partition.MeshNode.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.core.partition.MeshNode.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'mesh', t:'away.entities.Mesh'});
			break;
		case 1:
			p = away.core.partition.EntityNode.injectionPoints(t);
			break;
		case 2:
			p = away.core.partition.EntityNode.injectionPoints(t);
			break;
		case 3:
			p = away.core.partition.EntityNode.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

