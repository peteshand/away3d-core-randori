/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:40 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.net == "undefined")
	away.core.net = {};

away.core.net.IMGLoader = function(imageName) {
	this._name = "";
	this._crossOrigin = null;
	this._request = null;
	this._loaded = false;
	this._image = null;
	imageName = imageName || "";
	away.events.EventDispatcher.call(this);
	this._name = imageName;
	this.initImage();
};

away.core.net.IMGLoader.prototype.load = function(request) {
	this._loaded = false;
	this._request = request;
	if (this._crossOrigin) {
		if (this._image["crossOrigin"] != null) {
			this._image["crossOrigin"] = this._crossOrigin;
		}
	}
	this._image.src = this._request.get_url();
};

away.core.net.IMGLoader.prototype.dispose = function() {
	if (this._image) {
		this._image.onabort = null;
		this._image.onerror = null;
		this._image.onload = null;
		this._image = null;
	}
	if (this._request) {
		this._request = null;
	}
};

away.core.net.IMGLoader.prototype.get_image = function() {
	return this._image;
};

away.core.net.IMGLoader.prototype.get_loaded = function() {
	return this._loaded;
};

away.core.net.IMGLoader.prototype.get_crossOrigin = function() {
	return this._crossOrigin;
};

away.core.net.IMGLoader.prototype.set_crossOrigin = function(value) {
	this._crossOrigin = value;
};

away.core.net.IMGLoader.prototype.get_width = function() {
	if (this._image) {
		return this._image.width;
	}
	return null;
};

away.core.net.IMGLoader.prototype.get_height = function() {
	if (this._image) {
		return this._image.height;
	}
	return null;
};

away.core.net.IMGLoader.prototype.get_request = function() {
	return this._request;
};

away.core.net.IMGLoader.prototype.get_name = function() {
	if (this._image) {
		return this._image.name;
	}
	return this._name;
};

away.core.net.IMGLoader.prototype.set_name = function(value) {
	if (this._image) {
		this._image.name = value;
	}
	this._name = value;
};

away.core.net.IMGLoader.prototype.initImage = function() {
	var that = this;
	if (!this._image) {
		this._image = document.createElement('img');
		this._image.onabort = function(event) {
			that.onAbort(event);
		};
		this._image.onerror = function(event) {
			that.onError(event);
		};
		this._image.onload = function(event) {
			that.onLoadComplete(event);
		};
		this._image.name = this._name;
	}
};

away.core.net.IMGLoader.prototype.onAbort = function(event) {
	this.dispatchEvent(new away.events.Event(away.events.IOErrorEvent.IO_ERROR));
};

away.core.net.IMGLoader.prototype.onError = function(event) {
	this.dispatchEvent(new away.events.Event(away.events.IOErrorEvent.IO_ERROR));
};

away.core.net.IMGLoader.prototype.onLoadComplete = function(event) {
	this._loaded = true;
	this.dispatchEvent(new away.events.Event(away.events.Event.COMPLETE));
};

$inherit(away.core.net.IMGLoader, away.events.EventDispatcher);

away.core.net.IMGLoader.className = "away.core.net.IMGLoader";

away.core.net.IMGLoader.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.events.Event');
	p.push('away.events.IOErrorEvent');
	return p;
};

away.core.net.IMGLoader.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.core.net.IMGLoader.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'imageName', t:'String'});
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

