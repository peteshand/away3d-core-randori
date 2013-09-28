/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 28 11:54:56 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.base == "undefined")
	away.base = {};

away.base.Geometry = function() {
	this._subGeometries = null;
	away.library.assets.NamedAssetBase.call(this, null);
	this._subGeometries = [];
};

away.base.Geometry.prototype.get_assetType = function() {
	return away.library.assets.AssetType.GEOMETRY;
};

away.base.Geometry.prototype.get_subGeometries = function() {
	return this._subGeometries;
};

away.base.Geometry.prototype.getSubGeometries = function() {
	return this._subGeometries;
};

away.base.Geometry.prototype.applyTransformation = function(transform) {
	var len = this._subGeometries.length;
	for (var i = 0; i < len; ++i) {
		this._subGeometries[i].applyTransformation(transform);
	}
};

away.base.Geometry.prototype.addSubGeometry = function(subGeometry) {
	this._subGeometries.push(subGeometry);
	subGeometry.set_parentGeometry(this);
	this.dispatchEvent(new away.events.GeometryEvent(away.events.GeometryEvent.SUB_GEOMETRY_ADDED, subGeometry));
	this.iInvalidateBounds(subGeometry);
};

away.base.Geometry.prototype.removeSubGeometry = function(subGeometry) {
	this._subGeometries.splice(this._subGeometries.indexOf(subGeometry, 0), 1);
	subGeometry.set_parentGeometry(null);
	this.dispatchEvent(new away.events.GeometryEvent(away.events.GeometryEvent.SUB_GEOMETRY_REMOVED, subGeometry));
	this.iInvalidateBounds(subGeometry);
};

away.base.Geometry.prototype.clone = function() {
	var clone = new away.base.Geometry();
	var len = this._subGeometries.length;
	for (var i = 0; i < len; ++i) {
		clone.addSubGeometry(this._subGeometries[i].clone());
	}
	return clone;
};

away.base.Geometry.prototype.scale = function(scale) {
	var numSubGeoms = this._subGeometries.length;
	for (var i = 0; i < numSubGeoms; ++i) {
		this._subGeometries[i].scale(scale);
	}
};

away.base.Geometry.prototype.dispose = function() {
	var numSubGeoms = this._subGeometries.length;
	for (var i = 0; i < numSubGeoms; ++i) {
		var subGeom = this._subGeometries[0];
		this.removeSubGeometry(subGeom);
		subGeom.dispose();
	}
};

away.base.Geometry.prototype.scaleUV = function(scaleU, scaleV) {
	scaleU = scaleU || 1;
	scaleV = scaleV || 1;
	var numSubGeoms = this._subGeometries.length;
	for (var i = 0; i < numSubGeoms; ++i) {
		this._subGeometries[i].scaleUV(scaleU, scaleV);
	}
};

away.base.Geometry.prototype.convertToSeparateBuffers = function() {
	var subGeom;
	var numSubGeoms = this._subGeometries.length;
	var _removableCompactSubGeometries = [];
	for (var i = 0; i < numSubGeoms; ++i) {
		subGeom = this._subGeometries[i];
		if (subGeom instanceof away.base.SubGeometry) {
			continue;
		}
		_removableCompactSubGeometries.push(subGeom);
		this.addSubGeometry(subGeom.cloneWithSeperateBuffers());
	}
	var l = _removableCompactSubGeometries.length;
	var s;
	for (var c = 0; c < l; c++) {
		s = _removableCompactSubGeometries[c];
		this.removeSubGeometry(s);
		s.dispose();
	}
};

away.base.Geometry.prototype.iValidate = function() {
};

away.base.Geometry.prototype.iInvalidateBounds = function(subGeom) {
	this.dispatchEvent(new away.events.GeometryEvent(away.events.GeometryEvent.BOUNDS_INVALID, subGeom));
};

$inherit(away.base.Geometry, away.library.assets.NamedAssetBase);

away.base.Geometry.className = "away.base.Geometry";

away.base.Geometry.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.base.SubGeometry');
	p.push('away.events.GeometryEvent');
	p.push('away.library.assets.AssetType');
	return p;
};

away.base.Geometry.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.base.Geometry.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 1:
			p = away.library.assets.NamedAssetBase.injectionPoints(t);
			break;
		case 2:
			p = away.library.assets.NamedAssetBase.injectionPoints(t);
			break;
		case 3:
			p = away.library.assets.NamedAssetBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

