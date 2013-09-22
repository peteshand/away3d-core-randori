/** Compiled by the Randori compiler v0.2.6.2 on Sun Sep 22 11:19:57 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.controllers == "undefined")
	away.controllers = {};

away.controllers.FirstPersonController = function(targetObject, panAngle, tiltAngle, minTiltAngle, maxTiltAngle, steps, wrapPanAngle) {
	this._panAngle = 0;
	this._iCurrentPanAngle = 0;
	this._maxTiltAngle = 90;
	this._steps = 8;
	this._minTiltAngle = -90;
	this.fly = false;
	this._walkIncrement = 0;
	this._wrapPanAngle = false;
	this._iCurrentTiltAngle = 90;
	this._tiltAngle = 90;
	this._strafeIncrement = 0;
	targetObject = targetObject || null;
	panAngle = panAngle || 0;
	tiltAngle = tiltAngle || 90;
	minTiltAngle = minTiltAngle || -90;
	maxTiltAngle = maxTiltAngle || 90;
	steps = steps || 8;
	wrapPanAngle = wrapPanAngle || false;
	away.controllers.ControllerBase.call(this, targetObject);
	this.set_panAngle(panAngle);
	this.set_tiltAngle(tiltAngle);
	this.set_minTiltAngle(minTiltAngle);
	this.set_maxTiltAngle(maxTiltAngle);
	this.set_steps(steps);
	this.set_wrapPanAngle(wrapPanAngle);
	this._iCurrentPanAngle = this._panAngle;
	this._iCurrentTiltAngle = this._tiltAngle;
};

away.controllers.FirstPersonController.prototype.get_steps = function() {
	return this._steps;
};

away.controllers.FirstPersonController.prototype.set_steps = function(val) {
	val = (val < 1) ? 1 : val;
	if (this._steps == val)
		return;
	this._steps = val;
	this.pNotifyUpdate();
};

away.controllers.FirstPersonController.prototype.get_panAngle = function() {
	return this._panAngle;
};

away.controllers.FirstPersonController.prototype.set_panAngle = function(val) {
	if (this._panAngle == val)
		return;
	this._panAngle = val;
	this.pNotifyUpdate();
};

away.controllers.FirstPersonController.prototype.get_tiltAngle = function() {
	return this._tiltAngle;
};

away.controllers.FirstPersonController.prototype.set_tiltAngle = function(val) {
	val = Math.max(this._minTiltAngle, Math.min(this._maxTiltAngle, val));
	if (this._tiltAngle == val)
		return;
	this._tiltAngle = val;
	this.pNotifyUpdate();
};

away.controllers.FirstPersonController.prototype.get_minTiltAngle = function() {
	return this._minTiltAngle;
};

away.controllers.FirstPersonController.prototype.set_minTiltAngle = function(val) {
	if (this._minTiltAngle == val)
		return;
	this._minTiltAngle = val;
	this.set_tiltAngle(Math.max(this._minTiltAngle, Math.min(this._maxTiltAngle, this._tiltAngle)));
};

away.controllers.FirstPersonController.prototype.get_maxTiltAngle = function() {
	return this._maxTiltAngle;
};

away.controllers.FirstPersonController.prototype.set_maxTiltAngle = function(val) {
	if (this._maxTiltAngle == val)
		return;
	this._maxTiltAngle = val;
	this.set_tiltAngle(Math.max(this._minTiltAngle, Math.min(this._maxTiltAngle, this._tiltAngle)));
};

away.controllers.FirstPersonController.prototype.get_wrapPanAngle = function() {
	return this._wrapPanAngle;
};

away.controllers.FirstPersonController.prototype.set_wrapPanAngle = function(val) {
	if (this._wrapPanAngle == val)
		return;
	this._wrapPanAngle = val;
	this.pNotifyUpdate();
};

away.controllers.FirstPersonController.prototype.update = function(interpolate) {
	interpolate = interpolate || true;
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
			this._iCurrentTiltAngle = this._tiltAngle;
			this._iCurrentPanAngle = this._panAngle;
		}
		if ((Math.abs(this.get_tiltAngle() - this._iCurrentTiltAngle) < 0.01) && (Math.abs(this._panAngle - this._iCurrentPanAngle) < 0.01)) {
			this._iCurrentTiltAngle = this._tiltAngle;
			this._iCurrentPanAngle = this._panAngle;
		}
	}
	this.get_targetObject().set_rotationX(this._iCurrentTiltAngle);
	this.get_targetObject().set_rotationY(this._iCurrentPanAngle);
	if (this._walkIncrement) {
		if (this.fly)
			this.get_targetObject().moveForward(this._walkIncrement); else {
			this.get_targetObject().set_x(this.get_targetObject().get_x() + this._walkIncrement * Math.sin(this._panAngle * away.math.MathConsts.DEGREES_TO_RADIANS));
			this.get_targetObject().set_z(this.get_targetObject().get_z() + this._walkIncrement * Math.cos(this._panAngle * away.math.MathConsts.DEGREES_TO_RADIANS));
		}
		this._walkIncrement = 0;
	}
	if (this._strafeIncrement) {
		this.get_targetObject().moveRight(this._strafeIncrement);
		this._strafeIncrement = 0;
	}
};

away.controllers.FirstPersonController.prototype.incrementWalk = function(val) {
	if (val == 0)
		return;
	this._walkIncrement += val;
	this.pNotifyUpdate();
};

away.controllers.FirstPersonController.prototype.incrementStrafe = function(val) {
	if (val == 0)
		return;
	this._strafeIncrement += val;
	this.pNotifyUpdate();
};

$inherit(away.controllers.FirstPersonController, away.controllers.ControllerBase);

away.controllers.FirstPersonController.className = "away.controllers.FirstPersonController";

away.controllers.FirstPersonController.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.math.MathConsts');
	return p;
};

away.controllers.FirstPersonController.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.controllers.FirstPersonController.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'targetObject', t:'away.entities.Entity'});
			p.push({n:'panAngle', t:'Number'});
			p.push({n:'tiltAngle', t:'Number'});
			p.push({n:'minTiltAngle', t:'Number'});
			p.push({n:'maxTiltAngle', t:'Number'});
			p.push({n:'steps', t:'Number'});
			p.push({n:'wrapPanAngle', t:'Boolean'});
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

