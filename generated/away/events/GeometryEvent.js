/** Compiled by the Randori compiler v0.2.6.2 on Sun Sep 22 11:19:51 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.events == "undefined")
	away.events = {};

away.events.GeometryEvent = function(type, subGeometry) {
	this._subGeometry = null;
	subGeometry = subGeometry || null;
	away.events.Event.call(this, type);
	this._subGeometry = subGeometry;
};

away.events.GeometryEvent.SUB_GEOMETRY_ADDED = "SubGeometryAdded";

away.events.GeometryEvent.SUB_GEOMETRY_REMOVED = "SubGeometryRemoved";

away.events.GeometryEvent.BOUNDS_INVALID = "BoundsInvalid";

away.events.GeometryEvent.prototype.get_subGeometry = function() {
	return this._subGeometry;
};

away.events.GeometryEvent.prototype.clone = function() {
	return new away.events.GeometryEvent(this.type, this._subGeometry);
};

$inherit(away.events.GeometryEvent, away.events.Event);

away.events.GeometryEvent.className = "away.events.GeometryEvent";

away.events.GeometryEvent.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.events.GeometryEvent.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.events.GeometryEvent.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'type', t:'String'});
			p.push({n:'subGeometry', t:'away.base.ISubGeometry'});
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

