/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 04 21:18:32 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.primitives == "undefined")
	away.primitives = {};

away.primitives.WireframeTetrahedron = function(width, height, color, thickness, orientation) {
	this._width = 0;
	this._height = 0;
	this._orientation = null;
	away.primitives.WireframePrimitiveBase.call(this, color, thickness);
	this._width = width;
	this._height = height;
	this._orientation = orientation;
};

away.primitives.WireframeTetrahedron.ORIENTATION_YZ = "yz";

away.primitives.WireframeTetrahedron.ORIENTATION_XY = "xy";

away.primitives.WireframeTetrahedron.ORIENTATION_XZ = "xz";

away.primitives.WireframeTetrahedron.prototype.get_orientation = function() {
	return this._orientation;
};

away.primitives.WireframeTetrahedron.prototype.set_orientation = function(value) {
	this._orientation = value;
	this.pInvalidateGeometry();
};

away.primitives.WireframeTetrahedron.prototype.get_width = function() {
	return this._width;
};

away.primitives.WireframeTetrahedron.prototype.set_width = function(value) {
	if (value <= 0)
		throw new Error("Value needs to be greater than 0", 0);
	this._width = value;
	this.pInvalidateGeometry();
};

away.primitives.WireframeTetrahedron.prototype.get_height = function() {
	return this._height;
};

away.primitives.WireframeTetrahedron.prototype.set_height = function(value) {
	if (value <= 0)
		throw new Error("Value needs to be greater than 0", 0);
	this._height = value;
	this.pInvalidateGeometry();
};

away.primitives.WireframeTetrahedron.prototype.pBuildGeometry = function() {
	var bv0;
	var bv1;
	var bv2;
	var bv3;
	var top;
	var hw = this._width * 0.5;
	switch (this._orientation) {
		case away.primitives.WireframeTetrahedron.ORIENTATION_XY:
			bv0 = new away.geom.Vector3D(-hw, hw, 0, 0);
			bv1 = new away.geom.Vector3D(hw, hw, 0, 0);
			bv2 = new away.geom.Vector3D(hw, -hw, 0, 0);
			bv3 = new away.geom.Vector3D(-hw, -hw, 0, 0);
			top = new away.geom.Vector3D(0, 0, this._height, 0);
			break;
		case away.primitives.WireframeTetrahedron.ORIENTATION_XZ:
			bv0 = new away.geom.Vector3D(-hw, 0, hw, 0);
			bv1 = new away.geom.Vector3D(hw, 0, hw, 0);
			bv2 = new away.geom.Vector3D(hw, 0, -hw, 0);
			bv3 = new away.geom.Vector3D(-hw, 0, -hw, 0);
			top = new away.geom.Vector3D(0, this._height, 0, 0);
			break;
		case away.primitives.WireframeTetrahedron.ORIENTATION_YZ:
			bv0 = new away.geom.Vector3D(0, -hw, hw, 0);
			bv1 = new away.geom.Vector3D(0, hw, hw, 0);
			bv2 = new away.geom.Vector3D(0, hw, -hw, 0);
			bv3 = new away.geom.Vector3D(0, -hw, -hw, 0);
			top = new away.geom.Vector3D(this._height, 0, 0, 0);
			break;
	}
	this.pUpdateOrAddSegment(0, bv0, bv1);
	this.pUpdateOrAddSegment(1, bv1, bv2);
	this.pUpdateOrAddSegment(2, bv2, bv3);
	this.pUpdateOrAddSegment(3, bv3, bv0);
	this.pUpdateOrAddSegment(4, bv0, top);
	this.pUpdateOrAddSegment(5, bv1, top);
	this.pUpdateOrAddSegment(6, bv2, top);
	this.pUpdateOrAddSegment(7, bv3, top);
};

$inherit(away.primitives.WireframeTetrahedron, away.primitives.WireframePrimitiveBase);

away.primitives.WireframeTetrahedron.className = "away.primitives.WireframeTetrahedron";

away.primitives.WireframeTetrahedron.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.Vector3D');
	return p;
};

away.primitives.WireframeTetrahedron.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.primitives.WireframeTetrahedron.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'width', t:'Number'});
			p.push({n:'height', t:'Number'});
			p.push({n:'color', t:'Number'});
			p.push({n:'thickness', t:'Number'});
			p.push({n:'orientation', t:'String'});
			break;
		case 1:
			p = away.primitives.WireframePrimitiveBase.injectionPoints(t);
			break;
		case 2:
			p = away.primitives.WireframePrimitiveBase.injectionPoints(t);
			break;
		case 3:
			p = away.primitives.WireframePrimitiveBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

