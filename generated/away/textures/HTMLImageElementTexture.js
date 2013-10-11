/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:07 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.textures == "undefined")
	away.textures = {};

away.textures.HTMLImageElementTexture = function(htmlImageElement, generateMipmaps) {
	this._mipMapHolder = null;
	this._generateMipmaps = false;
	this._htmlImageElement = null;
	this._mipMaps = [];
	this._mipMapUses = [];
	away.textures.Texture2DBase.call(this);
	this._htmlImageElement = htmlImageElement;
	this._generateMipmaps = generateMipmaps;
};

away.textures.HTMLImageElementTexture._mipMaps = [];

away.textures.HTMLImageElementTexture._mipMapUses = [];

away.textures.HTMLImageElementTexture.prototype.get_htmlImageElement = function() {
	return this._htmlImageElement;
};

away.textures.HTMLImageElementTexture.prototype.set_htmlImageElement = function(value) {
	if (value == this._htmlImageElement) {
		return;
	}
	if (!away.utils.TextureUtils.isHTMLImageElementValid(value)) {
		throw new away.errors.away.errors.Error("Invalid bitmapData: Width and height must be power of 2 and cannot exceed 2048", 0, "");
	}
	this.invalidateContent();
	this.pSetSize(value.width, value.height);
	this._htmlImageElement = value;
	if (this._generateMipmaps) {
		this.getMipMapHolder();
	}
};

away.textures.HTMLImageElementTexture.prototype.pUploadContent = function(texture) {
	if (this._generateMipmaps) {
		away.materials.utils.MipmapGenerator.generateHTMLImageElementMipMaps(this._htmlImageElement, texture, this._mipMapHolder, true, -1);
	} else {
		var tx = texture;
		tx.uploadFromHTMLImageElement(this._htmlImageElement, 0);
	}
};

away.textures.HTMLImageElementTexture.prototype.getMipMapHolder = function() {
	var newW = this._htmlImageElement.width;
	var newH = this._htmlImageElement.height;
	if (this._mipMapHolder) {
		if (this._mipMapHolder.get_width() == newW && this._htmlImageElement.height == newH) {
			return;
		}
		this.freeMipMapHolder();
	}
	if (!away.textures.HTMLImageElementTexture._mipMaps[newW]) {
		away.textures.HTMLImageElementTexture._mipMaps[newW] = [];
		away.textures.HTMLImageElementTexture._mipMapUses[newW] = [];
	}
	if (!away.textures.HTMLImageElementTexture._mipMaps[newW][newH]) {
		away.textures.HTMLImageElementTexture._mipMaps[newW][newH] = new away.core.display.BitmapData(newW, newH, true, -1);
		this._mipMapHolder = away.textures.HTMLImageElementTexture._mipMaps[newW][newH];
		away.textures.HTMLImageElementTexture._mipMapUses[newW][newH] = 1;
	} else {
		away.textures.HTMLImageElementTexture._mipMapUses[newW][newH] = away.textures.HTMLImageElementTexture._mipMapUses[newW][newH] + 1;
		this._mipMapHolder = away.textures.HTMLImageElementTexture._mipMaps[newW][newH];
	}
};

away.textures.HTMLImageElementTexture.prototype.freeMipMapHolder = function() {
	var holderWidth = this._mipMapHolder.get_width();
	var holderHeight = this._mipMapHolder.get_height();
	if (--away.textures.HTMLImageElementTexture._mipMapUses[holderWidth][holderHeight] == 0) {
		away.textures.HTMLImageElementTexture._mipMaps[holderWidth][holderHeight].dispose();
		away.textures.HTMLImageElementTexture._mipMaps[holderWidth][holderHeight] = null;
	}
};

away.textures.HTMLImageElementTexture.prototype.dispose = function() {
	away.textures.Texture2DBase.prototype.dispose.call(this);
	if (this._mipMapHolder) {
		this.freeMipMapHolder();
	}
};

$inherit(away.textures.HTMLImageElementTexture, away.textures.Texture2DBase);

away.textures.HTMLImageElementTexture.className = "away.textures.HTMLImageElementTexture";

away.textures.HTMLImageElementTexture.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.materials.utils.MipmapGenerator');
	p.push('away.core.display.BitmapData');
	p.push('away.utils.TextureUtils');
	return p;
};

away.textures.HTMLImageElementTexture.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.textures.HTMLImageElementTexture.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'htmlImageElement', t:'HTMLImageElement'});
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

