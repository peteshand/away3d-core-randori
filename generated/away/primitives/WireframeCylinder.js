/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 28 11:54:52 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.primitives == "undefined")
	away.primitives = {};

away.primitives.WireframeCylinder = function(topRadius, bottomRadius, height, segmentsW, segmentsH, color, thickness) {
	this._topRadius = 0;
	this._height = 0;
	this._bottomRadius = 0;
	this.TWO_PI = 2 * 3.141592653589793;
	this._segmentsH = 0;
	this._segmentsW = 0;
	topRadius = topRadius || 50;
	bottomRadius = bottomRadius || 50;
	height = height || 100;
	segmentsW = segmentsW || 16;
	segmentsH = segmentsH || 1;
	color = color || 0xFFFFFF;
	thickness = thickness || 1;
	away.primitives.WireframePrimitiveBase.call(this, color, thickness);
	this._topRadius = topRadius;
	this._bottomRadius = bottomRadius;
	this._height = height;
	this._segmentsW = segmentsW;
	this._segmentsH = segmentsH;
};

away.primitives.WireframeCylinder.TWO_PI = 2 * 3.141592653589793;

away.primitives.WireframeCylinder.prototype.pBuildGeometry = function() {
	var i, j;
	var radius = this._topRadius;
	var revolutionAngle;
	var revolutionAngleDelta = away.primitives.WireframeCylinder.TWO_PI / this._segmentsW;
	var nextVertexIndex = 0;
	var x, y, z;
	var lastLayer = away.utils.VectorInit.AnyClass(__AS3__.vec.Vector.<away.geom.Vector3D>, this._segmentsH + 1);
	for (j = 0; j <= this._segmentsH; ++j) {
		lastLayer[j] = away.utils.VectorInit.AnyClass(away.geom.Vector3D, this._segmentsW + 1);
		radius = this._topRadius - ((j / this._segmentsH) * (this._topRadius - this._bottomRadius));
		z = -(this._height / 2) + (j / this._segmentsH * this._height);
		var previousV = null;
		for (i = 0; i <= this._segmentsW; ++i) {
			revolutionAngle = i * revolutionAngleDelta;
			x = radius * Math.cos(revolutionAngle);
			y = radius * Math.sin(revolutionAngle);
			var vertex;
			if (previousV) {
				vertex = new away.geom.Vector3D(x, -z, y, 0);
				this.pUpdateOrAddSegment(nextVertexIndex++, vertex, previousV);
				previousV = vertex;
			}
			else
				previousV = new away.geom.Vector3D(x, -z, y, 0);
			if (j > 0) {
				this.pUpdateOrAddSegment(nextVertexIndex++, vertex, lastLayer[j - 1][i]);
			}
			lastLayer[j][i] = previousV;
		}
	}
};

away.primitives.WireframeCylinder.prototype.get_topRadius = function() {
	return this._topRadius;
};

away.primitives.WireframeCylinder.prototype.set_topRadius = function(value) {
	this._topRadius = value;
	this.pInvalidateGeometry();
};

away.primitives.WireframeCylinder.prototype.get_bottomRadius = function() {
	return this._bottomRadius;
};

away.primitives.WireframeCylinder.prototype.set_bottomRadius = function(value) {
	this._bottomRadius = value;
	this.pInvalidateGeometry();
};

away.primitives.WireframeCylinder.prototype.get_height = function() {
	return this._height;
};

away.primitives.WireframeCylinder.prototype.set_height = function(value) {
	if (this.get_height() <= 0)
		throw new Error("Height must be a value greater than zero.", 0);
	this._height = value;
	this.pInvalidateGeometry();
};

$inherit(away.primitives.WireframeCylinder, away.primitives.WireframePrimitiveBase);

away.primitives.WireframeCylinder.className = "away.primitives.WireframeCylinder";

away.primitives.WireframeCylinder.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.Vector3D');
	p.push('away.utils.VectorInit');
	return p;
};

away.primitives.WireframeCylinder.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.primitives.WireframeCylinder.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'topRadius', t:'Number'});
			p.push({n:'bottomRadius', t:'Number'});
			p.push({n:'height', t:'Number'});
			p.push({n:'segmentsW', t:'Number'});
			p.push({n:'segmentsH', t:'Number'});
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

