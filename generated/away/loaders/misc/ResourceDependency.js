/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 04 21:18:37 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.loaders == "undefined")
	away.loaders = {};
if (typeof away.loaders.misc == "undefined")
	away.loaders.misc = {};

away.loaders.misc.ResourceDependency = function(id, req, data, parentParser, retrieveAsRawData, suppressAssetEvents) {
	this._iSuccess = null;
	this._req = null;
	this._id = null;
	this._parentParser = null;
	this._suppressAssetEvents = null;
	this._dependencies = null;
	this._data = null;
	this._iLoader = null;
	this._assets = null;
	this._retrieveAsRawData = null;
	this._id = id;
	this._req = req;
	this._parentParser = parentParser;
	this._data = data;
	this._retrieveAsRawData = retrieveAsRawData;
	this._suppressAssetEvents = suppressAssetEvents;
	this._assets = [];
	this._dependencies = [];
};

away.loaders.misc.ResourceDependency.prototype.get_id = function() {
	return this._id;
};

away.loaders.misc.ResourceDependency.prototype.get_assets = function() {
	return this._assets;
};

away.loaders.misc.ResourceDependency.prototype.get_dependencies = function() {
	return this._dependencies;
};

away.loaders.misc.ResourceDependency.prototype.get_request = function() {
	return this._req;
};

away.loaders.misc.ResourceDependency.prototype.get_retrieveAsRawData = function() {
	return this._retrieveAsRawData;
};

away.loaders.misc.ResourceDependency.prototype.get_suppresAssetEvents = function() {
	return this._suppressAssetEvents;
};

away.loaders.misc.ResourceDependency.prototype.get_data = function() {
	return this._data;
};

away.loaders.misc.ResourceDependency.prototype._iSetData = function(data) {
	this._data = data;
};

away.loaders.misc.ResourceDependency.prototype.get_parentParser = function() {
	return this._parentParser;
};

away.loaders.misc.ResourceDependency.prototype.resolve = function() {
	if (this._parentParser)
		this._parentParser._iResolveDependency(this);
};

away.loaders.misc.ResourceDependency.prototype.resolveFailure = function() {
	if (this._parentParser)
		this._parentParser._iResolveDependencyFailure(this);
};

away.loaders.misc.ResourceDependency.prototype.resolveName = function(asset) {
	if (this._parentParser)
		return this._parentParser._iResolveDependencyName(this, asset);
	return asset.get_name();
};

away.loaders.misc.ResourceDependency.className = "away.loaders.misc.ResourceDependency";

away.loaders.misc.ResourceDependency.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.loaders.misc.ResourceDependency.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.loaders.misc.ResourceDependency.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'id', t:'String'});
			p.push({n:'req', t:'away.net.URLRequest'});
			p.push({n:'data', t:'Object'});
			p.push({n:'parentParser', t:'away.loaders.parsers.ParserBase'});
			p.push({n:'retrieveAsRawData', t:'Boolean'});
			p.push({n:'suppressAssetEvents', t:'Boolean'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

