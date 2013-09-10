/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 10 22:28:15 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.library == "undefined")
	away.library = {};

away.library.AssetLibraryBundle = function(me) {
	this._loadingSessionsGarbage = [];
	this._strategyPreference = null;
	this._assetDictionary = null;
	this._assets = null;
	this._gcTimeoutIID = 0;
	this._assetDictDirty = null;
	this._strategy = null;
	this._loadingSessions = null;
	away.events.EventDispatcher.call(this);
	this._assets = [];
	this._assetDictionary = {};
	this._loadingSessions = [];
	this.set_conflictStrategy(away.library.naming.ConflictStrategy.IGNORE.create());
	this.set_conflictPrecedence(away.library.naming.ConflictPrecedence.FAVOR_NEW);
};

away.library.AssetLibraryBundle.getInstance = function(key) {
	if (!key) {
		key = "default";
	}
	if (!away.library.AssetLibrary._iInstances.hasOwnProperty(key)) {
		away.library.AssetLibrary._iInstances[key] = new away.library.AssetLibraryBundle(new away.library.AssetLibraryBundleSingletonEnforcer());
	}
	return away.library.AssetLibrary._iInstances[key];
};

away.library.AssetLibraryBundle.prototype.enableParser = function(parserClass) {
	away.loaders.misc.SingleFileLoader.enableParser(parserClass);
};

away.library.AssetLibraryBundle.prototype.enableParsers = function(parserClasses) {
	away.loaders.misc.SingleFileLoader.enableParsers(parserClasses);
};

away.library.AssetLibraryBundle.prototype.get_conflictStrategy = function() {
	return this._strategy;
};

away.library.AssetLibraryBundle.prototype.set_conflictStrategy = function(val) {
	if (!val) {
		throw new away.errors.Error("namingStrategy must not be null. To ignore naming, use AssetLibrary.IGNORE", 0, "");
	}
	this._strategy = val.create();
};

away.library.AssetLibraryBundle.prototype.get_conflictPrecedence = function() {
	return this._strategyPreference;
};

away.library.AssetLibraryBundle.prototype.set_conflictPrecedence = function(val) {
	this._strategyPreference = val;
};

away.library.AssetLibraryBundle.prototype.createIterator = function(assetTypeFilter, namespaceFilter, filterFunc) {
	return new away.library.utils.AssetLibraryIterator(this._assets, assetTypeFilter, namespaceFilter, filterFunc);
};

away.library.AssetLibraryBundle.prototype.load = function(req, context, ns, parser) {
	return this.loadResource(req, context, ns, parser);
};

away.library.AssetLibraryBundle.prototype.loadData = function(data, context, ns, parser) {
	return this.parseResource(data, context, ns, parser);
};

away.library.AssetLibraryBundle.prototype.getAsset = function(name, ns) {
	if (this._assetDictDirty) {
		this.rehashAssetDict();
	}
	if (ns == null) {
		ns = away.library.assets.NamedAssetBase.DEFAULT_NAMESPACE;
	}
	if (!this._assetDictionary.hasOwnProperty(ns)) {
		return null;
	}
	return this._assetDictionary[ns][name];
};

away.library.AssetLibraryBundle.prototype.addAsset = function(asset) {
	var ns;
	var old;
	if (this._assets.indexOf(asset, 0) >= 0) {
		return;
	}
	old = this.getAsset(asset.get_name(), asset.get_assetNamespace());
	ns = asset.get_assetNamespace() || away.library.assets.NamedAssetBase.DEFAULT_NAMESPACE;
	if (old != null) {
		this._strategy.resolveConflict(asset, old, this._assetDictionary[ns], this._strategyPreference);
	}
	asset.set_id(away.library.utils.IDUtil.createUID());
	this._assets.push(asset);
	if (!this._assetDictionary.hasOwnProperty(ns)) {
		this._assetDictionary[ns] = {};
	}
	this._assetDictionary[ns][asset.get_name()] = asset;
	asset.addEventListener(away.events.AssetEvent.ASSET_RENAME, $createStaticDelegate(this, this.onAssetRename), this);
	asset.addEventListener(away.events.AssetEvent.ASSET_CONFLICT_RESOLVED, $createStaticDelegate(this, this.onAssetConflictResolved), this);
};

away.library.AssetLibraryBundle.prototype.removeAsset = function(asset, dispose) {
	var idx;
	this.removeAssetFromDict(asset, true);
	asset.removeEventListener(away.events.AssetEvent.ASSET_RENAME, $createStaticDelegate(this, this.onAssetRename), this);
	asset.removeEventListener(away.events.AssetEvent.ASSET_CONFLICT_RESOLVED, $createStaticDelegate(this, this.onAssetConflictResolved), this);
	idx = this._assets.indexOf(asset, 0);
	if (idx >= 0) {
		this._assets.splice(idx, 1);
	}
	if (dispose) {
		asset.dispose();
	}
};

away.library.AssetLibraryBundle.prototype.removeAssetByName = function(name, ns, dispose) {
	var asset = this.getAsset(name, ns);
	if (asset) {
		this.removeAsset(asset, dispose);
	}
	return asset;
};

away.library.AssetLibraryBundle.prototype.removeAllAssets = function(dispose) {
	if (dispose) {
		var asset;
		for (var c = 0; c < this._assets.length; c++) {
			asset = this._assets[c];
			asset.dispose();
		}
	}
	this._assets.length = 0;
	this.rehashAssetDict();
};

away.library.AssetLibraryBundle.prototype.removeNamespaceAssets = function(ns, dispose) {
	var idx = 0;
	var asset;
	var old_assets;
	old_assets = this._assets.concat();
	this._assets.length = 0;
	if (ns == null) {
		ns = away.library.assets.NamedAssetBase.DEFAULT_NAMESPACE;
	}
	for (var d = 0; d < old_assets.length; d++) {
		asset = old_assets[d];
		if (asset.get_assetNamespace() == ns) {
			if (dispose) {
				asset.dispose();
			}
			this.removeAssetFromDict(asset, false);
		} else {
			this._assets[idx++] = asset;
		}
	}
	if (this._assetDictionary.hasOwnProperty(ns)) {
		delete this._assetDictionary[ns];
	}
};

away.library.AssetLibraryBundle.prototype.removeAssetFromDict = function(asset, autoRemoveEmptyNamespace) {
	if (this._assetDictDirty) {
		this.rehashAssetDict();
	}
	if (this._assetDictionary.hasOwnProperty(asset.get_assetNamespace())) {
		if (this._assetDictionary[asset.get_assetNamespace()].hasOwnProperty(asset.get_name())) {
			delete this._assetDictionary[asset.get_assetNamespace()][asset.get_name()];
		}
		if (autoRemoveEmptyNamespace) {
			var key;
			var empty = true;
			for (key in this._assetDictionary[asset.get_assetNamespace()]) {
				empty = false;
				break;
			}
			if (empty) {
				delete this._assetDictionary[asset.get_assetNamespace()];
			}
		}
	}
};

away.library.AssetLibraryBundle.prototype.loadResource = function(req, context, ns, parser) {
	var loader = new away.loaders.AssetLoader();
	if (!this._loadingSessions) {
		this._loadingSessions = [];
	}
	this._loadingSessions.push(loader);
	loader.addEventListener(away.events.LoaderEvent.RESOURCE_COMPLETE, $createStaticDelegate(this, this.onResourceRetrieved), this);
	loader.addEventListener(away.events.LoaderEvent.DEPENDENCY_COMPLETE, $createStaticDelegate(this, this.onDependencyRetrieved), this);
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
	loader._iAddErrorHandler($createStaticDelegate(this, this.onDependencyRetrievingError));
	loader._iAddParseErrorHandler($createStaticDelegate(this, this.onDependencyRetrievingParseError));
	return loader.load(req, context, ns, parser);
};

away.library.AssetLibraryBundle.prototype.stopAllLoadingSessions = function() {
	var i;
	if (!this._loadingSessions) {
		this._loadingSessions = [];
	}
	var length = this._loadingSessions.length;
	for (i = 0; i < length; i++) {
		this.killLoadingSession(this._loadingSessions[i]);
	}
	this._loadingSessions = null;
};

away.library.AssetLibraryBundle.prototype.parseResource = function(data, context, ns, parser) {
	var loader = new away.loaders.AssetLoader();
	if (!this._loadingSessions) {
		this._loadingSessions = [];
	}
	this._loadingSessions.push(loader);
	loader.addEventListener(away.events.LoaderEvent.RESOURCE_COMPLETE, $createStaticDelegate(this, this.onResourceRetrieved), this);
	loader.addEventListener(away.events.LoaderEvent.DEPENDENCY_COMPLETE, $createStaticDelegate(this, this.onDependencyRetrieved), this);
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
	loader._iAddErrorHandler($createStaticDelegate(this, this.onDependencyRetrievingError));
	loader._iAddParseErrorHandler($createStaticDelegate(this, this.onDependencyRetrievingParseError));
	return loader.loadData(data, "", context, ns, parser);
};

away.library.AssetLibraryBundle.prototype.rehashAssetDict = function() {
	var asset;
	this._assetDictionary = {};
	var l = this._assets.length;
	for (var c = 0; c < l; c++) {
		asset = this._assets[c];
		if (!this._assetDictionary.hasOwnProperty(asset.get_assetNamespace())) {
			this._assetDictionary[asset.get_assetNamespace()] = {};
		}
		this._assetDictionary[asset.get_assetNamespace()][asset.get_name()] = asset;
	}
	this._assetDictDirty = false;
};

away.library.AssetLibraryBundle.prototype.onDependencyRetrieved = function(event) {
	this.dispatchEvent(event);
};

away.library.AssetLibraryBundle.prototype.onDependencyRetrievingError = function(event) {
	if (this.hasEventListener(away.events.LoaderEvent.LOAD_ERROR, $createStaticDelegate(this, this.onDependencyRetrievingError), this)) {
		this.dispatchEvent(event);
		return true;
	} else {
		return false;
	}
};

away.library.AssetLibraryBundle.prototype.onDependencyRetrievingParseError = function(event) {
	if (this.hasEventListener(away.events.ParserEvent.PARSE_ERROR, $createStaticDelegate(this, this.onDependencyRetrievingParseError), this)) {
		this.dispatchEvent(event);
		return true;
	} else {
		return false;
	}
};

away.library.AssetLibraryBundle.prototype.onAssetComplete = function(event) {
	if (event.type == away.events.AssetEvent.ASSET_COMPLETE) {
		this.addAsset(event.get_asset());
	}
	this.dispatchEvent(event.clone());
};

away.library.AssetLibraryBundle.prototype.onTextureSizeError = function(event) {
	this.dispatchEvent(event.clone());
};

away.library.AssetLibraryBundle.prototype.onResourceRetrieved = function(event) {
	var loader = event.target;
	this.dispatchEvent(event.clone());
	var index = this._loadingSessions.indexOf(loader, 0);
	this._loadingSessions.splice(index, 1);
	this._loadingSessionsGarbage.push(loader);
	this._gcTimeoutIID = setTimeout($createStaticDelegate(this, this.loadingSessionGC), 100);
};

away.library.AssetLibraryBundle.prototype.loadingSessionGC = function() {
	var loader;
	while (this._loadingSessionsGarbage.length > 0) {
		loader = this._loadingSessionsGarbage.pop();
		this.killLoadingSession(loader);
	}
	clearTimeout(this._gcTimeoutIID);
	this._gcTimeoutIID = null;
};

away.library.AssetLibraryBundle.prototype.killLoadingSession = function(loader) {
	loader.removeEventListener(away.events.LoaderEvent.LOAD_ERROR, $createStaticDelegate(this, this.onDependencyRetrievingError), this);
	loader.removeEventListener(away.events.LoaderEvent.RESOURCE_COMPLETE, $createStaticDelegate(this, this.onResourceRetrieved), this);
	loader.removeEventListener(away.events.LoaderEvent.DEPENDENCY_COMPLETE, $createStaticDelegate(this, this.onDependencyRetrieved), this);
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
	loader.stop();
};

away.library.AssetLibraryBundle.prototype.onAssetRename = function(ev) {
	var asset = ev.target;
	var old = this.getAsset(asset.get_assetNamespace(), asset.get_name());
	if (old != null) {
		this._strategy.resolveConflict(asset, old, this._assetDictionary[asset.get_assetNamespace()], this._strategyPreference);
	} else {
		var dict = this._assetDictionary[ev.get_asset().get_assetNamespace()];
		if (dict == null) {
			return;
		}
		dict[ev.get_assetPrevName()] = null;
		dict[ev.get_asset().get_name()] = ev.get_asset();
	}
};

away.library.AssetLibraryBundle.prototype.onAssetConflictResolved = function(ev) {
	this.dispatchEvent(ev.clone());
};

$inherit(away.library.AssetLibraryBundle, away.events.EventDispatcher);

away.library.AssetLibraryBundle.className = "away.library.AssetLibraryBundle";

away.library.AssetLibraryBundle.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.library.naming.ConflictPrecedence');
	p.push('away.library.AssetLibrary');
	p.push('away.events.ParserEvent');
	p.push('away.events.LoaderEvent');
	p.push('away.library.utils.AssetLibraryIterator');
	p.push('away.library.utils.IDUtil');
	p.push('away.library.assets.NamedAssetBase');
	p.push('away.events.AssetEvent');
	p.push('away.library.naming.ConflictStrategy');
	p.push('away.loaders.AssetLoader');
	p.push('*away.library.assets.IAsset');
	p.push('away.library.AssetLibraryBundleSingletonEnforcer');
	p.push('away.loaders.misc.SingleFileLoader');
	return p;
};

away.library.AssetLibraryBundle.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.library.AssetLibraryBundle.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'me', t:'away.library.AssetLibraryBundleSingletonEnforcer'});
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

