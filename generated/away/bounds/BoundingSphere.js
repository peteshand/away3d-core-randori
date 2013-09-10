/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 10 22:28:11 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.bounds == "undefined")
	away.bounds = {};

away.bounds.BoundingSphere = function() {
	this._centerZ = 0;
	this._centerY = 0;
	this._centerX = 0;
	this._radius = 0;
	away.bounds.BoundingVolumeBase.call(this);
};

away.bounds.BoundingSphere.prototype.get_radius = function() {
	return this._radius;
};

away.bounds.BoundingSphere.prototype.nullify = function() {
	away.bounds.BoundingVolumeBase.prototype.nullify.call(this);
	this._centerX = this._centerY = this._centerZ = 0;
	this._radius = 0;
};

away.bounds.BoundingSphere.prototype.isInFrustum = function(planes, numPlanes) {
	for (var i = 0; i < numPlanes; ++i) {
		var plane = planes[i];
		var flippedExtentX = plane.a < 0 ? -this._radius : this._radius;
		var flippedExtentY = plane.b < 0 ? -this._radius : this._radius;
		var flippedExtentZ = plane.c < 0 ? -this._radius : this._radius;
		var projDist = plane.a * (this._centerX + flippedExtentX) + plane.b * (this._centerY + flippedExtentY) + plane.c * (this._centerZ + flippedExtentZ) - plane.d;
		if (projDist < 0) {
			return false;
		}
	}
	return true;
};

away.bounds.BoundingSphere.prototype.fromSphere = function(center, radius) {
	this._centerX = center.x;
	this._centerY = center.y;
	this._centerZ = center.z;
	this._radius = radius;
	this._pMax.x = this._centerX + radius;
	this._pMax.y = this._centerY + radius;
	this._pMax.z = this._centerZ + radius;
	this._pMin.x = this._centerX - radius;
	this._pMin.y = this._centerY - radius;
	this._pMin.z = this._centerZ - radius;
	this._pAabbPointsDirty = true;
	if (this._pBoundingRenderable) {
		this.pUpdateBoundingRenderable();
	}
};

away.bounds.BoundingSphere.prototype.fromExtremes = function(minX, minY, minZ, maxX, maxY, maxZ) {
	this._centerX = (maxX + minX) * .5;
	this._centerY = (maxY + minY) * .5;
	this._centerZ = (maxZ + minZ) * .5;
	var d = maxX - minX;
	var y = maxY - minY;
	var z = maxZ - minZ;
	if (y > d) {
		d = y;
	}
	if (z > d) {
		d = z;
	}
	this._radius = d * Math.sqrt(.5);
	away.bounds.BoundingVolumeBase.prototype.fromExtremes.call(this,minX, minY, minZ, maxX, maxY, maxZ);
};

away.bounds.BoundingSphere.prototype.clone = function() {
	var clone = new away.bounds.BoundingSphere();
	clone.fromSphere(new away.geom.Vector3D(this._centerX, this._centerY, this._centerZ, 0), this._radius);
	return clone;
};

away.bounds.BoundingSphere.prototype.rayIntersection = function(position, direction, targetNormal) {
	if (this.containsPoint(position)) {
		return 0;
	}
	var px = position.x - this._centerX, py = position.y - this._centerY, pz = position.z - this._centerZ;
	var vx = direction.x, vy = direction.y, vz = direction.z;
	var rayEntryDistance;
	var a = vx * vx + vy * vy + vz * vz;
	var b = 2 * (px * vx + py * vy + pz * vz);
	var c = px * px + py * py + pz * pz - this._radius * this._radius;
	var det = b * b - 4 * a * c;
	if (det >= 0) {
		var sqrtDet = Math.sqrt(det);
		rayEntryDistance = (-b - sqrtDet) / (2 * a);
		if (rayEntryDistance >= 0) {
			targetNormal.x = px + rayEntryDistance * vx;
			targetNormal.y = py + rayEntryDistance * vy;
			targetNormal.z = pz + rayEntryDistance * vz;
			targetNormal.normalize();
			return rayEntryDistance;
		}
	}
	return -1;
};

away.bounds.BoundingSphere.prototype.containsPoint = function(position) {
	var px = position.x - this._centerX;
	var py = position.y - this._centerY;
	var pz = position.z - this._centerZ;
	var distance = Math.sqrt(px * px + py * py + pz * pz);
	return distance <= this._radius;
};

away.bounds.BoundingSphere.prototype.pUpdateBoundingRenderable = function() {
	var sc = this._radius;
	if (sc == 0) {
		sc = 0.001;
	}
	this._pBoundingRenderable.set_scaleX(sc);
	this._pBoundingRenderable.set_scaleY(sc);
	this._pBoundingRenderable.set_scaleZ(sc);
	this._pBoundingRenderable.set_x(this._centerX);
	this._pBoundingRenderable.set_y(this._centerY);
	this._pBoundingRenderable.set_z(this._centerZ);
};

away.bounds.BoundingSphere.prototype.pCreateBoundingRenderable = function() {
	return new away.primitives.WireframeSphere(1, 16, 12, 0xffffff, 0.5);
};

away.bounds.BoundingSphere.prototype.classifyToPlane = function(plane) {
	var a = plane.a;
	var b = plane.b;
	var c = plane.c;
	var dd = a * this._centerX + b * this._centerY + c * this._centerZ - plane.d;
	if (a < 0) {
		a = -a;
	}
	if (b < 0) {
		b = -b;
	}
	if (c < 0) {
		c = -c;
	}
	var rr = (a + b + c) * this._radius;
	return dd > rr ? away.math.PlaneClassification.FRONT : dd < -rr ? away.math.PlaneClassification.BACK : away.math.PlaneClassification.INTERSECT;
};

away.bounds.BoundingSphere.prototype.transformFrom = function(bounds, matrix) {
	var sphere = bounds;
	var cx = sphere._centerX;
	var cy = sphere._centerY;
	var cz = sphere._centerZ;
	var raw = [];
	matrix.copyRawDataTo(raw, 0, false);
	var m11 = raw[0], m12 = raw[4], m13 = raw[8], m14 = raw[12];
	var m21 = raw[1], m22 = raw[5], m23 = raw[9], m24 = raw[13];
	var m31 = raw[2], m32 = raw[6], m33 = raw[10], m34 = raw[14];
	this._centerX = cx * m11 + cy * m12 + cz * m13 + m14;
	this._centerY = cx * m21 + cy * m22 + cz * m23 + m24;
	this._centerZ = cx * m31 + cy * m32 + cz * m33 + m34;
	if (m11 < 0)
		m11 = -m11;
	if (m12 < 0)
		m12 = -m12;
	if (m13 < 0)
		m13 = -m13;
	if (m21 < 0)
		m21 = -m21;
	if (m22 < 0)
		m22 = -m22;
	if (m23 < 0)
		m23 = -m23;
	if (m31 < 0)
		m31 = -m31;
	if (m32 < 0)
		m32 = -m32;
	if (m33 < 0)
		m33 = -m33;
	var r = sphere._radius;
	var rx = m11 + m12 + m13;
	var ry = m21 + m22 + m23;
	var rz = m31 + m32 + m33;
	this._radius = r * Math.sqrt(rx * rx + ry * ry + rz * rz);
	this._pMin.x = this._centerX - this._radius;
	this._pMin.y = this._centerY - this._radius;
	this._pMin.z = this._centerZ - this._radius;
	this._pMax.x = this._centerX + this._radius;
	this._pMax.y = this._centerY + this._radius;
	this._pMax.z = this._centerZ + this._radius;
};

$inherit(away.bounds.BoundingSphere, away.bounds.BoundingVolumeBase);

away.bounds.BoundingSphere.className = "away.bounds.BoundingSphere";

away.bounds.BoundingSphere.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.Vector3D');
	p.push('away.math.PlaneClassification');
	p.push('away.primitives.WireframeSphere');
	return p;
};

away.bounds.BoundingSphere.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.bounds.BoundingSphere.injectionPoints = function(t) {
	var p;
	switch (t) {
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

