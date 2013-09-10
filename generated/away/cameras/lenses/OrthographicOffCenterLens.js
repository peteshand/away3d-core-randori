/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 10 22:28:08 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.cameras == "undefined")
	away.cameras = {};
if (typeof away.cameras.lenses == "undefined")
	away.cameras.lenses = {};

away.cameras.lenses.OrthographicOffCenterLens = function(minX, maxX, minY, maxY) {
	this._minY = 0;
	this._minX = 0;
	this._maxX = 0;
	this._maxY = 0;
	away.cameras.lenses.LensBase.call(this);
	this._minX = minX;
	this._maxX = maxX;
	this._minY = minY;
	this._maxY = maxY;
};

away.cameras.lenses.OrthographicOffCenterLens.prototype.get_minX = function() {
	return this._minX;
};

away.cameras.lenses.OrthographicOffCenterLens.prototype.set_minX = function(value) {
	this._minX = value;
	this.pInvalidateMatrix();
};

away.cameras.lenses.OrthographicOffCenterLens.prototype.get_maxX = function() {
	return this._maxX;
};

away.cameras.lenses.OrthographicOffCenterLens.prototype.set_maxX = function(value) {
	this._maxX = value;
	this.pInvalidateMatrix();
};

away.cameras.lenses.OrthographicOffCenterLens.prototype.get_minY = function() {
	return this._minY;
};

away.cameras.lenses.OrthographicOffCenterLens.prototype.set_minY = function(value) {
	this._minY = value;
	this.pInvalidateMatrix();
};

away.cameras.lenses.OrthographicOffCenterLens.prototype.get_maxY = function() {
	return this._maxY;
};

away.cameras.lenses.OrthographicOffCenterLens.prototype.set_maxY = function(value) {
	this._maxY = value;
	this.pInvalidateMatrix();
};

away.cameras.lenses.OrthographicOffCenterLens.prototype.unproject = function(nX, nY, sZ) {
	var v = new away.geom.Vector3D(nX, -nY, sZ, 1.0);
	v = this.get_unprojectionMatrix().transformVector(v);
	v.z = sZ;
	return v;
};

away.cameras.lenses.OrthographicOffCenterLens.prototype.clone = function() {
	var clone = new away.cameras.lenses.OrthographicOffCenterLens(this._minX, this._maxX, this._minY, this._maxY);
	clone._pNear = this._pNear;
	clone._pFar = this._pFar;
	clone._pAspectRatio = this._pAspectRatio;
	return clone;
};

away.cameras.lenses.OrthographicOffCenterLens.prototype.pUpdateMatrix = function() {
	var raw = [];
	var w = 1 / (this._maxX - this._minX);
	var h = 1 / (this._maxY - this._minY);
	var d = 1 / (this._pFar - this._pNear);
	raw[0] = 2 * w;
	raw[5] = 2 * h;
	raw[10] = d;
	raw[12] = -(this._maxX + this._minX) * w;
	raw[13] = -(this._maxY + this._minY) * h;
	raw[14] = -this._pNear * d;
	raw[15] = 1;
	raw[1] = raw[2] = raw[3] = raw[4] = raw[6] = raw[7] = raw[8] = raw[9] = raw[11] = 0;
	this._pMatrix.copyRawDataFrom(raw, 0, false);
	this._pFrustumCorners[0] = this._pFrustumCorners[9] = this._pFrustumCorners[12] = this._pFrustumCorners[21] = this._minX;
	this._pFrustumCorners[3] = this._pFrustumCorners[6] = this._pFrustumCorners[15] = this._pFrustumCorners[18] = this._maxX;
	this._pFrustumCorners[1] = this._pFrustumCorners[4] = this._pFrustumCorners[13] = this._pFrustumCorners[16] = this._minY;
	this._pFrustumCorners[7] = this._pFrustumCorners[10] = this._pFrustumCorners[19] = this._pFrustumCorners[22] = this._maxY;
	this._pFrustumCorners[2] = this._pFrustumCorners[5] = this._pFrustumCorners[8] = this._pFrustumCorners[11] = this._pNear;
	this._pFrustumCorners[14] = this._pFrustumCorners[17] = this._pFrustumCorners[20] = this._pFrustumCorners[23] = this._pFar;
	this._pMatrixInvalid = false;
};

$inherit(away.cameras.lenses.OrthographicOffCenterLens, away.cameras.lenses.LensBase);

away.cameras.lenses.OrthographicOffCenterLens.className = "away.cameras.lenses.OrthographicOffCenterLens";

away.cameras.lenses.OrthographicOffCenterLens.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.Vector3D');
	return p;
};

away.cameras.lenses.OrthographicOffCenterLens.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.cameras.lenses.OrthographicOffCenterLens.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'minX', t:'Number'});
			p.push({n:'maxX', t:'Number'});
			p.push({n:'minY', t:'Number'});
			p.push({n:'maxY', t:'Number'});
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

