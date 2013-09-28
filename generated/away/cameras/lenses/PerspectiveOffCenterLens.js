/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 28 11:54:41 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.cameras == "undefined")
	away.cameras = {};
if (typeof away.cameras.lenses == "undefined")
	away.cameras.lenses = {};

away.cameras.lenses.PerspectiveOffCenterLens = function(minAngleX, maxAngleX, minAngleY, maxAngleY) {
	this._tanMinY = 0;
	this._tanMinX = 0;
	this._maxLengthY = 0;
	this._minAngleY = 0;
	this._minAngleX = 0;
	this._maxLengthX = 0;
	this._minLengthX = 0;
	this._minLengthY = 0;
	this._tanMaxX = 0;
	this._tanMaxY = 0;
	this._maxAngleY = 0;
	this._maxAngleX = 0;
	minAngleX = minAngleX || -40;
	maxAngleX = maxAngleX || 40;
	minAngleY = minAngleY || -40;
	maxAngleY = maxAngleY || 40;
	away.cameras.lenses.LensBase.call(this);
	this.set_minAngleX(minAngleX);
	this.set_maxAngleX(maxAngleX);
	this.set_minAngleY(minAngleY);
	this.set_maxAngleY(maxAngleY);
};

away.cameras.lenses.PerspectiveOffCenterLens.prototype.get_minAngleX = function() {
	return this._minAngleX;
};

away.cameras.lenses.PerspectiveOffCenterLens.prototype.set_minAngleX = function(value) {
	this._minAngleX = value;
	this._tanMinX = Math.tan(this._minAngleX * 3.141592653589793 / 180);
	this.pInvalidateMatrix();
};

away.cameras.lenses.PerspectiveOffCenterLens.prototype.get_maxAngleX = function() {
	return this._maxAngleX;
};

away.cameras.lenses.PerspectiveOffCenterLens.prototype.set_maxAngleX = function(value) {
	this._maxAngleX = value;
	this._tanMaxX = Math.tan(this._maxAngleX * 3.141592653589793 / 180);
	this.pInvalidateMatrix();
};

away.cameras.lenses.PerspectiveOffCenterLens.prototype.get_minAngleY = function() {
	return this._minAngleY;
};

away.cameras.lenses.PerspectiveOffCenterLens.prototype.set_minAngleY = function(value) {
	this._minAngleY = value;
	this._tanMinY = Math.tan(this._minAngleY * 3.141592653589793 / 180);
	this.pInvalidateMatrix();
};

away.cameras.lenses.PerspectiveOffCenterLens.prototype.get_maxAngleY = function() {
	return this._maxAngleY;
};

away.cameras.lenses.PerspectiveOffCenterLens.prototype.set_maxAngleY = function(value) {
	this._maxAngleY = value;
	this._tanMaxY = Math.tan(this._maxAngleY * 3.141592653589793 / 180);
	this.pInvalidateMatrix();
};

away.cameras.lenses.PerspectiveOffCenterLens.prototype.unproject = function(nX, nY, sZ) {
	var v = new away.geom.Vector3D(nX, -nY, sZ, 1.0);
	v.x *= sZ;
	v.y *= sZ;
	v = this.get_unprojectionMatrix().transformVector(v);
	v.z = sZ;
	return v;
};

away.cameras.lenses.PerspectiveOffCenterLens.prototype.clone = function() {
	var clone = new away.cameras.lenses.PerspectiveOffCenterLens(this._minAngleX, this._maxAngleX, this._minAngleY, this._maxAngleY);
	clone._pNear = this._pNear;
	clone._pFar = this._pFar;
	clone._pAspectRatio = this._pAspectRatio;
	return clone;
};

away.cameras.lenses.PerspectiveOffCenterLens.prototype.pUpdateMatrix = function() {
	var raw = [];
	this._minLengthX = this._pNear * this._tanMinX;
	this._maxLengthX = this._pNear * this._tanMaxX;
	this._minLengthY = this._pNear * this._tanMinY;
	this._maxLengthY = this._pNear * this._tanMaxY;
	var minLengthFracX = -this._minLengthX / (this._maxLengthX - this._minLengthX);
	var minLengthFracY = -this._minLengthY / (this._maxLengthY - this._minLengthY);
	var left;
	var right;
	var top;
	var bottom;
	var center = -this._minLengthX * (this._pScissorRect.x + this._pScissorRect.width * minLengthFracX) / (this._pScissorRect.width * minLengthFracX);
	var middle = this._minLengthY * (this._pScissorRect.y + this._pScissorRect.height * minLengthFracY) / (this._pScissorRect.height * minLengthFracY);
	left = center - (this._maxLengthX - this._minLengthX) * (this._pViewPort.width / this._pScissorRect.width);
	right = center;
	top = middle;
	bottom = middle + (this._maxLengthY - this._minLengthY) * (this._pViewPort.height / this._pScissorRect.height);
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
	this._pMatrix.copyRawDataFrom(raw, 0, false);
	this._minLengthX = this._pFar * this._tanMinX;
	this._maxLengthX = this._pFar * this._tanMaxX;
	this._minLengthY = this._pFar * this._tanMinY;
	this._maxLengthY = this._pFar * this._tanMaxY;
	this._pFrustumCorners[0] = left;
	this._pFrustumCorners[9] = left;
	this._pFrustumCorners[3] = right;
	this._pFrustumCorners[6] = right;
	this._pFrustumCorners[1] = top;
	this._pFrustumCorners[4] = top;
	this._pFrustumCorners[7] = bottom;
	this._pFrustumCorners[10] = bottom;
	this._pFrustumCorners[12] = this._minLengthX;
	this._pFrustumCorners[21] = this._minLengthX;
	this._pFrustumCorners[15] = this._maxLengthX;
	this._pFrustumCorners[18] = this._maxLengthX;
	this._pFrustumCorners[13] = this._minLengthY;
	this._pFrustumCorners[16] = this._minLengthY;
	this._pFrustumCorners[19] = this._maxLengthY;
	this._pFrustumCorners[22] = this._maxLengthY;
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

$inherit(away.cameras.lenses.PerspectiveOffCenterLens, away.cameras.lenses.LensBase);

away.cameras.lenses.PerspectiveOffCenterLens.className = "away.cameras.lenses.PerspectiveOffCenterLens";

away.cameras.lenses.PerspectiveOffCenterLens.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.Vector3D');
	return p;
};

away.cameras.lenses.PerspectiveOffCenterLens.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.cameras.lenses.PerspectiveOffCenterLens.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'minAngleX', t:'Number'});
			p.push({n:'maxAngleX', t:'Number'});
			p.push({n:'minAngleY', t:'Number'});
			p.push({n:'maxAngleY', t:'Number'});
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

