/** Compiled by the Randori compiler v0.2.6.2 on Sun Sep 22 11:19:33 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.primitives == "undefined")
	away.primitives = {};

away.primitives.RegularPolygonGeometry = function(radius, sides, yUp) {
	radius = radius || 100;
	sides = sides || 16;
	yUp = yUp || true;
	away.primitives.CylinderGeometry.call(this, radius, 0, 0, sides, 1, true, false, false, yUp);
};

away.primitives.RegularPolygonGeometry.prototype.get_radius = function() {
	return this._pBottomRadius;
};

away.primitives.RegularPolygonGeometry.prototype.set_radius = function(value) {
	this._pBottomRadius = value;
	this.pInvalidateGeometry();
};

away.primitives.RegularPolygonGeometry.prototype.get_sides = function() {
	return this._pSegmentsW;
};

away.primitives.RegularPolygonGeometry.prototype.set_sides = function(value) {
	this.setSegmentsW(value);
};

away.primitives.RegularPolygonGeometry.prototype.get_subdivisions = function() {
	return this._pSegmentsH;
};

away.primitives.RegularPolygonGeometry.prototype.set_subdivisions = function(value) {
	this.setSegmentsH(value);
};

$inherit(away.primitives.RegularPolygonGeometry, away.primitives.CylinderGeometry);

away.primitives.RegularPolygonGeometry.className = "away.primitives.RegularPolygonGeometry";

away.primitives.RegularPolygonGeometry.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.primitives.RegularPolygonGeometry.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.primitives.RegularPolygonGeometry.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'radius', t:'Number'});
			p.push({n:'sides', t:'Number'});
			p.push({n:'yUp', t:'Boolean'});
			break;
		case 1:
			p = away.primitives.CylinderGeometry.injectionPoints(t);
			break;
		case 2:
			p = away.primitives.CylinderGeometry.injectionPoints(t);
			break;
		case 3:
			p = away.primitives.CylinderGeometry.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

