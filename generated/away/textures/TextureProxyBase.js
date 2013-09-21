/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 21 16:02:38 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.textures == "undefined")
	away.textures = {};

away.textures.TextureProxyBase = function() {
	this._format = away.display3D.Context3DTextureFormat.BGRA;
	this._hasMipmaps = true;
	this._textures = null;
	this._dirty = null;
	this._pWidth = 0;
	this._pHeight = 0;
	away.library.assets.NamedAssetBase.call(this, null);
	this._textures = [null, null, null, null, null, null, null, null];
	this._dirty = [null, null, null, null, null, null, null, null];
};

away.textures.TextureProxyBase.prototype.get_hasMipMaps = function() {
	return this._hasMipmaps;
};

away.textures.TextureProxyBase.prototype.get_format = function() {
	return this._format;
};

away.textures.TextureProxyBase.prototype.get_assetType = function() {
	return away.library.assets.AssetType.TEXTURE;
};

away.textures.TextureProxyBase.prototype.get_width = function() {
	return this._pWidth;
};

away.textures.TextureProxyBase.prototype.get_height = function() {
	return this._pHeight;
};

away.textures.TextureProxyBase.prototype.getTextureForStage3D = function(stage3DProxy) {
	var contextIndex = stage3DProxy._iStage3DIndex;
	var tex = this._textures[contextIndex];
	var context = stage3DProxy._iContext3D;
	if (!tex || this._dirty[contextIndex] != context) {
		this._textures[contextIndex] = this.pCreateTexture(context);
		tex = this.pCreateTexture(context);
		this._dirty[contextIndex] = context;
		this.pUploadContent(tex);
	}
	return tex;
};

away.textures.TextureProxyBase.prototype.pUploadContent = function(texture) {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.textures.TextureProxyBase.prototype.pSetSize = function(width, height) {
	if (this._pWidth != width || this._pHeight != height) {
		this.pInvalidateSize();
	}
	this._pWidth = width;
	this._pHeight = height;
};

away.textures.TextureProxyBase.prototype.invalidateContent = function() {
	for (var i = 0; i < 8; ++i) {
		this._dirty[i] = null;
	}
};

away.textures.TextureProxyBase.prototype.pInvalidateSize = function() {
	var tex;
	for (var i = 0; i < 8; ++i) {
		tex = this._textures[i];
		if (tex) {
			tex.dispose();
			this._textures[i] = null;
			this._dirty[i] = null;
		}
	}
};

away.textures.TextureProxyBase.prototype.pCreateTexture = function(context) {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.textures.TextureProxyBase.prototype.dispose = function() {
	for (var i = 0; i < 8; ++i) {
		if (this._textures[i]) {
			this._textures[i].dispose();
		}
	}
};

$inherit(away.textures.TextureProxyBase, away.library.assets.NamedAssetBase);

away.textures.TextureProxyBase.className = "away.textures.TextureProxyBase";

away.textures.TextureProxyBase.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.errors.AbstractMethodError');
	p.push('away.library.assets.AssetType');
	return p;
};

away.textures.TextureProxyBase.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('away.display3D.Context3DTextureFormat');
	return p;
};

away.textures.TextureProxyBase.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 1:
			p = away.library.assets.NamedAssetBase.injectionPoints(t);
			break;
		case 2:
			p = away.library.assets.NamedAssetBase.injectionPoints(t);
			break;
		case 3:
			p = away.library.assets.NamedAssetBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

