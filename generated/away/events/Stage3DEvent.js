/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 21 16:02:16 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.events == "undefined")
	away.events = {};

away.events.Stage3DEvent = function(type) {
	away.events.Event.call(this, type);
};

away.events.Stage3DEvent.CONTEXT3D_CREATED = "Context3DCreated";

away.events.Stage3DEvent.CONTEXT3D_DISPOSED = "Context3DDisposed";

away.events.Stage3DEvent.CONTEXT3D_RECREATED = "Context3DRecreated";

away.events.Stage3DEvent.VIEWPORT_UPDATED = "ViewportUpdated";

$inherit(away.events.Stage3DEvent, away.events.Event);

away.events.Stage3DEvent.className = "away.events.Stage3DEvent";

away.events.Stage3DEvent.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.events.Stage3DEvent.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.events.Stage3DEvent.injectionPoints = function(t) {
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

