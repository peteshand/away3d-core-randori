/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 25 08:00:50 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.primitives == "undefined")
	away.primitives = {};

away.primitives.WireframePlane = function(width, height, segmentsW, segmentsH, color, thickness, orientation) {
	this._segmentsH = 0;
	this._width = 0;
	this._height = 0;
	this._orientation = null;
	this._segmentsW = 0;
	segmentsW = segmentsW || 10;
	segmentsH = segmentsH || 10;
	color = color || 0xFFFFFF;
	thickness = thickness || 1;
	orientation = orientation || "yz";
	away.primitives.WireframePrimitiveBase.call(this, color, thickness);
	this._width = width;
	this._height = height;
	this._segmentsW = segmentsW;
	this._segmentsH = segmentsH;
	this._orientation = orientation;
};

away.primitives.WireframePlane.ORIENTATION_YZ = "yz";

away.primitives.WireframePlane.ORIENTATION_XY = "xy";

away.primitives.WireframePlane.ORIENTATION_XZ = "xz";

away.primitives.WireframePlane.prototype.get_orientation = function() {
	return this._orientation;
};

away.primitives.WireframePlane.prototype.set_orientation = function(value) {
	this._orientation = value;
	this.pInvalidateGeometry();
};

away.primitives.WireframePlane.prototype.get_width = function() {
	return this._width;
};

away.primitives.WireframePlane.prototype.set_width = function(value) {
	this._width = value;
	this.pInvalidateGeometry();
};

away.primitives.WireframePlane.prototype.get_height = function() {
	return this._height;
};

away.primitives.WireframePlane.prototype.set_height = function(value) {
	if (value <= 0)
		throw new Error("Value needs to be greater than 0", 0);
	this._height = value;
	this.pInvalidateGeometry();
};

away.primitives.WireframePlane.prototype.get_segmentsW = function() {
	return this._segmentsW;
};

away.primitives.WireframePlane.prototype.set_segmentsW = function(value) {
	this._segmentsW = value;
	this.removeAllSegments();
	this.pInvalidateGeometry();
};

away.primitives.WireframePlane.prototype.get_segmentsH = function() {
	return this._segmentsH;
};

away.primitives.WireframePlane.prototype.set_segmentsH = function(value) {
	this._segmentsH = value;
	this.removeAllSegments();
	this.pInvalidateGeometry();
};

away.primitives.WireframePlane.prototype.pBuildGeometry = function() {
	var v0 = new away.geom.Vector3D(0, 0, 0, 0);
	var v1 = new away.geom.Vector3D(0, 0, 0, 0);
	var hw = this._width * .5;
	var hh = this._height * .5;
	var index = 0;
	var ws, hs;
	if (this._orientation == away.primitives.WireframePlane.ORIENTATION_XY) {
		v0.y = hh;
		v0.z = 0;
		v1.y = -hh;
		v1.z = 0;
		for (ws = 0; ws <= this._segmentsW; ++ws) {
			v0.x = (ws / this._segmentsW - .5) * this._width;
			v1.x = (ws / this._segmentsW - .5) * this._width;
			this.pUpdateOrAddSegment(index++, v0, v1);
		}
		v0.x = -hw;
		v1.x = hw;
		for (hs = 0; hs <= this._segmentsH; ++hs) {
			v0.y = (hs / this._segmentsH - .5) * this._height;
			v1.y = (hs / this._segmentsH - .5) * this._height;
			this.pUpdateOrAddSegment(index++, v0, v1);
		}
	} else if (this._orientation == away.primitives.WireframePlane.ORIENTATION_XZ) {
		v0.z = hh;
		v0.y = 0;
		v1.z = -hh;
		v1.y = 0;
		for (ws = 0; ws <= this._segmentsW; ++ws) {
			v0.x = (ws / this._segmentsW - .5) * this._width;
			v1.x = (ws / this._segmentsW - .5) * this._width;
			this.pUpdateOrAddSegment(index++, v0, v1);
		}
		v0.x = -hw;
		v1.x = hw;
		for (hs = 0; hs <= this._segmentsH; ++hs) {
			v0.z = (hs / this._segmentsH - .5) * this._height;
			v1.z = (hs / this._segmentsH - .5) * this._height;
			this.pUpdateOrAddSegment(index++, v0, v1);
		}
	} else if (this._orientation == away.primitives.WireframePlane.ORIENTATION_YZ) {
		v0.y = hh;
		v0.x = 0;
		v1.y = -hh;
		v1.x = 0;
		for (ws = 0; ws <= this._segmentsW; ++ws) {
			v0.z = (ws / this._segmentsW - .5) * this._width;
			v1.z = (ws / this._segmentsW - .5) * this._width;
			this.pUpdateOrAddSegment(index++, v0, v1);
		}
		v0.z = hw;
		v1.z = -hw;
		for (hs = 0; hs <= this._segmentsH; ++hs) {
			v0.y = (hs / this._segmentsH - .5) * this._height;
			v1.y = (hs / this._segmentsH - .5) * this._height;
			this.pUpdateOrAddSegment(index++, v0, v1);
		}
	}
};

$inherit(away.primitives.WireframePlane, away.primitives.WireframePrimitiveBase);

away.primitives.WireframePlane.className = "away.primitives.WireframePlane";

away.primitives.WireframePlane.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.Vector3D');
	return p;
};

away.primitives.WireframePlane.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.primitives.WireframePlane.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'width', t:'Number'});
			p.push({n:'height', t:'Number'});
			p.push({n:'segmentsW', t:'Number'});
			p.push({n:'segmentsH', t:'Number'});
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

