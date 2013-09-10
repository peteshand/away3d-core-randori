/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 10 22:28:12 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.bounds == "undefined")
	away.bounds = {};

away.bounds.AxisAlignedBoundingBox = function() {
	this._halfExtentsX = 0;
	this._halfExtentsY = 0;
	this._halfExtentsZ = 0;
	this._centerZ = 0;
	this._centerY = 0;
	this._centerX = 0;
	away.bounds.BoundingVolumeBase.call(this);
};

away.bounds.AxisAlignedBoundingBox.prototype.nullify = function() {
	away.bounds.BoundingVolumeBase.prototype.nullify.call(this);
	this._centerX = this._centerY = this._centerZ = 0;
	this._halfExtentsX = this._halfExtentsY = this._halfExtentsZ = 0;
};

away.bounds.AxisAlignedBoundingBox.prototype.isInFrustum = function(planes, numPlanes) {
	for (var i = 0; i < numPlanes; ++i) {
		var plane = planes[i];
		var a = plane.a;
		var b = plane.b;
		var c = plane.c;
		var flippedExtentX = a < 0 ? -this._halfExtentsX : this._halfExtentsX;
		var flippedExtentY = b < 0 ? -this._halfExtentsY : this._halfExtentsY;
		var flippedExtentZ = c < 0 ? -this._halfExtentsZ : this._halfExtentsZ;
		var projDist = a * (this._centerX + flippedExtentX) + b * (this._centerY + flippedExtentY) + c * (this._centerZ + flippedExtentZ) - plane.d;
		if (projDist < 0)
			return false;
	}
	return true;
};

away.bounds.AxisAlignedBoundingBox.prototype.rayIntersection = function(position, direction, targetNormal) {
	if (this.containsPoint(position))
		return 0;
	var px = position.x - this._centerX;
	var py = position.y - this._centerY;
	var pz = position.z - this._centerZ;
	var vx = direction.x;
	var vy = direction.y;
	var vz = direction.z;
	var ix;
	var iy;
	var iz;
	var rayEntryDistance;
	var intersects;
	if (vx < 0) {
		rayEntryDistance = (this._halfExtentsX - px) / vx;
		if (rayEntryDistance > 0) {
			iy = py + rayEntryDistance * vy;
			iz = pz + rayEntryDistance * vz;
			if (iy > -this._halfExtentsY && iy < this._halfExtentsY && iz > -this._halfExtentsZ && iz < this._halfExtentsZ) {
				targetNormal.x = 1;
				targetNormal.y = 0;
				targetNormal.z = 0;
				intersects = true;
			}
		}
	}
	if (!intersects && vx > 0) {
		rayEntryDistance = (-this._halfExtentsX - px) / vx;
		if (rayEntryDistance > 0) {
			iy = py + rayEntryDistance * vy;
			iz = pz + rayEntryDistance * vz;
			if (iy > -this._halfExtentsY && iy < this._halfExtentsY && iz > -this._halfExtentsZ && iz < this._halfExtentsZ) {
				targetNormal.x = -1;
				targetNormal.y = 0;
				targetNormal.z = 0;
				intersects = true;
			}
		}
	}
	if (!intersects && vy < 0) {
		rayEntryDistance = (this._halfExtentsY - py) / vy;
		if (rayEntryDistance > 0) {
			ix = px + rayEntryDistance * vx;
			iz = pz + rayEntryDistance * vz;
			if (ix > -this._halfExtentsX && ix < this._halfExtentsX && iz > -this._halfExtentsZ && iz < this._halfExtentsZ) {
				targetNormal.x = 0;
				targetNormal.y = 1;
				targetNormal.z = 0;
				intersects = true;
			}
		}
	}
	if (!intersects && vy > 0) {
		rayEntryDistance = (-this._halfExtentsY - py) / vy;
		if (rayEntryDistance > 0) {
			ix = px + rayEntryDistance * vx;
			iz = pz + rayEntryDistance * vz;
			if (ix > -this._halfExtentsX && ix < this._halfExtentsX && iz > -this._halfExtentsZ && iz < this._halfExtentsZ) {
				targetNormal.x = 0;
				targetNormal.y = -1;
				targetNormal.z = 0;
				intersects = true;
			}
		}
	}
	if (!intersects && vz < 0) {
		rayEntryDistance = (this._halfExtentsZ - pz) / vz;
		if (rayEntryDistance > 0) {
			ix = px + rayEntryDistance * vx;
			iy = py + rayEntryDistance * vy;
			if (iy > -this._halfExtentsY && iy < this._halfExtentsY && ix > -this._halfExtentsX && ix < this._halfExtentsX) {
				targetNormal.x = 0;
				targetNormal.y = 0;
				targetNormal.z = 1;
				intersects = true;
			}
		}
	}
	if (!intersects && vz > 0) {
		rayEntryDistance = (-this._halfExtentsZ - pz) / vz;
		if (rayEntryDistance > 0) {
			ix = px + rayEntryDistance * vx;
			iy = py + rayEntryDistance * vy;
			if (iy > -this._halfExtentsY && iy < this._halfExtentsY && ix > -this._halfExtentsX && ix < this._halfExtentsX) {
				targetNormal.x = 0;
				targetNormal.y = 0;
				targetNormal.z = -1;
				intersects = true;
			}
		}
	}
	return intersects ? rayEntryDistance : -1;
};

away.bounds.AxisAlignedBoundingBox.prototype.containsPoint = function(position) {
	var px = position.x - this._centerX, py = position.y - this._centerY, pz = position.z - this._centerZ;
	return px <= this._halfExtentsX && px >= -this._halfExtentsX && py <= this._halfExtentsY && py >= -this._halfExtentsY && pz <= this._halfExtentsZ && pz >= -this._halfExtentsZ;
};

away.bounds.AxisAlignedBoundingBox.prototype.fromExtremes = function(minX, minY, minZ, maxX, maxY, maxZ) {
	this._centerX = (maxX + minX) * .5;
	this._centerY = (maxY + minY) * .5;
	this._centerZ = (maxZ + minZ) * .5;
	this._halfExtentsX = (maxX - minX) * .5;
	this._halfExtentsY = (maxY - minY) * .5;
	this._halfExtentsZ = (maxZ - minZ) * .5;
	away.bounds.BoundingVolumeBase.prototype.fromExtremes.call(this,minX, minY, minZ, maxX, maxY, maxZ);
};

away.bounds.AxisAlignedBoundingBox.prototype.clone = function() {
	var clone = new away.bounds.AxisAlignedBoundingBox();
	clone.fromExtremes(this._pMin.x, this._pMin.y, this._pMin.z, this._pMax.x, this._pMax.y, this._pMax.z);
	return clone;
};

away.bounds.AxisAlignedBoundingBox.prototype.get_halfExtentsX = function() {
	return this._halfExtentsX;
};

away.bounds.AxisAlignedBoundingBox.prototype.get_halfExtentsY = function() {
	return this._halfExtentsY;
};

away.bounds.AxisAlignedBoundingBox.prototype.get_halfExtentsZ = function() {
	return this._halfExtentsZ;
};

away.bounds.AxisAlignedBoundingBox.prototype.closestPointToPoint = function(point, target) {
	var p;
	if (target == null) {
		target = new away.geom.Vector3D(0, 0, 0, 0);
	}
	p = point.x;
	if (p < this._pMin.x)
		p = this._pMin.x;
	if (p > this._pMax.x)
		p = this._pMax.x;
	target.x = p;
	p = point.y;
	if (p < this._pMin.y)
		p = this._pMin.y;
	if (p > this._pMax.y)
		p = this._pMax.y;
	target.y = p;
	p = point.z;
	if (p < this._pMin.z)
		p = this._pMin.z;
	if (p > this._pMax.z)
		p = this._pMax.z;
	target.z = p;
	return target;
};

away.bounds.AxisAlignedBoundingBox.prototype.pUpdateBoundingRenderable = function() {
	this._pBoundingRenderable.set_scaleX(Math.max(this._halfExtentsX * 2, 0.001));
	this._pBoundingRenderable.set_scaleY(Math.max(this._halfExtentsY * 2, 0.001));
	this._pBoundingRenderable.set_scaleZ(Math.max(this._halfExtentsZ * 2, 0.001));
	this._pBoundingRenderable.set_x(this._centerX);
	this._pBoundingRenderable.set_y(this._centerY);
	this._pBoundingRenderable.set_z(this._centerZ);
};

away.bounds.AxisAlignedBoundingBox.prototype.pCreateBoundingRenderable = function() {
	return new away.primitives.WireframeCube(1, 1, 1, 0xffffff, 0.5);
};

away.bounds.AxisAlignedBoundingBox.prototype.classifyToPlane = function(plane) {
	var a = plane.a;
	var b = plane.b;
	var c = plane.c;
	var centerDistance = a * this._centerX + b * this._centerY + c * this._centerZ - plane.d;
	if (a < 0)
		a = -a;
	if (b < 0)
		b = -b;
	if (c < 0)
		c = -c;
	var boundOffset = a * this._halfExtentsX + b * this._halfExtentsY + c * this._halfExtentsZ;
	return centerDistance > boundOffset ? away.math.PlaneClassification.FRONT : centerDistance < -boundOffset ? away.math.PlaneClassification.BACK : away.math.PlaneClassification.INTERSECT;
};

away.bounds.AxisAlignedBoundingBox.prototype.transformFrom = function(bounds, matrix) {
	var aabb = bounds;
	var cx = aabb._centerX;
	var cy = aabb._centerY;
	var cz = aabb._centerZ;
	var raw = away.math.Matrix3DUtils.RAW_DATA_CONTAINER;
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
	var hx = aabb._halfExtentsX;
	var hy = aabb._halfExtentsY;
	var hz = aabb._halfExtentsZ;
	this._halfExtentsX = hx * m11 + hy * m12 + hz * m13;
	this._halfExtentsY = hx * m21 + hy * m22 + hz * m23;
	this._halfExtentsZ = hx * m31 + hy * m32 + hz * m33;
	this._pMin.x = this._centerX - this._halfExtentsX;
	this._pMin.y = this._centerY - this._halfExtentsY;
	this._pMin.z = this._centerZ - this._halfExtentsZ;
	this._pMax.x = this._centerX + this._halfExtentsX;
	this._pMax.y = this._centerY + this._halfExtentsY;
	this._pMax.z = this._centerZ + this._halfExtentsZ;
};

$inherit(away.bounds.AxisAlignedBoundingBox, away.bounds.BoundingVolumeBase);

away.bounds.AxisAlignedBoundingBox.className = "away.bounds.AxisAlignedBoundingBox";

away.bounds.AxisAlignedBoundingBox.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.Vector3D');
	p.push('away.primitives.WireframeCube');
	p.push('away.math.PlaneClassification');
	p.push('away.math.Matrix3DUtils');
	return p;
};

away.bounds.AxisAlignedBoundingBox.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.bounds.AxisAlignedBoundingBox.injectionPoints = function(t) {
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

