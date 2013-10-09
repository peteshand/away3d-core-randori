/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:41 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.entities == "undefined")
	away.entities = {};

away.entities.SubSet = function() {
	this.numIndices = 0;
	this.indexBuffer = null;
	this.vertices = null;
	this.lineCount = 0;
	this.vertexContext3D = null;
	this.indices = null;
	this.indexBufferDirty = false;
	this.vertexBuffer = null;
	this.indexContext3D = null;
	this.numVertices = 0;
	this.vertexBufferDirty = false;
	
};

away.entities.SubSet.prototype.dispose = function() {
	this.vertices = null;
	if (this.vertexBuffer) {
		this.vertexBuffer.dispose();
	}
	if (this.indexBuffer) {
		this.indexBuffer.dispose();
	}
};

away.entities.SubSet.className = "away.entities.SubSet";

away.entities.SubSet.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.entities.SubSet.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.entities.SubSet.injectionPoints = function(t) {
	return [];
};
