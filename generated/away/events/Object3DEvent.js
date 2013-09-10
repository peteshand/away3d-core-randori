/** Compiled by the Randori compiler v0.2.6.2 on Thu Sep 05 22:44:01 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.events == "undefined")
	away.events = {};

away.events.Object3DEvent = function(type, object) {
	away.events.Event.call(this, type);
	this.object = object;
};

away.events.Object3DEvent.VISIBLITY_UPDATED = "visiblityUpdated";

away.events.Object3DEvent.SCENETRANSFORM_CHANGED = "scenetransformChanged";

away.events.Object3DEvent.SCENE_CHANGED = "sceneChanged";

away.events.Object3DEvent.POSITION_CHANGED = "positionChanged";

away.events.Object3DEvent.ROTATION_CHANGED = "rotationChanged";

away.events.Object3DEvent.SCALE_CHANGED = "scaleChanged";

$inherit(away.events.Object3DEvent, away.events.Event);

away.events.Object3DEvent.className = "away.events.Object3DEvent";

away.events.Object3DEvent.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.events.Object3DEvent.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.events.Object3DEvent.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'type', t:'String'});
			p.push({n:'object', t:'away.base.Object3D'});
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

