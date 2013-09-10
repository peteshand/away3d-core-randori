/** Compiled by the Randori compiler v0.2.6.2 on Thu Sep 05 22:21:01 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.events == "undefined")
	away.events = {};

away.events.CameraEvent = function(type, camera) {
	this._camera = null;
	away.events.Event.call(this, type);
	this._camera = camera;
};

away.events.CameraEvent.LENS_CHANGED = "lensChanged";

away.events.CameraEvent.prototype.get_camera = function() {
	return this._camera;
};

$inherit(away.events.CameraEvent, away.events.Event);

away.events.CameraEvent.className = "away.events.CameraEvent";

away.events.CameraEvent.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.events.CameraEvent.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.events.CameraEvent.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'type', t:'String'});
			p.push({n:'camera', t:'away.cameras.Camera3D'});
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

