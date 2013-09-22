/** Compiled by the Randori compiler v0.2.6.2 on Sun Sep 22 11:19:59 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.cameras == "undefined")
	away.cameras = {};
if (typeof away.cameras.lenses == "undefined")
	away.cameras.lenses = {};

away.cameras.lenses.LensBase = function() {
	this._pAspectRatio = 1;
	this._pMatrixInvalid = true;
	this._pViewPort = new away.geom.Rectangle(0, 0, 0, 0);
	this._pFar = 3000;
	this._pScissorRect = new away.geom.Rectangle(0, 0, 0, 0);
	this._pMatrix = null;
	this._pNear = 20;
	this._unprojection = null;
	this._unprojectionInvalid = true;
	this._pFrustumCorners = [];
	away.events.EventDispatcher.call(this);
	this._pMatrix = new away.geom.Matrix3D();
};

away.cameras.lenses.LensBase.prototype.get_frustumCorners = function() {
	return this._pFrustumCorners;
};

away.cameras.lenses.LensBase.prototype.set_frustumCorners = function(frustumCorners) {
	this._pFrustumCorners = frustumCorners;
};

away.cameras.lenses.LensBase.prototype.get_matrix = function() {
	if (this._pMatrixInvalid) {
		this.pUpdateMatrix();
		this._pMatrixInvalid = false;
	}
	return this._pMatrix;
};

away.cameras.lenses.LensBase.prototype.set_matrix = function(value) {
	this._pMatrix = value;
	this.pInvalidateMatrix();
};

away.cameras.lenses.LensBase.prototype.get_near = function() {
	return this._pNear;
};

away.cameras.lenses.LensBase.prototype.set_near = function(value) {
	if (value == this._pNear) {
		return;
	}
	this._pNear = value;
	this.pInvalidateMatrix();
};

away.cameras.lenses.LensBase.prototype.get_far = function() {
	return this._pFar;
};

away.cameras.lenses.LensBase.prototype.set_far = function(value) {
	if (value == this._pFar) {
		return;
	}
	this._pFar = value;
	this.pInvalidateMatrix();
};

away.cameras.lenses.LensBase.prototype.project = function(point3d) {
	var v = this.get_matrix().transformVector(point3d);
	v.x = v.x / v.w;
	v.y = -v.y / v.w;
	v.z = point3d.z;
	return v;
};

away.cameras.lenses.LensBase.prototype.get_unprojectionMatrix = function() {
	if (this._unprojectionInvalid) {
		if (!this._unprojection) {
			this._unprojection = new away.geom.Matrix3D();
		}
		this._unprojection.copyFrom(this.get_matrix());
		this._unprojection.invert();
		this._unprojectionInvalid = false;
	}
	return this._unprojection;
};

away.cameras.lenses.LensBase.prototype.unproject = function(nX, nY, sZ) {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.cameras.lenses.LensBase.prototype.clone = function() {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.cameras.lenses.LensBase.prototype.get_iAspectRatio = function() {
	return this._pAspectRatio;
};

away.cameras.lenses.LensBase.prototype.set_iAspectRatio = function(value) {
	if (this._pAspectRatio == value) {
		return;
	}
	this._pAspectRatio = value;
	this.pInvalidateMatrix();
};

away.cameras.lenses.LensBase.prototype.pInvalidateMatrix = function() {
	this._pMatrixInvalid = true;
	this._unprojectionInvalid = true;
	this.dispatchEvent(new away.events.LensEvent(away.events.LensEvent.MATRIX_CHANGED, this));
};

away.cameras.lenses.LensBase.prototype.pUpdateMatrix = function() {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.cameras.lenses.LensBase.prototype.iUpdateScissorRect = function(x, y, width, height) {
	this._pScissorRect.x = x;
	this._pScissorRect.y = y;
	this._pScissorRect.width = width;
	this._pScissorRect.height = height;
	this.pInvalidateMatrix();
};

away.cameras.lenses.LensBase.prototype.iUpdateViewport = function(x, y, width, height) {
	this._pViewPort.x = x;
	this._pViewPort.y = y;
	this._pViewPort.width = width;
	this._pViewPort.height = height;
	this.pInvalidateMatrix();
};

$inherit(away.cameras.lenses.LensBase, away.events.EventDispatcher);

away.cameras.lenses.LensBase.className = "away.cameras.lenses.LensBase";

away.cameras.lenses.LensBase.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.Matrix3D');
	p.push('away.errors.AbstractMethodError');
	p.push('away.events.LensEvent');
	return p;
};

away.cameras.lenses.LensBase.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.Rectangle');
	return p;
};

away.cameras.lenses.LensBase.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 1:
			p = away.events.EventDispatcher.injectionPoints(t);
			break;
		case 2:
			p = away.events.EventDispatcher.injectionPoints(t);
			break;
		case 3:
			p = away.events.EventDispatcher.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

