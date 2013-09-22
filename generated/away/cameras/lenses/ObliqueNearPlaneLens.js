/** Compiled by the Randori compiler v0.2.6.2 on Sun Sep 22 11:20:00 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.cameras == "undefined")
	away.cameras = {};
if (typeof away.cameras.lenses == "undefined")
	away.cameras.lenses = {};

away.cameras.lenses.ObliqueNearPlaneLens = function(baseLens, plane) {
	this._plane = null;
	this._baseLens = null;
	away.cameras.lenses.LensBase.call(this);
	this.set_baseLens(baseLens);
	this.set_plane(plane);
};

away.cameras.lenses.ObliqueNearPlaneLens.prototype.get_frustumCorners = function() {
	return this._baseLens.get_frustumCorners();
};

away.cameras.lenses.ObliqueNearPlaneLens.prototype.get_near = function() {
	return this._baseLens.get_near();
};

away.cameras.lenses.ObliqueNearPlaneLens.prototype.set_near = function(value) {
	this._baseLens.set_near(value);
};

away.cameras.lenses.ObliqueNearPlaneLens.prototype.get_far = function() {
	return this._baseLens.get_far();
};

away.cameras.lenses.ObliqueNearPlaneLens.prototype.set_far = function(value) {
	this._baseLens.set_far(value);
};

away.cameras.lenses.ObliqueNearPlaneLens.prototype.get_iAspectRatio = function() {
	return this._baseLens.get_iAspectRatio();
};

away.cameras.lenses.ObliqueNearPlaneLens.prototype.set_iAspectRatio = function(value) {
	this._baseLens.set_iAspectRatio(value);
};

away.cameras.lenses.ObliqueNearPlaneLens.prototype.get_plane = function() {
	return this._plane;
};

away.cameras.lenses.ObliqueNearPlaneLens.prototype.set_plane = function(value) {
	this._plane = value;
	this.pInvalidateMatrix();
};

away.cameras.lenses.ObliqueNearPlaneLens.prototype.set_baseLens = function(value) {
	if (this._baseLens) {
		this._baseLens.removeEventListener(away.events.LensEvent.MATRIX_CHANGED, $createStaticDelegate(this, this.onLensMatrixChanged), this);
	}
	this._baseLens = value;
	if (this._baseLens) {
		this._baseLens.addEventListener(away.events.LensEvent.MATRIX_CHANGED, $createStaticDelegate(this, this.onLensMatrixChanged), this);
	}
	this.pInvalidateMatrix();
};

away.cameras.lenses.ObliqueNearPlaneLens.prototype.onLensMatrixChanged = function(event) {
	this.pInvalidateMatrix();
};

away.cameras.lenses.ObliqueNearPlaneLens.prototype.pUpdateMatrix = function() {
	this._pMatrix.copyFrom(this._baseLens.get_matrix());
	var cx = this._plane.a;
	var cy = this._plane.b;
	var cz = this._plane.c;
	var cw = -this._plane.d + .05;
	var signX = cx >= 0 ? 1 : -1;
	var signY = cy >= 0 ? 1 : -1;
	var p = new away.geom.Vector3D(signX, signY, 1, 1);
	var inverse = this._pMatrix.clone();
	inverse.invert();
	var q = inverse.transformVector(p);
	this._pMatrix.copyRowTo(3, p);
	var a = (q.x * p.x + q.y * p.y + q.z * p.z + q.w * p.w) / (cx * q.x + cy * q.y + cz * q.z + cw * q.w);
	this._pMatrix.copyRowFrom(2, new away.geom.Vector3D(cx * a, cy * a, cz * a, cw * a));
};

$inherit(away.cameras.lenses.ObliqueNearPlaneLens, away.cameras.lenses.LensBase);

away.cameras.lenses.ObliqueNearPlaneLens.className = "away.cameras.lenses.ObliqueNearPlaneLens";

away.cameras.lenses.ObliqueNearPlaneLens.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.Vector3D');
	p.push('away.events.LensEvent');
	p.push('away.cameras.lenses.LensBase');
	return p;
};

away.cameras.lenses.ObliqueNearPlaneLens.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.cameras.lenses.ObliqueNearPlaneLens.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'baseLens', t:'away.cameras.lenses.LensBase'});
			p.push({n:'plane', t:'away.math.Plane3D'});
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

