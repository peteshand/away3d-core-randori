/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 04 21:18:39 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.cameras == "undefined")
	away.cameras = {};
if (typeof away.cameras.lenses == "undefined")
	away.cameras.lenses = {};

away.cameras.lenses.OrthographicLens = function(projectionHeight) {
	this._yMax = 0;
	this._projectionHeight = 0;
	this._xMax = 0;
	away.cameras.lenses.LensBase.call(this);
	this._projectionHeight = projectionHeight;
};

away.cameras.lenses.OrthographicLens.prototype.get_projectionHeight = function() {
	return this._projectionHeight;
};

away.cameras.lenses.OrthographicLens.prototype.set_projectionHeight = function(value) {
	if (value == this._projectionHeight) {
		return;
	}
	this._projectionHeight = value;
	this.pInvalidateMatrix();
};

away.cameras.lenses.OrthographicLens.prototype.unproject = function(nX, nY, sZ) {
	var v = new away.geom.Vector3D(nX + this.get_matrix().rawData[12], -nY + this.get_matrix().rawData[13], sZ, 1.0);
	v = this.get_unprojectionMatrix().transformVector(v);
	v.z = sZ;
	return v;
};

away.cameras.lenses.OrthographicLens.prototype.clone = function() {
	var clone = new away.cameras.lenses.OrthographicLens(500);
	clone._pNear = this._pNear;
	clone._pFar = this._pFar;
	clone._pAspectRatio = this._pAspectRatio;
	clone.set_projectionHeight(this._projectionHeight);
	return clone;
};

away.cameras.lenses.OrthographicLens.prototype.pUpdateMatrix = function() {
	var raw = [];
	this._yMax = this._projectionHeight * .5;
	this._xMax = this._yMax * this._pAspectRatio;
	var left;
	var right;
	var top;
	var bottom;
	if (this._pScissorRect.x == 0 && this._pScissorRect.y == 0 && this._pScissorRect.width == this._pViewPort.width && this._pScissorRect.height == this._pViewPort.height) {
		left = -this._xMax;
		right = this._xMax;
		top = -this._yMax;
		bottom = this._yMax;
		raw[0] = 2 / (this._projectionHeight * this._pAspectRatio);
		raw[5] = 2 / this._projectionHeight;
		raw[10] = 1 / (this._pFar - this._pNear);
		raw[14] = this._pNear / (this._pNear - this._pFar);
		raw[1] = raw[2] = raw[3] = raw[4] = raw[6] = raw[7] = raw[8] = raw[9] = raw[11] = raw[12] = raw[13] = 0;
		raw[15] = 1;
	} else {
		var xWidth = this._xMax * (this._pViewPort.width / this._pScissorRect.width);
		var yHgt = this._yMax * (this._pViewPort.height / this._pScissorRect.height);
		var center = this._xMax * (this._pScissorRect.x * 2 - this._pViewPort.width) / this._pScissorRect.width + this._xMax;
		var middle = -this._yMax * (this._pScissorRect.y * 2 - this._pViewPort.height) / this._pScissorRect.height - this._yMax;
		left = center - xWidth;
		right = center + xWidth;
		top = middle - yHgt;
		bottom = middle + yHgt;
		raw[0] = 2 * 1 / (right - left);
		raw[5] = -2 * 1 / (top - bottom);
		raw[10] = 1 / (this._pFar - this._pNear);
		raw[12] = (right + left) / (right - left);
		raw[13] = (bottom + top) / (bottom - top);
		raw[14] = this._pNear / (this.get_near() - $createStaticDelegate(this, this.get_far));
		raw[1] = raw[2] = raw[3] = raw[4] = raw[6] = raw[7] = raw[8] = raw[9] = raw[11] = 0;
		raw[15] = 1;
	}
	this._pFrustumCorners[0] = this._pFrustumCorners[9] = this._pFrustumCorners[12] = this._pFrustumCorners[21] = left;
	this._pFrustumCorners[3] = this._pFrustumCorners[6] = this._pFrustumCorners[15] = this._pFrustumCorners[18] = right;
	this._pFrustumCorners[1] = this._pFrustumCorners[4] = this._pFrustumCorners[13] = this._pFrustumCorners[16] = top;
	this._pFrustumCorners[7] = this._pFrustumCorners[10] = this._pFrustumCorners[19] = this._pFrustumCorners[22] = bottom;
	this._pFrustumCorners[2] = this._pFrustumCorners[5] = this._pFrustumCorners[8] = this._pFrustumCorners[11] = this._pNear;
	this._pFrustumCorners[14] = this._pFrustumCorners[17] = this._pFrustumCorners[20] = this._pFrustumCorners[23] = this._pFar;
	this._pMatrix.copyRawDataFrom(raw, 0, false);
	this._pMatrix.appendRotation(180, new away.geom.Vector3D(0, 0, 1, 0));
	this._pMatrixInvalid = false;
};

$inherit(away.cameras.lenses.OrthographicLens, away.cameras.lenses.LensBase);

away.cameras.lenses.OrthographicLens.className = "away.cameras.lenses.OrthographicLens";

away.cameras.lenses.OrthographicLens.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.Vector3D');
	return p;
};

away.cameras.lenses.OrthographicLens.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.cameras.lenses.OrthographicLens.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'projectionHeight', t:'Number'});
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

