/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:06 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.loaders == "undefined")
	away.loaders = {};

away.loaders.Loader3D = function(useAssetLibrary, assetLibraryId) {
	this._assetLibId = null;
	this._loadingSessions = null;
	this._useAssetLib = false;
	assetLibraryId = assetLibraryId || null;
	away.containers.ObjectContainer3D.call(this);
	this._loadingSessions = [];
	this._useAssetLib = useAssetLibrary;
	this._assetLibId = assetLibraryId;
};

away.loaders.Loader3D.prototype.load = function(req, context, ns, parser) {
	context = context || null;
	ns = ns || null;
	parser = parser || null;
	var token;
	if (this._useAssetLib) {
		var lib;
		lib = away.library.AssetLibraryBundle.getInstance(this._assetLibId);
		token = lib.load(req, context, ns, parser);
	} else {
		var loader = new away.loaders.AssetLoader();
		this._loadingSessions.push(loader);
		token = loader.load(req, context, ns, parser);
	}
	token.addEventListener(away.events.LoaderEvent.RESOURCE_COMPLETE, $createStaticDelegate(this, this.onResourceRetrieved), this);
	token.addEventListener(away.events.AssetEvent.ASSET_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	token.addEventListener(away.events.AssetEvent.ANIMATION_SET_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	token.addEventListener(away.events.AssetEvent.ANIMATION_STATE_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	token.addEventListener(away.events.AssetEvent.ANIMATION_NODE_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	token.addEventListener(away.events.AssetEvent.STATE_TRANSITION_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	token.addEventListener(away.events.AssetEvent.TEXTURE_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	token.addEventListener(away.events.AssetEvent.CONTAINER_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	token.addEventListener(away.events.AssetEvent.GEOMETRY_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	token.addEventListener(away.events.AssetEvent.MATERIAL_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	token.addEventListener(away.events.AssetEvent.MESH_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	token.addEventListener(away.events.AssetEvent.ENTITY_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	token.addEventListener(away.events.AssetEvent.SKELETON_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	token.addEventListener(away.events.AssetEvent.SKELETON_POSE_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	token._iLoader._iAddErrorHandler($createStaticDelegate(this, this.onDependencyRetrievingError));
	token._iLoader._iAddParseErrorHandler($createStaticDelegate(this, this.onDependencyRetrievingParseError));
	return token;
};

away.loaders.Loader3D.prototype.loadData = function(data, context, ns, parser) {
	context = context || null;
	ns = ns || null;
	parser = parser || null;
	var token;
	if (this._useAssetLib) {
		var lib;
		lib = away.library.AssetLibraryBundle.getInstance(this._assetLibId);
		token = lib.loadData(data, context, ns, parser);
	} else {
		var loader = new away.loaders.AssetLoader();
		this._loadingSessions.push(loader);
		token = loader.loadData(data, "", context, ns, parser);
	}
	token.addEventListener(away.events.LoaderEvent.RESOURCE_COMPLETE, $createStaticDelegate(this, this.onResourceRetrieved), this);
	token.addEventListener(away.events.AssetEvent.ASSET_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	token.addEventListener(away.events.AssetEvent.ANIMATION_SET_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	token.addEventListener(away.events.AssetEvent.ANIMATION_STATE_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	token.addEventListener(away.events.AssetEvent.ANIMATION_NODE_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	token.addEventListener(away.events.AssetEvent.STATE_TRANSITION_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	token.addEventListener(away.events.AssetEvent.TEXTURE_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	token.addEventListener(away.events.AssetEvent.CONTAINER_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	token.addEventListener(away.events.AssetEvent.GEOMETRY_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	token.addEventListener(away.events.AssetEvent.MATERIAL_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	token.addEventListener(away.events.AssetEvent.MESH_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	token.addEventListener(away.events.AssetEvent.ENTITY_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	token.addEventListener(away.events.AssetEvent.SKELETON_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	token.addEventListener(away.events.AssetEvent.SKELETON_POSE_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	token._iLoader._iAddErrorHandler($createStaticDelegate(this, this.onDependencyRetrievingError));
	token._iLoader._iAddParseErrorHandler($createStaticDelegate(this, this.onDependencyRetrievingParseError));
	return token;
};

away.loaders.Loader3D.prototype.stopLoad = function() {
	if (this._useAssetLib) {
		var lib;
		lib = away.library.AssetLibraryBundle.getInstance(this._assetLibId);
		lib.stopAllLoadingSessions();
		this._loadingSessions = null;
		return;
	}
	var i;
	var length = this._loadingSessions.length;
	for (i = 0; i < length; i++) {
		this.removeListeners(this._loadingSessions[i]);
		this._loadingSessions[i].stop();
		this._loadingSessions[i] = null;
	}
	this._loadingSessions = null;
};

away.loaders.Loader3D.enableParser = function(parserClass) {
	away.loaders.misc.SingleFileLoader.enableParser(parserClass);
};

away.loaders.Loader3D.enableParsers = function(parserClasses) {
	away.loaders.misc.SingleFileLoader.enableParsers(parserClasses);
};

away.loaders.Loader3D.prototype.removeListeners = function(dispatcher) {
	dispatcher.removeEventListener(away.events.LoaderEvent.RESOURCE_COMPLETE, $createStaticDelegate(this, this.onResourceRetrieved), this);
	dispatcher.removeEventListener(away.events.AssetEvent.ASSET_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	dispatcher.removeEventListener(away.events.AssetEvent.ANIMATION_SET_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	dispatcher.removeEventListener(away.events.AssetEvent.ANIMATION_STATE_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	dispatcher.removeEventListener(away.events.AssetEvent.ANIMATION_NODE_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	dispatcher.removeEventListener(away.events.AssetEvent.STATE_TRANSITION_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	dispatcher.removeEventListener(away.events.AssetEvent.TEXTURE_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	dispatcher.removeEventListener(away.events.AssetEvent.CONTAINER_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	dispatcher.removeEventListener(away.events.AssetEvent.GEOMETRY_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	dispatcher.removeEventListener(away.events.AssetEvent.MATERIAL_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	dispatcher.removeEventListener(away.events.AssetEvent.MESH_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	dispatcher.removeEventListener(away.events.AssetEvent.ENTITY_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	dispatcher.removeEventListener(away.events.AssetEvent.SKELETON_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	dispatcher.removeEventListener(away.events.AssetEvent.SKELETON_POSE_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
};

away.loaders.Loader3D.prototype.onAssetComplete = function(ev) {
	if (ev.type == away.events.AssetEvent.ASSET_COMPLETE) {
		var obj;
		switch (ev.get_asset().get_assetType()) {
			case away.library.assets.AssetType.LIGHT:
				obj = ev.get_asset();
				break;
			case away.library.assets.AssetType.CONTAINER:
				obj = ev.get_asset();
				break;
			case away.library.assets.AssetType.MESH:
				obj = ev.get_asset();
				break;
				break;
				break;
			case away.library.assets.AssetType.CAMERA:
				obj = ev.get_asset();
				break;
			case away.library.assets.AssetType.SEGMENT_SET:
				obj = ev.get_asset();
				break;
		}
		if (obj && obj.get_parent() == null)
			this.addChild(obj);
	}
	this.dispatchEvent(ev.clone());
};

away.loaders.Loader3D.prototype.onDependencyRetrievingError = function(event) {
	if (this.hasEventListener(away.events.LoaderEvent.LOAD_ERROR, $createStaticDelegate(this, this.onDependencyRetrievingError), this)) {
		this.dispatchEvent(event);
		return true;
	} else {
		return false;
	}
};

away.loaders.Loader3D.prototype.onDependencyRetrievingParseError = function(event) {
	if (this.hasEventListener(away.events.ParserEvent.PARSE_ERROR, $createStaticDelegate(this, this.onDependencyRetrievingParseError), this)) {
		this.dispatchEvent(event);
		return true;
	} else {
		return false;
	}
};

away.loaders.Loader3D.prototype.onResourceRetrieved = function(event) {
	var loader = event.target;
	this.dispatchEvent(event.clone());
};

$inherit(away.loaders.Loader3D, away.containers.ObjectContainer3D);

away.loaders.Loader3D.className = "away.loaders.Loader3D";

away.loaders.Loader3D.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.library.AssetLibraryBundle');
	p.push('away.loaders.AssetLoader');
	p.push('away.events.ParserEvent');
	p.push('away.events.LoaderEvent');
	p.push('away.loaders.misc.SingleFileLoader');
	p.push('away.events.AssetEvent');
	p.push('away.library.assets.AssetType');
	return p;
};

away.loaders.Loader3D.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.loaders.Loader3D.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'useAssetLibrary', t:'Boolean'});
			p.push({n:'assetLibraryId', t:'String'});
			break;
		case 1:
			p = away.containers.ObjectContainer3D.injectionPoints(t);
			break;
		case 2:
			p = away.containers.ObjectContainer3D.injectionPoints(t);
			break;
		case 3:
			p = away.containers.ObjectContainer3D.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

