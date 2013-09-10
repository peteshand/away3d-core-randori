/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 10 22:28:12 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.controllers == "undefined")
	away.controllers = {};

away.controllers.LookAtController = function(targetObject, lookAtObject) {
	this._pOrigin = new away.geom.Vector3D(0.0, 0.0, 0.0, 0);
	this._pLookAtObject = null;
	this._pLookAtPosition = null;
	away.controllers.ControllerBase.call(this, targetObject);
	if (lookAtObject) {
		lookAtObject = lookAtObject;
	} else {
		this.set_lookAtPosition(new away.geom.Vector3D(0, 0, 0, 0));
	}
};

away.controllers.LookAtController.prototype.get_lookAtPosition = function() {
	return this._pLookAtPosition;
};

away.controllers.LookAtController.prototype.set_lookAtPosition = function(val) {
	if (this._pLookAtObject) {
		this._pLookAtObject.removeEventListener(away.events.Object3DEvent.SCENETRANSFORM_CHANGED, $createStaticDelegate(this, this.onLookAtObjectChanged), this);
		this._pLookAtObject = null;
	}
	this._pLookAtPosition = val;
	this.pNotifyUpdate();
};

away.controllers.LookAtController.prototype.get_lookAtObject = function() {
	return this._pLookAtObject;
};

away.controllers.LookAtController.prototype.set_lookAtObject = function(val) {
	if (this._pLookAtPosition) {
		this._pLookAtPosition = null;
	}
	if (this._pLookAtObject == val) {
		return;
	}
	if (this._pLookAtObject) {
		this._pLookAtObject.removeEventListener(away.events.Object3DEvent.SCENETRANSFORM_CHANGED, $createStaticDelegate(this, this.onLookAtObjectChanged), this);
	}
	this._pLookAtObject = val;
	if (this._pLookAtObject) {
		this._pLookAtObject.addEventListener(away.events.Object3DEvent.SCENETRANSFORM_CHANGED, $createStaticDelegate(this, this.onLookAtObjectChanged), this);
	}
	this.pNotifyUpdate();
};

away.controllers.LookAtController.prototype.update = function(interpolate) {
	interpolate = interpolate;
	if (this._pTargetObject) {
		if (this._pLookAtPosition) {
			this._pTargetObject.lookAt(this._pLookAtPosition);
		} else if (this._pLookAtObject) {
			this._pTargetObject.lookAt(this._pLookAtObject.get_scene() ? this._pLookAtObject.get_scenePosition() : this._pLookAtObject.get_position());
		}
	}
};

away.controllers.LookAtController.prototype.onLookAtObjectChanged = function(event) {
	this.pNotifyUpdate();
};

$inherit(away.controllers.LookAtController, away.controllers.ControllerBase);

away.controllers.LookAtController.className = "away.controllers.LookAtController";

away.controllers.LookAtController.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.Vector3D');
	p.push('away.events.Object3DEvent');
	return p;
};

away.controllers.LookAtController.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.Vector3D');
	return p;
};

away.controllers.LookAtController.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'targetObject', t:'away.entities.Entity'});
			p.push({n:'lookAtObject', t:'away.containers.ObjectContainer3D'});
			break;
		case 1:
			p = away.controllers.ControllerBase.injectionPoints(t);
			break;
		case 2:
			p = away.controllers.ControllerBase.injectionPoints(t);
			break;
		case 3:
			p = away.controllers.ControllerBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

