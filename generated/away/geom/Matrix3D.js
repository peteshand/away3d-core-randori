/** Compiled by the Randori compiler v0.2.6.2 on Mon Sep 02 23:32:23 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.geom == "undefined")
	away.geom = {};

away.geom.Matrix3D = function(v) {
	this.rawData = null;
	if (v != null && v.length == 16) {
		this.rawData = v;
	} else {
		this.rawData = [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1];
	}
};

away.geom.Matrix3D.prototype.append = function(lhs) {
	var m111 = this.rawData[0], m121 = this.rawData[4], m131 = this.rawData[8], m141 = this.rawData[12], m112 = this.rawData[1], m122 = this.rawData[5], m132 = this.rawData[9], m142 = this.rawData[13], m113 = this.rawData[2], m123 = this.rawData[6], m133 = this.rawData[10], m143 = this.rawData[14], m114 = this.rawData[3], m124 = this.rawData[7], m134 = this.rawData[11], m144 = this.rawData[15], m211 = lhs.rawData[0], m221 = lhs.rawData[4], m231 = lhs.rawData[8], m241 = lhs.rawData[12], m212 = lhs.rawData[1], m222 = lhs.rawData[5], m232 = lhs.rawData[9], m242 = lhs.rawData[13], m213 = lhs.rawData[2], m223 = lhs.rawData[6], m233 = lhs.rawData[10], m243 = lhs.rawData[14], m214 = lhs.rawData[3], m224 = lhs.rawData[7], m234 = lhs.rawData[11], m244 = lhs.rawData[15];
	this.rawData[0] = m111 * m211 + m112 * m221 + m113 * m231 + m114 * m241;
	this.rawData[1] = m111 * m212 + m112 * m222 + m113 * m232 + m114 * m242;
	this.rawData[2] = m111 * m213 + m112 * m223 + m113 * m233 + m114 * m243;
	this.rawData[3] = m111 * m214 + m112 * m224 + m113 * m234 + m114 * m244;
	this.rawData[4] = m121 * m211 + m122 * m221 + m123 * m231 + m124 * m241;
	this.rawData[5] = m121 * m212 + m122 * m222 + m123 * m232 + m124 * m242;
	this.rawData[6] = m121 * m213 + m122 * m223 + m123 * m233 + m124 * m243;
	this.rawData[7] = m121 * m214 + m122 * m224 + m123 * m234 + m124 * m244;
	this.rawData[8] = m131 * m211 + m132 * m221 + m133 * m231 + m134 * m241;
	this.rawData[9] = m131 * m212 + m132 * m222 + m133 * m232 + m134 * m242;
	this.rawData[10] = m131 * m213 + m132 * m223 + m133 * m233 + m134 * m243;
	this.rawData[11] = m131 * m214 + m132 * m224 + m133 * m234 + m134 * m244;
	this.rawData[12] = m141 * m211 + m142 * m221 + m143 * m231 + m144 * m241;
	this.rawData[13] = m141 * m212 + m142 * m222 + m143 * m232 + m144 * m242;
	this.rawData[14] = m141 * m213 + m142 * m223 + m143 * m233 + m144 * m243;
	this.rawData[15] = m141 * m214 + m142 * m224 + m143 * m234 + m144 * m244;
};

away.geom.Matrix3D.prototype.appendRotation = function(degrees, axis) {
	var m = away.geom.Matrix3D.getAxisRotation(axis.x, axis.y, axis.z, degrees);
	this.append(m);
};

away.geom.Matrix3D.prototype.appendScale = function(xScale, yScale, zScale) {
	this.append(new away.geom.Matrix3D([xScale, 0.0, 0.0, 0.0, 0.0, yScale, 0.0, 0.0, 0.0, 0.0, zScale, 0.0, 0.0, 0.0, 0.0, 1.0]));
};

away.geom.Matrix3D.prototype.appendTranslation = function(x, y, z) {
	this.rawData[12] += x;
	this.rawData[13] += y;
	this.rawData[14] += z;
};

away.geom.Matrix3D.prototype.clone = function() {
	return new away.geom.Matrix3D(this.rawData.slice(0, 2147483647));
};

away.geom.Matrix3D.prototype.copyColumnFrom = function(column, vector3D) {
	switch (column) {
		case 0:
			this.rawData[0] = vector3D.x;
			this.rawData[1] = vector3D.y;
			this.rawData[2] = vector3D.z;
			this.rawData[3] = vector3D.w;
			break;
		case 1:
			this.rawData[4] = vector3D.x;
			this.rawData[5] = vector3D.y;
			this.rawData[6] = vector3D.z;
			this.rawData[7] = vector3D.w;
			break;
		case 2:
			this.rawData[8] = vector3D.x;
			this.rawData[9] = vector3D.y;
			this.rawData[10] = vector3D.z;
			this.rawData[11] = vector3D.w;
			break;
		case 3:
			this.rawData[12] = vector3D.x;
			this.rawData[13] = vector3D.y;
			this.rawData[14] = vector3D.z;
			this.rawData[15] = vector3D.w;
			break;
		default:
			throw new away.errors.ArgumentError("ArgumentError, Column " + column + " out of bounds [0, ..., 3]", 0);
	}
};

away.geom.Matrix3D.prototype.copyColumnTo = function(column, vector3D) {
	switch (column) {
		case 0:
			vector3D.x = this.rawData[0];
			vector3D.y = this.rawData[1];
			vector3D.z = this.rawData[2];
			vector3D.w = this.rawData[3];
			break;
		case 1:
			vector3D.x = this.rawData[4];
			vector3D.y = this.rawData[5];
			vector3D.z = this.rawData[6];
			vector3D.w = this.rawData[7];
			break;
		case 2:
			vector3D.x = this.rawData[8];
			vector3D.y = this.rawData[9];
			vector3D.z = this.rawData[10];
			vector3D.w = this.rawData[11];
			break;
		case 3:
			vector3D.x = this.rawData[12];
			vector3D.y = this.rawData[13];
			vector3D.z = this.rawData[14];
			vector3D.w = this.rawData[15];
			break;
		default:
			throw new away.errors.ArgumentError("ArgumentError, Column " + column + " out of bounds [0, ..., 3]", 0);
	}
};

away.geom.Matrix3D.prototype.copyFrom = function(sourceMatrix3D) {
	var l = sourceMatrix3D.rawData.length;
	for (var c = 0; c < l; c++) {
		this.rawData[c] = sourceMatrix3D.rawData[c];
	}
};

away.geom.Matrix3D.prototype.copyRawDataFrom = function(vector, index, transposeThis) {
	if (transposeThis) {
		this.transpose();
	}
	var l = vector.length - index;
	for (var c = 0; c < l; c++) {
		this.rawData[c] = vector[c + index];
	}
	if (transposeThis) {
		this.transpose();
	}
};

away.geom.Matrix3D.prototype.copyRawDataTo = function(vector, index, transposeThis) {
	if (transposeThis) {
		this.transpose();
	}
	var l = this.rawData.length;
	for (var c = 0; c < l; c++) {
		vector[c + index] = this.rawData[c];
	}
	if (transposeThis) {
		this.transpose();
	}
};

away.geom.Matrix3D.prototype.copyRowFrom = function(row, vector3D) {
	switch (row) {
		case 0:
			this.rawData[0] = vector3D.x;
			this.rawData[4] = vector3D.y;
			this.rawData[8] = vector3D.z;
			this.rawData[12] = vector3D.w;
			break;
		case 1:
			this.rawData[1] = vector3D.x;
			this.rawData[5] = vector3D.y;
			this.rawData[9] = vector3D.z;
			this.rawData[13] = vector3D.w;
			break;
		case 2:
			this.rawData[2] = vector3D.x;
			this.rawData[6] = vector3D.y;
			this.rawData[10] = vector3D.z;
			this.rawData[14] = vector3D.w;
			break;
		case 3:
			this.rawData[3] = vector3D.x;
			this.rawData[7] = vector3D.y;
			this.rawData[11] = vector3D.z;
			this.rawData[15] = vector3D.w;
			break;
		default:
			throw new away.errors.ArgumentError("ArgumentError, Row " + row + " out of bounds [0, ..., 3]", 0);
	}
};

away.geom.Matrix3D.prototype.copyRowTo = function(row, vector3D) {
	switch (row) {
		case 0:
			vector3D.x = this.rawData[0];
			vector3D.y = this.rawData[4];
			vector3D.z = this.rawData[8];
			vector3D.w = this.rawData[12];
			break;
		case 1:
			vector3D.x = this.rawData[1];
			vector3D.y = this.rawData[5];
			vector3D.z = this.rawData[9];
			vector3D.w = this.rawData[13];
			break;
		case 2:
			vector3D.x = this.rawData[2];
			vector3D.y = this.rawData[6];
			vector3D.z = this.rawData[10];
			vector3D.w = this.rawData[14];
			break;
		case 3:
			vector3D.x = this.rawData[3];
			vector3D.y = this.rawData[7];
			vector3D.z = this.rawData[11];
			vector3D.w = this.rawData[15];
			break;
		default:
			throw new away.errors.ArgumentError("ArgumentError, Row " + row + " out of bounds [0, ..., 3]", 0);
	}
};

away.geom.Matrix3D.prototype.copyToMatrix3D = function(dest) {
	dest.rawData = this.rawData.slice(0, 2147483647);
};

away.geom.Matrix3D.prototype.decompose = function() {
	var vec = [];
	var m = this.clone();
	var mr = m.rawData;
	var pos = new away.geom.Vector3D(mr[12], mr[13], mr[14], 0);
	mr[12] = 0;
	mr[13] = 0;
	mr[14] = 0;
	var scale = new away.geom.Vector3D(0, 0, 0, 0);
	scale.x = Math.sqrt(mr[0] * mr[0] + mr[1] * mr[1] + mr[2] * mr[2]);
	scale.y = Math.sqrt(mr[4] * mr[4] + mr[5] * mr[5] + mr[6] * mr[6]);
	scale.z = Math.sqrt(mr[8] * mr[8] + mr[9] * mr[9] + mr[10] * mr[10]);
	if (mr[0] * (mr[5] * mr[10] - mr[6] * mr[9]) - mr[1] * (mr[4] * mr[10] - mr[6] * mr[8]) + mr[2] * (mr[4] * mr[9] - mr[5] * mr[8]) < 0) {
		scale.z = -scale.z;
	}
	mr[0] /= scale.x;
	mr[1] /= scale.x;
	mr[2] /= scale.x;
	mr[4] /= scale.y;
	mr[5] /= scale.y;
	mr[6] /= scale.y;
	mr[8] /= scale.z;
	mr[9] /= scale.z;
	mr[10] /= scale.z;
	var rot = new away.geom.Vector3D(0, 0, 0, 0);
	rot.y = Math.asin(-mr[2]);
	var cos = Math.cos(rot.y);
	if (cos > 0) {
		rot.x = Math.atan2(mr[6], mr[10]);
		rot.z = Math.atan2(mr[1], mr[0]);
	} else {
		rot.z = 0;
		rot.x = Math.atan2(mr[4], mr[5]);
	}
	vec.push(pos);
	vec.push(rot);
	vec.push(scale);
	return vec;
};

away.geom.Matrix3D.prototype.deltaTransformVector = function(v) {
	var x = v.x, y = v.y, z = v.z;
	return new away.geom.Vector3D((x * this.rawData[0] + y * this.rawData[1] + z * this.rawData[2] + this.rawData[3]), (x * this.rawData[4] + y * this.rawData[5] + z * this.rawData[6] + this.rawData[7]), (x * this.rawData[8] + y * this.rawData[9] + z * this.rawData[10] + this.rawData[11]), 0);
};

away.geom.Matrix3D.prototype.identity = function() {
	this.rawData = [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1];
};

away.geom.Matrix3D.interpolate = function(thisMat, toMat, percent) {
	var m = new away.geom.Matrix3D();
	for (var i = 0; i < 16; ++i) {
		m.rawData[i] = thisMat.rawData[i] + (toMat.rawData[i] - thisMat.rawData[i]) * percent;
	}
	return m;
};

away.geom.Matrix3D.prototype.interpolateTo = function(toMat, percent) {
	for (var i = 0; i < 16; ++i) {
		this.rawData[i] = this.rawData[i] + (toMat.rawData[i] - this.rawData[i]) * percent;
	}
};

away.geom.Matrix3D.prototype.invert = function() {
	var d = this.get_determinant();
	var invertable = Math.abs(d) > 0.00000000001;
	if (invertable) {
		d = 1 / d;
		var m11 = this.rawData[0];
		var m21 = this.rawData[4];
		var m31 = this.rawData[8];
		var m41 = this.rawData[12];
		var m12 = this.rawData[1];
		var m22 = this.rawData[5];
		var m32 = this.rawData[9];
		var m42 = this.rawData[13];
		var m13 = this.rawData[2];
		var m23 = this.rawData[6];
		var m33 = this.rawData[10];
		var m43 = this.rawData[14];
		var m14 = this.rawData[3];
		var m24 = this.rawData[7];
		var m34 = this.rawData[11];
		var m44 = this.rawData[15];
		this.rawData[0] = d * (m22 * (m33 * m44 - m43 * m34) - m32 * (m23 * m44 - m43 * m24) + m42 * (m23 * m34 - m33 * m24));
		this.rawData[1] = -d * (m12 * (m33 * m44 - m43 * m34) - m32 * (m13 * m44 - m43 * m14) + m42 * (m13 * m34 - m33 * m14));
		this.rawData[2] = d * (m12 * (m23 * m44 - m43 * m24) - m22 * (m13 * m44 - m43 * m14) + m42 * (m13 * m24 - m23 * m14));
		this.rawData[3] = -d * (m12 * (m23 * m34 - m33 * m24) - m22 * (m13 * m34 - m33 * m14) + m32 * (m13 * m24 - m23 * m14));
		this.rawData[4] = -d * (m21 * (m33 * m44 - m43 * m34) - m31 * (m23 * m44 - m43 * m24) + m41 * (m23 * m34 - m33 * m24));
		this.rawData[5] = d * (m11 * (m33 * m44 - m43 * m34) - m31 * (m13 * m44 - m43 * m14) + m41 * (m13 * m34 - m33 * m14));
		this.rawData[6] = -d * (m11 * (m23 * m44 - m43 * m24) - m21 * (m13 * m44 - m43 * m14) + m41 * (m13 * m24 - m23 * m14));
		this.rawData[7] = d * (m11 * (m23 * m34 - m33 * m24) - m21 * (m13 * m34 - m33 * m14) + m31 * (m13 * m24 - m23 * m14));
		this.rawData[8] = d * (m21 * (m32 * m44 - m42 * m34) - m31 * (m22 * m44 - m42 * m24) + m41 * (m22 * m34 - m32 * m24));
		this.rawData[9] = -d * (m11 * (m32 * m44 - m42 * m34) - m31 * (m12 * m44 - m42 * m14) + m41 * (m12 * m34 - m32 * m14));
		this.rawData[10] = d * (m11 * (m22 * m44 - m42 * m24) - m21 * (m12 * m44 - m42 * m14) + m41 * (m12 * m24 - m22 * m14));
		this.rawData[11] = -d * (m11 * (m22 * m34 - m32 * m24) - m21 * (m12 * m34 - m32 * m14) + m31 * (m12 * m24 - m22 * m14));
		this.rawData[12] = -d * (m21 * (m32 * m43 - m42 * m33) - m31 * (m22 * m43 - m42 * m23) + m41 * (m22 * m33 - m32 * m23));
		this.rawData[13] = d * (m11 * (m32 * m43 - m42 * m33) - m31 * (m12 * m43 - m42 * m13) + m41 * (m12 * m33 - m32 * m13));
		this.rawData[14] = -d * (m11 * (m22 * m43 - m42 * m23) - m21 * (m12 * m43 - m42 * m13) + m41 * (m12 * m23 - m22 * m13));
		this.rawData[15] = d * (m11 * (m22 * m33 - m32 * m23) - m21 * (m12 * m33 - m32 * m13) + m31 * (m12 * m23 - m22 * m13));
	}
	return invertable;
};

away.geom.Matrix3D.prototype.prepend = function(rhs) {
	var m111 = rhs.rawData[0], m121 = rhs.rawData[4], m131 = rhs.rawData[8], m141 = rhs.rawData[12], m112 = rhs.rawData[1], m122 = rhs.rawData[5], m132 = rhs.rawData[9], m142 = rhs.rawData[13], m113 = rhs.rawData[2], m123 = rhs.rawData[6], m133 = rhs.rawData[10], m143 = rhs.rawData[14], m114 = rhs.rawData[3], m124 = rhs.rawData[7], m134 = rhs.rawData[11], m144 = rhs.rawData[15], m211 = this.rawData[0], m221 = this.rawData[4], m231 = this.rawData[8], m241 = this.rawData[12], m212 = this.rawData[1], m222 = this.rawData[5], m232 = this.rawData[9], m242 = this.rawData[13], m213 = this.rawData[2], m223 = this.rawData[6], m233 = this.rawData[10], m243 = this.rawData[14], m214 = this.rawData[3], m224 = this.rawData[7], m234 = this.rawData[11], m244 = this.rawData[15];
	this.rawData[0] = m111 * m211 + m112 * m221 + m113 * m231 + m114 * m241;
	this.rawData[1] = m111 * m212 + m112 * m222 + m113 * m232 + m114 * m242;
	this.rawData[2] = m111 * m213 + m112 * m223 + m113 * m233 + m114 * m243;
	this.rawData[3] = m111 * m214 + m112 * m224 + m113 * m234 + m114 * m244;
	this.rawData[4] = m121 * m211 + m122 * m221 + m123 * m231 + m124 * m241;
	this.rawData[5] = m121 * m212 + m122 * m222 + m123 * m232 + m124 * m242;
	this.rawData[6] = m121 * m213 + m122 * m223 + m123 * m233 + m124 * m243;
	this.rawData[7] = m121 * m214 + m122 * m224 + m123 * m234 + m124 * m244;
	this.rawData[8] = m131 * m211 + m132 * m221 + m133 * m231 + m134 * m241;
	this.rawData[9] = m131 * m212 + m132 * m222 + m133 * m232 + m134 * m242;
	this.rawData[10] = m131 * m213 + m132 * m223 + m133 * m233 + m134 * m243;
	this.rawData[11] = m131 * m214 + m132 * m224 + m133 * m234 + m134 * m244;
	this.rawData[12] = m141 * m211 + m142 * m221 + m143 * m231 + m144 * m241;
	this.rawData[13] = m141 * m212 + m142 * m222 + m143 * m232 + m144 * m242;
	this.rawData[14] = m141 * m213 + m142 * m223 + m143 * m233 + m144 * m243;
	this.rawData[15] = m141 * m214 + m142 * m224 + m143 * m234 + m144 * m244;
};

away.geom.Matrix3D.prototype.prependRotation = function(degrees, axis) {
	var m = away.geom.Matrix3D.getAxisRotation(axis.x, axis.y, axis.z, degrees);
	this.prepend(m);
};

away.geom.Matrix3D.prototype.prependScale = function(xScale, yScale, zScale) {
	this.prepend(new away.geom.Matrix3D([xScale, 0, 0, 0, 0, yScale, 0, 0, 0, 0, zScale, 0, 0, 0, 0, 1]));
};

away.geom.Matrix3D.prototype.prependTranslation = function(x, y, z) {
	var m = new away.geom.Matrix3D();
	m.position = new away.geom.Vector3D(x, y, z, 0);
	this.prepend(m);
};

away.geom.Matrix3D.prototype.recompose = function(components) {
	if (components.length < 3)
		return false;
	this.identity();
	this.appendScale(components[2].x, components[2].y, components[2].z);
	var angle;
	angle = -components[1].x;
	this.append(new away.geom.Matrix3D([1, 0, 0, 0, 0, Math.cos(angle), -Math.sin(angle), 0, 0, Math.sin(angle), Math.cos(angle), 0, 0, 0, 0, 0]));
	angle = -components[1].y;
	this.append(new away.geom.Matrix3D([Math.cos(angle), 0, Math.sin(angle), 0, 0, 1, 0, 0, -Math.sin(angle), 0, Math.cos(angle), 0, 0, 0, 0, 0]));
	angle = -components[1].z;
	this.append(new away.geom.Matrix3D([Math.cos(angle), -Math.sin(angle), 0, 0, Math.sin(angle), Math.cos(angle), 0, 0, 0, 0, 1, 0, 0, 0, 0, 0]));
	this.set_position(components[0]);
	this.rawData[15] = 1;
	return true;
};

away.geom.Matrix3D.prototype.transformVector = function(v) {
	var x = v.x;
	var y = v.y;
	var z = v.z;
	return new away.geom.Vector3D((x * this.rawData[0] + y * this.rawData[4] + z * this.rawData[8] + this.rawData[12]), (x * this.rawData[1] + y * this.rawData[5] + z * this.rawData[9] + this.rawData[13]), (x * this.rawData[2] + y * this.rawData[6] + z * this.rawData[10] + this.rawData[14]), (x * this.rawData[3] + y * this.rawData[7] + z * this.rawData[11] + this.rawData[15]));
};

away.geom.Matrix3D.prototype.transformVectors = function(vin, vout) {
	var i = 0;
	var x = 0, y = 0, z = 0;
	while (i + 3 <= vin.length) {
		x = vin[i];
		y = vin[i + 1];
		z = vin[i + 2];
		vout[i] = x * this.rawData[0] + y * this.rawData[4] + z * this.rawData[8] + this.rawData[12];
		vout[i + 1] = x * this.rawData[1] + y * this.rawData[5] + z * this.rawData[9] + this.rawData[13];
		vout[i + 2] = x * this.rawData[2] + y * this.rawData[6] + z * this.rawData[10] + this.rawData[14];
		i += 3;
	}
};

away.geom.Matrix3D.prototype.transpose = function() {
	var oRawData = this.rawData.slice(0, 2147483647);
	this.rawData[1] = oRawData[4];
	this.rawData[2] = oRawData[8];
	this.rawData[3] = oRawData[12];
	this.rawData[4] = oRawData[1];
	this.rawData[6] = oRawData[9];
	this.rawData[7] = oRawData[13];
	this.rawData[8] = oRawData[2];
	this.rawData[9] = oRawData[6];
	this.rawData[11] = oRawData[14];
	this.rawData[12] = oRawData[3];
	this.rawData[13] = oRawData[7];
	this.rawData[14] = oRawData[11];
};

away.geom.Matrix3D.getAxisRotation = function(x, y, z, degrees) {
	var m = new away.geom.Matrix3D();
	var a1 = new away.geom.Vector3D(x, y, z, 0);
	var rad = -degrees * (3.141592653589793 / 180);
	var c = Math.cos(rad);
	var s = Math.sin(rad);
	var t = 1.0 - c;
	m.rawData[0] = c + a1.x * a1.x * t;
	m.rawData[5] = c + a1.y * a1.y * t;
	m.rawData[10] = c + a1.z * a1.z * t;
	var tmp1 = a1.x * a1.y * t;
	var tmp2 = a1.z * s;
	m.rawData[4] = tmp1 + tmp2;
	m.rawData[1] = tmp1 - tmp2;
	tmp1 = a1.x * a1.z * t;
	tmp2 = a1.y * s;
	m.rawData[8] = tmp1 - tmp2;
	m.rawData[2] = tmp1 + tmp2;
	tmp1 = a1.y * a1.z * t;
	tmp2 = a1.x * s;
	m.rawData[9] = tmp1 + tmp2;
	m.rawData[6] = tmp1 - tmp2;
	return m;
};

away.geom.Matrix3D.prototype.get_determinant = function() {
	return ((this.rawData[0] * this.rawData[5] - this.rawData[4] * this.rawData[1]) * (this.rawData[10] * this.rawData[15] - this.rawData[14] * this.rawData[11]) - (this.rawData[0] * this.rawData[9] - this.rawData[8] * this.rawData[1]) * (this.rawData[6] * this.rawData[15] - this.rawData[14] * this.rawData[7]) + (this.rawData[0] * this.rawData[13] - this.rawData[12] * this.rawData[1]) * (this.rawData[6] * this.rawData[11] - this.rawData[10] * this.rawData[7]) + (this.rawData[4] * this.rawData[9] - this.rawData[8] * this.rawData[5]) * (this.rawData[2] * this.rawData[15] - this.rawData[14] * this.rawData[3]) - (this.rawData[4] * this.rawData[13] - this.rawData[12] * this.rawData[5]) * (this.rawData[2] * this.rawData[11] - this.rawData[10] * this.rawData[3]) + (this.rawData[8] * this.rawData[13] - this.rawData[12] * this.rawData[9]) * (this.rawData[2] * this.rawData[7] - this.rawData[6] * this.rawData[3]));
};

away.geom.Matrix3D.prototype.get_position = function() {
	return new away.geom.Vector3D(this.rawData[12], this.rawData[13], this.rawData[14], 0);
};

away.geom.Matrix3D.prototype.set_position = function(value) {
	this.rawData[12] = value.x;
	this.rawData[13] = value.y;
	this.rawData[14] = value.z;
};

away.geom.Matrix3D.className = "away.geom.Matrix3D";

away.geom.Matrix3D.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.Vector3D');
	p.push('Object');
	return p;
};

away.geom.Matrix3D.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.geom.Matrix3D.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'v', t:'Array'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

