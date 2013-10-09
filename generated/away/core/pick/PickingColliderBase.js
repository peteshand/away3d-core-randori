/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:38 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.pick == "undefined")
	away.core.pick = {};

away.core.pick.PickingColliderBase = function() {
this.rayPosition = null;
this.rayDirection = null;
};

away.core.pick.PickingColliderBase.prototype._pPetCollisionNormal = function(indexData, vertexData, triangleIndex) {
	var normal = new away.core.geom.Vector3D(0, 0, 0, 0);
	var i0 = indexData[triangleIndex] * 3;
	var i1 = indexData[triangleIndex + 1] * 3;
	var i2 = indexData[triangleIndex + 2] * 3;
	var p0 = new away.core.geom.Vector3D(vertexData[i0], vertexData[i0 + 1], vertexData[i0 + 2], 0);
	var p1 = new away.core.geom.Vector3D(vertexData[i1], vertexData[i1 + 1], vertexData[i1 + 2], 0);
	var p2 = new away.core.geom.Vector3D(vertexData[i2], vertexData[i2 + 1], vertexData[i2 + 2], 0);
	var side0 = p1.subtract(p0);
	var side1 = p2.subtract(p0);
	normal = side0.crossProduct(side1);
	normal.normalize();
	return normal;
};

away.core.pick.PickingColliderBase.prototype._pGetCollisionUV = function(indexData, uvData, triangleIndex, v, w, u, uvOffset, uvStride) {
	var uv = new away.core.geom.Point(0, 0);
	var uIndex = indexData[triangleIndex] * uvStride + uvOffset;
	var uv0 = new away.core.geom.Vector3D(uvData[uIndex], uvData[uIndex + 1], 0, 0);
	uIndex = indexData[triangleIndex + 1] * uvStride + uvOffset;
	var uv1 = new away.core.geom.Vector3D(uvData[uIndex], uvData[uIndex + 1], 0, 0);
	uIndex = indexData[triangleIndex + 2] * uvStride + uvOffset;
	var uv2 = new away.core.geom.Vector3D(uvData[uIndex], uvData[uIndex + 1], 0, 0);
	uv.x = u * uv0.x + v * uv1.x + w * uv2.x;
	uv.y = u * uv0.y + v * uv1.y + w * uv2.y;
	return uv;
};

away.core.pick.PickingColliderBase.prototype.pGetMeshSubgeometryIndex = function(subGeometry) {
	away.utils.Debug.throwPIR("away.pick.PickingColliderBase", "pGetMeshSubMeshIndex", "GeometryUtils.getMeshSubMeshIndex");
	return 0;
};

away.core.pick.PickingColliderBase.prototype.pGetMeshSubMeshIndex = function(subMesh) {
	away.utils.Debug.throwPIR("away.pick.PickingColliderBase", "pGetMeshSubMeshIndex", "GeometryUtils.getMeshSubMeshIndex");
	return 0;
};

away.core.pick.PickingColliderBase.prototype.setLocalRay = function(localPosition, localDirection) {
	this.rayPosition = localPosition;
	this.rayDirection = localDirection;
};

away.core.pick.PickingColliderBase.className = "away.core.pick.PickingColliderBase";

away.core.pick.PickingColliderBase.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.utils.Debug');
	p.push('away.core.geom.Vector3D');
	p.push('away.core.geom.Point');
	return p;
};

away.core.pick.PickingColliderBase.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.core.pick.PickingColliderBase.injectionPoints = function(t) {
	return [];
};
