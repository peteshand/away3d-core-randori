/** Compiled by the Randori compiler v0.2.6.2 on Sun Sep 22 11:20:03 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.library == "undefined")
	away.library = {};
if (typeof away.library.utils == "undefined")
	away.library.utils = {};

away.library.utils.AssetLibraryIterator = function(assets, assetTypeFilter, namespaceFilter, filterFunc) {
	this._assets = null;
	this._filtered = null;
	this._idx = 0;
	this._assets = assets;
	this.filter(assetTypeFilter, namespaceFilter, filterFunc);
};

away.library.utils.AssetLibraryIterator.prototype.get_currentAsset = function() {
	return (this._idx < this._filtered.length) ? this._filtered[this._idx] : null;
};

away.library.utils.AssetLibraryIterator.prototype.get_numAssets = function() {
	return this._filtered.length;
};

away.library.utils.AssetLibraryIterator.prototype.next = function() {
	var next = null;
	if (this._idx < this._filtered.length)
		next = this._filtered[this._idx];
	this._idx++;
	return next;
};

away.library.utils.AssetLibraryIterator.prototype.reset = function() {
	this._idx = 0;
};

away.library.utils.AssetLibraryIterator.prototype.setIndex = function(index) {
	this._idx = index;
};

away.library.utils.AssetLibraryIterator.prototype.filter = function(assetTypeFilter, namespaceFilter, filterFunc) {
	if (assetTypeFilter || namespaceFilter) {
		var idx;
		var asset;
		idx = 0;
		this._filtered = [];
		var l = this._assets.length;
		for (var c = 0; c < l; c++) {
			asset = this._assets[c];
			if (assetTypeFilter && asset.get_assetType() != assetTypeFilter)
				continue;
			if (namespaceFilter && asset.get_assetNamespace() != namespaceFilter)
				continue;
			if (filterFunc != null && !filterFunc(asset))
				continue;
			this._filtered[idx++] = asset;
		}
	} else {
		this._filtered = this._assets;
	}
};

away.library.utils.AssetLibraryIterator.className = "away.library.utils.AssetLibraryIterator";

away.library.utils.AssetLibraryIterator.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.library.utils.AssetLibraryIterator.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.library.utils.AssetLibraryIterator.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'assets', t:'Array'});
			p.push({n:'assetTypeFilter', t:'String'});
			p.push({n:'namespaceFilter', t:'String'});
			p.push({n:'filterFunc', t:'Object'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

