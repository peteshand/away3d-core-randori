/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 04 21:18:40 EST 2013 */

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
	if (data instanceof HTMLImageElement) {
		return true;
	}
	return false;
};

away.loaders.parsers.ImageParser.prototype._pProceedParsing = function() {
	var asset;
	if (this.get_data() instanceof HTMLImageElement) {
		asset = new away.textures.HTMLImageElementTexture(this.get_data(), false);
		if (away.utils.TextureUtils.isHTMLImageElementValid(this.get_data())) {
			this._pFinalizeAsset(IAsset(asset), this._iFileName);
		} else {
			this.dispatchEvent(new away.events.AssetEvent(away.events.AssetEvent.TEXTURE_SIZE_ERROR, IAsset(asset)));
		}
		return away.loaders.parsers.ParserBase.PARSING_DONE;
	}
	return away.loaders.parsers.ParserBase.PARSING_DONE;
};

$inherit(away.loaders.parsers.ImageParser, away.loaders.parsers.ParserBase);

away.loaders.parsers.ImageParser.className = "away.loaders.parsers.ImageParser";

away.loaders.parsers.ImageParser.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.loaders.parsers.ParserLoaderType');
	p.push('away.loaders.parsers.ParserDataFormat');
	p.push('away.loaders.parsers.ParserBase');
	p.push('away.textures.HTMLImageElementTexture');
	p.push('away.events.AssetEvent');
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

