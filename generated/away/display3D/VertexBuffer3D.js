/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 21 16:02:02 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.display3D == "undefined")
	away.display3D = {};

away.display3D.VertexBuffer3D = function(gl, numVertices, data32PerVertex) {
	this._numVertices = 0;
	this._buffer = null;
	this._data32PerVertex = 0;
	this._gl = null;
	this._gl = gl;
	this._buffer = this._gl.createBuffer();
	this._numVertices = numVertices;
	this._data32PerVertex = data32PerVertex;
};

away.display3D.VertexBuffer3D.prototype.uploadFromArray = function(vertices, startVertex, numVertices) {
	this._gl.bindBuffer(34962, this._buffer);
	//console.log("** WARNING upload not fully implemented, startVertex & numVertices not considered.");
	this._gl.bufferData(34962, new Float32Array(vertices), 35044);
};

away.display3D.VertexBuffer3D.prototype.get_numVertices = function() {
	return this._numVertices;
};

away.display3D.VertexBuffer3D.prototype.get_data32PerVertex = function() {
	return this._data32PerVertex;
};

away.display3D.VertexBuffer3D.prototype.get_glBuffer = function() {
	return this._buffer;
};

away.display3D.VertexBuffer3D.prototype.dispose = function() {
	this._gl.deleteBuffer(this._buffer);
};

away.display3D.VertexBuffer3D.className = "away.display3D.VertexBuffer3D";

away.display3D.VertexBuffer3D.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.display3D.VertexBuffer3D.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.display3D.VertexBuffer3D.injectionPoints = function(t) {
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

