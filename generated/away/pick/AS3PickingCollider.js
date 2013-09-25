/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 25 08:00:47 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.pick == "undefined")
	away.pick = {};

away.pick.AS3PickingCollider = function(findClosestCollision) {
	this._findClosestCollision = false;
	findClosestCollision = findClosestCollision || false;
	away.pick.PickingColliderBase.call(this);
	this._findClosestCollision = findClosestCollision;
};

away.pick.AS3PickingCollider.prototype.testSubMeshCollision = function(subMesh, pickingCollisionVO, shortestCollisionDistance) {
	var t;
	var i0, i1, i2;
	var rx, ry, rz;
	var nx, ny, nz;
	var cx, cy, cz;
	var coeff, u, v, w;
	var p0x, p0y, p0z;
	var p1x, p1y, p1z;
	var p2x, p2y, p2z;
	var s0x, s0y, s0z;
	var s1x, s1y, s1z;
	var nl, nDotV, D, disToPlane;
	var Q1Q2, Q1Q1, Q2Q2, RQ1, RQ2;
	var indexData = subMesh.get_indexData();
	var vertexData = subMesh.get_vertexData();
	var uvData = subMesh.get_UVData();
	var collisionTriangleIndex = -1;
	var bothSides = subMesh.get_material().get_bothSides();
	var vertexStride = subMesh.get_vertexStride();
	var vertexOffset = subMesh.get_vertexOffset();
	var uvStride = subMesh.get_UVStride();
	var uvOffset = subMesh.get_UVOffset();
	var numIndices = indexData.length;
	for (var index = 0; index < numIndices; index += 3) {
		i0 = vertexOffset + indexData[index] * vertexStride;
		i1 = vertexOffset + indexData[(index + 1)] * vertexStride;
		i2 = vertexOffset + indexData[(index + 2)] * vertexStride;
		p0x = vertexData[i0];
		p0y = vertexData[(i0 + 1)];
		p0z = vertexData[(i0 + 2)];
		p1x = vertexData[i1];
		p1y = vertexData[(i1 + 1)];
		p1z = vertexData[(i1 + 2)];
		p2x = vertexData[i2];
		p2y = vertexData[(i2 + 1)];
		p2z = vertexData[(i2 + 2)];
		s0x = p1x - p0x;
		s0y = p1y - p0y;
		s0z = p1z - p0z;
		s1x = p2x - p0x;
		s1y = p2y - p0y;
		s1z = p2z - p0z;
		nx = s0y * s1z - s0z * s1y;
		ny = s0z * s1x - s0x * s1z;
		nz = s0x * s1y - s0y * s1x;
		nl = 1 / Math.sqrt(nx * nx + ny * ny + nz * nz);
		nx *= nl;
		ny *= nl;
		nz *= nl;
		nDotV = nx * this.rayDirection.x + ny * +this.rayDirection.y + nz * this.rayDirection.z;
		if ((!bothSides && nDotV < 0.0) || (bothSides && nDotV != 0.0)) {
			D = -(nx * p0x + ny * p0y + nz * p0z);
			disToPlane = -(nx * this.rayPosition.x + ny * this.rayPosition.y + nz * this.rayPosition.z + D);
			t = disToPlane / nDotV;
			cx = this.rayPosition.x + t * this.rayDirection.x;
			cy = this.rayPosition.y + t * this.rayDirection.y;
			cz = this.rayPosition.z + t * this.rayDirection.z;
			Q1Q2 = s0x * s1x + s0y * s1y + s0z * s1z;
			Q1Q1 = s0x * s0x + s0y * s0y + s0z * s0z;
			Q2Q2 = s1x * s1x + s1y * s1y + s1z * s1z;
			rx = cx - p0x;
			ry = cy - p0y;
			rz = cz - p0z;
			RQ1 = rx * s0x + ry * s0y + rz * s0z;
			RQ2 = rx * s1x + ry * s1y + rz * s1z;
			coeff = 1 / (Q1Q1 * Q2Q2 - Q1Q2 * Q1Q2);
			v = coeff * (Q2Q2 * RQ1 - Q1Q2 * RQ2);
			w = coeff * (-Q1Q2 * RQ1 + Q1Q1 * RQ2);
			if (v < 0)
				continue;
			if (w < 0)
				continue;
			u = 1 - v - w;
			if (!(u < 0) && t > 0 && t < shortestCollisionDistance) {
				shortestCollisionDistance = t;
				collisionTriangleIndex = index / 3;
				pickingCollisionVO.rayEntryDistance = t;
				pickingCollisionVO.localPosition = new away.geom.Vector3D(cx, cy, cz, 0);
				pickingCollisionVO.localNormal = new away.geom.Vector3D(nx, ny, nz, 0);
				pickingCollisionVO.uv = this._pGetCollisionUV(indexData, uvData, index, v, w, u, uvOffset, uvStride);
				pickingCollisionVO.index = index;
				pickingCollisionVO.subGeometryIndex = this.pGetMeshSubMeshIndex(subMesh);
				if (!this._findClosestCollision)
					return true;
			}
		}
	}
	if (collisionTriangleIndex >= 0)
		return true;
	return false;
};

$inherit(away.pick.AS3PickingCollider, away.pick.PickingColliderBase);

away.pick.AS3PickingCollider.className = "away.pick.AS3PickingCollider";

away.pick.AS3PickingCollider.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.Vector3D');
	return p;
};

away.pick.AS3PickingCollider.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.pick.AS3PickingCollider.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'findClosestCollision', t:'Boolean'});
			break;
		case 1:
			p = away.pick.PickingColliderBase.injectionPoints(t);
			break;
		case 2:
			p = away.pick.PickingColliderBase.injectionPoints(t);
			break;
		case 3:
			p = away.pick.PickingColliderBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

