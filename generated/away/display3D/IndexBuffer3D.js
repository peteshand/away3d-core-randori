/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 04 21:18:29 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.display3D == "undefined")
	away.display3D = {};

away.display3D.IndexBuffer3D = function(gl, numIndices) {
	this._buffer = null;
	this._numIndices = 0;
	this._gl = null;
	this._gl = gl;
	this._buffer = this._gl.createBuffer();
	this._numIndices = numIndices;
};

away.display3D.IndexBuffer3D.prototype.uploadFromArray = function(data, startOffset, count) {
	this._gl.bindBuffer(34963, this._buffer);
	this._gl.bufferData(34963, new Uint16Array(data), 35044);
};

away.display3D.IndexBuffer3D.prototype.dispose = function() {
	this._gl.deleteBuffer(this._buffer);
};

away.display3D.IndexBuffer3D.prototype.get_numIndices = function() {
	return this._numIndices;
};

away.display3D.IndexBuffer3D.prototype.get_glBuffer = function() {
	return this._buffer;
};

away.display3D.IndexBuffer3D.className = "away.display3D.IndexBuffer3D";

away.display3D.IndexBuffer3D.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('Uint16Array');
	return p;
};

away.display3D.IndexBuffer3D.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.display3D.IndexBuffer3D.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'gl', t:'WebGLRenderingContext'});
			p.push({n:'numIndices', t:'Number'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

