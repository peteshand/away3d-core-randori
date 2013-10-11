/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:07 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.display3D == "undefined")
	away.core.display3D = {};

away.core.display3D.IndexBuffer3D = function(gl, numIndices) {
	this._buffer = null;
	this._numIndices = 0;
	this._gl = null;
	this._gl = gl;
	this._buffer = this._gl.createBuffer();
	this._numIndices = numIndices;
};

away.core.display3D.IndexBuffer3D.prototype.uploadFromArray = function(data, startOffset, count) {
	this._gl.bindBuffer(34963, this._buffer);
	this._gl.bufferData(34963, new Uint16Array(data), 35044);
};

away.core.display3D.IndexBuffer3D.prototype.dispose = function() {
	this._gl.deleteBuffer(this._buffer);
};

away.core.display3D.IndexBuffer3D.prototype.get_numIndices = function() {
	return this._numIndices;
};

away.core.display3D.IndexBuffer3D.prototype.get_glBuffer = function() {
	return this._buffer;
};

away.core.display3D.IndexBuffer3D.className = "away.core.display3D.IndexBuffer3D";

away.core.display3D.IndexBuffer3D.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.core.display3D.IndexBuffer3D.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.core.display3D.IndexBuffer3D.injectionPoints = function(t) {
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

