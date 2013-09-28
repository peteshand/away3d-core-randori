/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 28 11:54:47 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.loaders == "undefined")
	away.loaders = {};
if (typeof away.loaders.misc == "undefined")
	away.loaders.misc = {};

away.loaders.misc.AssetLoaderToken = function(loader) {
	this._iLoader = null;
	away.events.EventDispatcher.call(this);
	this._iLoader = loader;
};

away.loaders.misc.AssetLoaderToken.prototype.addEventListener = function(type, listener, target) {
	this._iLoader.addEventListener(type, $createStaticDelegate(this, listener), target);
};

away.loaders.misc.AssetLoaderToken.prototype.removeEventListener = function(type, listener, target) {
	this._iLoader.removeEventListener(type, $createStaticDelegate(this, listener), target);
};

away.loaders.misc.AssetLoaderToken.prototype.hasEventListener = function(type, listener, target) {
	listener = listener || null;
	target = target || null;
	return this._iLoader.hasEventListener(type, $createStaticDelegate(this, listener), target);
};

$inherit(away.loaders.misc.AssetLoaderToken, away.events.EventDispatcher);

away.loaders.misc.AssetLoaderToken.className = "away.loaders.misc.AssetLoaderToken";

away.loaders.misc.AssetLoaderToken.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.loaders.misc.AssetLoaderToken.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.loaders.misc.AssetLoaderToken.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'loader', t:'away.loaders.AssetLoader'});
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

