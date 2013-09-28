/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 28 11:54:36 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.cameras == "undefined")
	away.cameras = {};
if (typeof away.cameras.lenses == "undefined")
	away.cameras.lenses = {};

away.cameras.lenses.PerspectiveLens = function(fieldOfView) {
	this._fieldOfView = 0;
	this._focalLengthInv = 0;
	this._xMax = 0;
	this._yMax = 0;
	this._focalLength = 0;
	fieldOfView = fieldOfView || 60;
	away.cameras.lenses.LensBase.call(this);
	this.set_fieldOfView(fieldOfView);
};

away.cameras.lenses.PerspectiveLens.prototype.get_fieldOfView = function() {
	return this._fieldOfView;
};

away.cameras.lenses.PerspectiveLens.prototype.set_fieldOfView = function(value) {
	if (value == this._fieldOfView) {
		return;
	}
	this._fieldOfView = value;
	this._focalLengthInv = Math.tan(this._fieldOfView * 3.141592653589793 / 360);
	this._focalLength = 1 / this._focalLengthInv;
	this.pInvalidateMatrix();
};

away.cameras.lenses.PerspectiveLens.prototype.get_focalLength = function() {
	return this._focalLength;
};

away.cameras.lenses.PerspectiveLens.prototype.set_focalLength = function(value) {
	if (value == this._focalLength) {
		return;
	}
	this._focalLength = value;
	this._focalLengthInv = 1 / this._focalLength;
	this._fieldOfView = Math.atan(this._focalLengthInv) * 360 / 3.141592653589793;
	this.pInvalidateMatrix();
};

away.cameras.lenses.PerspectiveLens.prototype.unproject = function(nX, nY, sZ) {
	var v = new away.geom.Vector3D(nX, -nY, sZ, 1.0);
	v.x *= sZ;
	v.y *= sZ;
	v.z = sZ;
	v = this.get_unprojectionMatrix().transformVector(v);
	return v;
};

away.cameras.lenses.PerspectiveLens.prototype.clone = function() {
	var clone = new away.cameras.lenses.PerspectiveLens(this._fieldOfView);
	clone._pNear = this._pNear;
	clone._pFar = this._pFar;
	clone._pAspectRatio = this._pAspectRatio;
	return clone;
};

away.cameras.lenses.PerspectiveLens.prototype.pUpdateMatrix = function() {
	var raw = [];
	this._yMax = this._pNear * this._focalLengthInv;
	this._xMax = this._yMax * this._pAspectRatio;
	var left, right, top, bottom;
	if (this._pScissorRect.x == 0 && this._pScissorRect.y == 0 && this._pScissorRect.width == this._pViewPort.width && this._pScissorRect.height == this._pViewPort.height) {
		left = -this._xMax;
		right = this._xMax;
		top = -this._yMax;
		bottom = this._yMax;
		raw[0] = this._pNear / this._xMax;
		raw[5] = this._pNear / this._yMax;
		raw[10] = this._pFar / (this._pFar - this._pNear);
		raw[11] = 1;
		raw[1] = 0;
		raw[2] = 0;
		raw[3] = 0;
		raw[4] = 0;
		raw[6] = 0;
		raw[7] = 0;
		raw[8] = 0;
		raw[9] = 0;
		raw[12] = 0;
		raw[13] = 0;
		raw[15] = 0;
		raw[14] = -this._pNear * raw[10];
	} else {
		var xWidth = this._xMax * (this._pViewPort.width / this._pScissorRect.width);
		var yHgt = this._yMax * (this._pViewPort.height / this._pScissorRect.height);
		var center = this._xMax * (this._pScissorRect.x * 2 - this._pViewPort.width) / this._pScissorRect.width + this._xMax;
		var middle = -this._yMax * (this._pScissorRect.y * 2 - this._pViewPort.height) / this._pScissorRect.height - this._yMax;
		left = center - xWidth;
		right = center + xWidth;
		top = middle - yHgt;
		bottom = middle + yHgt;
		raw[0] = 2 * this._pNear / (right - left);
		raw[5] = 2 * this._pNear / (bottom - top);
		raw[8] = (right + left) / (right - left);
		raw[9] = (bottom + top) / (bottom - top);
		raw[10] = (this._pFar + this._pNear) / (this._pFar - this._pNear);
		raw[11] = 1;
		raw[1] = 0;
		raw[2] = 0;
		raw[3] = 0;
		raw[4] = 0;
		raw[6] = 0;
		raw[7] = 0;
		raw[12] = 0;
		raw[13] = 0;
		raw[15] = 0;
		raw[14] = -2 * this._pFar * this._pNear / (this._pFar - this._pNear);
	}
	this._pMatrix.copyRawDataFrom(raw, 0, false);
	var yMaxFar = this._pFar * this._focalLengthInv;
	var xMaxFar = yMaxFar * this._pAspectRatio;
	this._pFrustumCorners[0] = left;
	this._pFrustumCorners[9] = left;
	this._pFrustumCorners[3] = right;
	this._pFrustumCorners[6] = right;
	this._pFrustumCorners[1] = top;
	this._pFrustumCorners[4] = top;
	this._pFrustumCorners[7] = bottom;
	this._pFrustumCorners[10] = bottom;
	this._pFrustumCorners[12] = -xMaxFar;
	this._pFrustumCorners[21] = -xMaxFar;
	this._pFrustumCorners[15] = xMaxFar;
	this._pFrustumCorners[18] = xMaxFar;
	this._pFrustumCorners[13] = -yMaxFar;
	this._pFrustumCorners[16] = -yMaxFar;
	this._pFrustumCorners[19] = yMaxFar;
	this._pFrustumCorners[22] = yMaxFar;
	this._pFrustumCorners[2] = this._pNear;
	this._pFrustumCorners[5] = this._pNear;
	this._pFrustumCorners[8] = this._pNear;
	this._pFrustumCorners[11] = this._pNear;
	this._pFrustumCorners[14] = this._pFar;
	this._pFrustumCorners[17] = this._pFar;
	this._pFrustumCorners[20] = this._pFar;
	this._pFrustumCorners[23] = this._pFar;
	this._pMatrixInvalid = false;
};

$inherit(away.cameras.lenses.PerspectiveLens, away.cameras.lenses.LensBase);

away.cameras.lenses.PerspectiveLens.className = "away.cameras.lenses.PerspectiveLens";

away.cameras.lenses.PerspectiveLens.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.Vector3D');
	return p;
};

away.cameras.lenses.PerspectiveLens.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.cameras.lenses.PerspectiveLens.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'fieldOfView', t:'Number'});
			break;
		case 1:
			p = away.cameras.lenses.LensBase.injectionPoints(t);
			break;
		case 2:
			p = away.cameras.lenses.LensBase.injectionPoints(t);
			break;
		case 3:
			p = away.cameras.lenses.LensBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

