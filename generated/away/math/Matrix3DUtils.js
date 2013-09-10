/** Compiled by the Randori compiler v0.2.6.2 on Thu Sep 05 22:19:21 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.math == "undefined")
	away.math = {};

away.math.Matrix3DUtils = function() {
	
};

away.math.Matrix3DUtils.RAW_DATA_CONTAINER = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

away.math.Matrix3DUtils.CALCULATION_MATRIX = new away.geom.Matrix3D();

away.math.Matrix3DUtils.quaternion2matrix = function(quarternion, m) {
	var x = quarternion.x;
	var y = quarternion.y;
	var z = quarternion.z;
	var w = quarternion.w;
	var xx = x * x;
	var xy = x * y;
	var xz = x * z;
	var xw = x * w;
	var yy = y * y;
	var yz = y * z;
	var yw = y * w;
	var zz = z * z;
	var zw = z * w;
	var raw = away.math.Matrix3DUtils.RAW_DATA_CONTAINER;
	raw[0] = 1 - 2 * (yy + zz);
	raw[1] = 2 * (xy + zw);
	raw[2] = 2 * (xz - yw);
	raw[4] = 2 * (xy - zw);
	raw[5] = 1 - 2 * (xx + zz);
	raw[6] = 2 * (yz + xw);
	raw[8] = 2 * (xz + yw);
	raw[9] = 2 * (yz - xw);
	raw[10] = 1 - 2 * (xx + yy);
	raw[3] = raw[7] = raw[11] = raw[12] = raw[13] = raw[14] = 0;
	raw[15] = 1;
	if (m) {
		m.copyRawDataFrom(raw, 0, false);
		return m;
	}
	else
		return new away.geom.Matrix3D(raw);
};

away.math.Matrix3DUtils.getForward = function(m, v) {
	if (v === null || v == undefined) {
		v = new away.geom.Vector3D(0.0, 0.0, 0.0, 0);
	}
	m.copyColumnTo(2, v);
	v.normalize();
	return v;
};

away.math.Matrix3DUtils.getUp = function(m, v) {
	if (v === null || v == undefined) {
		v = new away.geom.Vector3D(0.0, 0.0, 0.0, 0);
	}
	m.copyColumnTo(1, v);
	v.normalize();
	return v;
};

away.math.Matrix3DUtils.getRight = function(m, v) {
	if (v === null || v == undefined) {
		v = new away.geom.Vector3D(0.0, 0.0, 0.0, 0);
	}
	m.copyColumnTo(0, v);
	v.normalize();
	return v;
};

away.math.Matrix3DUtils.compare = function(m1, m2) {
	var r1 = away.math.Matrix3DUtils.RAW_DATA_CONTAINER;
	var r2 = m2.rawData;
	m1.copyRawDataTo(r1, 0, false);
	for (var i = 0; i < 16; ++i) {
		if (r1[i] != r2[i])
			return false;
	}
	return true;
};

away.math.Matrix3DUtils.lookAt = function(matrix, pos, dir, up) {
	var dirN;
	var upN;
	var lftN;
	var raw = away.math.Matrix3DUtils.RAW_DATA_CONTAINER;
	lftN = dir.crossProduct(up);
	lftN.normalize();
	upN = lftN.crossProduct(dir);
	upN.normalize();
	dirN = dir.clone();
	dirN.normalize();
	raw[0] = lftN.x;
	raw[1] = upN.x;
	raw[2] = -dirN.x;
	raw[3] = 0.0;
	raw[4] = lftN.y;
	raw[5] = upN.y;
	raw[6] = -dirN.y;
	raw[7] = 0.0;
	raw[8] = lftN.z;
	raw[9] = upN.z;
	raw[10] = -dirN.z;
	raw[11] = 0.0;
	raw[12] = -lftN.dotProduct(pos);
	raw[13] = -upN.dotProduct(pos);
	raw[14] = dirN.dotProduct(pos);
	raw[15] = 1.0;
	matrix.copyRawDataFrom(raw, 0, false);
};

away.math.Matrix3DUtils.reflection = function(plane, target) {
	if (target === null || target == undefined) {
		target = new away.geom.Matrix3D();
	}
	var a = plane.a, b = plane.b, c = plane.c, d = plane.d;
	var rawData = away.math.Matrix3DUtils.RAW_DATA_CONTAINER;
	var ab2 = -2 * a * b;
	var ac2 = -2 * a * c;
	var bc2 = -2 * b * c;
	rawData[0] = 1 - 2 * a * a;
	rawData[4] = ab2;
	rawData[8] = ac2;
	rawData[12] = -2 * a * d;
	rawData[1] = ab2;
	rawData[5] = 1 - 2 * b * b;
	rawData[9] = bc2;
	rawData[13] = -2 * b * d;
	rawData[2] = ac2;
	rawData[6] = bc2;
	rawData[10] = 1 - 2 * c * c;
	rawData[14] = -2 * c * d;
	rawData[3] = 0;
	rawData[7] = 0;
	rawData[11] = 0;
	rawData[15] = 1;
	target.copyRawDataFrom(rawData, 0, false);
	return target;
};

away.math.Matrix3DUtils.className = "away.math.Matrix3DUtils";

away.math.Matrix3DUtils.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.Vector3D');
	p.push('away.geom.Matrix3D');
	return p;
};

away.math.Matrix3DUtils.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.Matrix3D');
	return p;
};

away.math.Matrix3DUtils.injectionPoints = function(t) {
	return [];
};
