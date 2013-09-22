/** Compiled by the Randori compiler v0.2.6.2 on Sun Sep 22 11:19:56 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.primitives == "undefined")
	away.primitives = {};

away.primitives.WireframeCube = function(width, height, depth, color, thickness) {
	this._height = 0;
	this._width = 0;
	this._depth = 0;
	width = width || 100;
	height = height || 100;
	depth = depth || 100;
	color = color || 0xFFFFFF;
	thickness = thickness || 1;
	away.primitives.WireframePrimitiveBase.call(this, color, thickness);
	this._width = width;
	this._height = height;
	this._depth = depth;
};

away.primitives.WireframeCube.prototype.get_width = function() {
	return this._width;
};

away.primitives.WireframeCube.prototype.set_width = function(value) {
	this._width = value;
	this.pInvalidateGeometry();
};

away.primitives.WireframeCube.prototype.get_height = function() {
	return this._height;
};

away.primitives.WireframeCube.prototype.set_height = function(value) {
	if (value <= 0)
		throw new Error("Value needs to be greater than 0", 0);
	this._height = value;
	this.pInvalidateGeometry();
};

away.primitives.WireframeCube.prototype.get_depth = function() {
	return this._depth;
};

away.primitives.WireframeCube.prototype.set_depth = function(value) {
	this._depth = value;
	this.pInvalidateGeometry();
};

away.primitives.WireframeCube.prototype.pBuildGeometry = function() {
	var v0 = new away.geom.Vector3D(0, 0, 0, 0);
	var v1 = new away.geom.Vector3D(0, 0, 0, 0);
	var hw = this._width * .5;
	var hh = this._height * .5;
	var hd = this._depth * .5;
	v0.x = -hw;
	v0.y = hh;
	v0.z = -hd;
	v1.x = -hw;
	v1.y = -hh;
	v1.z = -hd;
	this.pUpdateOrAddSegment(0, v0, v1);
	v0.z = hd;
	v1.z = hd;
	this.pUpdateOrAddSegment(1, v0, v1);
	v0.x = hw;
	v1.x = hw;
	this.pUpdateOrAddSegment(2, v0, v1);
	v0.z = -hd;
	v1.z = -hd;
	this.pUpdateOrAddSegment(3, v0, v1);
	v0.x = -hw;
	v0.y = -hh;
	v0.z = -hd;
	v1.x = hw;
	v1.y = -hh;
	v1.z = -hd;
	this.pUpdateOrAddSegment(4, v0, v1);
	v0.y = hh;
	v1.y = hh;
	this.pUpdateOrAddSegment(5, v0, v1);
	v0.z = hd;
	v1.z = hd;
	this.pUpdateOrAddSegment(6, v0, v1);
	v0.y = -hh;
	v1.y = -hh;
	this.pUpdateOrAddSegment(7, v0, v1);
	v0.x = -hw;
	v0.y = -hh;
	v0.z = -hd;
	v1.x = -hw;
	v1.y = -hh;
	v1.z = hd;
	this.pUpdateOrAddSegment(8, v0, v1);
	v0.y = hh;
	v1.y = hh;
	this.pUpdateOrAddSegment(9, v0, v1);
	v0.x = hw;
	v1.x = hw;
	this.pUpdateOrAddSegment(10, v0, v1);
	v0.y = -hh;
	v1.y = -hh;
	this.pUpdateOrAddSegment(11, v0, v1);
};

$inherit(away.primitives.WireframeCube, away.primitives.WireframePrimitiveBase);

away.primitives.WireframeCube.className = "away.primitives.WireframeCube";

away.primitives.WireframeCube.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.Vector3D');
	return p;
};

away.primitives.WireframeCube.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.primitives.WireframeCube.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'width', t:'Number'});
			p.push({n:'height', t:'Number'});
			p.push({n:'depth', t:'Number'});
			p.push({n:'color', t:'Number'});
			p.push({n:'thickness', t:'Number'});
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

