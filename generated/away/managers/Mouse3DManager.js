/** Compiled by the Randori compiler v0.2.6.2 on Thu Sep 05 22:19:28 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.managers == "undefined")
	away.managers = {};

away.managers.Mouse3DManager = function() {
	this._childDepth = 0;
	this._mouseDown = new away.events.MouseEvent3D(away.events.MouseEvent3D.MOUSE_DOWN);
	this._collidingViewObjects = null;
	this._mouseWheel = new away.events.MouseEvent3D(away.events.MouseEvent3D.MOUSE_WHEEL);
	this._viewCount = 0;
	this._view3Ds = null;
	this._mouseMove = new away.events.MouseEvent3D(away.events.MouseEvent3D.MOUSE_MOVE);
	this._previousCollidingObject = null;
	this._activeView = null;
	this._mousePicker = away.pick.PickingType.RAYCAST_FIRST_ENCOUNTERED;
	this._queuedEvents = [];
	this._mouseDoubleClick = new away.events.MouseEvent3D(away.events.MouseEvent3D.DOUBLE_CLICK);
	this._collidingView = -1;
	this._nullVector = new away.geom.Vector3D(0, 0, 0, 0);
	this._forceMouseMove = null;
	this._mouseClick = new away.events.MouseEvent3D(away.events.MouseEvent3D.CLICK);
	this._collidingDownObject = null;
	this._mouseOut = new away.events.MouseEvent3D(away.events.MouseEvent3D.MOUSE_OUT);
	this._updateDirty = true;
	this._mouseOver = new away.events.MouseEvent3D(away.events.MouseEvent3D.MOUSE_OVER);
	this._view3DLookup = null;
	this._collidingUpObject = null;
	this._mouseUp = new away.events.MouseEvent3D(away.events.MouseEvent3D.MOUSE_UP);
	this._previousCollidingView = -1;
	if (!away.managers.Mouse3DManager._view3Ds) {
		away.managers.Mouse3DManager._view3Ds = {};
		away.managers.Mouse3DManager._view3DLookup = [];
	}
};

away.managers.Mouse3DManager._view3Ds;

away.managers.Mouse3DManager._view3DLookup;

away.managers.Mouse3DManager._viewCount = 0;

away.managers.Mouse3DManager._pCollidingObject;

away.managers.Mouse3DManager._previousCollidingObject;

away.managers.Mouse3DManager._collidingViewObjects;

away.managers.Mouse3DManager._queuedEvents = [];

away.managers.Mouse3DManager._mouseUp = new away.events.MouseEvent3D(away.events.MouseEvent3D.MOUSE_UP);

away.managers.Mouse3DManager._mouseClick = new away.events.MouseEvent3D(away.events.MouseEvent3D.CLICK);

away.managers.Mouse3DManager._mouseOut = new away.events.MouseEvent3D(away.events.MouseEvent3D.MOUSE_OUT);

away.managers.Mouse3DManager._mouseDown = new away.events.MouseEvent3D(away.events.MouseEvent3D.MOUSE_DOWN);

away.managers.Mouse3DManager._mouseMove = new away.events.MouseEvent3D(away.events.MouseEvent3D.MOUSE_MOVE);

away.managers.Mouse3DManager._mouseOver = new away.events.MouseEvent3D(away.events.MouseEvent3D.MOUSE_OVER);

away.managers.Mouse3DManager._mouseWheel = new away.events.MouseEvent3D(away.events.MouseEvent3D.MOUSE_WHEEL);

away.managers.Mouse3DManager._mouseDoubleClick = new away.events.MouseEvent3D(away.events.MouseEvent3D.DOUBLE_CLICK);

away.managers.Mouse3DManager._previousCollidingView = -1;

away.managers.Mouse3DManager._collidingView = -1;

away.managers.Mouse3DManager.prototype.updateCollider = function(view) {
	throw new away.errors.PartialImplementationError("stage3DProxy", 0);
};

away.managers.Mouse3DManager.prototype.fireMouseEvents = function() {
	throw new away.errors.PartialImplementationError("View3D().layeredView", 0);
};

away.managers.Mouse3DManager.prototype.addViewLayer = function(view) {
	throw new away.errors.PartialImplementationError("Stage3DProxy, Stage, DisplayObjectContainer ( as3 \/ native ) ", 0);
};

away.managers.Mouse3DManager.prototype.enableMouseListeners = function(view) {
	throw new away.errors.PartialImplementationError("MouseEvent ( as3 \/ native ) as3 <> JS Conversion", 0);
};

away.managers.Mouse3DManager.prototype.disableMouseListeners = function(view) {
	throw new away.errors.PartialImplementationError("MouseEvent ( as3 \/ native ) as3 <> JS Conversion", 0);
};

away.managers.Mouse3DManager.prototype.dispose = function() {
	this._mousePicker.dispose();
};

away.managers.Mouse3DManager.prototype.queueDispatch = function(event, sourceEvent, collider) {
	throw new away.errors.PartialImplementationError("MouseEvent ( as3 \/ native ) as3 <> JS Conversion", 0);
};

away.managers.Mouse3DManager.prototype.reThrowEvent = function(event) {
	throw new away.errors.PartialImplementationError("MouseEvent - AS3 <> JS Conversion", 0);
};

away.managers.Mouse3DManager.prototype.hasKey = function(view) {
	for (var v in away.managers.Mouse3DManager._view3Ds) {
		if (v === view) {
			return true;
		}
	}
	return false;
};

away.managers.Mouse3DManager.prototype.traverseDisplayObjects = function(container) {
	throw new away.errors.PartialImplementationError("DisplayObjectContainer ( as3 \/ native ) as3 <> JS Conversion", 0);
};

away.managers.Mouse3DManager.prototype.onMouseMove = function(event) {
	throw new away.errors.PartialImplementationError("MouseEvent ( as3 \/ native ) as3 <> JS Conversion", 0);
};

away.managers.Mouse3DManager.prototype.onMouseOut = function(event) {
	this._activeView = null;
	if (away.managers.Mouse3DManager._pCollidingObject) {
		this.queueDispatch(away.managers.Mouse3DManager._mouseOut, event, away.managers.Mouse3DManager._pCollidingObject);
	}
	this._updateDirty = true;
	throw new away.errors.PartialImplementationError("MouseEvent ( as3 \/ native ) as3 <> JS Conversion", 0);
};

away.managers.Mouse3DManager.prototype.onMouseOver = function(event) {
	throw new away.errors.PartialImplementationError("MouseEvent ( as3 \/ native ) as3 <> JS Conversion", 0);
};

away.managers.Mouse3DManager.prototype.onClick = function(event) {
	throw new away.errors.PartialImplementationError("MouseEvent ( as3 \/ native ) as3 <> JS Conversion", 0);
};

away.managers.Mouse3DManager.prototype.onDoubleClick = function(event) {
	if (away.managers.Mouse3DManager._pCollidingObject) {
		this.queueDispatch(away.managers.Mouse3DManager._mouseDoubleClick, event);
	} else {
		this.reThrowEvent(event);
	}
	this._updateDirty = true;
};

away.managers.Mouse3DManager.prototype.onMouseDown = function(event) {
	throw new away.errors.PartialImplementationError("MouseEvent ( as3 \/ native ) as3 <> JS Conversion", 0);
};

away.managers.Mouse3DManager.prototype.onMouseUp = function(event) {
	throw new away.errors.PartialImplementationError("MouseEvent ( as3 \/ native ) as3 <> JS Conversion", 0);
};

away.managers.Mouse3DManager.prototype.onMouseWheel = function(event) {
	throw new away.errors.PartialImplementationError("MouseEvent ( as3 \/ native ) as3 <> JS Conversion", 0);
};

away.managers.Mouse3DManager.prototype.get_forceMouseMove = function() {
	return this._forceMouseMove;
};

away.managers.Mouse3DManager.prototype.set_forceMouseMove = function(value) {
	this._forceMouseMove = value;
};

away.managers.Mouse3DManager.prototype.get_mousePicker = function() {
	return this._mousePicker;
};

away.managers.Mouse3DManager.prototype.set_mousePicker = function(value) {
	this._mousePicker = value;
};

away.managers.Mouse3DManager.className = "away.managers.Mouse3DManager";

away.managers.Mouse3DManager.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.managers.Mouse3DManager');
	p.push('away.errors.PartialImplementationError');
	return p;
};

away.managers.Mouse3DManager.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.Vector3D');
	p.push('away.pick.PickingType');
	p.push('away.events.MouseEvent3D');
	return p;
};

away.managers.Mouse3DManager.injectionPoints = function(t) {
	return [];
};
