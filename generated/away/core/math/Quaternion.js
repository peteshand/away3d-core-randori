/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:40 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.math == "undefined")
	away.core.math = {};

away.core.math.Quaternion = function(x, y, z, w) {
	x = x || 0;
	y = y || 0;
	z = z || 0;
	w = w || 1;
	this.x = x;
	this.y = y;
	this.z = z;
	this.w = w;
};

away.core.math.Quaternion.prototype.get_magnitude = function() {
	return Math.sqrt(this.w * this.w + this.x * this.x + this.y * this.y + this.z * this.z);
};

away.core.math.Quaternion.prototype.multiply = function(qa, qb) {
	var w1 = qa.w, x1 = qa.x, y1 = qa.y, z1 = qa.z;
	var w2 = qb.w, x2 = qb.x, y2 = qb.y, z2 = qb.z;
	this.w = w1 * w2 - x1 * x2 - y1 * y2 - z1 * z2;
	this.x = w1 * x2 + x1 * w2 + y1 * z2 - z1 * y2;
	this.y = w1 * y2 - x1 * z2 + y1 * w2 + z1 * x2;
	this.z = w1 * z2 + x1 * y2 - y1 * x2 + z1 * w2;
};

away.core.math.Quaternion.prototype.multiplyVector = function(vector, target) {
	target = target || null;
	if (target === null) {
		target = new away.core.math.Quaternion(0, 0, 0, 1);
	}
	var x2 = vector.x;
	var y2 = vector.y;
	var z2 = vector.z;
	target.w = -this.x * x2 - this.y * y2 - this.z * z2;
	target.x = this.w * x2 + this.y * z2 - this.z * y2;
	target.y = this.w * y2 - this.x * z2 + this.z * x2;
	target.z = this.w * z2 + this.x * y2 - this.y * x2;
	return target;
};

away.core.math.Quaternion.prototype.fromAxisAngle = function(axis, angle) {
	var sin_a = Math.sin(angle / 2);
	var cos_a = Math.cos(angle / 2);
	this.x = axis.x * sin_a;
	this.y = axis.y * sin_a;
	this.z = axis.z * sin_a;
	this.w = cos_a;
	this.normalize(1);
};

away.core.math.Quaternion.prototype.slerp = function(qa, qb, t) {
	var w1 = qa.w, x1 = qa.x, y1 = qa.y, z1 = qa.z;
	var w2 = qb.w, x2 = qb.x, y2 = qb.y, z2 = qb.z;
	var dot = w1 * w2 + x1 * x2 + y1 * y2 + z1 * z2;
	if (dot < 0) {
		dot = -dot;
		w2 = -w2;
		x2 = -x2;
		y2 = -y2;
		z2 = -z2;
	}
	if (dot < 0.95) {
		var angle = Math.acos(dot);
		var s = 1 / Math.sin(angle);
		var s1 = Math.sin(angle * (1 - t)) * s;
		var s2 = Math.sin(angle * t) * s;
		this.w = w1 * s1 + w2 * s2;
		this.x = x1 * s1 + x2 * s2;
		this.y = y1 * s1 + y2 * s2;
		this.z = z1 * s1 + z2 * s2;
	} else {
		this.w = w1 + t * (w2 - w1);
		this.x = x1 + t * (x2 - x1);
		this.y = y1 + t * (y2 - y1);
		this.z = z1 + t * (z2 - z1);
		var len = 1.0 / Math.sqrt(this.w * this.w + this.x * this.x + this.y * this.y + this.z * this.z);
		this.w *= len;
		this.x *= len;
		this.y *= len;
		this.z *= len;
	}
};

away.core.math.Quaternion.prototype.lerp = function(qa, qb, t) {
	var w1 = qa.w, x1 = qa.x, y1 = qa.y, z1 = qa.z;
	var w2 = qb.w, x2 = qb.x, y2 = qb.y, z2 = qb.z;
	var len;
	if (w1 * w2 + x1 * x2 + y1 * y2 + z1 * z2 < 0) {
		w2 = -w2;
		x2 = -x2;
		y2 = -y2;
		z2 = -z2;
	}
	this.w = w1 + t * (w2 - w1);
	this.x = x1 + t * (x2 - x1);
	this.y = y1 + t * (y2 - y1);
	this.z = z1 + t * (z2 - z1);
	len = 1.0 / Math.sqrt(this.w * this.w + this.x * this.x + this.y * this.y + this.z * this.z);
	this.w *= len;
	this.x *= len;
	this.y *= len;
	this.z *= len;
};

away.core.math.Quaternion.prototype.fromEulerAngles = function(ax, ay, az) {
	var halfX = ax * .5, halfY = ay * .5, halfZ = az * .5;
	var cosX = Math.cos(halfX), sinX = Math.sin(halfX);
	var cosY = Math.cos(halfY), sinY = Math.sin(halfY);
	var cosZ = Math.cos(halfZ), sinZ = Math.sin(halfZ);
	this.w = cosX * cosY * cosZ + sinX * sinY * sinZ;
	this.x = sinX * cosY * cosZ - cosX * sinY * sinZ;
	this.y = cosX * sinY * cosZ + sinX * cosY * sinZ;
	this.z = cosX * cosY * sinZ - sinX * sinY * cosZ;
};

away.core.math.Quaternion.prototype.toEulerAngles = function(target) {
	target = target || null;
	if (target === null) {
		target = new away.core.geom.Vector3D(0, 0, 0, 0);
	}
	target.x = Math.atan2(2 * (this.w * this.x + this.y * this.z), 1 - 2 * (this.x * this.x + this.y * this.y));
	target.y = Math.asin(2 * (this.w * this.y - this.z * this.x));
	target.z = Math.atan2(2 * (this.w * this.z + this.x * this.y), 1 - 2 * (this.y * this.y + this.z * this.z));
	return target;
};

away.core.math.Quaternion.prototype.normalize = function(val) {
	val = val || 1;
	var mag = val / Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z + this.w * this.w);
	this.x *= mag;
	this.y *= mag;
	this.z *= mag;
	this.w *= mag;
};

away.core.math.Quaternion.prototype.toString = function() {
	return "{x:" + this.x + " y:" + this.y + " z:" + this.z + " w:" + this.w + "}";
};

away.core.math.Quaternion.prototype.toMatrix3D = function(target) {
	target = target || null;
	var rawData = away.core.math.Matrix3DUtils.RAW_DATA_CONTAINER;
	var xy2 = 2.0 * this.x * this.y, xz2 = 2.0 * this.x * this.z, xw2 = 2.0 * this.x * this.w;
	var yz2 = 2.0 * this.y * this.z, yw2 = 2.0 * this.y * this.w, zw2 = 2.0 * this.z * this.w;
	var xx = this.x * this.x, yy = this.y * this.y, zz = this.z * this.z, ww = this.w * this.w;
	rawData[0] = xx - yy - zz + ww;
	rawData[4] = xy2 - zw2;
	rawData[8] = xz2 + yw2;
	rawData[12] = 0;
	rawData[1] = xy2 + zw2;
	rawData[5] = -xx + yy - zz + ww;
	rawData[9] = yz2 - xw2;
	rawData[13] = 0;
	rawData[2] = xz2 - yw2;
	rawData[6] = yz2 + xw2;
	rawData[10] = -xx - yy + zz + ww;
	rawData[14] = 0;
	rawData[3] = 0.0;
	rawData[7] = 0.0;
	rawData[11] = 0;
	rawData[15] = 1;
	if (!target)
		return new away.core.geom.Matrix3D(rawData);
	target.copyRawDataFrom(rawData, 0, false);
	return target;
};

away.core.math.Quaternion.prototype.fromMatrix = function(matrix) {
	var v = matrix.decompose()[1];
	this.x = v.x;
	this.y = v.y;
	this.z = v.z;
	this.w = v.w;
};

away.core.math.Quaternion.prototype.toRawData = function(target, exclude4thRow) {
	var xy2 = 2.0 * this.x * this.y, xz2 = 2.0 * this.x * this.z, xw2 = 2.0 * this.x * this.w;
	var yz2 = 2.0 * this.y * this.z, yw2 = 2.0 * this.y * this.w, zw2 = 2.0 * this.z * this.w;
	var xx = this.x * this.x, yy = this.y * this.y, zz = this.z * this.z, ww = this.w * this.w;
	target[0] = xx - yy - zz + ww;
	target[1] = xy2 - zw2;
	target[2] = xz2 + yw2;
	target[4] = xy2 + zw2;
	target[5] = -xx + yy - zz + ww;
	target[6] = yz2 - xw2;
	target[8] = xz2 - yw2;
	target[9] = yz2 + xw2;
	target[10] = -xx - yy + zz + ww;
	target[11] = 0;
	target[7] = target[11];
	target[3] = target[7];
	if (!exclude4thRow) {
		target[14] = 0;
		target[13] = target[14];
		target[12] = target[13];
		target[15] = 1;
	}
};

away.core.math.Quaternion.prototype.clone = function() {
	return new away.core.math.Quaternion(this.x, this.y, this.z, this.w);
};

away.core.math.Quaternion.prototype.rotatePoint = function(vector, target) {
	target = target || null;
	var x1, y1, z1, w1;
	var x2 = vector.x, y2 = vector.y, z2 = vector.z;
	if (target === null) {
		target = new away.core.geom.Vector3D(0, 0, 0, 0);
	}
	w1 = -this.x * x2 - this.y * y2 - this.z * z2;
	x1 = this.w * x2 + this.y * z2 - this.z * y2;
	y1 = this.w * y2 - this.x * z2 + this.z * x2;
	z1 = this.w * z2 + this.x * y2 - this.y * x2;
	target.x = -w1 * this.x + x1 * this.w - y1 * this.z + z1 * this.y;
	target.y = -w1 * this.y + x1 * this.z + y1 * this.w - z1 * this.x;
	target.z = -w1 * this.z - x1 * this.y + y1 * this.x + z1 * this.w;
	return target;
};

away.core.math.Quaternion.prototype.copyFrom = function(q) {
	this.x = q.x;
	this.y = q.y;
	this.z = q.z;
	this.w = q.w;
};

away.core.math.Quaternion.className = "away.core.math.Quaternion";

away.core.math.Quaternion.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.core.geom.Vector3D');
	p.push('away.core.geom.Matrix3D');
	p.push('away.core.math.Matrix3DUtils');
	return p;
};

away.core.math.Quaternion.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.core.math.Quaternion.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'x', t:'Number'});
			p.push({n:'y', t:'Number'});
			p.push({n:'z', t:'Number'});
			p.push({n:'w', t:'Number'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

