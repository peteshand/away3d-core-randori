/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:42 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.display3D == "undefined")
	away.core.display3D = {};

away.core.display3D.CubeTexture = function(gl, size) {
	this._size = 0;
	this._textures = null;
	away.core.display3D.TextureBase.call(this, gl);
	this._size = size;
	this.textureType = "textureCube";
	this._textures = [];
	for (var i = 0; i < 6; ++i) {
		this._textures[i] = this._gl.createTexture();
	}
};

away.core.display3D.CubeTexture.prototype.dispose = function() {
	for (var i = 0; i < 6; ++i) {
		this._gl.deleteTexture(this._textures[i]);
	}
};

away.core.display3D.CubeTexture.prototype.uploadFromHTMLImageElement = function(image, side, miplevel) {
	miplevel = miplevel || 0;
	switch (side) {
		case 0:
			this._gl.bindTexture(34067, this._textures[0]);
			this._gl.texImage2D(34069, miplevel, 6408, 6408, 5121, image);
			this._gl.bindTexture(34067, null);
			break;
		case 1:
			this._gl.bindTexture(34067, this._textures[1]);
			this._gl.texImage2D(34070, miplevel, 6408, 6408, 5121, image);
			this._gl.bindTexture(34067, null);
			break;
		case 2:
			this._gl.bindTexture(34067, this._textures[2]);
			this._gl.texImage2D(34071, miplevel, 6408, 6408, 5121, image);
			this._gl.bindTexture(34067, null);
			break;
		case 3:
			this._gl.bindTexture(34067, this._textures[3]);
			this._gl.texImage2D(34072, miplevel, 6408, 6408, 5121, image);
			this._gl.bindTexture(34067, null);
			break;
		case 4:
			this._gl.bindTexture(34067, this._textures[4]);
			this._gl.texImage2D(34073, miplevel, 6408, 6408, 5121, image);
			this._gl.bindTexture(34067, null);
			break;
		case 5:
			this._gl.bindTexture(34067, this._textures[5]);
			this._gl.texImage2D(34074, miplevel, 6408, 6408, 5121, image);
			this._gl.bindTexture(34067, null);
			break;
		default:
			throw "unknown side type";
	}
};

away.core.display3D.CubeTexture.prototype.uploadFromBitmapData = function(data, side, miplevel) {
	miplevel = miplevel || 0;
	switch (side) {
		case 0:
			this._gl.bindTexture(34067, this._textures[0]);
			this._gl.texImage2D(34069, miplevel, 6408, 6408, 5121, data.get_imageData());
			this._gl.bindTexture(34067, null);
			break;
		case 1:
			this._gl.bindTexture(34067, this._textures[1]);
			this._gl.texImage2D(34070, miplevel, 6408, 6408, 5121, data.get_imageData());
			this._gl.bindTexture(34067, null);
			break;
		case 2:
			this._gl.bindTexture(34067, this._textures[2]);
			this._gl.texImage2D(34071, miplevel, 6408, 6408, 5121, data.get_imageData());
			this._gl.bindTexture(34067, null);
			break;
		case 3:
			this._gl.bindTexture(34067, this._textures[3]);
			this._gl.texImage2D(34072, miplevel, 6408, 6408, 5121, data.get_imageData());
			this._gl.bindTexture(34067, null);
			break;
		case 4:
			this._gl.bindTexture(34067, this._textures[4]);
			this._gl.texImage2D(34073, miplevel, 6408, 6408, 5121, data.get_imageData());
			this._gl.bindTexture(34067, null);
			break;
		case 5:
			this._gl.bindTexture(34067, this._textures[5]);
			this._gl.texImage2D(34074, miplevel, 6408, 6408, 5121, data.get_imageData());
			this._gl.bindTexture(34067, null);
			break;
		default:
			throw "unknown side type";
	}
};

away.core.display3D.CubeTexture.prototype.get_size = function() {
	return this._size;
};

away.core.display3D.CubeTexture.prototype.glTextureAt = function(index) {
	return this._textures[index];
};

$inherit(away.core.display3D.CubeTexture, away.core.display3D.TextureBase);

away.core.display3D.CubeTexture.className = "away.core.display3D.CubeTexture";

away.core.display3D.CubeTexture.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.core.display.BitmapData');
	return p;
};

away.core.display3D.CubeTexture.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.core.display3D.CubeTexture.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'gl', t:'WebGLRenderingContext'});
			p.push({n:'size', t:'Number'});
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

