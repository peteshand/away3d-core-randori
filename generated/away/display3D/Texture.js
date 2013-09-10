/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 10 22:28:12 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.display3D == "undefined")
	away.display3D = {};

away.display3D.Texture = function(gl, width, height) {
	this._height = 0;
	this._width = 0;
	away.display3D.TextureBase.call(this, gl);
	this._width = width;
	this._height = height;
	this._gl.bindTexture(3553, this.get_glTexture());
	this._gl.texImage2D(3553, 0, 6408, width, height, 0, 6408, 5121, null);
};

away.display3D.Texture.prototype.get_width = function() {
	return this._width;
};

away.display3D.Texture.prototype.get_height = function() {
	return this._height;
};

away.display3D.Texture.prototype.uploadFromHTMLImageElement = function(image, miplevel) {
	this._gl.texImage2D(3553, miplevel, 6408, 6408, 5121, image);
};

away.display3D.Texture.prototype.uploadFromBitmapData = function(data, miplevel) {
	this._gl.texImage2D(3553, miplevel, 6408, 6408, 5121, data.get_imageData());
};

$inherit(away.display3D.Texture, away.display3D.TextureBase);

away.display3D.Texture.className = "away.display3D.Texture";

away.display3D.Texture.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.display.BitmapData');
	return p;
};

away.display3D.Texture.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.display3D.Texture.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'gl', t:'WebGLRenderingContext'});
			p.push({n:'width', t:'Number'});
			p.push({n:'height', t:'Number'});
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

