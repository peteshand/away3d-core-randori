/** Compiled by the Randori compiler v0.2.6.2 on Thu Sep 05 22:44:46 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.loaders == "undefined")
	away.loaders = {};
if (typeof away.loaders.misc == "undefined")
	away.loaders.misc = {};

away.loaders.misc.SingleFileURLLoader = function() {
	this._loader = null;
	this._data = null;
	away.events.EventDispatcher.call(this);
	this.initLoader();
};

away.loaders.misc.SingleFileURLLoader.prototype.load = function(req) {
	this._loader.load(req);
};

away.loaders.misc.SingleFileURLLoader.prototype.dispose = function() {
	this.disposeLoader();
	this._data = null;
};

away.loaders.misc.SingleFileURLLoader.prototype.get_data = function() {
	return this._loader.get_data();
};

away.loaders.misc.SingleFileURLLoader.prototype.get_dataFormat = function() {
	return this._loader.get_dataFormat();
};

away.loaders.misc.SingleFileURLLoader.prototype.set_dataFormat = function(value) {
	this._loader.set_dataFormat(value);
};

away.loaders.misc.SingleFileURLLoader.prototype.initLoader = function() {
	if (!this._loader) {
		this._loader = new away.net.URLLoader();
		this._loader.addEventListener(away.events.Event.COMPLETE, $createStaticDelegate(this, this.onLoadComplete), this);
		this._loader.addEventListener(away.events.IOErrorEvent.IO_ERROR, $createStaticDelegate(this, this.onLoadError), this);
	}
};

away.loaders.misc.SingleFileURLLoader.prototype.disposeLoader = function() {
	if (this._loader) {
		this._loader.dispose();
		this._loader.removeEventListener(away.events.Event.COMPLETE, $createStaticDelegate(this, this.onLoadComplete), this);
		this._loader.removeEventListener(away.events.IOErrorEvent.IO_ERROR, $createStaticDelegate(this, this.onLoadError), this);
		this._loader = null;
	}
};

away.loaders.misc.SingleFileURLLoader.prototype.onLoadComplete = function(event) {
	this.dispatchEvent(event);
};

away.loaders.misc.SingleFileURLLoader.prototype.onLoadError = function(event) {
	this.dispatchEvent(event);
};

$inherit(away.loaders.misc.SingleFileURLLoader, away.events.EventDispatcher);

away.loaders.misc.SingleFileURLLoader.className = "away.loaders.misc.SingleFileURLLoader";

away.loaders.misc.SingleFileURLLoader.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.net.URLLoader');
	p.push('away.events.Event');
	p.push('away.events.IOErrorEvent');
	return p;
};

away.loaders.misc.SingleFileURLLoader.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.loaders.misc.SingleFileURLLoader.injectionPoints = function(t) {
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

