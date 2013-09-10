/** Compiled by the Randori compiler v0.2.6.2 on Thu Sep 05 22:29:08 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.textures == "undefined")
	away.textures = {};

away.textures.BitmapTexture = function(bitmapData, generateMipmaps) {
	this._mipMapHolder = null;
	this._mipMaps = [];
	this._bitmapData = null;
	this._generateMipmaps = null;
	this._mipMapUses = [];
	away.textures.Texture2DBase.call(this);
	bitmapData = bitmapData;
	this._generateMipmaps = generateMipmaps;
};

away.textures.BitmapTexture._mipMaps = [];

away.textures.BitmapTexture._mipMapUses = [];

away.textures.BitmapTexture.prototype.get_bitmapData = function() {
	return this._bitmapData;
};

away.textures.BitmapTexture.prototype.set_bitmapData = function(value) {
	if (value == this._bitmapData) {
		return;
	}
	if (!away.utils.TextureUtils.isBitmapDataValid(value)) {
		throw new Error("Invalid bitmapData: Width and height must be power of 2 and cannot exceed 2048", 0);
	}
	this.invalidateContent();
	this.pSetSize(value.get_width(), value.get_height());
	this._bitmapData = value;
	if (this._generateMipmaps) {
		this.getMipMapHolder();
	}
};

away.textures.BitmapTexture.prototype.pUploadContent = function(texture) {
	if (this._generateMipmaps) {
		away.materials.utils.MipmapGenerator.generateMipMaps(this._bitmapData, texture, this._mipMapHolder, true, -1);
	} else {
		var tx = texture;
		tx.uploadFromBitmapData(this._bitmapData, 0);
	}
};

away.textures.BitmapTexture.prototype.getMipMapHolder = function() {
	var newW, newH;
	newW = this._bitmapData.get_width();
	newH = this._bitmapData.get_height();
	if (this._mipMapHolder) {
		if (this._mipMapHolder.get_width() == newW && this._bitmapData.get_height() == newH) {
			return;
		}
		this.freeMipMapHolder();
	}
	if (!away.textures.BitmapTexture._mipMaps[newW]) {
		away.textures.BitmapTexture._mipMaps[newW] = [];
		away.textures.BitmapTexture._mipMapUses[newW] = [];
	}
	if (!away.textures.BitmapTexture._mipMaps[newW][newH]) {
		this._mipMapHolder = away.textures.BitmapTexture._mipMaps[newW][newH] = new away.display.BitmapData(newW, newH, true, -1);
		away.textures.BitmapTexture._mipMapUses[newW][newH] = 1;
	} else {
		away.textures.BitmapTexture._mipMapUses[newW][newH] = away.textures.BitmapTexture._mipMapUses[newW][newH] + 1;
		this._mipMapHolder = away.textures.BitmapTexture._mipMaps[newW][newH];
	}
};

away.textures.BitmapTexture.prototype.freeMipMapHolder = function() {
	var holderWidth = this._mipMapHolder.get_width();
	var holderHeight = this._mipMapHolder.get_height();
	if (--away.textures.BitmapTexture._mipMapUses[holderWidth][holderHeight] == 0) {
		away.textures.BitmapTexture._mipMaps[holderWidth][holderHeight].dispose();
		away.textures.BitmapTexture._mipMaps[holderWidth][holderHeight] = null;
	}
};

away.textures.BitmapTexture.prototype.dispose = function() {
	away.textures.Texture2DBase.prototype.dispose.call(this);
	if (this._mipMapHolder) {
		this.freeMipMapHolder();
	}
};

$inherit(away.textures.BitmapTexture, away.textures.Texture2DBase);

away.textures.BitmapTexture.className = "away.textures.BitmapTexture";

away.textures.BitmapTexture.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.materials.utils.MipmapGenerator');
	p.push('away.display.BitmapData');
	p.push('away.utils.TextureUtils');
	return p;
};

away.textures.BitmapTexture.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.textures.BitmapTexture.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'bitmapData', t:'away.display.BitmapData'});
			p.push({n:'generateMipmaps', t:'Boolean'});
			break;
		case 1:
			p = away.textures.Texture2DBase.injectionPoints(t);
			break;
		case 2:
			p = away.textures.Texture2DBase.injectionPoints(t);
			break;
		case 3:
			p = away.textures.Texture2DBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

