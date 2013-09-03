/** Compiled by the Randori compiler v0.2.6.2 on Mon Sep 02 23:32:23 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.lights == "undefined")
	away.lights = {};

away.lights.DirectionalLight = function(xDir, yDir, zDir) {
	this._tmpLookAt = null;
	this._direction = null;
	this._projAABBPoints = null;
	this._sceneDirection = null;
	away.lights.LightBase.call(this);
	this.set_direction(new away.geom.Vector3D(xDir, yDir, zDir, 0));
	this._sceneDirection = new away.geom.Vector3D(0, 0, 0, 0);
};

away.lights.DirectionalLight.prototype.pCreateEntityPartitionNode = function() {
	return new away.partition.DirectionalLightNode(this);
};

away.lights.DirectionalLight.prototype.get_sceneDirection = function() {
	if (this._pSceneTransformDirty) {
		this.pUpdateSceneTransform();
	}
	return this._sceneDirection;
};

away.lights.DirectionalLight.prototype.get_direction = function() {
	return this._direction;
};

away.lights.DirectionalLight.prototype.set_direction = function(value) {
	this._direction = value;
	if (!this._tmpLookAt) {
		this._tmpLookAt = new away.geom.Vector3D(0, 0, 0, 0);
	}
	this._tmpLookAt.x = this.get_x() + this._direction.x;
	this._tmpLookAt.y = this.get_y() + this._direction.y;
	this._tmpLookAt.z = this.get_z() + this._direction.z;
	this.lookAt(this._tmpLookAt);
};

away.lights.DirectionalLight.prototype.pGetDefaultBoundingVolume = function() {
	return new away.bounds.NullBounds(true);
};

away.lights.DirectionalLight.prototype.pUpdateBounds = function() {
};

away.lights.DirectionalLight.prototype.pUpdateSceneTransform = function() {
	away.lights.LightBase.prototype.pUpdateSceneTransform.call(this);
	this.get_sceneTransform().copyColumnTo(2, this._sceneDirection);
	this._sceneDirection.normalize();
};

away.lights.DirectionalLight.prototype.pCreateShadowMapper = function() {
	return new away.lights.shadowmaps.DirectionalShadowMapper();
};

away.lights.DirectionalLight.prototype.iGetObjectProjectionMatrix = function(renderable, target) {
	var raw = [];
	var bounds = renderable.get_sourceEntity().get_bounds();
	var m = new away.geom.Matrix3D();
	m.copyFrom(renderable.get_sceneTransform());
	m.append(this.get_inverseSceneTransform());
	if (!this._projAABBPoints) {
		this._projAABBPoints = [];
	}
	m.transformVectors(bounds.get_aabbPoints(), this._projAABBPoints);
	var xMin = Infinity, xMax = -Infinity;
	var yMin = Infinity, yMax = -Infinity;
	var zMin = Infinity, zMax = -Infinity;
	var d;
	for (var i = 0; i < 24;) {
		d = this._projAABBPoints[i++];
		if (d < xMin)
			xMin = d;
		if (d > xMax)
			xMax = d;
		d = this._projAABBPoints[i++];
		if (d < yMin)
			yMin = d;
		if (d > yMax)
			yMax = d;
		d = this._projAABBPoints[i++];
		if (d < zMin)
			zMin = d;
		if (d > zMax)
			zMax = d;
	}
	var invXRange = 1 / (xMax - xMin);
	var invYRange = 1 / (yMax - yMin);
	var invZRange = 1 / (zMax - zMin);
	raw[0] = 2 * invXRange;
	raw[5] = 2 * invYRange;
	raw[10] = invZRange;
	raw[12] = -(xMax + xMin) * invXRange;
	raw[13] = -(yMax + yMin) * invYRange;
	raw[14] = -zMin * invZRange;
	raw[1] = raw[2] = raw[3] = raw[4] = raw[6] = raw[7] = raw[8] = raw[9] = raw[11] = 0;
	raw[15] = 1;
	if (!target) {
		target = new away.geom.Matrix3D();
	}
	target.copyRawDataFrom(raw, 0, false);
	target.prepend(m);
	return target;
};

$inherit(away.lights.DirectionalLight, away.lights.LightBase);

away.lights.DirectionalLight.className = "away.lights.DirectionalLight";

away.lights.DirectionalLight.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.bounds.NullBounds');
	p.push('away.geom.Vector3D');
	p.push('away.geom.Matrix3D');
	p.push('*away.base.IRenderable');
	p.push('away.bounds.BoundingVolumeBase');
	p.push('away.lights.shadowmaps.DirectionalShadowMapper');
	p.push('away.partition.DirectionalLightNode');
	return p;
};

away.lights.DirectionalLight.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.lights.DirectionalLight.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'xDir', t:'Number'});
			p.push({n:'yDir', t:'Number'});
			p.push({n:'zDir', t:'Number'});
			break;
		case 1:
			p = away.lights.LightBase.injectionPoints(t);
			break;
		case 2:
			p = away.lights.LightBase.injectionPoints(t);
			break;
		case 3:
			p = away.lights.LightBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

