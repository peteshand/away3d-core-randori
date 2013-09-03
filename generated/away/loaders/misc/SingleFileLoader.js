/** Compiled by the Randori compiler v0.2.6.2 on Mon Sep 02 23:32:27 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.loaders == "undefined")
	away.loaders = {};
if (typeof away.loaders.misc == "undefined")
	away.loaders.misc = {};

away.loaders.misc.SingleFileLoader = function(materialMode) {
	this._loadAsRawData = null;
	this._materialMode = 0;
	this._req = null;
	this._parsers = [];
	this._data = null;
	this._fileName = null;
	this._fileExtension = null;
	this._parser = null;
	away.events.EventDispatcher.call(this);
	this._materialMode = materialMode;
};

away.loaders.misc.SingleFileLoader._parsers = [];

away.loaders.misc.SingleFileLoader.enableParser = function(parser) {
	if (away.loaders.misc.SingleFileLoader._parsers.indexOf(parser, 0) < 0) {
		away.loaders.misc.SingleFileLoader._parsers.push(parser);
	}
};

away.loaders.misc.SingleFileLoader.enableParsers = function(parsers) {
	var pc;
	for (var c = 0; c < parsers.length; c++) {
		away.loaders.misc.SingleFileLoader.enableParser(parsers[c]);
	}
};

away.loaders.misc.SingleFileLoader.prototype.get_url = function() {
	return this._req ? this._req.get_url() : "";
};

away.loaders.misc.SingleFileLoader.prototype.get_data = function() {
	return this._data;
};

away.loaders.misc.SingleFileLoader.prototype.get_loadAsRawData = function() {
	return this._loadAsRawData;
};

away.loaders.misc.SingleFileLoader.prototype.load = function(urlRequest, parser, loadAsRawData) {
	var dataFormat;
	var loaderType = away.loaders.parsers.ParserLoaderType.URL_LOADER;
	this._loadAsRawData = loadAsRawData;
	this._req = urlRequest;
	this.decomposeFilename(this._req.get_url());
	if (this._loadAsRawData) {
		dataFormat = away.net.URLLoaderDataFormat.BINARY;
	} else {
		if (parser) {
			this._parser = parser;
		}
		if (!this._parser) {
			this._parser = this.getParserFromSuffix();
		}
		if (this._parser) {
			switch (this._parser.get_dataFormat()) {
				case away.loaders.parsers.ParserDataFormat.BINARY:
					dataFormat = away.net.URLLoaderDataFormat.BINARY;
					break;
				case away.loaders.parsers.ParserDataFormat.PLAIN_TEXT:
					dataFormat = away.net.URLLoaderDataFormat.TEXT;
					break;
			}
			switch (this._parser.get_loaderType()) {
				case away.loaders.parsers.ParserLoaderType.IMG_LOADER:
					loaderType = away.loaders.parsers.ParserLoaderType.IMG_LOADER;
					break;
				case away.loaders.parsers.ParserLoaderType.URL_LOADER:
					loaderType = away.loaders.parsers.ParserLoaderType.URL_LOADER;
					break;
			}
		} else {
			dataFormat = away.net.URLLoaderDataFormat.BINARY;
		}
	}
	var loader = this.getLoader(loaderType);
	loader.set_dataFormat(dataFormat);
	loader.addEventListener(away.events.Event.COMPLETE, $createStaticDelegate(this, this.handleUrlLoaderComplete), this);
	loader.addEventListener(away.events.IOErrorEvent.IO_ERROR, $createStaticDelegate(this, this.handleUrlLoaderError), this);
	loader.load(urlRequest);
};

away.loaders.misc.SingleFileLoader.prototype.parseData = function(data, parser, req) {
	if (data.constructor === Function) {
		data = new data();
	}
	if (parser) {
		this._parser = parser;
	}
	this._req = req;
	this.parse(data);
};

away.loaders.misc.SingleFileLoader.prototype.get_parser = function() {
	return this._parser;
};

away.loaders.misc.SingleFileLoader.prototype.get_dependencies = function() {
	return this._parser ? this._parser.get_dependencies() : [];
};

away.loaders.misc.SingleFileLoader.prototype.getLoader = function(loaderType) {
	var loader;
	switch (loaderType) {
		case away.loaders.parsers.ParserLoaderType.IMG_LOADER:
			loader = new away.loaders.misc.SingleFileImageLoader();
			break;
		case away.loaders.parsers.ParserLoaderType.URL_LOADER:
			loader = new away.loaders.misc.SingleFileURLLoader();
			break;
	}
	return loader;
};

away.loaders.misc.SingleFileLoader.prototype.decomposeFilename = function(url) {
	var base = (url.indexOf("?", 0) > 0) ? url.split("?", 4.294967295E9)[0] : url;
	var i = base.lastIndexOf(".", 2147483647);
	this._fileExtension = base.substr(i + 1, 2147483647).toLowerCase();
	this._fileName = base.substr(0, i);
};

away.loaders.misc.SingleFileLoader.prototype.getParserFromSuffix = function() {
	var len = away.loaders.misc.SingleFileLoader._parsers.length;
	for (var i = len - 1; i >= 0; i--) {
		var currentParser = away.loaders.misc.SingleFileLoader._parsers[i];
		var supportstype = away.loaders.misc.SingleFileLoader._parsers[i].supportsType(this._fileExtension);
		if (away.loaders.misc.SingleFileLoader._parsers[i]["supportsType"](this._fileExtension)) {
			return new away.loaders.misc.SingleFileLoader._parsers[i]();
		}
	}
	return null;
};

away.loaders.misc.SingleFileLoader.prototype.getParserFromData = function(data) {
	var len = away.loaders.misc.SingleFileLoader._parsers.length;
	for (var i = len - 1; i >= 0; i--)
		if (away.loaders.misc.SingleFileLoader._parsers[i].supportsData(data))
			return new away.loaders.misc.SingleFileLoader._parsers[i]();
	return null;
};

away.loaders.misc.SingleFileLoader.prototype.removeListeners = function(urlLoader) {
	urlLoader.removeEventListener(away.events.Event.COMPLETE, $createStaticDelegate(this, this.handleUrlLoaderComplete), this);
	urlLoader.removeEventListener(away.events.IOErrorEvent.IO_ERROR, $createStaticDelegate(this, this.handleUrlLoaderError), this);
};

away.loaders.misc.SingleFileLoader.prototype.handleUrlLoaderError = function(event) {
	var urlLoader = ISingleFileTSLoader(event.target);
	this.removeListeners(urlLoader);
	this.dispatchEvent(new away.events.LoaderEvent(away.events.LoaderEvent.LOAD_ERROR, this._req.get_url(), true));
};

away.loaders.misc.SingleFileLoader.prototype.handleUrlLoaderComplete = function(event) {
	var urlLoader = ISingleFileTSLoader(event.target);
	this.removeListeners(urlLoader);
	this._data = urlLoader.get_data();
	if (this._loadAsRawData) {
		this.dispatchEvent(new away.events.LoaderEvent(away.events.LoaderEvent.DEPENDENCY_COMPLETE, null, false));
	} else {
		this.parse(this._data);
	}
};

away.loaders.misc.SingleFileLoader.prototype.parse = function(data) {
	if (!this._parser) {
		this._parser = this.getParserFromData(data);
	}
	if (this._parser) {
		this._parser.addEventListener(away.events.ParserEvent.READY_FOR_DEPENDENCIES, $createStaticDelegate(this, this.onReadyForDependencies), this);
		this._parser.addEventListener(away.events.ParserEvent.PARSE_ERROR, $createStaticDelegate(this, this.onParseError), this);
		this._parser.addEventListener(away.events.ParserEvent.PARSE_COMPLETE, $createStaticDelegate(this, this.onParseComplete), this);
		this._parser.addEventListener(away.events.AssetEvent.TEXTURE_SIZE_ERROR, $createStaticDelegate(this, this.onTextureSizeError), this);
		this._parser.addEventListener(away.events.AssetEvent.ASSET_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
		this._parser.addEventListener(away.events.AssetEvent.ANIMATION_SET_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
		this._parser.addEventListener(away.events.AssetEvent.ANIMATION_STATE_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
		this._parser.addEventListener(away.events.AssetEvent.ANIMATION_NODE_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
		this._parser.addEventListener(away.events.AssetEvent.STATE_TRANSITION_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
		this._parser.addEventListener(away.events.AssetEvent.TEXTURE_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
		this._parser.addEventListener(away.events.AssetEvent.CONTAINER_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
		this._parser.addEventListener(away.events.AssetEvent.GEOMETRY_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
		this._parser.addEventListener(away.events.AssetEvent.MATERIAL_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
		this._parser.addEventListener(away.events.AssetEvent.MESH_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
		this._parser.addEventListener(away.events.AssetEvent.ENTITY_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
		this._parser.addEventListener(away.events.AssetEvent.SKELETON_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
		this._parser.addEventListener(away.events.AssetEvent.SKELETON_POSE_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
		if (this._req && this._req.get_url()) {
			this._parser._iFileName = this._req.get_url();
		}
		this._parser.set_materialMode(this._materialMode);
		this._parser.parseAsync(data, 30);
	} else {
		var msg = "No parser defined. To enable all parsers for auto-detection, use Parsers.enableAllBundled()";
		this.dispatchEvent(new away.events.LoaderEvent(away.events.LoaderEvent.LOAD_ERROR, "", true, msg));
	}
};

away.loaders.misc.SingleFileLoader.prototype.onParseError = function(event) {
	this.dispatchEvent(event.clone());
};

away.loaders.misc.SingleFileLoader.prototype.onReadyForDependencies = function(event) {
	this.dispatchEvent(event.clone());
};

away.loaders.misc.SingleFileLoader.prototype.onAssetComplete = function(event) {
	this.dispatchEvent(event.clone());
};

away.loaders.misc.SingleFileLoader.prototype.onTextureSizeError = function(event) {
	this.dispatchEvent(event.clone());
};

away.loaders.misc.SingleFileLoader.prototype.onParseComplete = function(event) {
	this.dispatchEvent(new away.events.LoaderEvent(away.events.LoaderEvent.DEPENDENCY_COMPLETE, this.get_url(), false));
	this._parser.removeEventListener(away.events.ParserEvent.READY_FOR_DEPENDENCIES, $createStaticDelegate(this, this.onReadyForDependencies), this);
	this._parser.removeEventListener(away.events.ParserEvent.PARSE_COMPLETE, $createStaticDelegate(this, this.onParseComplete), this);
	this._parser.removeEventListener(away.events.ParserEvent.PARSE_ERROR, $createStaticDelegate(this, this.onParseError), this);
	this._parser.removeEventListener(away.events.AssetEvent.TEXTURE_SIZE_ERROR, $createStaticDelegate(this, this.onTextureSizeError), this);
	this._parser.removeEventListener(away.events.AssetEvent.ASSET_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	this._parser.removeEventListener(away.events.AssetEvent.ANIMATION_SET_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	this._parser.removeEventListener(away.events.AssetEvent.ANIMATION_STATE_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	this._parser.removeEventListener(away.events.AssetEvent.ANIMATION_NODE_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	this._parser.removeEventListener(away.events.AssetEvent.STATE_TRANSITION_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	this._parser.removeEventListener(away.events.AssetEvent.TEXTURE_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	this._parser.removeEventListener(away.events.AssetEvent.CONTAINER_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	this._parser.removeEventListener(away.events.AssetEvent.GEOMETRY_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	this._parser.removeEventListener(away.events.AssetEvent.MATERIAL_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	this._parser.removeEventListener(away.events.AssetEvent.MESH_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	this._parser.removeEventListener(away.events.AssetEvent.ENTITY_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	this._parser.removeEventListener(away.events.AssetEvent.SKELETON_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	this._parser.removeEventListener(away.events.AssetEvent.SKELETON_POSE_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
};

$inherit(away.loaders.misc.SingleFileLoader, away.events.EventDispatcher);

away.loaders.misc.SingleFileLoader.className = "away.loaders.misc.SingleFileLoader";

away.loaders.misc.SingleFileLoader.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.net.URLRequest');
	p.push('away.loaders.misc.SingleFileImageLoader');
	p.push('away.loaders.parsers.ParserLoaderType');
	p.push('away.events.Event');
	p.push('away.loaders.misc.SingleFileURLLoader');
	p.push('away.net.URLLoaderDataFormat');
	p.push('away.events.ParserEvent');
	p.push('away.events.LoaderEvent');
	p.push('away.loaders.parsers.ParserDataFormat');
	p.push('away.events.AssetEvent');
	p.push('away.events.IOErrorEvent');
	return p;
};

away.loaders.misc.SingleFileLoader.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.loaders.misc.SingleFileLoader.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'materialMode', t:'Number'});
			break;
		case 1:
			p = away.events.EventDispatcher.injectionPoints(t);
			break;
		case 2:
			p = away.events.EventDispatcher.injectionPoints(t);
			break;
		case 3:
			p = away.events.EventDispatcher.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

