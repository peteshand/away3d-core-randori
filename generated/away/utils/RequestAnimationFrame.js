/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 03 00:08:02 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.utils == "undefined")
	away.utils = {};

away.utils.RequestAnimationFrame = function(callback, callbackContext) {
	this._active = false;
	this._dt = 0;
	this._currentTime = 0;
	this._prevTime = 0;
	this._callbackContext = null;
	this._argsArray = [];
	this._rafUpdateFunction = null;
	this._callback = null;
	this.setCallback($createStaticDelegate(this, callback), callbackContext);
	var that = this;
	this._rafUpdateFunction = function() {
		if (that._active) {
			that._tick();
		}
	};
	this._argsArray.push(this._dt);
};

away.utils.RequestAnimationFrame.prototype.setCallback = function(callback, callbackContext) {
	this._callback = callback;
	this._callbackContext = callbackContext;
};

away.utils.RequestAnimationFrame.prototype.start = function() {
	this._prevTime = new Date().getTime();
	this._active = true;
	if (window["mozRequestAnimationFrame"]) {
		window.requestAnimationFrame = window["mozRequestAnimationFrame"];
	} else if (window["webkitRequestAnimationFrame"]) {
		window.requestAnimationFrame = window["webkitRequestAnimationFrame"];
	} else if (window["oRequestAnimationFrame"]) {
		window.requestAnimationFrame = window["oRequestAnimationFrame"];
	}
	if (window.requestAnimationFrame) {
		window.requestAnimationFrame(this._rafUpdateFunction);
	}
};

away.utils.RequestAnimationFrame.prototype.stop = function() {
	this._active = false;
};

away.utils.RequestAnimationFrame.prototype.get_active = function() {
	return this._active;
};

away.utils.RequestAnimationFrame.prototype._tick = function() {
	this._currentTime = new Date().getTime();
	this._dt = this._currentTime - this._prevTime;
	this._argsArray[0] = this._dt;
	this._callback.apply(this._callbackContext, this._argsArray);
	window.requestAnimationFrame(this._rafUpdateFunction);
	this._prevTime = this._currentTime;
};

away.utils.RequestAnimationFrame.className = "away.utils.RequestAnimationFrame";

away.utils.RequestAnimationFrame.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.utils.RequestAnimationFrame.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.utils.RequestAnimationFrame.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'callback', t:'Function'});
			p.push({n:'callbackContext', t:'Object'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

