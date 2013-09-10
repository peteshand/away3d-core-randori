/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 10 22:28:12 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.display3D == "undefined")
	away.display3D = {};

away.display3D.TextureBase = function(gl) {
	this._gl = null;
	this._glTexture = null;
	this._gl = gl;
	this._glTexture = this._gl.createTexture();
};

away.display3D.TextureBase.prototype.dispose = function() {
	this._gl.deleteTexture(this._glTexture);
};

away.display3D.TextureBase.prototype.get_glTexture = function() {
	return this._glTexture;
};

away.display3D.TextureBase.className = "away.display3D.TextureBase";

away.display3D.TextureBase.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.display3D.TextureBase.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.display3D.TextureBase.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'gl', t:'WebGLRenderingContext'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

