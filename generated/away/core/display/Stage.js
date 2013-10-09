/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:38 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.display == "undefined")
	away.core.display = {};

away.core.display.Stage = function(width, height) {
	this.stage3Ds = null;
	this._stageWidth = 0;
	this.STAGE3D_MAX_QUANTITY = 8;
	this._stageHeight = 0;
	width = width || 640;
	height = height || 480;
	away.events.EventDispatcher.call(this);
	if (!document) {
		throw new away.errors.DocumentError("A root document object does not exist.", 0);
	}
	this.initStage3DObjects();
	this.resize(width, height);
};

away.core.display.Stage.STAGE3D_MAX_QUANTITY = 8;

away.core.display.Stage.prototype.resize = function(width, height) {
	this._stageHeight = height;
	this._stageWidth = width;
	var s3d;
	for (var i = 0; i < away.core.display.Stage.STAGE3D_MAX_QUANTITY; ++i) {
		s3d = this.stage3Ds[i];
		s3d.set_width(width);
		s3d.set_height(height);
		s3d.set_x(0);
		s3d.set_y(0);
	}
	this.dispatchEvent(new away.events.Event(away.events.Event.RESIZE));
};

away.core.display.Stage.prototype.getStage3DAt = function(index) {
	if (0 <= index && index < away.core.display.Stage.STAGE3D_MAX_QUANTITY) {
		return this.stage3Ds[index];
	}
	throw new away.errors.away.errors.ArgumentError("Index is out of bounds [0.." + away.core.display.Stage.STAGE3D_MAX_QUANTITY + "]", 0);
};

away.core.display.Stage.prototype.initStage3DObjects = function() {
	this.stage3Ds = [];
	for (var i = 0; i < away.core.display.Stage.STAGE3D_MAX_QUANTITY; ++i) {
		var canvas = this.createHTMLCanvasElement();
		var stage3D = new away.core.display.Stage3D(canvas);
		stage3D.addEventListener(away.events.Event.CONTEXT3D_CREATE, $createStaticDelegate(this, this.onContextCreated), this);
		this.stage3Ds.push(stage3D);
	}
};

away.core.display.Stage.prototype.onContextCreated = function(e) {
	var stage3D = e.target;
	this.addChildHTMLElement(stage3D.get_canvas());
};

away.core.display.Stage.prototype.createHTMLCanvasElement = function() {
	return document.createElement("canvas");
};

away.core.display.Stage.prototype.addChildHTMLElement = function(canvas) {
	document.body.appendChild(canvas);
};

away.core.display.Stage.prototype.get_stageWidth = function() {
	return this._stageWidth;
};

away.core.display.Stage.prototype.get_stageHeight = function() {
	return this._stageHeight;
};

away.core.display.Stage.prototype.get_rect = function() {
	return new away.core.geom.Rectangle(0, 0, this._stageWidth, this._stageHeight);
};

$inherit(away.core.display.Stage, away.events.EventDispatcher);

away.core.display.Stage.className = "away.core.display.Stage";

away.core.display.Stage.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.events.Event');
	p.push('away.core.display.Stage3D');
	p.push('away.core.geom.Rectangle');
	p.push('away.errors.DocumentError');
	return p;
};

away.core.display.Stage.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.core.display.Stage.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'width', t:'Number'});
			p.push({n:'height', t:'Number'});
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

