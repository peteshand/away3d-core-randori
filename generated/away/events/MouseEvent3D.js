/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 10 22:28:14 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.events == "undefined")
	away.events = {};

away.events.MouseEvent3D = function(type) {
	this.shiftKey = null;
	this.object = null;
	this.subGeometryIndex = 0;
	this.uv = null;
	this.screenY = 0;
	this._iAllowedToPropagate = true;
	this.screenX = 0;
	this.localNormal = null;
	this.index = 0;
	this.delta = 0;
	this.localPosition = null;
	this.material = null;
	this._iParentEvent = null;
	this.renderable = null;
	this.altKey = null;
	this.view = null;
	this.ctrlKey = null;
	away.events.Event.call(this, type);
};

away.events.MouseEvent3D.MOUSE_OVER = "mouseOver3d";

away.events.MouseEvent3D.MOUSE_OUT = "mouseOut3d";

away.events.MouseEvent3D.MOUSE_UP = "mouseUp3d";

away.events.MouseEvent3D.MOUSE_DOWN = "mouseDown3d";

away.events.MouseEvent3D.MOUSE_MOVE = "mouseMove3d";

away.events.MouseEvent3D.CLICK = "click3d";

away.events.MouseEvent3D.DOUBLE_CLICK = "doubleClick3d";

away.events.MouseEvent3D.MOUSE_WHEEL = "mouseWheel3d";

away.events.MouseEvent3D.prototype.get_bubbles = function() {
	var doesBubble = this._iAllowedToPropagate;
	this._iAllowedToPropagate = true;
	return doesBubble;
};

away.events.MouseEvent3D.prototype.stopPropagation = function() {
	this._iAllowedToPropagate = false;
	if (this._iParentEvent) {
		this._iParentEvent.stopPropagation();
	}
};

away.events.MouseEvent3D.prototype.stopImmediatePropagation = function() {
	this._iAllowedToPropagate = false;
	if (this._iParentEvent) {
		this._iParentEvent.stopImmediatePropagation();
	}
};

away.events.MouseEvent3D.prototype.clone = function() {
	var result = new away.events.MouseEvent3D(this.type);
	result.screenX = this.screenX;
	result.screenY = this.screenY;
	result.view = this.view;
	result.object = this.object;
	result.renderable = this.renderable;
	result.material = this.material;
	result.uv = this.uv;
	result.localPosition = this.localPosition;
	result.localNormal = this.localNormal;
	result.index = this.index;
	result.subGeometryIndex = this.subGeometryIndex;
	result.delta = this.delta;
	result.ctrlKey = this.ctrlKey;
	result.shiftKey = this.shiftKey;
	result._iParentEvent = this;
	result._iAllowedToPropagate = this._iAllowedToPropagate;
	return result;
};

away.events.MouseEvent3D.prototype.get_scenePosition = function() {
	if (this.object instanceof away.containers.ObjectContainer3D) {
		var objContainer = this.object;
		return objContainer.get_sceneTransform().transformVector(this.localPosition);
	} else {
		return this.localPosition;
	}
};

away.events.MouseEvent3D.prototype.get_sceneNormal = function() {
	if (this.object instanceof away.containers.ObjectContainer3D) {
		var objContainer = this.object;
		var sceneNormal = objContainer.get_sceneTransform().deltaTransformVector(this.localNormal);
		sceneNormal.normalize();
		return sceneNormal;
	} else {
		return this.localNormal;
	}
};

$inherit(away.events.MouseEvent3D, away.events.Event);

away.events.MouseEvent3D.className = "away.events.MouseEvent3D";

away.events.MouseEvent3D.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.containers.ObjectContainer3D');
	return p;
};

away.events.MouseEvent3D.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.events.MouseEvent3D.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'type', t:'String'});
			break;
		case 1:
			p = away.events.Event.injectionPoints(t);
			break;
		case 2:
			p = away.events.Event.injectionPoints(t);
			break;
		case 3:
			p = away.events.Event.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

