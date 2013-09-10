/** Compiled by the Randori compiler v0.2.6.2 on Thu Sep 05 22:19:05 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.controllers == "undefined")
	away.controllers = {};

away.controllers.SpringController = function(targetObject, lookAtObject, stiffness, mass, damping) {
	this._velocity = null;
	this._desiredPosition = null;
	this.positionOffset = new away.geom.Vector3D(0, 500, -1000, 0);
	this._force = null;
	this._dv = null;
	this._stretch = null;
	this._acceleration = null;
	away.controllers.LookAtController.call(this, targetObject, lookAtObject);
	stiffness = stiffness;
	damping = damping;
	mass = mass;
	this._velocity = new away.geom.Vector3D(0, 0, 0, 0);
	this._dv = new away.geom.Vector3D(0, 0, 0, 0);
	this._stretch = new away.geom.Vector3D(0, 0, 0, 0);
	this._force = new away.geom.Vector3D(0, 0, 0, 0);
	this._acceleration = new away.geom.Vector3D(0, 0, 0, 0);
	this._desiredPosition = new away.geom.Vector3D(0, 0, 0, 0);
};

away.controllers.SpringController.prototype.update = function(interpolate) {
	interpolate = interpolate;
	var offs;
	if (!this._pLookAtObject || !this._pTargetObject)
		return;
	offs = this._pLookAtObject.get_transform().deltaTransformVector(this.positionOffset);
	this._desiredPosition.x = this._pLookAtObject.get_x() + offs.x;
	this._desiredPosition.y = this._pLookAtObject.get_y() + offs.y;
	this._desiredPosition.z = this._pLookAtObject.get_z() + offs.z;
	this._stretch.x = this._pTargetObject.get_x() - this._desiredPosition.x;
	this._stretch.y = this._pTargetObject.get_y() - this._desiredPosition.y;
	this._stretch.z = this._pTargetObject.get_z() - this._desiredPosition.z;
	this._stretch.scaleBy(-this.stiffness);
	this._dv.copyFrom(this._velocity);
	this._dv.scaleBy(this.damping);
	this._force.x = this._stretch.x - this._dv.x;
	this._force.y = this._stretch.y - this._dv.y;
	this._force.z = this._stretch.z - this._dv.z;
	this._acceleration.copyFrom(this._force);
	this._acceleration.scaleBy(1 / this.mass);
	this._velocity.x += this._acceleration.x;
	this._velocity.y += this._acceleration.y;
	this._velocity.z += this._acceleration.z;
	this._pTargetObject.set_x(this._pTargetObject.get_x() + this._velocity.x);
	this._pTargetObject.set_y(this._pTargetObject.get_y() + this._velocity.y);
	this._pTargetObject.set_z(this._pTargetObject.get_z() + this._velocity.z);
	away.controllers.LookAtController.prototype.update.call(thistrue);
};

$inherit(away.controllers.SpringController, away.controllers.LookAtController);

away.controllers.SpringController.className = "away.controllers.SpringController";

away.controllers.SpringController.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.Vector3D');
	return p;
};

away.controllers.SpringController.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.Vector3D');
	return p;
};

away.controllers.SpringController.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'targetObject', t:'away.entities.Entity'});
			p.push({n:'lookAtObject', t:'away.containers.ObjectContainer3D'});
			p.push({n:'stiffness', t:'Number'});
			p.push({n:'mass', t:'Number'});
			p.push({n:'damping', t:'Number'});
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

