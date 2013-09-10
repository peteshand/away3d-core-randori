/** Compiled by the Randori compiler v0.2.6.2 on Thu Sep 05 22:19:21 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.lights == "undefined")
	away.lights = {};
if (typeof away.lights.shadowmaps == "undefined")
	away.lights.shadowmaps = {};

away.lights.shadowmaps.DirectionalShadowMapper = function() {
	this._pSnap = 64;
	this._pMatrix = null;
	this._pMinZ = 0;
	this._pOverallDepthCamera = null;
	this._pLightOffset = 10000;
	this._pMaxZ = 0;
	this._pCullPlanes = null;
	this._pLocalFrustum = null;
	this._pOverallDepthLens = null;
	away.lights.shadowmaps.ShadowMapperBase.call(this);
	this._pCullPlanes = [];
	this._pOverallDepthLens = new away.cameras.lenses.FreeMatrixLens();
	this._pOverallDepthCamera = new away.cameras.Camera3D(this._pOverallDepthLens);
	this._pLocalFrustum = [];
	this._pMatrix = new away.geom.Matrix3D();
};

away.lights.shadowmaps.DirectionalShadowMapper.prototype.get_snap = function() {
	return this._pSnap;
};

away.lights.shadowmaps.DirectionalShadowMapper.prototype.set_snap = function(value) {
	this._pSnap = value;
};

away.lights.shadowmaps.DirectionalShadowMapper.prototype.get_lightOffset = function() {
	return this._pLightOffset;
};

away.lights.shadowmaps.DirectionalShadowMapper.prototype.set_lightOffset = function(value) {
	this._pLightOffset = value;
};

away.lights.shadowmaps.DirectionalShadowMapper.prototype.get_iDepthProjection = function() {
	return this._pOverallDepthCamera.get_viewProjection();
};

away.lights.shadowmaps.DirectionalShadowMapper.prototype.get_depth = function() {
	return this._pMaxZ - this._pMinZ;
};

away.lights.shadowmaps.DirectionalShadowMapper.prototype.pDrawDepthMap = function(target, scene, renderer) {
	this._pCasterCollector.set_camera(this._pOverallDepthCamera);
	this._pCasterCollector.set_cullPlanes(this._pCullPlanes);
	this._pCasterCollector.clear();
	scene.traversePartitions(this._pCasterCollector);
	renderer.iRender(this._pCasterCollector, target, null, 0);
	this._pCasterCollector.cleanUp();
};

away.lights.shadowmaps.DirectionalShadowMapper.prototype.pUpdateCullPlanes = function(viewCamera) {
	var lightFrustumPlanes = this._pOverallDepthCamera.get_frustumPlanes();
	var viewFrustumPlanes = viewCamera.get_frustumPlanes();
	this._pCullPlanes.length = 4;
	this._pCullPlanes[0] = lightFrustumPlanes[0];
	this._pCullPlanes[1] = lightFrustumPlanes[1];
	this._pCullPlanes[2] = lightFrustumPlanes[2];
	this._pCullPlanes[3] = lightFrustumPlanes[3];
	var light = this._pLight;
	var dir = light.get_sceneDirection();
	var dirX = dir.x;
	var dirY = dir.y;
	var dirZ = dir.z;
	var j = 4;
	for (var i = 0; i < 6; ++i) {
		var plane = viewFrustumPlanes[i];
		if (plane.a * dirX + plane.b * dirY + plane.c * dirZ < 0) {
			this._pCullPlanes[j++] = plane;
		}
	}
};

away.lights.shadowmaps.DirectionalShadowMapper.prototype.pUpdateDepthProjection = function(viewCamera) {
	this.pUpdateProjectionFromFrustumCorners(viewCamera, viewCamera.get_lens().get_frustumCorners(), this._pMatrix);
	this._pOverallDepthLens.set_matrix(this._pMatrix);
	this.pUpdateCullPlanes(viewCamera);
};

away.lights.shadowmaps.DirectionalShadowMapper.prototype.pUpdateProjectionFromFrustumCorners = function(viewCamera, corners, matrix) {
	var raw = [];
	var dir;
	var x, y, z;
	var minX, minY;
	var maxX, maxY;
	var i;
	var light = this._pLight;
	dir = light.get_sceneDirection();
	this._pOverallDepthCamera.set_transform(this._pLight.get_sceneTransform());
	x = Math.floor((viewCamera.get_x() - dir.x * this._pLightOffset) / this._pSnap) * this._pSnap;
	y = Math.floor((viewCamera.get_y() - dir.y * this._pLightOffset) / this._pSnap) * this._pSnap;
	z = Math.floor((viewCamera.get_z() - dir.z * this._pLightOffset) / this._pSnap) * this._pSnap;
	this._pOverallDepthCamera.set_x(x);
	this._pOverallDepthCamera.set_y(y);
	this._pOverallDepthCamera.set_z(z);
	this._pMatrix.copyFrom(this._pOverallDepthCamera.get_inverseSceneTransform());
	this._pMatrix.prepend(viewCamera.get_sceneTransform());
	this._pMatrix.transformVectors(corners, this._pLocalFrustum);
	minX = maxX = this._pLocalFrustum[0];
	minY = maxY = this._pLocalFrustum[1];
	this._pMaxZ = this._pLocalFrustum[2];
	i = 3;
	while (i < 24) {
		x = this._pLocalFrustum[i];
		y = this._pLocalFrustum[i + 1];
		z = this._pLocalFrustum[i + 2];
		if (x < minX)
			minX = x;
		if (x > maxX)
			maxX = x;
		if (y < minY)
			minY = y;
		if (y > maxY)
			maxY = y;
		if (z > this._pMaxZ)
			this._pMaxZ = z;
		i += 3;
	}
	this._pMinZ = 1;
	var w = maxX - minX;
	var h = maxY - minY;
	var d = 1 / (this._pMaxZ - this._pMinZ);
	if (minX < 0) {
		minX -= this._pSnap;
	}
	if (minY < 0) {
		minY -= this._pSnap;
	}
	minX = Math.floor(minX / this._pSnap) * this._pSnap;
	minY = Math.floor(minY / this._pSnap) * this._pSnap;
	var snap2 = 2 * this._pSnap;
	w = Math.floor(w / snap2 + 2) * snap2;
	h = Math.floor(h / snap2 + 2) * snap2;
	maxX = minX + w;
	maxY = minY + h;
	w = 1 / w;
	h = 1 / h;
	raw[0] = 2 * w;
	raw[5] = 2 * h;
	raw[10] = d;
	raw[12] = -(maxX + minX) * w;
	raw[13] = -(maxY + minY) * h;
	raw[14] = -this._pMinZ * d;
	raw[15] = 1;
	raw[1] = raw[2] = raw[3] = raw[4] = raw[6] = raw[7] = raw[8] = raw[9] = raw[11] = 0;
	matrix.copyRawDataFrom(raw, 0, false);
};

$inherit(away.lights.shadowmaps.DirectionalShadowMapper, away.lights.shadowmaps.ShadowMapperBase);

away.lights.shadowmaps.DirectionalShadowMapper.className = "away.lights.shadowmaps.DirectionalShadowMapper";

away.lights.shadowmaps.DirectionalShadowMapper.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.Matrix3D');
	p.push('away.cameras.Camera3D');
	p.push('away.cameras.lenses.FreeMatrixLens');
	p.push('away.cameras.lenses.LensBase');
	return p;
};

away.lights.shadowmaps.DirectionalShadowMapper.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.lights.shadowmaps.DirectionalShadowMapper.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 1:
			p = away.lights.shadowmaps.ShadowMapperBase.injectionPoints(t);
			break;
		case 2:
			p = away.lights.shadowmaps.ShadowMapperBase.injectionPoints(t);
			break;
		case 3:
			p = away.lights.shadowmaps.ShadowMapperBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

