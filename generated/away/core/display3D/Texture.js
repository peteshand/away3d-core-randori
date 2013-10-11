/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:01 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.display3D == "undefined")
	away.core.display3D = {};

away.core.display3D.Texture = function(gl, width, height) {
	this._height = 0;
	this._width = 0;
	this._glTexture = null;
	away.core.display3D.TextureBase.call(this, gl);
	this.textureType = "texture2d";
	this._width = width;
	this._height = height;
	this._glTexture = this._gl.createTexture();
};

away.core.display3D.Texture.prototype.dispose = function() {
	this._gl.deleteTexture(this._glTexture);
};

away.core.display3D.Texture.prototype.get_width = function() {
	return this._width;
};

away.core.display3D.Texture.prototype.get_height = function() {
	return this._height;
};

away.core.display3D.Texture.prototype.uploadFromHTMLImageElement = function(image, miplevel) {
	miplevel = miplevel || 0;
	this._gl.bindTexture(3553, this._glTexture);
	this._gl.texImage2D(3553, miplevel, 6408, 6408, 5121, image);
	this._gl.bindTexture(3553, null);
};

away.core.display3D.Texture.prototype.uploadFromBitmapData = function(data, miplevel) {
	miplevel = miplevel || 0;
	this._gl.bindTexture(3553, this._glTexture);
	this._gl.texImage2D(3553, miplevel, 6408, 6408, 5121, data.get_imageData());
	this._gl.bindTexture(3553, null);
};

away.core.display3D.Texture.prototype.get_glTexture = function() {
	return this._glTexture;
};

$inherit(away.core.display3D.Texture, away.core.display3D.TextureBase);

away.core.display3D.Texture.className = "away.core.display3D.Texture";

away.core.display3D.Texture.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.core.display.BitmapData');
	return p;
};

away.core.display3D.Texture.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.core.display3D.Texture.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'gl', t:'WebGLRenderingContext'});
			p.push({n:'width', t:'Number'});
			p.push({n:'height', t:'Number'});
			break;
		case 1:
			p = away.core.display3D.TextureBase.injectionPoints(t);
			break;
		case 2:
			p = away.core.display3D.TextureBase.injectionPoints(t);
			break;
		case 3:
			p = away.core.display3D.TextureBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

