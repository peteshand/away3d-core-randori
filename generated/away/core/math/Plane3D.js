/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:39 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.math == "undefined")
	away.core.math = {};

away.core.math.Plane3D = function(a, b, c, d) {
	this._iAlignment = 0;
	a = a || 0;
	b = b || 0;
	c = c || 0;
	d = d || 0;
	this.a = a;
	this.b = b;
	this.c = c;
	this.d = d;
	if (a == 0 && b == 0) {
		this._iAlignment = away.core.math.Plane3D.ALIGN_XY_AXIS;
	} else if (b == 0 && c == 0) {
		this._iAlignment = away.core.math.Plane3D.ALIGN_YZ_AXIS;
	} else if (a == 0 && c == 0) {
		this._iAlignment = away.core.math.Plane3D.ALIGN_XZ_AXIS;
	} else {
		this._iAlignment = away.core.math.Plane3D.ALIGN_ANY;
	}
};

away.core.math.Plane3D.ALIGN_ANY = 0;

away.core.math.Plane3D.ALIGN_XY_AXIS = 1;

away.core.math.Plane3D.ALIGN_YZ_AXIS = 2;

away.core.math.Plane3D.ALIGN_XZ_AXIS = 3;

away.core.math.Plane3D.prototype.fromPoints = function(p0, p1, p2) {
	var d1x = p1.x - p0.x;
	var d1y = p1.y - p0.y;
	var d1z = p1.z - p0.z;
	var d2x = p2.x - p0.x;
	var d2y = p2.y - p0.y;
	var d2z = p2.z - p0.z;
	this.a = d1y * d2z - d1z * d2y;
	this.b = d1z * d2x - d1x * d2z;
	this.c = d1x * d2y - d1y * d2x;
	this.d = this.a * p0.x + this.b * p0.y + this.c * p0.z;
	if (this.a == 0 && this.b == 0) {
		this._iAlignment = away.core.math.Plane3D.ALIGN_XY_AXIS;
	} else if (this.b == 0 && this.c == 0) {
		this._iAlignment = away.core.math.Plane3D.ALIGN_YZ_AXIS;
	} else if (this.a == 0 && this.c == 0) {
		this._iAlignment = away.core.math.Plane3D.ALIGN_XZ_AXIS;
	} else {
		this._iAlignment = away.core.math.Plane3D.ALIGN_ANY;
	}
};

away.core.math.Plane3D.prototype.fromNormalAndPoint = function(normal, point) {
	this.a = normal.x;
	this.b = normal.y;
	this.c = normal.z;
	this.d = this.a * point.x + this.b * point.y + this.c * point.z;
	if (this.a == 0 && this.b == 0) {
		this._iAlignment = away.core.math.Plane3D.ALIGN_XY_AXIS;
	} else if (this.b == 0 && this.c == 0) {
		this._iAlignment = away.core.math.Plane3D.ALIGN_YZ_AXIS;
	} else if (this.a == 0 && this.c == 0) {
		this._iAlignment = away.core.math.Plane3D.ALIGN_XZ_AXIS;
	} else {
		this._iAlignment = away.core.math.Plane3D.ALIGN_ANY;
	}
};

away.core.math.Plane3D.prototype.normalize = function() {
	var len = 1 / Math.sqrt(this.a * this.a + this.b * this.b + this.c * this.c);
	this.a *= len;
	this.b *= len;
	this.c *= len;
	this.d *= len;
	return this;
};

away.core.math.Plane3D.prototype.distance = function(p) {
	if (this._iAlignment == away.core.math.Plane3D.ALIGN_YZ_AXIS) {
		return this.a * p.x - this.d;
	} else if (this._iAlignment == away.core.math.Plane3D.ALIGN_XZ_AXIS) {
		return this.b * p.y - this.d;
	} else if (this._iAlignment == away.core.math.Plane3D.ALIGN_XY_AXIS) {
		return this.c * p.z - this.d;
	} else {
		return this.a * p.x + this.b * p.y + this.c * p.z - this.d;
	}
};

away.core.math.Plane3D.prototype.classifyPoint = function(p, epsilon) {
	epsilon = epsilon || 0.01;
	if (this.d != this.d)
		return away.core.math.PlaneClassification.FRONT;
	var len;
	if (this._iAlignment == away.core.math.Plane3D.ALIGN_YZ_AXIS)
		len = this.a * p.x - this.d;
	else if (this._iAlignment == away.core.math.Plane3D.ALIGN_XZ_AXIS)
		len = this.b * p.y - this.d;
	else if (this._iAlignment == away.core.math.Plane3D.ALIGN_XY_AXIS)
		len = this.c * p.z - this.d;
	else
		len = this.a * p.x + this.b * p.y + this.c * p.z - this.d;
	if (len < -epsilon)
		return away.core.math.PlaneClassification.BACK;
	else if (len > epsilon)
		return away.core.math.PlaneClassification.FRONT;
	else
		return away.core.math.PlaneClassification.INTERSECT;
};

away.core.math.Plane3D.prototype.toString = function() {
	return "Plane3D [a:" + this.a + ", b:" + this.b + ", c:" + this.c + ", d:" + this.d + "]";
};

away.core.math.Plane3D.className = "away.core.math.Plane3D";

away.core.math.Plane3D.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.core.math.PlaneClassification');
	return p;
};

away.core.math.Plane3D.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.core.math.Plane3D.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'a', t:'Number'});
			p.push({n:'b', t:'Number'});
			p.push({n:'c', t:'Number'});
			p.push({n:'d', t:'Number'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

