/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 21 16:02:24 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.controllers == "undefined")
	away.controllers = {};

away.controllers.HoverController = function(targetObject, lookAtObject, panAngle, tiltAngle, distance, minTiltAngle, maxTiltAngle, minPanAngle, maxPanAngle, steps, yFactor, wrapPanAngle) {
	this._minPanAngle = -Infinity;
	this._maxPanAngle = Infinity;
	this._steps = 8;
	this._minTiltAngle = -90;
	this._iCurrentTiltAngle = 90;
	this._panAngle = 0;
	this._distance = 1000;
	this._iCurrentPanAngle = 0;
	this._maxTiltAngle = 90;
	this._wrapPanAngle = false;
	this._tiltAngle = 90;
	this._yFactor = 2;
	away.controllers.LookAtController.call(this, targetObject, lookAtObject);
	this.set_distance(distance);
	this.set_panAngle(panAngle);
	this.set_tiltAngle(tiltAngle);
	this.set_minPanAngle(minPanAngle || -Infinity);
	this.set_maxPanAngle(maxPanAngle || Infinity);
	this.set_minTiltAngle(minTiltAngle);
	this.set_maxTiltAngle(maxTiltAngle);
	this.set_steps(steps);
	this.set_yFactor(yFactor);
	this.set_wrapPanAngle(wrapPanAngle);
	this._iCurrentPanAngle = this._panAngle;
	this._iCurrentTiltAngle = this._tiltAngle;
};

away.controllers.HoverController.prototype.get_steps = function() {
	return this._steps;
};

away.controllers.HoverController.prototype.set_steps = function(val) {
	val = (val < 1) ? 1 : val;
	if (this._steps == val)
		return;
	this._steps = val;
	this.pNotifyUpdate();
};

away.controllers.HoverController.prototype.get_panAngle = function() {
	return this._panAngle;
};

away.controllers.HoverController.prototype.set_panAngle = function(val) {
	val = Math.max(this._minPanAngle, Math.min(this._maxPanAngle, val));
	if (this._panAngle == val)
		return;
	this._panAngle = val;
	this.pNotifyUpdate();
};

away.controllers.HoverController.prototype.get_tiltAngle = function() {
	return this._tiltAngle;
};

away.controllers.HoverController.prototype.set_tiltAngle = function(val) {
	val = Math.max(this._minTiltAngle, Math.min(this._maxTiltAngle, val));
	if (this._tiltAngle == val)
		return;
	this._tiltAngle = val;
	this.pNotifyUpdate();
};

away.controllers.HoverController.prototype.get_distance = function() {
	return this._distance;
};

away.controllers.HoverController.prototype.set_distance = function(val) {
	if (this._distance == val)
		return;
	this._distance = val;
	this.pNotifyUpdate();
};

away.controllers.HoverController.prototype.get_minPanAngle = function() {
	return this._minPanAngle;
};

away.controllers.HoverController.prototype.set_minPanAngle = function(val) {
	if (this._minPanAngle == val)
		return;
	this._minPanAngle = val;
	this.set_panAngle(Math.max(this._minPanAngle, Math.min(this._maxPanAngle, this._panAngle)));
};

away.controllers.HoverController.prototype.get_maxPanAngle = function() {
	return this._maxPanAngle;
};

away.controllers.HoverController.prototype.set_maxPanAngle = function(val) {
	if (this._maxPanAngle == val)
		return;
	this._maxPanAngle = val;
	this.set_panAngle(Math.max(this._minPanAngle, Math.min(this._maxPanAngle, this._panAngle)));
};

away.controllers.HoverController.prototype.get_minTiltAngle = function() {
	return this._minTiltAngle;
};

away.controllers.HoverController.prototype.set_minTiltAngle = function(val) {
	if (this._minTiltAngle == val)
		return;
	this._minTiltAngle = val;
	this.set_tiltAngle(Math.max(this._minTiltAngle, Math.min(this._maxTiltAngle, this._tiltAngle)));
};

away.controllers.HoverController.prototype.get_maxTiltAngle = function() {
	return this._maxTiltAngle;
};

away.controllers.HoverController.prototype.set_maxTiltAngle = function(val) {
	if (this._maxTiltAngle == val)
		return;
	this._maxTiltAngle = val;
	this.set_tiltAngle(Math.max(this._minTiltAngle, Math.min(this._maxTiltAngle, this._tiltAngle)));
};

away.controllers.HoverController.prototype.get_yFactor = function() {
	return this._yFactor;
};

away.controllers.HoverController.prototype.set_yFactor = function(val) {
	if (this._yFactor == val)
		return;
	this._yFactor = val;
	this.pNotifyUpdate();
};

away.controllers.HoverController.prototype.get_wrapPanAngle = function() {
	return this._wrapPanAngle;
};

away.controllers.HoverController.prototype.set_wrapPanAngle = function(val) {
	if (this._wrapPanAngle == val)
		return;
	this._wrapPanAngle = val;
	this.pNotifyUpdate();
};

away.controllers.HoverController.prototype.update = function(interpolate) {
	if (this._tiltAngle != this._iCurrentTiltAngle || this._panAngle != this._iCurrentPanAngle) {
		this.pNotifyUpdate();
		if (this._wrapPanAngle) {
			if (this._panAngle < 0) {
				this._iCurrentPanAngle += this._panAngle % 360 + 360 - this._panAngle;
				this._panAngle = this._panAngle % 360 + 360;
			} else {
				this._iCurrentPanAngle += this._panAngle % 360 - this._panAngle;
				this._panAngle = this._panAngle % 360;
			}
			while (this._panAngle - this._iCurrentPanAngle < -180)
				this._iCurrentPanAngle -= 360;
			while (this._panAngle - this._iCurrentPanAngle > 180)
				this._iCurrentPanAngle += 360;
		}
		if (interpolate) {
			this._iCurrentTiltAngle += (this._tiltAngle - this._iCurrentTiltAngle) / (this.get_steps() + 1);
			this._iCurrentPanAngle += (this._panAngle - this._iCurrentPanAngle) / (this.get_steps() + 1);
		} else {
			this._iCurrentPanAngle = this._panAngle;
			this._iCurrentTiltAngle = this._tiltAngle;
		}
		if ((Math.abs(this.get_tiltAngle() - this._iCurrentTiltAngle) < 0.01) && (Math.abs(this._panAngle - this._iCurrentPanAngle) < 0.01)) {
			this._iCurrentTiltAngle = this._tiltAngle;
			this._iCurrentPanAngle = this._panAngle;
		}
	}
	var pos = this.get_lookAtObject() ? this.get_lookAtObject().get_position() : this.get_lookAtPosition() ? this.get_lookAtPosition() : this._pOrigin;
	this.get_targetObject().set_x(pos.x + this.get_distance() * Math.sin(this._iCurrentPanAngle * away.math.MathConsts.DEGREES_TO_RADIANS) * Math.cos(this._iCurrentTiltAngle * away.math.MathConsts.DEGREES_TO_RADIANS));
	this.get_targetObject().set_z(pos.z + this.get_distance() * Math.cos(this._iCurrentPanAngle * away.math.MathConsts.DEGREES_TO_RADIANS) * Math.cos(this._iCurrentTiltAngle * away.math.MathConsts.DEGREES_TO_RADIANS));
	this.get_targetObject().set_y(pos.y + this.get_distance() * Math.sin(this._iCurrentTiltAngle * away.math.MathConsts.DEGREES_TO_RADIANS) * this.get_yFactor());
	away.controllers.LookAtController.prototype.update.call(thistrue);
};

$inherit(away.controllers.HoverController, away.controllers.LookAtController);

away.controllers.HoverController.className = "away.controllers.HoverController";

away.controllers.HoverController.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.math.MathConsts');
	return p;
};

away.controllers.HoverController.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.controllers.HoverController.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'targetObject', t:'away.entities.Entity'});
			p.push({n:'lookAtObject', t:'away.containers.ObjectContainer3D'});
			p.push({n:'panAngle', t:'Number'});
			p.push({n:'tiltAngle', t:'Number'});
			p.push({n:'distance', t:'Number'});
			p.push({n:'minTiltAngle', t:'Number'});
			p.push({n:'maxTiltAngle', t:'Number'});
			p.push({n:'minPanAngle', t:'Number'});
			p.push({n:'maxPanAngle', t:'Number'});
			p.push({n:'steps', t:'Number'});
			p.push({n:'yFactor', t:'Number'});
			p.push({n:'wrapPanAngle', t:'Boolean'});
			break;
		case 1:
			p = away.controllers.LookAtController.injectionPoints(t);
			break;
		case 2:
			p = away.controllers.LookAtController.injectionPoints(t);
			break;
		case 3:
			p = away.controllers.LookAtController.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

