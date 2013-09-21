/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 21 16:02:38 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.loaders == "undefined")
	away.loaders = {};
if (typeof away.loaders.parsers == "undefined")
	away.loaders.parsers = {};

away.loaders.parsers.ImageParser = function() {
	this._startedParsing = null;
	this._doneParsing = null;
	away.loaders.parsers.ParserBase.call(this, away.loaders.parsers.ParserDataFormat.IMAGE, away.loaders.parsers.ParserLoaderType.IMG_LOADER);
};

away.loaders.parsers.ImageParser.supportsType = function(extension) {
	extension = extension.toLowerCase();
	return extension == "jpg" || extension == "jpeg" || extension == "png" || extension == "gif";
};

away.loaders.parsers.ImageParser.supportsData = function(data) {
	if (data instanceof HTMLImageElement)
		return true;
	if (!(data instanceof away.utils.ByteArray))
		return false;
	var ba = data;
	ba.position = 0;
	if (ba.readUnsignedShort() == 0xffd8)
		return true;
	ba.position = 0;
	if (ba.readShort() == 0x424D)
		return true;
	ba.position = 1;
	if (ba.readUTFBytes(3) == "PNG")
		return true;
	ba.position = 0;
	if (ba.readUTFBytes(3) == "GIF" && ba.readShort() == 0x3839 && ba.readByte() == 0x61)
		return true;
	ba.position = 0;
	if (ba.readUTFBytes(3) == "ATF")
		return true;
	return false;
};

away.loaders.parsers.ImageParser.prototype._pProceedParsing = function() {
	var asset;
	var sizeError = false;
	if (this.get_data() instanceof HTMLImageElement) {
		if (away.utils.TextureUtils.isHTMLImageElementValid(this.get_data())) {
			asset = new away.textures.HTMLImageElementTexture(this.get_data(), false);
			this._pFinalizeAsset(asset, this._iFileName);
		} else {
			sizeError = true;
		}
	} else if (this.get_data() instanceof away.utils.ByteArray) {
		var ba = this.get_data();
		ba.position = 0;
		var htmlImageElement = away.loaders.parsers.utils.ParserUtil.byteArrayToImage(this.get_data());
		if (away.utils.TextureUtils.isHTMLImageElementValid(htmlImageElement)) {
			asset = new away.textures.HTMLImageElementTexture(htmlImageElement, false);
			this._pFinalizeAsset(asset, this._iFileName);
		} else {
			sizeError = true;
		}
	}
	if (sizeError == true) {
		asset = new away.textures.BitmapTexture(away.materials.utils.DefaultMaterialManager.createCheckeredBitmapData(), false);
		this._pFinalizeAsset(asset, this._iFileName);
		this.dispatchEvent(new away.events.AssetEvent(away.events.AssetEvent.TEXTURE_SIZE_ERROR, asset));
	}
	return away.loaders.parsers.ParserBase.PARSING_DONE;
};

$inherit(away.loaders.parsers.ImageParser, away.loaders.parsers.ParserBase);

away.loaders.parsers.ImageParser.className = "away.loaders.parsers.ImageParser";

away.loaders.parsers.ImageParser.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.utils.ByteArray');
	p.push('away.loaders.parsers.ParserLoaderType');
	p.push('away.textures.BitmapTexture');
	p.push('away.loaders.parsers.utils.ParserUtil');
	p.push('away.loaders.parsers.ParserDataFormat');
	p.push('away.loaders.parsers.ParserBase');
	p.push('away.textures.HTMLImageElementTexture');
	p.push('away.events.AssetEvent');
	p.push('away.materials.utils.DefaultMaterialManager');
	p.push('away.utils.TextureUtils');
	return p;
};

away.loaders.parsers.ImageParser.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.loaders.parsers.ImageParser.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 1:
			p = away.loaders.parsers.ParserBase.injectionPoints(t);
			break;
		case 2:
			p = away.loaders.parsers.ParserBase.injectionPoints(t);
			break;
		case 3:
			p = away.loaders.parsers.ParserBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

