/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 04 21:18:31 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.controllers == "undefined")
	away.controllers = {};

away.controllers.ControllerBase = function(targetObject) {
	this._pTargetObject = null;
	this._pAutoUpdate = true;
	this.set_targetObject(targetObject);
};

away.controllers.ControllerBase.prototype.pNotifyUpdate = function() {
	if (this._pTargetObject && this._pTargetObject.iGetImplicitPartition() && this._pAutoUpdate) {
		this._pTargetObject.iGetImplicitPartition().iMarkForUpdate(this._pTargetObject);
	}
};

away.controllers.ControllerBase.prototype.get_targetObject = function() {
	return this._pTargetObject;
};

away.controllers.ControllerBase.prototype.set_targetObject = function(val) {
	if (this._pTargetObject == val) {
		return;
	}
	if (this._pTargetObject && this._pAutoUpdate) {
		this._pTargetObject._iController = null;
	}
	this._pTargetObject = val;
	if (this._pTargetObject && this._pAutoUpdate) {
		this._pTargetObject._iController = this;
	}
	this.pNotifyUpdate();
};

away.controllers.ControllerBase.prototype.get_autoUpdate = function() {
	return this._pAutoUpdate;
};

away.controllers.ControllerBase.prototype.set_autoUpdate = function(val) {
	if (this._pAutoUpdate == val) {
		return;
	}
	this._pAutoUpdate = val;
	if (this._pTargetObject) {
		if (this._pTargetObject) {
			this._pTargetObject._iController = this;
		} else {
			this._pTargetObject._iController = null;
		}
	}
};

away.controllers.ControllerBase.prototype.update = function(interpolate) {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.controllers.ControllerBase.className = "away.controllers.ControllerBase";

away.controllers.ControllerBase.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.errors.AbstractMethodError');
	return p;
};

away.controllers.ControllerBase.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.controllers.ControllerBase.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'targetObject', t:'away.entities.Entity'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

