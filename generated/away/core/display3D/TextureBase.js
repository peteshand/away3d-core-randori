/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:01 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.display3D == "undefined")
	away.core.display3D = {};

away.core.display3D.TextureBase = function(gl) {
	this.textureType = "";
	this._gl = null;
	this._gl = gl;
};

away.core.display3D.TextureBase.prototype.dispose = function() {
	throw "Abstract method must be overridden.";
};

away.core.display3D.TextureBase.className = "away.core.display3D.TextureBase";

away.core.display3D.TextureBase.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.core.display3D.TextureBase.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.core.display3D.TextureBase.injectionPoints = function(t) {
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

