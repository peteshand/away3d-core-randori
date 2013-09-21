/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 21 16:02:37 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.library == "undefined")
	away.library = {};

away.library.AssetLibrary = function(se) {
	se = se;
};

away.library.AssetLibrary._iInstances = {};

away.library.AssetLibrary.getBundle = function(key) {
	return away.library.AssetLibraryBundle.getInstance(key);
};

away.library.AssetLibrary.enableParser = function(parserClass) {
	away.loaders.misc.SingleFileLoader.enableParser(parserClass);
};

away.library.AssetLibrary.enableParsers = function(parserClasses) {
	away.loaders.misc.SingleFileLoader.enableParsers(parserClasses);
};

away.library.AssetLibrary.get_conflictStrategy = function() {
	return away.library.AssetLibrary.getBundle("default").get_conflictStrategy();
};

away.library.AssetLibrary.set_conflictStrategy = function(val) {
	away.library.AssetLibrary.getBundle("default").set_conflictStrategy(val);
};

away.library.AssetLibrary.get_conflictPrecedence = function() {
	return away.library.AssetLibrary.getBundle("default").get_conflictPrecedence();
};

away.library.AssetLibrary.set_conflictPrecedence = function(val) {
	away.library.AssetLibrary.getBundle("default").set_conflictPrecedence(val);
};

away.library.AssetLibrary.createIterator = function(assetTypeFilter, namespaceFilter, filterFunc) {
	return away.library.AssetLibrary.getBundle("default").createIterator(assetTypeFilter, namespaceFilter, filterFunc);
};

away.library.AssetLibrary.load = function(req, context, ns, parser) {
	return away.library.AssetLibrary.getBundle("default").load(req, context, ns, parser);
};

away.library.AssetLibrary.loadData = function(data, context, ns, parser) {
	return away.library.AssetLibrary.getBundle("default").loadData(data, context, ns, parser);
};

away.library.AssetLibrary.stopLoad = function() {
	away.library.AssetLibrary.getBundle("default").stopAllLoadingSessions();
};

away.library.AssetLibrary.getAsset = function(name, ns) {
	return away.library.AssetLibrary.getBundle("default").getAsset(name, ns);
};

away.library.AssetLibrary.addEventListener = function(type, listener, target) {
	away.library.AssetLibrary.getBundle("default").addEventListener(type, $createStaticDelegate(this, listener), target);
};

away.library.AssetLibrary.removeEventListener = function(type, listener, target) {
	away.library.AssetLibrary.getBundle("default").removeEventListener(type, $createStaticDelegate(this, listener), target);
};

away.library.AssetLibrary.addAsset = function(asset) {
	away.library.AssetLibrary.getBundle("default").addAsset(asset);
};

away.library.AssetLibrary.removeAsset = function(asset, dispose) {
	away.library.AssetLibrary.getBundle("default").removeAsset(asset, dispose);
};

away.library.AssetLibrary.removeAssetByName = function(name, ns, dispose) {
	return away.library.AssetLibrary.getBundle("default").removeAssetByName(name, ns, dispose);
};

away.library.AssetLibrary.removeAllAssets = function(dispose) {
	away.library.AssetLibrary.getBundle("default").removeAllAssets(dispose);
};

away.library.AssetLibrary.removeNamespaceAssets = function(ns, dispose) {
	away.library.AssetLibrary.getBundle("default").removeNamespaceAssets(ns, dispose);
};

away.library.AssetLibrary.className = "away.library.AssetLibrary";

away.library.AssetLibrary.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.library.AssetLibraryBundle');
	p.push('away.loaders.misc.SingleFileLoader');
	return p;
};

away.library.AssetLibrary.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.library.AssetLibrary.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'se', t:'away.library.AssetLibrary$AssetLibrarySingletonEnforcer'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

