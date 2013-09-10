/** Compiled by the Randori compiler v0.2.6.2 on Thu Sep 05 22:19:19 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.controllers == "undefined")
	away.controllers = {};

away.controllers.FollowController = function(targetObject, lookAtObject, tiltAngle, distance) {
	away.controllers.HoverController.call(this, targetObject, lookAtObject, 0, tiltAngle, distance, -90, 90, NaN, NaN, 8, 2, false);
};

away.controllers.FollowController.prototype.update = function(interpolate) {
	interpolate = interpolate;
	if (!this.get_lookAtObject())
		return;
	this.set_panAngle(this._pLookAtObject.get_rotationY() - 180);
	away.controllers.HoverController.prototype.update.call(thistrue);
};

$inherit(away.controllers.FollowController, away.controllers.HoverController);

away.controllers.FollowController.className = "away.controllers.FollowController";

away.controllers.FollowController.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.controllers.FollowController.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.controllers.FollowController.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'targetObject', t:'away.entities.Entity'});
			p.push({n:'lookAtObject', t:'away.containers.ObjectContainer3D'});
			p.push({n:'tiltAngle', t:'Number'});
			p.push({n:'distance', t:'Number'});
			break;
		case 1:
			p = away.controllers.HoverController.injectionPoints(t);
			break;
		case 2:
			p = away.controllers.HoverController.injectionPoints(t);
			break;
		case 3:
			p = away.controllers.HoverController.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

