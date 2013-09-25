/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 25 08:08:24 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.primitives == "undefined")
	away.primitives = {};

away.primitives.ConeGeometry = function(radius, height, segmentsW, segmentsH, closed, yUp) {
	radius = radius || 50;
	height = height || 100;
	segmentsW = segmentsW || 16;
	segmentsH = segmentsH || 1;
	closed = closed || true;
	yUp = yUp || true;
	away.primitives.CylinderGeometry.call(this, 0, radius, height, segmentsW, segmentsH, false, closed, true, yUp);
};

away.primitives.ConeGeometry.prototype.get_radius = function() {
	return this._pBottomRadius;
};

away.primitives.ConeGeometry.prototype.set_radius = function(value) {
	this._pBottomRadius = value;
	this.pInvalidateGeometry();
};

$inherit(away.primitives.ConeGeometry, away.primitives.CylinderGeometry);

away.primitives.ConeGeometry.className = "away.primitives.ConeGeometry";

away.primitives.ConeGeometry.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.primitives.ConeGeometry.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.primitives.ConeGeometry.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'radius', t:'Number'});
			p.push({n:'height', t:'Number'});
			p.push({n:'segmentsW', t:'Number'});
			p.push({n:'segmentsH', t:'Number'});
			p.push({n:'closed', t:'Boolean'});
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

