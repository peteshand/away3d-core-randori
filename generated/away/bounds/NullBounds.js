/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 21 16:02:29 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.bounds == "undefined")
	away.bounds = {};

away.bounds.NullBounds = function(alwaysIn, renderable) {
	this._alwaysIn = null;
	this._renderable = null;
	away.bounds.BoundingVolumeBase.call(this);
	this._alwaysIn = alwaysIn;
	this._renderable = renderable;
	this._pMax.x = Infinity;
	this._pMax.y = Infinity;
	this._pMax.z = Infinity;
	this._pMin.x = this._alwaysIn ? -Infinity : Infinity;
	this._pMin.y = this._alwaysIn ? -Infinity : Infinity;
	this._pMin.z = this._alwaysIn ? -Infinity : Infinity;
};

away.bounds.NullBounds.prototype.clone = function() {
	return new away.bounds.NullBounds(this._alwaysIn);
};

away.bounds.NullBounds.prototype.pCreateBoundingRenderable = function() {
	return null;
};

away.bounds.NullBounds.prototype.isInFrustum = function(planes, numPlanes) {
	planes = planes;
	numPlanes = numPlanes;
	return this._alwaysIn;
};

away.bounds.NullBounds.prototype.fromGeometry = function(geometry) {
};

away.bounds.NullBounds.prototype.fromSphere = function(center, radius) {
};

away.bounds.NullBounds.prototype.fromExtremes = function(minX, minY, minZ, maxX, maxY, maxZ) {
};

away.bounds.NullBounds.prototype.classifyToPlane = function(plane) {
	plane = plane;
	return away.math.PlaneClassification.INTERSECT;
};

away.bounds.NullBounds.prototype.transformFrom = function(bounds, matrix) {
	matrix = matrix;
	var nullBounds = bounds;
	this._alwaysIn = nullBounds._alwaysIn;
};

$inherit(away.bounds.NullBounds, away.bounds.BoundingVolumeBase);

away.bounds.NullBounds.className = "away.bounds.NullBounds";

away.bounds.NullBounds.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.math.PlaneClassification');
	return p;
};

away.bounds.NullBounds.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.bounds.NullBounds.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'alwaysIn', t:'Boolean'});
			p.push({n:'renderable', t:'away.primitives.WireframePrimitiveBase'});
			break;
		case 1:
			p = away.bounds.BoundingVolumeBase.injectionPoints(t);
			break;
		case 2:
			p = away.bounds.BoundingVolumeBase.injectionPoints(t);
			break;
		case 3:
			p = away.bounds.BoundingVolumeBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

