/** Compiled by the Randori compiler v0.2.6.2 on Mon Sep 02 23:32:29 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.cameras == "undefined")
	away.cameras = {};

away.cameras.Camera3D = function(lens) {
	this._frustumPlanesDirty = true;
	this._viewProjectionDirty = true;
	this._lens = null;
	this._viewProjection = new away.geom.Matrix3D();
	this._frustumPlanes = null;
	away.entities.Entity.call(this);
	this._lens = lens || new away.cameras.lenses.PerspectiveLens(60);
	this._lens.addEventListener(away.events.LensEvent.MATRIX_CHANGED, $createStaticDelegate(, this.onLensMatrixChanged), this);
	this._frustumPlanes = [];
	for (var i = 0; i < 6; ++i) {
		this._frustumPlanes[i] = new away.math.Plane3D(0, 0, 0, 0);
	}
	this.set_z(-1000);
};

away.cameras.Camera3D.prototype.pGetDefaultBoundingVolume = function() {
	return new away.bounds.NullBounds(true);
};

away.cameras.Camera3D.prototype.get_assetType = function() {
	return away.library.assets.AssetType.CAMERA;
};

away.cameras.Camera3D.prototype.onLensMatrixChanged = function(event) {
	this._viewProjectionDirty = true;
	this._frustumPlanesDirty = true;
	this.dispatchEvent(event);
};

away.cameras.Camera3D.prototype.get_frustumPlanes = function() {
	if (this._frustumPlanesDirty) {
		this.updateFrustum();
	}
	return this._frustumPlanes;
};

away.cameras.Camera3D.prototype.updateFrustum = function() {
	var a, b, c;
	var c11, c12, c13, c14;
	var c21, c22, c23, c24;
	var c31, c32, c33, c34;
	var c41, c42, c43, c44;
	var p;
	var raw = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
	var invLen;
	this.get_viewProjection().copyRawDataTo(raw, 0, false);
	c11 = raw[0];
	c12 = raw[4];
	c13 = raw[8];
	c14 = raw[12];
	c21 = raw[1];
	c22 = raw[5];
	c23 = raw[9];
	c24 = raw[13];
	c31 = raw[2];
	c32 = raw[6];
	c33 = raw[10];
	c34 = raw[14];
	c41 = raw[3];
	c42 = raw[7];
	c43 = raw[11];
	c44 = raw[15];
	p = this._frustumPlanes[0];
	a = c41 + c11;
	b = c42 + c12;
	c = c43 + c13;
	invLen = 1 / Math.sqrt(a * a + b * b + c * c);
	p.a = a * invLen;
	p.b = b * invLen;
	p.c = c * invLen;
	p.d = -(c44 + c14) * invLen;
	p = this._frustumPlanes[1];
	a = c41 - c11;
	b = c42 - c12;
	c = c43 - c13;
	invLen = 1 / Math.sqrt(a * a + b * b + c * c);
	p.a = a * invLen;
	p.b = b * invLen;
	p.c = c * invLen;
	p.d = (c14 - c44) * invLen;
	p = this._frustumPlanes[2];
	a = c41 + c21;
	b = c42 + c22;
	c = c43 + c23;
	invLen = 1 / Math.sqrt(a * a + b * b + c * c);
	p.a = a * invLen;
	p.b = b * invLen;
	p.c = c * invLen;
	p.d = -(c44 + c24) * invLen;
	p = this._frustumPlanes[3];
	a = c41 - c21;
	b = c42 - c22;
	c = c43 - c23;
	invLen = 1 / Math.sqrt(a * a + b * b + c * c);
	p.a = a * invLen;
	p.b = b * invLen;
	p.c = c * invLen;
	p.d = (c24 - c44) * invLen;
	p = this._frustumPlanes[4];
	a = c31;
	b = c32;
	c = c33;
	invLen = 1 / Math.sqrt(a * a + b * b + c * c);
	p.a = a * invLen;
	p.b = b * invLen;
	p.c = c * invLen;
	p.d = -c34 * invLen;
	p = this._frustumPlanes[5];
	a = c41 - c31;
	b = c42 - c32;
	c = c43 - c33;
	invLen = 1 / Math.sqrt(a * a + b * b + c * c);
	p.a = a * invLen;
	p.b = b * invLen;
	p.c = c * invLen;
	p.d = (c34 - c44) * invLen;
	this._frustumPlanesDirty = false;
};

away.cameras.Camera3D.prototype.pInvalidateSceneTransform = function() {
	away.entities.Entity.prototype.pInvalidateSceneTransform.call(this);
	this._viewProjectionDirty = true;
	this._frustumPlanesDirty = true;
};

away.cameras.Camera3D.prototype.pUpdateBounds = function() {
	this._pBounds.nullify();
	this._pBoundsInvalid = false;
};

away.cameras.Camera3D.prototype.pCreateEntityPartitionNode = function() {
	return new away.partition.CameraNode(this);
};

away.cameras.Camera3D.prototype.get_lens = function() {
	return this._lens;
};

away.cameras.Camera3D.prototype.set_lens = function(value) {
	if (this._lens == value) {
		return;
	}
	if (!value) {
		throw new Error("Lens cannot be null!", 0);
	}
	this._lens.removeEventListener(away.events.LensEvent.MATRIX_CHANGED, $createStaticDelegate(, this.onLensMatrixChanged), this);
	this._lens = value;
	this._lens.addEventListener(away.events.LensEvent.MATRIX_CHANGED, $createStaticDelegate(, this.onLensMatrixChanged), this);
	this.dispatchEvent(new away.events.CameraEvent(away.events.CameraEvent.LENS_CHANGED, this));
};

away.cameras.Camera3D.prototype.get_viewProjection = function() {
	if (this._viewProjectionDirty) {
		this._viewProjection.copyFrom(this.get_inverseSceneTransform());
		this._viewProjection.append(this._lens.get_matrix());
		this._viewProjectionDirty = false;
	}
	return this._viewProjection;
};

away.cameras.Camera3D.prototype.getRay = function(nX, nY, sZ) {
	return this.get_sceneTransform().deltaTransformVector(this._lens.unproject(nX, nY, sZ));
};

away.cameras.Camera3D.prototype.project = function(point3d) {
	return this._lens.project(this.get_inverseSceneTransform().transformVector(point3d));
};

away.cameras.Camera3D.prototype.unproject = function(nX, nY, sZ) {
	return this.get_sceneTransform().transformVector(this._lens.unproject(nX, nY, sZ));
};

$inherit(away.cameras.Camera3D, away.entities.Entity);

away.cameras.Camera3D.className = "away.cameras.Camera3D";

away.cameras.Camera3D.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.partition.CameraNode');
	p.push('away.math.Plane3D');
	p.push('away.events.CameraEvent');
	p.push('away.bounds.NullBounds');
	p.push('away.cameras.lenses.PerspectiveLens');
	p.push('away.events.LensEvent');
	p.push('away.cameras.lenses.LensBase');
	p.push('away.library.assets.AssetType');
	return p;
};

away.cameras.Camera3D.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.Matrix3D');
	return p;
};

away.cameras.Camera3D.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'lens', t:'away.cameras.lenses.LensBase'});
			break;
		case 1:
			p = away.entities.Entity.injectionPoints(t);
			break;
		case 2:
			p = away.entities.Entity.injectionPoints(t);
			break;
		case 3:
			p = away.entities.Entity.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

