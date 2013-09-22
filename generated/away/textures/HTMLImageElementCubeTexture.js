/** Compiled by the Randori compiler v0.2.6.2 on Sun Sep 22 12:28:46 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.textures == "undefined")
	away.textures = {};

away.textures.HTMLImageElementCubeTexture = function(posX, negX, posY, negY, posZ, negZ) {
	this._bitmapDatas = null;
	this._useMipMaps = false;
	away.textures.CubeTextureBase.call(this);
	this._bitmapDatas = [null, null, null, null, null, null];
	this.testSize(this._bitmapDatas[0] = posX);
	this.testSize(this._bitmapDatas[1] = negX);
	this.testSize(this._bitmapDatas[2] = posY);
	this.testSize(this._bitmapDatas[3] = negY);
	this.testSize(this._bitmapDatas[4] = posZ);
	this.testSize(this._bitmapDatas[5] = negZ);
	this.pSetSize(posX.width, posX.height);
};

away.textures.HTMLImageElementCubeTexture.prototype.get_positiveX = function() {
	return this._bitmapDatas[0];
};

away.textures.HTMLImageElementCubeTexture.prototype.set_positiveX = function(value) {
	this.testSize(value);
	this.invalidateContent();
	this.pSetSize(value.width, value.height);
	this._bitmapDatas[0] = value;
};

away.textures.HTMLImageElementCubeTexture.prototype.get_negativeX = function() {
	return this._bitmapDatas[1];
};

away.textures.HTMLImageElementCubeTexture.prototype.set_negativeX = function(value) {
	this.testSize(value);
	this.invalidateContent();
	this.pSetSize(value.width, value.height);
	this._bitmapDatas[1] = value;
};

away.textures.HTMLImageElementCubeTexture.prototype.get_positiveY = function() {
	return this._bitmapDatas[2];
};

away.textures.HTMLImageElementCubeTexture.prototype.set_positiveY = function(value) {
	this.testSize(value);
	this.invalidateContent();
	this.pSetSize(value.width, value.height);
	this._bitmapDatas[2] = value;
};

away.textures.HTMLImageElementCubeTexture.prototype.get_negativeY = function() {
	return this._bitmapDatas[3];
};

away.textures.HTMLImageElementCubeTexture.prototype.set_negativeY = function(value) {
	this.testSize(value);
	this.invalidateContent();
	this.pSetSize(value.width, value.height);
	this._bitmapDatas[3] = value;
};

away.textures.HTMLImageElementCubeTexture.prototype.get_positiveZ = function() {
	return this._bitmapDatas[4];
};

away.textures.HTMLImageElementCubeTexture.prototype.set_positiveZ = function(value) {
	this.testSize(value);
	this.invalidateContent();
	this.pSetSize(value.width, value.height);
	this._bitmapDatas[4] = value;
};

away.textures.HTMLImageElementCubeTexture.prototype.get_negativeZ = function() {
	return this._bitmapDatas[5];
};

away.textures.HTMLImageElementCubeTexture.prototype.set_negativeZ = function(value) {
	this.testSize(value);
	this.invalidateContent();
	this.pSetSize(value.width, value.height);
	this._bitmapDatas[5] = value;
};

away.textures.HTMLImageElementCubeTexture.prototype.testSize = function(value) {
	if (value.width != value.height)
		throw new Error("BitmapData should have equal width and height!", 0);
	if (!away.utils.TextureUtils.isHTMLImageElementValid(value))
		throw new Error("Invalid bitmapData: Width and height must be power of 2 and cannot exceed 2048", 0);
};

away.textures.HTMLImageElementCubeTexture.prototype.pUploadContent = function(texture) {
	for (var i = 0; i < 6; ++i) {
		if (this._useMipMaps) {
		} else {
			var tx = texture;
			tx.uploadFromHTMLImageElement(this._bitmapDatas[i], i, 0);
		}
	}
};

$inherit(away.textures.HTMLImageElementCubeTexture, away.textures.CubeTextureBase);

away.textures.HTMLImageElementCubeTexture.className = "away.textures.HTMLImageElementCubeTexture";

away.textures.HTMLImageElementCubeTexture.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.utils.TextureUtils');
	return p;
};

away.textures.HTMLImageElementCubeTexture.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.textures.HTMLImageElementCubeTexture.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'posX', t:'HTMLImageElement'});
			p.push({n:'negX', t:'HTMLImageElement'});
			p.push({n:'posY', t:'HTMLImageElement'});
			p.push({n:'negY', t:'HTMLImageElement'});
			p.push({n:'posZ', t:'HTMLImageElement'});
			p.push({n:'negZ', t:'HTMLImageElement'});
			break;
		case 1:
			p = away.textures.CubeTextureBase.injectionPoints(t);
			break;
		case 2:
			p = away.textures.CubeTextureBase.injectionPoints(t);
			break;
		case 3:
			p = away.textures.CubeTextureBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

