/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 24 23:06:57 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.cameras == "undefined")
	away.cameras = {};
if (typeof away.cameras.lenses == "undefined")
	away.cameras.lenses = {};

away.cameras.lenses.FreeMatrixLens = function() {
	away.cameras.lenses.LensBase.call(this);
	this._pMatrix.copyFrom(new away.cameras.lenses.PerspectiveLens(60).get_matrix());
};

away.cameras.lenses.FreeMatrixLens.prototype.set_near = function(value) {
	this._pNear = value;
};

away.cameras.lenses.FreeMatrixLens.prototype.set_far = function(value) {
	this._pFar = value;
};

away.cameras.lenses.FreeMatrixLens.prototype.set_iAspectRatio = function(value) {
	this._pAspectRatio = value;
};

away.cameras.lenses.FreeMatrixLens.prototype.clone = function() {
	var clone = new away.cameras.lenses.FreeMatrixLens();
	clone._pMatrix.copyFrom(this._pMatrix);
	clone._pNear = this._pNear;
	clone._pFar = this._pFar;
	clone._pAspectRatio = this._pAspectRatio;
	clone.pInvalidateMatrix();
	return clone;
};

away.cameras.lenses.FreeMatrixLens.prototype.pUpdateMatrix = function() {
	this._pMatrixInvalid = false;
};

$inherit(away.cameras.lenses.FreeMatrixLens, away.cameras.lenses.LensBase);

away.cameras.lenses.FreeMatrixLens.className = "away.cameras.lenses.FreeMatrixLens";

away.cameras.lenses.FreeMatrixLens.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.cameras.lenses.PerspectiveLens');
	return p;
};

away.cameras.lenses.FreeMatrixLens.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.cameras.lenses.FreeMatrixLens.injectionPoints = function(t) {
	var p;
	switch (t) {
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

