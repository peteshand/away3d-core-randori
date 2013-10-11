/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:04 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.loaders == "undefined")
	away.loaders = {};
if (typeof away.loaders.parsers == "undefined")
	away.loaders.parsers = {};

away.loaders.parsers.CubeTextureParser = function() {
	this.posY = "posY";
	this.posX = "posX";
	this.posZ = "posZ";
	this.STATE_LOAD_IMAGES = 1;
	this._loadedImageCounter = 0;
	this._dependencyCount = 0;
	this._state = -1;
	this._loadedTextures = null;
	this._imgLoaderDictionary = null;
	this.negZ = "negZ";
	this.negY = "negY";
	this._totalImages = 0;
	this.negX = "negX";
	this.STATE_COMPLETE = 2;
	this.STATE_PARSE_DATA = 0;
	away.loaders.parsers.ParserBase.call(this, away.loaders.parsers.ParserDataFormat.PLAIN_TEXT, away.loaders.parsers.ParserLoaderType.URL_LOADER);
	this._loadedTextures = [];
	this._state = this.STATE_PARSE_DATA;
};

away.loaders.parsers.CubeTextureParser.posX = "posX";

away.loaders.parsers.CubeTextureParser.negX = "negX";

away.loaders.parsers.CubeTextureParser.posY = "posY";

away.loaders.parsers.CubeTextureParser.negY = "negY";

away.loaders.parsers.CubeTextureParser.posZ = "posZ";

away.loaders.parsers.CubeTextureParser.negZ = "negZ";

away.loaders.parsers.CubeTextureParser.supportsType = function(extension) {
	extension = extension.toLowerCase();
	return extension == "cube";
};

away.loaders.parsers.CubeTextureParser.supportsData = function(data) {
	try {
		var obj = JSON.parse(data);
		if (obj) {
			return true;
		}
		return false;
	} catch (e) {
		return false;
	}
	return false;
};

away.loaders.parsers.CubeTextureParser.prototype._iResolveDependency = function(resourceDependency) {
};

away.loaders.parsers.CubeTextureParser.prototype._iResolveDependencyFailure = function(resourceDependency) {
};

away.loaders.parsers.CubeTextureParser.prototype.parseJson = function() {
	if (away.loaders.parsers.CubeTextureParser.supportsData(this.get_data())) {
		try {
			this._imgLoaderDictionary = {};
			var json = JSON.parse(this.get_data());
			var data = json.data;
			var rec;
			var rq;
			for (var c = 0; c < data.length; c++) {
				rec = data[c];
				var uri = rec.image;
				var id = rec.id;
				rq = new away.core.net.URLRequest(uri);
				var imgLoader = new away.core.net.IMGLoader("");
				imgLoader.set_name(rec.id);
				imgLoader.load(rq);
				imgLoader.addEventListener(away.events.Event.COMPLETE, $createStaticDelegate(this, this.onIMGLoadComplete), this);
				this._imgLoaderDictionary[imgLoader.get_name()] = imgLoader;
			}
			if (data.length != 6) {
				this._pDieWithError("CubeTextureParser: Error - cube texture should have exactly 6 images");
				this._state = this.STATE_COMPLETE;
				return;
			}
			if (!this.validateCubeData()) {
				this._pDieWithError("CubeTextureParser: JSON data error - cubes require id of:   \n" + away.loaders.parsers.CubeTextureParser.posX + ", " + away.loaders.parsers.CubeTextureParser.negX + ",  \n" + away.loaders.parsers.CubeTextureParser.posY + ", " + away.loaders.parsers.CubeTextureParser.negY + ",  \n" + away.loaders.parsers.CubeTextureParser.posZ + ", " + away.loaders.parsers.CubeTextureParser.negZ);
				this._state = this.STATE_COMPLETE;
				return;
			}
			this._state = this.STATE_LOAD_IMAGES;
		} catch (e) {
			this._pDieWithError("CubeTexturePaser Error parsing JSON");
			this._state = this.STATE_COMPLETE;
		}
	}
};

away.loaders.parsers.CubeTextureParser.prototype.createCubeTexture = function() {
	var asset = new away.textures.HTMLImageElementCubeTexture(this.getHTMLImageElement(away.loaders.parsers.CubeTextureParser.posX), this.getHTMLImageElement(away.loaders.parsers.CubeTextureParser.negX), this.getHTMLImageElement(away.loaders.parsers.CubeTextureParser.posY), this.getHTMLImageElement(away.loaders.parsers.CubeTextureParser.negY), this.getHTMLImageElement(away.loaders.parsers.CubeTextureParser.posZ), this.getHTMLImageElement(away.loaders.parsers.CubeTextureParser.negZ));
	asset.set_name(this._iFileName);
	this._pFinalizeAsset(asset, this._iFileName);
	this._state = this.STATE_COMPLETE;
};

away.loaders.parsers.CubeTextureParser.prototype.validateCubeData = function() {
	return (this.getHTMLImageElement(away.loaders.parsers.CubeTextureParser.posX) != null && this.getHTMLImageElement(away.loaders.parsers.CubeTextureParser.negX) != null && this.getHTMLImageElement(away.loaders.parsers.CubeTextureParser.posY) != null && this.getHTMLImageElement(away.loaders.parsers.CubeTextureParser.negY) != null && this.getHTMLImageElement(away.loaders.parsers.CubeTextureParser.posZ) != null && this.getHTMLImageElement(away.loaders.parsers.CubeTextureParser.negZ) != null);
};

away.loaders.parsers.CubeTextureParser.prototype.getHTMLImageElement = function(name) {
	var imgLoader = this._imgLoaderDictionary[name];
	if (imgLoader) {
		return imgLoader.get_image();
	}
	return null;
};

away.loaders.parsers.CubeTextureParser.prototype.onIMGLoadComplete = function(e) {
	this._loadedImageCounter++;
	if (this._loadedImageCounter == 6) {
		this.createCubeTexture();
	}
};

away.loaders.parsers.CubeTextureParser.prototype._pProceedParsing = function() {
	switch (this._state) {
		case this.STATE_PARSE_DATA:
			this.parseJson();
			return away.loaders.parsers.ParserBase.MORE_TO_PARSE;
			break;
		case this.STATE_LOAD_IMAGES:
			break;
		case this.STATE_COMPLETE:
			return away.loaders.parsers.ParserBase.PARSING_DONE;
			break;
	}
	return false;
};

$inherit(away.loaders.parsers.CubeTextureParser, away.loaders.parsers.ParserBase);

away.loaders.parsers.CubeTextureParser.className = "away.loaders.parsers.CubeTextureParser";

away.loaders.parsers.CubeTextureParser.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.loaders.parsers.ParserLoaderType');
	p.push('away.loaders.parsers.CubeTextureParser');
	p.push('away.events.Event');
	p.push('away.textures.HTMLImageElementCubeTexture');
	p.push('away.core.net.URLRequest');
	p.push('away.loaders.parsers.ParserDataFormat');
	p.push('away.loaders.parsers.ParserBase');
	p.push('away.core.net.IMGLoader');
	return p;
};

away.loaders.parsers.CubeTextureParser.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.loaders.parsers.CubeTextureParser.injectionPoints = function(t) {
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

