/** Compiled by the Randori compiler v0.2.6.2 on Mon Sep 02 23:32:27 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.display3D == "undefined")
	away.display3D = {};

away.display3D.CubeTexture = function(gl, size) {
	this._size = 0;
	away.display3D.TextureBase.call(this, gl);
	this._size = size;
};

away.display3D.CubeTexture.prototype.uploadFromHTMLImageElement = function(image, miplevel) {
	this._gl.texImage2D(3553, miplevel, 6408, 6408, 5121, image);
};

away.display3D.CubeTexture.prototype.uploadFromBitmapData = function(data, miplevel) {
	this._gl.texImage2D(3553, miplevel, 6408, 6408, 5121, data.get_imageData());
};

$inherit(away.display3D.CubeTexture, away.display3D.TextureBase);

away.display3D.CubeTexture.className = "away.display3D.CubeTexture";

away.display3D.CubeTexture.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.display.BitmapData');
	return p;
};

away.display3D.CubeTexture.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.display3D.CubeTexture.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'gl', t:'WebGLRenderingContext'});
			p.push({n:'size', t:'Number'});
			break;
		case 1:
			p = away.display3D.TextureBase.injectionPoints(t);
			break;
		case 2:
			p = away.display3D.TextureBase.injectionPoints(t);
			break;
		case 3:
			p = away.display3D.TextureBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

