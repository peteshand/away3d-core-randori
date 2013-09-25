/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 25 00:03:30 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.lights == "undefined")
	away.lights = {};

away.lights.PointLight = function() {
	this._pFallOff = 100000;
	this._pFallOffFactor = 0;
	this._pRadius = 90000;
	away.lights.LightBase.call(this);
	this._pFallOffFactor = 1 / (this._pFallOff * this._pFallOff - this._pRadius * this._pRadius);
};

away.lights.PointLight.prototype.pCreateShadowMapper = function() {
	return new away.lights.shadowmaps.CubeMapShadowMapper();
};

away.lights.PointLight.prototype.pCreateEntityPartitionNode = function() {
	return new away.partition.PointLightNode(this);
};

away.lights.PointLight.prototype.get_radius = function() {
	return this._pRadius;
};

away.lights.PointLight.prototype.set_radius = function(value) {
	this._pRadius = value;
	if (this._pRadius < 0) {
		this._pRadius = 0;
	} else if (this._pRadius > this._pFallOff) {
		this._pFallOff = this._pRadius;
		this.pInvalidateBounds();
	}
	this._pFallOffFactor = 1 / (this._pFallOff * this._pFallOff - this._pRadius * this._pRadius);
};

away.lights.PointLight.prototype.iFallOffFactor = function() {
	return this._pFallOffFactor;
};

away.lights.PointLight.prototype.get_fallOff = function() {
	return this._pFallOff;
};

away.lights.PointLight.prototype.set_fallOff = function(value) {
	this._pFallOff = value;
	if (this._pFallOff < 0) {
		this._pFallOff = 0;
	}
	if (this._pFallOff < this._pRadius) {
		this._pRadius = this._pFallOff;
	}
	this._pFallOffFactor = 1 / (this._pFallOff * this._pFallOff - this._pRadius * this._pRadius);
	this.pInvalidateBounds();
};

away.lights.PointLight.prototype.pUpdateBounds = function() {
	this._pBounds.fromSphere(new away.geom.Vector3D(0, 0, 0, 0), this._pFallOff);
	this._pBoundsInvalid = false;
};

away.lights.PointLight.prototype.pGetDefaultBoundingVolume = function() {
	return new away.bounds.BoundingSphere();
};

away.lights.PointLight.prototype.iGetObjectProjectionMatrix = function(renderable, target) {
	target = target || null;
	var raw = away.utils.VectorInit.AnyClass(Number);
	var bounds = renderable.get_sourceEntity().get_bounds();
	var m = new away.geom.Matrix3D();
	m.copyFrom(renderable.get_sceneTransform());
	m.append(this._pParent.get_inverseSceneTransform());
	this.lookAt(m.get_position());
	m.copyFrom(renderable.get_sceneTransform());
	m.append(this.get_inverseSceneTransform());
	m.copyColumnTo(3, this._pPos);
	var v1 = m.deltaTransformVector(bounds.get_min());
	var v2 = m.deltaTransformVector(bounds.get_max());
	var z = this._pPos.z;
	var d1 = v1.x * v1.x + v1.y * v1.y + v1.z * v1.z;
	var d2 = v2.x * v2.x + v2.y * v2.y + v2.z * v2.z;
	var d = Math.sqrt(d1 > d2 ? d1 : d2);
	var zMin;
	var zMax;
	zMin = z - d;
	zMax = z + d;
	raw[5] = zMin / d;
	raw[0] = zMin / d;
	raw[10] = zMax / (zMax - zMin);
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
	raw[14] = -zMin * raw[10];
	if (!target) {
		target = new away.geom.Matrix3D();
	}
	target.copyRawDataFrom(raw, 0, false);
	target.prepend(m);
	return target;
};

$inherit(away.lights.PointLight, away.lights.LightBase);

away.lights.PointLight.className = "away.lights.PointLight";

away.lights.PointLight.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.lights.shadowmaps.CubeMapShadowMapper');
	p.push('away.geom.Vector3D');
	p.push('away.geom.Matrix3D');
	p.push('Number');
	p.push('*away.base.IRenderable');
	p.push('away.bounds.BoundingVolumeBase');
	p.push('away.partition.PointLightNode');
	p.push('away.bounds.BoundingSphere');
	p.push('away.utils.VectorInit');
	p.push('away.containers.ObjectContainer3D');
	return p;
};

away.lights.PointLight.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.lights.PointLight.injectionPoints = function(t) {
	var p;
	switch (t) {
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

