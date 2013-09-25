/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 24 23:06:44 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.primitives == "undefined")
	away.primitives = {};

away.primitives.WireframeRegularPolygon = function(radius, sides, color, thickness, orientation) {
	this._sides = 0;
	this._orientation = null;
	this._radius = 0;
	color = color || 0xFFFFFF;
	thickness = thickness || 1;
	orientation = orientation || "yz";
	away.primitives.WireframePrimitiveBase.call(this, color, thickness);
	this._radius = radius;
	this._sides = sides;
	this._orientation = orientation;
};

away.primitives.WireframeRegularPolygon.ORIENTATION_YZ = "yz";

away.primitives.WireframeRegularPolygon.ORIENTATION_XY = "xy";

away.primitives.WireframeRegularPolygon.ORIENTATION_XZ = "xz";

away.primitives.WireframeRegularPolygon.prototype.get_orientation = function() {
	return this._orientation;
};

away.primitives.WireframeRegularPolygon.prototype.set_orientation = function(value) {
	this._orientation = value;
	this.pInvalidateGeometry();
};

away.primitives.WireframeRegularPolygon.prototype.get_radius = function() {
	return this._radius;
};

away.primitives.WireframeRegularPolygon.prototype.set_radius = function(value) {
	this._radius = value;
	this.pInvalidateGeometry();
};

away.primitives.WireframeRegularPolygon.prototype.get_sides = function() {
	return this._sides;
};

away.primitives.WireframeRegularPolygon.prototype.set_sides = function(value) {
	this._sides = value;
	this.removeAllSegments();
	this.pInvalidateGeometry();
};

away.primitives.WireframeRegularPolygon.prototype.pBuildGeometry = function() {
	var v0 = new away.geom.Vector3D(0, 0, 0, 0);
	var v1 = new away.geom.Vector3D(0, 0, 0, 0);
	var index = 0;
	var s;
	if (this._orientation == away.primitives.WireframeRegularPolygon.ORIENTATION_XY) {
		v0.z = 0;
		v1.z = 0;
		for (s = 0; s < this._sides; ++s) {
			v0.x = this._radius * Math.cos(2 * 3.141592653589793 * s / this._sides);
			v0.y = this._radius * Math.sin(2 * 3.141592653589793 * s / this._sides);
			v1.x = this._radius * Math.cos(2 * 3.141592653589793 * (s + 1) / this._sides);
			v1.y = this._radius * Math.sin(2 * 3.141592653589793 * (s + 1) / this._sides);
			this.pUpdateOrAddSegment(index++, v0, v1);
		}
	} else if (this._orientation == away.primitives.WireframeRegularPolygon.ORIENTATION_XZ) {
		v0.y = 0;
		v1.y = 0;
		for (s = 0; s < this._sides; ++s) {
			v0.x = this._radius * Math.cos(2 * 3.141592653589793 * s / this._sides);
			v0.z = this._radius * Math.sin(2 * 3.141592653589793 * s / this._sides);
			v1.x = this._radius * Math.cos(2 * 3.141592653589793 * (s + 1) / this._sides);
			v1.z = this._radius * Math.sin(2 * 3.141592653589793 * (s + 1) / this._sides);
			this.pUpdateOrAddSegment(index++, v0, v1);
		}
	} else if (this._orientation == away.primitives.WireframeRegularPolygon.ORIENTATION_YZ) {
		v0.x = 0;
		v1.x = 0;
		for (s = 0; s < this._sides; ++s) {
			v0.z = this._radius * Math.cos(2 * 3.141592653589793 * s / this._sides);
			v0.y = this._radius * Math.sin(2 * 3.141592653589793 * s / this._sides);
			v1.z = this._radius * Math.cos(2 * 3.141592653589793 * (s + 1) / this._sides);
			v1.y = this._radius * Math.sin(2 * 3.141592653589793 * (s + 1) / this._sides);
			this.pUpdateOrAddSegment(index++, v0, v1);
		}
	}
};

$inherit(away.primitives.WireframeRegularPolygon, away.primitives.WireframePrimitiveBase);

away.primitives.WireframeRegularPolygon.className = "away.primitives.WireframeRegularPolygon";

away.primitives.WireframeRegularPolygon.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.Vector3D');
	return p;
};

away.primitives.WireframeRegularPolygon.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.primitives.WireframeRegularPolygon.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'radius', t:'Number'});
			p.push({n:'sides', t:'Number'});
			p.push({n:'color', t:'Number'});
			p.push({n:'thickness', t:'Number'});
			p.push({n:'orientation', t:'String'});
			break;
		case 1:
			p = away.primitives.WireframePrimitiveBase.injectionPoints(t);
			break;
		case 2:
			p = away.primitives.WireframePrimitiveBase.injectionPoints(t);
			break;
		case 3:
			p = away.primitives.WireframePrimitiveBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

