/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 10 22:44:24 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.display == "undefined")
	away.display = {};

away.display.Stage3D = function(canvas) {
	this._x = 0;
	this._width = 0;
	this._height = 0;
	this._y = 0;
	this._context3D = null;
	this._canvas = null;
	away.events.EventDispatcher.call(this);
	this._canvas = canvas;
};

away.display.Stage3D.prototype.requestContext = function(aglslContext) {
	try {
		if (aglslContext) {
			this._context3D = new away.display3D.AGLSLContext3D(this._canvas);
		} else {
			this._context3D = new away.display3D.Context3D(this._canvas);
		}
	} catch (e) {
		this.dispatchEvent(new away.events.Event(away.events.Event.ERROR));
	}
	if (this._context3D) {
		this.dispatchEvent(new away.events.Event(away.events.Event.CONTEXT3D_CREATE));
	}
};

away.display.Stage3D.prototype.set_width = function(v) {
	this._width = v;
	away.utils.CSS.setCanvasWidth(this._canvas, v);
};

away.display.Stage3D.prototype.get_width = function() {
	return this._width;
};

away.display.Stage3D.prototype.set_height = function(v) {
	this._height = v;
	away.utils.CSS.setCanvasHeight(this._canvas, v);
};

away.display.Stage3D.prototype.get_height = function() {
	return this._height;
};

away.display.Stage3D.prototype.set_x = function(v) {
	this._x = v;
	away.utils.CSS.setCanvasX(this._canvas, v);
};

away.display.Stage3D.prototype.get_x = function() {
	return this._x;
};

away.display.Stage3D.prototype.set_y = function(v) {
	this._y = v;
	away.utils.CSS.setCanvasY(this._canvas, v);
};

away.display.Stage3D.prototype.get_y = function() {
	return this._y;
};

away.display.Stage3D.prototype.set_visible = function(v) {
	away.utils.CSS.setCanvasVisibility(this._canvas, v);
};

away.display.Stage3D.prototype.get_visible = function() {
	return away.utils.CSS.getCanvasVisibility(this._canvas);
};

away.display.Stage3D.prototype.get_canvas = function() {
	return this._canvas;
};

away.display.Stage3D.prototype.get_context3D = function() {
	return this._context3D;
};

$inherit(away.display.Stage3D, away.events.EventDispatcher);

away.display.Stage3D.className = "away.display.Stage3D";

away.display.Stage3D.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.events.Event');
	p.push('away.utils.CSS');
	p.push('away.display3D.AGLSLContext3D');
	p.push('away.display3D.Context3D');
	return p;
};

away.display.Stage3D.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.display.Stage3D.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'canvas', t:'HTMLCanvasElement'});
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

