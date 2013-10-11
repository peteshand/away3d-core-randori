/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:08 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.loaders == "undefined")
	away.loaders = {};

away.loaders.AssetLoader = function() {
	this._baseDependency = null;
	this._context = null;
	this._errorHandlers = null;
	this._parseErrorHandlers = null;
	this._namespace = null;
	this._loadingDependency = null;
	this._uri = null;
	this._stack = null;
	this._token = null;
	away.events.EventDispatcher.call(this);
	this._stack = [];
	this._errorHandlers = [];
	this._parseErrorHandlers = [];
};

away.loaders.AssetLoader.prototype.get_baseDependency = function() {
	return this._baseDependency;
};

away.loaders.AssetLoader.enableParser = function(parserClass) {
	away.loaders.misc.SingleFileLoader.enableParser(parserClass);
};

away.loaders.AssetLoader.enableParsers = function(parserClasses) {
	away.loaders.misc.SingleFileLoader.enableParsers(parserClasses);
};

away.loaders.AssetLoader.prototype.load = function(req, context, ns, parser) {
	context = context || null;
	ns = ns || null;
	parser = parser || null;
	if (!this._token) {
		this._token = new away.loaders.misc.AssetLoaderToken(this);
		req.set_url(req.get_url().replace(/\\/g, "\/"));
		this._uri = req.get_url();
		this._context = context;
		this._namespace = ns;
		this._baseDependency = new away.loaders.misc.ResourceDependency("", req, null, null, false, false);
		this.retrieveDependency(this._baseDependency, parser);
		return this._token;
	}
	return null;
};

away.loaders.AssetLoader.prototype.loadData = function(data, id, context, ns, parser) {
	context = context || null;
	ns = ns || null;
	parser = parser || null;
	if (!this._token) {
		this._token = new away.loaders.misc.AssetLoaderToken(this);
		this._uri = id;
		this._context = context;
		this._namespace = ns;
		this._baseDependency = new away.loaders.misc.ResourceDependency(id, null, data, null, false, false);
		this.retrieveDependency(this._baseDependency, parser);
		return this._token;
	}
	return null;
};

away.loaders.AssetLoader.prototype.retrieveNext = function(parser) {
	parser = parser || null;
	if (this._loadingDependency.get_dependencies().length) {
		var dep = this._loadingDependency.get_dependencies().pop();
		this._stack.push(this._loadingDependency);
		this.retrieveDependency(dep);
	} else if (this._loadingDependency._iLoader.get_parser() && this._loadingDependency._iLoader.get_parser().get_parsingPaused()) {
		this._loadingDependency._iLoader.get_parser()._iResumeParsingAfterDependencies();
		this._stack.pop();
	} else if (this._stack.length) {
		var prev = this._loadingDependency;
		this._loadingDependency = this._stack.pop();
		if (prev._iSuccess) {
			prev.resolve();
		}
		this.retrieveNext(parser);
	} else {
		this.dispatchEvent(new away.events.LoaderEvent(away.events.LoaderEvent.RESOURCE_COMPLETE, this._uri, this._baseDependency.get_assets(), false));
	}
};

away.loaders.AssetLoader.prototype.retrieveDependency = function(dependency, parser) {
	parser = parser || null;
	var data;
	var matMode = 0;
	if (this._context && this._context.get_materialMode() != 0) {
		matMode = this._context.get_materialMode();
	}
	this._loadingDependency = dependency;
	this._loadingDependency._iLoader = new away.loaders.misc.SingleFileLoader(matMode);
	this.addEventListeners(this._loadingDependency._iLoader);
	data = this._loadingDependency.get_data();
	if (this._context && this._loadingDependency.get_request() && this._context._iHasDataForUrl(this._loadingDependency.get_request().get_url())) {
		data = this._context._iGetDataForUrl(this._loadingDependency.get_request().get_url());
	}
	if (data) {
		if (this._loadingDependency.get_retrieveAsRawData()) {
			this.dispatchEvent(new away.events.LoaderEvent(away.events.LoaderEvent.DEPENDENCY_COMPLETE, this._loadingDependency.get_request().get_url(), this._baseDependency.get_assets(), true));
			this._loadingDependency._iSetData(data);
			this._loadingDependency.resolve();
			this.retrieveNext();
		} else {
			this._loadingDependency._iLoader.parseData(data, parser, this._loadingDependency.get_request());
		}
	} else {
		dependency.get_request().set_url(this.resolveDependencyUrl(dependency));
		this._loadingDependency._iLoader.load(dependency.get_request(), parser, this._loadingDependency.get_retrieveAsRawData());
	}
};

away.loaders.AssetLoader.prototype.joinUrl = function(base, end) {
	if (end.charAt(0) == "\/") {
		end = end.substr(1, 2147483647);
	}
	if (base.length == 0) {
		return end;
	}
	if (base.charAt(base.length - 1) == "\/") {
		base = base.substr(0, base.length - 1);
	}
	return base.concat("\/", end);
};

away.loaders.AssetLoader.prototype.resolveDependencyUrl = function(dependency) {
	var scheme_re;
	var base;
	var url = dependency.get_request().get_url();
	if (this._context && this._context._iHasMappingForUrl(url))
		return this._context._iGetRemappedUrl(url);
	if (url == this._uri) {
		return url;
	}
	scheme_re = new RegExp("\/^[a-zA-Z]{3,4}:\/\/\/");
	if (url.charAt(0) == "\/") {
		if (this._context && this._context.get_overrideAbsolutePaths())
			return this.joinUrl(this._context.get_dependencyBaseUrl(), url);
		else
			return url;
	} else if (scheme_re.test(url)) {
		if (this._context && this._context.get_overrideFullURLs()) {
			var noscheme_url;
			noscheme_url = url["replace"](scheme_re);
			return this.joinUrl(this._context.get_dependencyBaseUrl(), noscheme_url);
		}
	}
	if (this._context && this._context.get_dependencyBaseUrl()) {
		base = this._context.get_dependencyBaseUrl();
		return this.joinUrl(base, url);
	} else {
		base = this._uri.substring(0, this._uri.lastIndexOf("\/", 2147483647) + 1);
		return this.joinUrl(base, url);
	}
};

away.loaders.AssetLoader.prototype.retrieveLoaderDependencies = function(loader) {
	if (!this._loadingDependency) {
		return;
	}
	var i, len = loader.get_dependencies().length;
	for (i = 0; i < len; i++) {
		this._loadingDependency.get_dependencies()[i] = loader.get_dependencies()[i];
	}
	loader.get_dependencies().length = 0;
	this._stack.push(this._loadingDependency);
	this.retrieveNext();
};

away.loaders.AssetLoader.prototype.onRetrievalFailed = function(event) {
	var handled;
	var isDependency = (this._loadingDependency != this._baseDependency);
	var loader = event.target;
	this.removeEventListeners(loader);
	event = new away.events.LoaderEvent(away.events.LoaderEvent.LOAD_ERROR, this._uri, this._baseDependency.get_assets(), isDependency, event.get_message());
	this.dispatchEvent(event);
	handled = true;
	var i, len = this._errorHandlers.length;
	for (i = 0; i < len; i++) {
		var handlerFunction = this._errorHandlers[i];
		handled = handled || handlerFunction(event);
	}
	if (handled) {
		if (isDependency) {
			this._loadingDependency.resolveFailure();
			this.retrieveNext();
		} else {
			this.dispose();
			return;
		}
	} else {
		throw new away.errors.away.errors.Error(event.get_message(), 0, "");
	}
};

away.loaders.AssetLoader.prototype.onParserError = function(event) {
	var handled;
	var isDependency = (this._loadingDependency != this._baseDependency);
	var loader = event.target;
	this.removeEventListeners(loader);
	event = new away.events.ParserEvent(away.events.ParserEvent.PARSE_ERROR, event.get_message());
	this.dispatchEvent(event);
	handled = true;
	var i, len = this._parseErrorHandlers.length;
	for (i = 0; i < len; i++) {
		var handlerFunction = this._parseErrorHandlers[i];
		handled = handled || handlerFunction(event);
	}
	if (handled) {
		this.dispose();
		return;
	} else {
		throw new away.errors.away.errors.Error(event.get_message(), 0, "");
	}
};

away.loaders.AssetLoader.prototype.onAssetComplete = function(event) {
	if (event.type == away.events.AssetEvent.ASSET_COMPLETE) {
		if (this._loadingDependency) {
			this._loadingDependency.get_assets().push(event.get_asset());
		}
		event.get_asset().resetAssetPath(event.get_asset().get_name(), this._namespace, true);
	}
	if (!this._loadingDependency.get_suppresAssetEvents()) {
		this.dispatchEvent(event.clone());
	}
};

away.loaders.AssetLoader.prototype.onReadyForDependencies = function(event) {
	var loader = event.target;
	if (this._context && !this._context.get_includeDependencies()) {
		loader.get_parser()._iResumeParsingAfterDependencies();
	} else {
		this.retrieveLoaderDependencies(loader);
	}
};

away.loaders.AssetLoader.prototype.onRetrievalComplete = function(event) {
	var loader = event.target;
	this._loadingDependency._iSetData(loader.get_data());
	this._loadingDependency._iSuccess = true;
	this.dispatchEvent(new away.events.LoaderEvent(away.events.LoaderEvent.DEPENDENCY_COMPLETE, event.get_url(), this._baseDependency.get_assets(), false));
	this.removeEventListeners(loader);
	if (loader.get_dependencies().length && (!this._context || this._context.get_includeDependencies())) {
		this.retrieveLoaderDependencies(loader);
	} else {
		this.retrieveNext();
	}
};

away.loaders.AssetLoader.prototype.onTextureSizeError = function(event) {
	event.get_asset().set_name(this._loadingDependency.resolveName(event.get_asset()));
	this.dispatchEvent(event);
};

away.loaders.AssetLoader.prototype.addEventListeners = function(loader) {
	loader.addEventListener(away.events.LoaderEvent.DEPENDENCY_COMPLETE, $createStaticDelegate(this, this.onRetrievalComplete), this);
	loader.addEventListener(away.events.LoaderEvent.LOAD_ERROR, $createStaticDelegate(this, this.onRetrievalFailed), this);
	loader.addEventListener(away.events.AssetEvent.TEXTURE_SIZE_ERROR, $createStaticDelegate(this, this.onTextureSizeError), this);
	loader.addEventListener(away.events.AssetEvent.ASSET_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	loader.addEventListener(away.events.AssetEvent.ANIMATION_SET_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	loader.addEventListener(away.events.AssetEvent.ANIMATION_STATE_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	loader.addEventListener(away.events.AssetEvent.ANIMATION_NODE_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	loader.addEventListener(away.events.AssetEvent.STATE_TRANSITION_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	loader.addEventListener(away.events.AssetEvent.TEXTURE_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	loader.addEventListener(away.events.AssetEvent.CONTAINER_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	loader.addEventListener(away.events.AssetEvent.GEOMETRY_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	loader.addEventListener(away.events.AssetEvent.MATERIAL_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	loader.addEventListener(away.events.AssetEvent.MESH_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	loader.addEventListener(away.events.AssetEvent.ENTITY_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	loader.addEventListener(away.events.AssetEvent.SKELETON_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	loader.addEventListener(away.events.AssetEvent.SKELETON_POSE_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	loader.addEventListener(away.events.ParserEvent.READY_FOR_DEPENDENCIES, $createStaticDelegate(this, this.onReadyForDependencies), this);
	loader.addEventListener(away.events.ParserEvent.PARSE_ERROR, $createStaticDelegate(this, this.onParserError), this);
};

away.loaders.AssetLoader.prototype.removeEventListeners = function(loader) {
	loader.removeEventListener(away.events.ParserEvent.READY_FOR_DEPENDENCIES, $createStaticDelegate(this, this.onReadyForDependencies), this);
	loader.removeEventListener(away.events.LoaderEvent.DEPENDENCY_COMPLETE, $createStaticDelegate(this, this.onRetrievalComplete), this);
	loader.removeEventListener(away.events.LoaderEvent.LOAD_ERROR, $createStaticDelegate(this, this.onRetrievalFailed), this);
	loader.removeEventListener(away.events.AssetEvent.TEXTURE_SIZE_ERROR, $createStaticDelegate(this, this.onTextureSizeError), this);
	loader.removeEventListener(away.events.AssetEvent.ASSET_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	loader.removeEventListener(away.events.AssetEvent.ANIMATION_SET_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	loader.removeEventListener(away.events.AssetEvent.ANIMATION_STATE_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	loader.removeEventListener(away.events.AssetEvent.ANIMATION_NODE_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	loader.removeEventListener(away.events.AssetEvent.STATE_TRANSITION_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	loader.removeEventListener(away.events.AssetEvent.TEXTURE_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	loader.removeEventListener(away.events.AssetEvent.CONTAINER_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	loader.removeEventListener(away.events.AssetEvent.GEOMETRY_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	loader.removeEventListener(away.events.AssetEvent.MATERIAL_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	loader.removeEventListener(away.events.AssetEvent.MESH_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	loader.removeEventListener(away.events.AssetEvent.ENTITY_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	loader.removeEventListener(away.events.AssetEvent.SKELETON_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	loader.removeEventListener(away.events.AssetEvent.SKELETON_POSE_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	loader.removeEventListener(away.events.ParserEvent.PARSE_ERROR, $createStaticDelegate(this, this.onParserError), this);
};

away.loaders.AssetLoader.prototype.stop = function() {
	this.dispose();
};

away.loaders.AssetLoader.prototype.dispose = function() {
	this._errorHandlers = null;
	this._parseErrorHandlers = null;
	this._context = null;
	this._token = null;
	this._stack = null;
	if (this._loadingDependency && this._loadingDependency._iLoader) {
		this.removeEventListeners(this._loadingDependency._iLoader);
	}
	this._loadingDependency = null;
};

away.loaders.AssetLoader.prototype._iAddParseErrorHandler = function(handler) {
	if (this._parseErrorHandlers.indexOf(handler, 0) < 0) {
		this._parseErrorHandlers.push(handler);
	}
};

away.loaders.AssetLoader.prototype._iAddErrorHandler = function(handler) {
	if (this._errorHandlers.indexOf(handler, 0) < 0) {
		this._errorHandlers.push(handler);
	}
};

$inherit(away.loaders.AssetLoader, away.events.EventDispatcher);

away.loaders.AssetLoader.className = "away.loaders.AssetLoader";

away.loaders.AssetLoader.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.loaders.misc.AssetLoaderContext');
	p.push('away.loaders.misc.ResourceDependency');
	p.push('away.core.net.URLRequest');
	p.push('*away.library.assets.IAsset');
	p.push('away.events.ParserEvent');
	p.push('away.events.LoaderEvent');
	p.push('away.loaders.misc.SingleFileLoader');
	p.push('away.events.AssetEvent');
	p.push('away.loaders.misc.AssetLoaderToken');
	return p;
};

away.loaders.AssetLoader.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.loaders.AssetLoader.injectionPoints = function(t) {
	var p;
	switch (t) {
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

