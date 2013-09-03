/** Compiled by the Randori compiler v0.2.6.2 on Mon Sep 02 23:32:13 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.events == "undefined")
	away.events = {};

away.events.Scene3DEvent = function(type, objectContainer) {
	this.objectContainer3D = null;
	this.target = objectContainer;
	away.events.Event.call(this, type);
};

away.events.Scene3DEvent.ADDED_TO_SCENE = "addedToScene";

away.events.Scene3DEvent.REMOVED_FROM_SCENE = "removedFromScene";

away.events.Scene3DEvent.PARTITION_CHANGED = "partitionChanged";

$inherit(away.events.Scene3DEvent, away.events.Event);

away.events.Scene3DEvent.className = "away.events.Scene3DEvent";

away.events.Scene3DEvent.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.events.Scene3DEvent.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.events.Scene3DEvent.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'type', t:'String'});
			p.push({n:'objectContainer', t:'away.containers.ObjectContainer3D'});
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

