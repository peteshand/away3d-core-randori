/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 21 16:02:31 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.display3D == "undefined")
	away.display3D = {};

away.display3D.TextureBase = function(gl) {
	this.textureType = "";
	this._gl = null;
	this._gl = gl;
};

away.display3D.TextureBase.prototype.dispose = function() {
	throw "Abstract method must be overridden.";
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

