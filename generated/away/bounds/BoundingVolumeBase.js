/** Compiled by the Randori compiler v0.2.6.2 on Mon Sep 02 23:32:23 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.bounds == "undefined")
	away.bounds = {};

away.bounds.BoundingVolumeBase = function() {
	this._pAabbPointsDirty = true;
	this._pBoundingRenderable = null;
	this._pMax = null;
	this._pMin = null;
	this._pAabbPoints = [];
	this._pMin = new away.geom.Vector3D(0, 0, 0, 0);
	this._pMax = new away.geom.Vector3D(0, 0, 0, 0);
};

away.bounds.BoundingVolumeBase.prototype.get_max = function() {
	return this._pMax;
};

away.bounds.BoundingVolumeBase.prototype.get_min = function() {
	return this._pMin;
};

away.bounds.BoundingVolumeBase.prototype.get_aabbPoints = function() {
	if (this._pAabbPointsDirty) {
		this.pUpdateAABBPoints();
	}
	return this._pAabbPoints;
};

away.bounds.BoundingVolumeBase.prototype.get_boundingRenderable = function() {
	if (!this._pBoundingRenderable) {
		this._pBoundingRenderable = this.pCreateBoundingRenderable();
		this.pUpdateBoundingRenderable();
	}
	return this._pBoundingRenderable;
};

away.bounds.BoundingVolumeBase.prototype.nullify = function() {
	this._pMin.x = this._pMin.y = this._pMin.z = 0;
	this._pMax.x = this._pMax.y = this._pMax.z = 0;
	this._pAabbPointsDirty = true;
	if (this._pBoundingRenderable) {
		this.pUpdateBoundingRenderable();
	}
};

away.bounds.BoundingVolumeBase.prototype.disposeRenderable = function() {
	if (this._pBoundingRenderable) {
		this._pBoundingRenderable.dispose();
	}
	this._pBoundingRenderable = null;
};

away.bounds.BoundingVolumeBase.prototype.fromVertices = function(vertices) {
	var i;
	var len = vertices.length;
	var minX, minY, minZ;
	var maxX, maxY, maxZ;
	if (len == 0) {
		this.nullify();
		return;
	}
	var v;
	minX = maxX = vertices[i++];
	minY = maxY = vertices[i++];
	minZ = maxZ = vertices[i++];
	while (i < len) {
		v = vertices[i++];
		if (v < minX)
			minX = v;
		else if (v > maxX)
			maxX = v;
		v = vertices[i++];
		if (v < minY)
			minY = v;
		else if (v > maxY)
			maxY = v;
		v = vertices[i++];
		if (v < minZ)
			minZ = v;
		else if (v > maxZ)
			maxZ = v;
	}
	this.fromExtremes(minX, minY, minZ, maxX, maxY, maxZ);
};

away.bounds.BoundingVolumeBase.prototype.fromGeometry = function(geometry) {
	var subGeoms = geometry.get_subGeometries();
	var numSubGeoms = subGeoms.length;
	var minX, minY, minZ;
	var maxX, maxY, maxZ;
	if (numSubGeoms > 0) {
		var j = 0;
		minX = minY = minZ = Infinity;
		maxX = maxY = maxZ = -Infinity;
		while (j < numSubGeoms) {
			var subGeom = subGeoms[j++];
			var vertices = subGeom.get_vertexData();
			var vertexDataLen = vertices.length;
			var i = subGeom.get_vertexOffset();
			var stride = subGeom.get_vertexStride();
			while (i < vertexDataLen) {
				var v = vertices[i];
				if (v < minX) {
					minX = v;
				} else if (v > maxX) {
					maxX = v;
				}
				v = vertices[i + 1];
				if (v < minY) {
					minY = v;
				} else if (v > maxY) {
					maxY = v;
				}
				v = vertices[i + 2];
				if (v < minZ) {
					minZ = v;
				} else if (v > maxZ) {
					maxZ = v;
				}
				i += stride;
			}
		}
		this.fromExtremes(minX, minY, minZ, maxX, maxY, maxZ);
	} else {
		this.fromExtremes(0, 0, 0, 0, 0, 0);
	}
};

away.bounds.BoundingVolumeBase.prototype.fromSphere = function(center, radius) {
	this.fromExtremes(center.x - radius, center.y - radius, center.z - radius, center.x + radius, center.y + radius, center.z + radius);
};

away.bounds.BoundingVolumeBase.prototype.fromExtremes = function(minX, minY, minZ, maxX, maxY, maxZ) {
	this._pMin.x = minX;
	this._pMin.y = minY;
	this._pMin.z = minZ;
	this._pMax.x = maxX;
	this._pMax.y = maxY;
	this._pMax.z = maxZ;
	this._pAabbPointsDirty = true;
	if (this._pBoundingRenderable) {
		this.pUpdateBoundingRenderable();
	}
};

away.bounds.BoundingVolumeBase.prototype.isInFrustum = function(planes, numPlanes) {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.bounds.BoundingVolumeBase.prototype.overlaps = function(bounds) {
	var min = bounds._pMin;
	var max = bounds._pMax;
	return this._pMax.x > min.x && this._pMin.x < max.x && this._pMax.y > min.y && this._pMin.y < max.y && this._pMax.z > min.z && this._pMin.z < max.z;
};

away.bounds.BoundingVolumeBase.prototype.clone = function() {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.bounds.BoundingVolumeBase.prototype.rayIntersection = function(position, direction, targetNormal) {
	position = position;
	direction = direction;
	targetNormal = targetNormal;
	return -1;
};

away.bounds.BoundingVolumeBase.prototype.containsPoint = function(position) {
	position = position;
	return false;
};

away.bounds.BoundingVolumeBase.prototype.pUpdateAABBPoints = function() {
	var maxX = this._pMax.x;
	var maxY = this._pMax.y;
	var maxZ = this._pMax.z;
	var minX = this._pMin.x;
	var minY = this._pMin.y;
	var minZ = this._pMin.z;
	this._pAabbPoints[0] = minX;
	this._pAabbPoints[1] = minY;
	this._pAabbPoints[2] = minZ;
	this._pAabbPoints[3] = maxX;
	this._pAabbPoints[4] = minY;
	this._pAabbPoints[5] = minZ;
	this._pAabbPoints[6] = minX;
	this._pAabbPoints[7] = maxY;
	this._pAabbPoints[8] = minZ;
	this._pAabbPoints[9] = maxX;
	this._pAabbPoints[10] = maxY;
	this._pAabbPoints[11] = minZ;
	this._pAabbPoints[12] = minX;
	this._pAabbPoints[13] = minY;
	this._pAabbPoints[14] = maxZ;
	this._pAabbPoints[15] = maxX;
	this._pAabbPoints[16] = minY;
	this._pAabbPoints[17] = maxZ;
	this._pAabbPoints[18] = minX;
	this._pAabbPoints[19] = maxY;
	this._pAabbPoints[20] = maxZ;
	this._pAabbPoints[21] = maxX;
	this._pAabbPoints[22] = maxY;
	this._pAabbPoints[23] = maxZ;
	this._pAabbPointsDirty = false;
};

away.bounds.BoundingVolumeBase.prototype.pUpdateBoundingRenderable = function() {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.bounds.BoundingVolumeBase.prototype.pCreateBoundingRenderable = function() {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.bounds.BoundingVolumeBase.prototype.classifyToPlane = function(plane) {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.bounds.BoundingVolumeBase.prototype.transformFrom = function(bounds, matrix) {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.bounds.BoundingVolumeBase.className = "away.bounds.BoundingVolumeBase";

away.bounds.BoundingVolumeBase.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.Vector3D');
	p.push('away.errors.AbstractMethodError');
	return p;
};

away.bounds.BoundingVolumeBase.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.bounds.BoundingVolumeBase.injectionPoints = function(t) {
	return [];
};
