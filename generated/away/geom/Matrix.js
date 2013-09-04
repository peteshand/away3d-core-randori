/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 04 21:18:32 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.geom == "undefined")
	away.geom = {};

away.geom.Matrix = function(a, b, c, d, tx, ty) {
	this.a = a;
	this.b = b;
	this.c = c;
	this.d = d;
	this.tx = tx;
	this.ty = ty;
};

away.geom.Matrix.prototype.clone = function() {
	return new away.geom.Matrix(this.a, this.b, this.c, this.d, this.tx, this.ty);
};

away.geom.Matrix.prototype.concat = function(m) {
	var a1 = this.a * m.a + this.b * m.c;
	this.b = this.a * m.b + this.b * m.d;
	this.a = a1;
	var c1 = this.c * m.a + this.d * m.c;
	this.d = this.c * m.b + this.d * m.d;
	this.c = c1;
	var tx1 = this.tx * m.a + this.ty * m.c + m.tx;
	this.ty = this.tx * m.b + this.ty * m.d + m.ty;
	this.tx = tx1;
};

away.geom.Matrix.prototype.copyColumnFrom = function(column, vector3D) {
	if (column > 2) {
		throw "Column " + column + " out of bounds (2)";
	} else if (column == 0) {
		this.a = vector3D.x;
		this.c = vector3D.y;
	} else if (column == 1) {
		this.b = vector3D.x;
		this.d = vector3D.y;
	} else {
		this.tx = vector3D.x;
		this.ty = vector3D.y;
	}
};

away.geom.Matrix.prototype.copyColumnTo = function(column, vector3D) {
	if (column > 2) {
		throw new away.errors.ArgumentError("ArgumentError, Column " + column + " out of bounds [0, ..., 2]", 0);
	} else if (column == 0) {
		vector3D.x = this.a;
		vector3D.y = this.c;
		vector3D.z = 0;
	} else if (column == 1) {
		vector3D.x = this.b;
		vector3D.y = this.d;
		vector3D.z = 0;
	} else {
		vector3D.x = this.tx;
		vector3D.y = this.ty;
		vector3D.z = 1;
	}
};

away.geom.Matrix.prototype.copyFrom = function(other) {
	this.a = other.a;
	this.b = other.b;
	this.c = other.c;
	this.d = other.d;
	this.tx = other.tx;
	this.ty = other.ty;
};

away.geom.Matrix.prototype.copyRowFrom = function(row, vector3D) {
	if (row > 2) {
		throw new away.errors.ArgumentError("ArgumentError, Row " + row + " out of bounds [0, ..., 2]", 0);
	} else if (row == 0) {
		this.a = vector3D.x;
		this.c = vector3D.y;
	} else if (row == 1) {
		this.b = vector3D.x;
		this.d = vector3D.y;
	} else {
		this.tx = vector3D.x;
		this.ty = vector3D.y;
	}
};

away.geom.Matrix.prototype.copyRowTo = function(row, vector3D) {
	if (row > 2) {
		throw new away.errors.ArgumentError("ArgumentError, Row " + row + " out of bounds [0, ..., 2]", 0);
	} else if (row == 0) {
		vector3D.x = this.a;
		vector3D.y = this.b;
		vector3D.z = this.tx;
	} else if (row == 1) {
		vector3D.x = this.c;
		vector3D.y = this.d;
		vector3D.z = this.ty;
	} else {
		vector3D.setTo(0, 0, 1);
	}
};

away.geom.Matrix.prototype.createBox = function(scaleX, scaleY, rotation, tx, ty) {
	this.a = scaleX;
	this.d = scaleY;
	this.b = rotation;
	tx = tx;
	ty = ty;
};

away.geom.Matrix.prototype.createGradientBox = function(width, height, rotation, tx, ty) {
	this.a = width / 1638.4;
	this.d = height / 1638.4;
	if (rotation != 0.0) {
		var cos = Math.cos(rotation);
		var sin = Math.sin(rotation);
		this.b = sin * this.d;
		this.c = -sin * this.a;
		this.a *= cos;
		this.d *= cos;
	} else {
		this.b = this.c = 0;
	}
	tx = tx + width / 2;
	ty = ty + height / 2;
};

away.geom.Matrix.prototype.deltaTransformPoint = function(point) {
	return new away.geom.Point(point.x * this.a + point.y * this.c, point.x * this.b + point.y * this.d);
};

away.geom.Matrix.prototype.identity = function() {
	this.a = 1;
	this.b = 0;
	this.c = 0;
	this.d = 1;
	this.tx = 0;
	this.ty = 0;
};

away.geom.Matrix.prototype.invert = function() {
	var norm = this.a * this.d - this.b * this.c;
	if (norm == 0) {
		this.a = this.b = this.c = this.d = 0;
		this.tx = -this.tx;
		this.ty = -this.ty;
	} else {
		norm = 1.0 / norm;
		var a1 = this.d * norm;
		this.d = this.a * norm;
		this.a = a1;
		this.b *= -norm;
		this.c *= -norm;
		var tx1 = -this.a * this.tx - this.c * this.ty;
		this.ty = -this.b * this.tx - this.d * this.ty;
		this.tx = tx1;
	}
	return this;
};

away.geom.Matrix.prototype.mult = function(m) {
	var result = new away.geom.Matrix(1, 0, 0, 1, 0, 0);
	result.a = this.a * m.a + this.b * m.c;
	result.b = this.a * m.b + this.b * m.d;
	result.c = this.c * m.a + this.d * m.c;
	result.d = this.c * m.b + this.d * m.d;
	result.tx = this.tx * m.a + this.ty * m.c + m.tx;
	result.ty = this.tx * m.b + this.ty * m.d + m.ty;
	return result;
};

away.geom.Matrix.prototype.rotate = function(angle) {
	var cos = Math.cos(angle);
	var sin = Math.sin(angle);
	var a1 = this.a * cos - this.b * sin;
	this.b = this.a * sin + this.b * cos;
	this.a = a1;
	var c1 = this.c * cos - this.d * sin;
	this.d = this.c * sin + this.d * cos;
	this.c = c1;
	var tx1 = this.tx * cos - this.ty * sin;
	this.ty = this.tx * sin + this.ty * cos;
	this.tx = tx1;
};

away.geom.Matrix.prototype.scale = function(x, y) {
	this.a *= x;
	this.b *= y;
	this.c *= x;
	this.d *= y;
	this.tx *= x;
	this.ty *= y;
};

away.geom.Matrix.prototype.setRotation = function(angle, scale) {
	this.a = Math.cos(angle) * scale;
	this.c = Math.sin(angle) * scale;
	this.b = -this.c;
	this.d = this.a;
};

away.geom.Matrix.prototype.setTo = function(a, b, c, d, tx, ty) {
	a = a;
	b = b;
	c = c;
	d = d;
	tx = tx;
	ty = ty;
};

away.geom.Matrix.prototype.toString = function() {
	return "[Matrix] (a=" + this.a + ", b=" + this.b + ", c=" + this.c + ", d=" + this.d + ", tx=" + this.tx + ", ty=" + this.ty + ")";
};

away.geom.Matrix.prototype.transformPoint = function(point) {
	return new away.geom.Point(point.x * this.a + point.y * this.c + this.tx, point.x * this.b + point.y * this.d + this.ty);
};

away.geom.Matrix.prototype.translate = function(x, y) {
	this.tx += x;
	this.ty += y;
};

away.geom.Matrix.className = "away.geom.Matrix";

away.geom.Matrix.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.Point');
	return p;
};

away.geom.Matrix.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.geom.Matrix.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'a', t:'Number'});
			p.push({n:'b', t:'Number'});
			p.push({n:'c', t:'Number'});
			p.push({n:'d', t:'Number'});
			p.push({n:'tx', t:'Number'});
			p.push({n:'ty', t:'Number'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

