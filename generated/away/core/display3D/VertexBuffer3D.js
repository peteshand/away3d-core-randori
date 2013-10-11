/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:07 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.display3D == "undefined")
	away.core.display3D = {};

away.core.display3D.VertexBuffer3D = function(gl, numVertices, data32PerVertex) {
	this._numVertices = 0;
	this._buffer = null;
	this._data32PerVertex = 0;
	this._gl = null;
	this._gl = gl;
	this._buffer = this._gl.createBuffer();
	this._numVertices = numVertices;
	this._data32PerVertex = data32PerVertex;
};

away.core.display3D.VertexBuffer3D.prototype.uploadFromArray = function(vertices, startVertex, numVertices) {
	this._gl.bindBuffer(34962, this._buffer);
	console.log("** WARNING upload not fully implemented, startVertex & numVertices not considered.");
	this._gl.bufferData(34962, new Float32Array(vertices), 35044);
};

away.core.display3D.VertexBuffer3D.prototype.get_numVertices = function() {
	return this._numVertices;
};

away.core.display3D.VertexBuffer3D.prototype.get_data32PerVertex = function() {
	return this._data32PerVertex;
};

away.core.display3D.VertexBuffer3D.prototype.get_glBuffer = function() {
	return this._buffer;
};

away.core.display3D.VertexBuffer3D.prototype.dispose = function() {
	this._gl.deleteBuffer(this._buffer);
};

away.core.display3D.VertexBuffer3D.className = "away.core.display3D.VertexBuffer3D";

away.core.display3D.VertexBuffer3D.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.core.display3D.VertexBuffer3D.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.core.display3D.VertexBuffer3D.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'gl', t:'WebGLRenderingContext'});
			p.push({n:'numVertices', t:'Number'});
			p.push({n:'data32PerVertex', t:'Number'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

