/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 04 21:18:27 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.loaders == "undefined")
	away.loaders = {};
if (typeof away.loaders.misc == "undefined")
	away.loaders.misc = {};

away.loaders.misc.AssetLoaderContext = function(includeDependencies, dependencyBaseUrl) {
	this._includeDependencies = null;
	this._materialMode = 0;
	this._overrideAbsPath = null;
	this._remappedUrls = null;
	this._dependencyBaseUrl = null;
	this._overrideFullUrls = null;
	this._embeddedDataByUrl = null;
	this._includeDependencies = includeDependencies;
	this._dependencyBaseUrl = dependencyBaseUrl || "";
	this._embeddedDataByUrl = {};
	this._remappedUrls = {};
	this._materialMode = away.loaders.misc.AssetLoaderContext.UNDEFINED;
};

away.loaders.misc.AssetLoaderContext.UNDEFINED = 0;

away.loaders.misc.AssetLoaderContext.SINGLEPASS_MATERIALS = 1;

away.loaders.misc.AssetLoaderContext.MULTIPASS_MATERIALS = 2;

away.loaders.misc.AssetLoaderContext.prototype.get_includeDependencies = function() {
	return this._includeDependencies;
};

away.loaders.misc.AssetLoaderContext.prototype.set_includeDependencies = function(val) {
	this._includeDependencies = val;
};

away.loaders.misc.AssetLoaderContext.prototype.get_materialMode = function() {
	return this._materialMode;
};

away.loaders.misc.AssetLoaderContext.prototype.set_materialMode = function(materialMode) {
	this._materialMode = materialMode;
};

away.loaders.misc.AssetLoaderContext.prototype.get_dependencyBaseUrl = function() {
	return this._dependencyBaseUrl;
};

away.loaders.misc.AssetLoaderContext.prototype.set_dependencyBaseUrl = function(val) {
	this._dependencyBaseUrl = val;
};

away.loaders.misc.AssetLoaderContext.prototype.get_overrideAbsolutePaths = function() {
	return this._overrideAbsPath;
};

away.loaders.misc.AssetLoaderContext.prototype.set_overrideAbsolutePaths = function(val) {
	this._overrideAbsPath = val;
};

away.loaders.misc.AssetLoaderContext.prototype.get_overrideFullURLs = function() {
	return this._overrideFullUrls;
};

away.loaders.misc.AssetLoaderContext.prototype.set_overrideFullURLs = function(val) {
	this._overrideFullUrls = val;
};

away.loaders.misc.AssetLoaderContext.prototype.mapUrl = function(originalUrl, newUrl) {
	this._remappedUrls[originalUrl] = newUrl;
};

away.loaders.misc.AssetLoaderContext.prototype.mapUrlToData = function(originalUrl, data) {
	this._embeddedDataByUrl[originalUrl] = data;
};

away.loaders.misc.AssetLoaderContext.prototype._iHasDataForUrl = function(url) {
	return this._embeddedDataByUrl.hasOwnProperty(url);
};

away.loaders.misc.AssetLoaderContext.prototype._iGetDataForUrl = function(url) {
	return this._embeddedDataByUrl[url];
};

away.loaders.misc.AssetLoaderContext.prototype._iHasMappingForUrl = function(url) {
	return this._remappedUrls.hasOwnProperty(url);
};

away.loaders.misc.AssetLoaderContext.prototype._iGetRemappedUrl = function(originalUrl) {
	return this._remappedUrls[originalUrl];
};

away.loaders.misc.AssetLoaderContext.className = "away.loaders.misc.AssetLoaderContext";

away.loaders.misc.AssetLoaderContext.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.loaders.misc.AssetLoaderContext.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.loaders.misc.AssetLoaderContext.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'includeDependencies', t:'Boolean'});
			p.push({n:'dependencyBaseUrl', t:'String'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

