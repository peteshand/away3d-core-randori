/** Compiled by the Randori compiler v0.2.6.2 on Thu Sep 05 22:44:46 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.library == "undefined")
	away.library = {};
if (typeof away.library.assets == "undefined")
	away.library.assets = {};

away.library.assets.NamedAssetBase = function(name) {
	this._full_path = null;
	this._name = null;
	this._assetType = null;
	this._namespace = null;
	this._originalName = null;
	this._id = null;
	away.events.EventDispatcher.call(this);
	if (name == null)
		name = "null";
	this._name = name;
	this._originalName = name;
	this.updateFullPath();
};

away.library.assets.NamedAssetBase.DEFAULT_NAMESPACE = "default";

away.library.assets.NamedAssetBase.prototype.get_originalName = function() {
	return this._originalName;
};

away.library.assets.NamedAssetBase.prototype.get_id = function() {
	return this._id;
};

away.library.assets.NamedAssetBase.prototype.set_id = function(newID) {
	this._id = newID;
};

away.library.assets.NamedAssetBase.prototype.get_assetType = function() {
	return this._assetType;
};

away.library.assets.NamedAssetBase.prototype.set_assetType = function(type) {
	this._assetType = type;
};

away.library.assets.NamedAssetBase.prototype.get_name = function() {
	return this._name;
};

away.library.assets.NamedAssetBase.prototype.set_name = function(val) {
	var prev;
	prev = this._name;
	this._name = val;
	if (this._name == null) {
		this._name = "null";
	}
	this.updateFullPath();
	this.dispatchEvent(new away.events.AssetEvent(away.events.AssetEvent.ASSET_RENAME, this, prev));
};

away.library.assets.NamedAssetBase.prototype.dispose = function() {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.library.assets.NamedAssetBase.prototype.get_assetNamespace = function() {
	return this._namespace;
};

away.library.assets.NamedAssetBase.prototype.get_assetFullPath = function() {
	return this._full_path;
};

away.library.assets.NamedAssetBase.prototype.assetPathEquals = function(name, ns) {
	return (this._name == name && (!ns || this._namespace == ns));
};

away.library.assets.NamedAssetBase.prototype.resetAssetPath = function(name, ns, overrideOriginal) {
	this._name = name ? name : "null";
	this._namespace = ns ? ns : away.library.assets.NamedAssetBase.DEFAULT_NAMESPACE;
	if (overrideOriginal) {
		this._originalName = this._name;
	}
	this.updateFullPath();
};

away.library.assets.NamedAssetBase.prototype.updateFullPath = function() {
	this._full_path = [this._namespace, this._name];
};

$inherit(away.library.assets.NamedAssetBase, away.events.EventDispatcher);

away.library.assets.NamedAssetBase.className = "away.library.assets.NamedAssetBase";

away.library.assets.NamedAssetBase.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.errors.AbstractMethodError');
	p.push('away.events.AssetEvent');
	return p;
};

away.library.assets.NamedAssetBase.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.library.assets.NamedAssetBase.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'name', t:'String'});
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

