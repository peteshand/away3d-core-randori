/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 10 22:28:10 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.primitives == "undefined")
	away.primitives = {};

away.primitives.SphereGeometry = function(radius, segmentsW, segmentsH, yUp) {
	this._yUp = null;
	this._radius = 0;
	this._segmentsH = 0;
	this._segmentsW = 0;
	away.primitives.PrimitiveBase.call(this);
	this._radius = radius;
	this._segmentsW = segmentsW;
	this._segmentsH = segmentsH;
	this._yUp = yUp;
};

away.primitives.SphereGeometry.prototype.pBuildGeometry = function(target) {
	var vertices;
	var indices;
	var i;
	var j;
	var triIndex = 0;
	var numVerts = (this._segmentsH + 1) * (this._segmentsW + 1);
	var stride = target.get_vertexStride();
	var skip = stride - 9;
	if (numVerts == target.get_numVertices()) {
		vertices = target.get_vertexData();
		if (target.get_indexData()) {
			indices = target.get_indexData();
		} else {
			indices = [];
		}
	} else {
		vertices = [];
		indices = [];
		this.pInvalidateGeometry();
	}
	var startIndex;
	var index = target.get_vertexOffset();
	var comp1;
	var comp2;
	var t1;
	var t2;
	for (j = 0; j <= this._segmentsH; ++j) {
		startIndex = index;
		var horangle = 3.141592653589793 * j / this._segmentsH;
		var z = -this._radius * Math.cos(horangle);
		var ringradius = this._radius * Math.sin(horangle);
		for (i = 0; i <= this._segmentsW; ++i) {
			var verangle = 2 * 3.141592653589793 * i / this._segmentsW;
			var x = ringradius * Math.cos(verangle);
			var y = ringradius * Math.sin(verangle);
			var normLen = 1 / Math.sqrt(x * x + y * y + z * z);
			var tanLen = Math.sqrt(y * y + x * x);
			if (this._yUp) {
				t1 = 0;
				t2 = tanLen > .007 ? x / tanLen : 0;
				comp1 = -z;
				comp2 = y;
			} else {
				t1 = tanLen > .007 ? x / tanLen : 0;
				t2 = 0;
				comp1 = y;
				comp2 = z;
			}
			if (i == this._segmentsW) {
				vertices[index++] = vertices[startIndex];
				vertices[index++] = vertices[startIndex + 1];
				vertices[index++] = vertices[startIndex + 2];
				vertices[index++] = vertices[startIndex + 3] + (x * normLen) * .5;
				vertices[index++] = vertices[startIndex + 4] + (comp1 * normLen) * .5;
				vertices[index++] = vertices[startIndex + 5] + (comp2 * normLen) * .5;
				vertices[index++] = tanLen > .007 ? -y / tanLen : 1;
				vertices[index++] = t1;
				vertices[index++] = t2;
			} else {
				vertices[index++] = x;
				vertices[index++] = comp1;
				vertices[index++] = comp2;
				vertices[index++] = x * normLen;
				vertices[index++] = comp1 * normLen;
				vertices[index++] = comp2 * normLen;
				vertices[index++] = tanLen > .007 ? -y / tanLen : 1;
				vertices[index++] = t1;
				vertices[index++] = t2;
			}
			if (i > 0 && j > 0) {
				var a = (this._segmentsW + 1) * j + i;
				var b = (this._segmentsW + 1) * j + i - 1;
				var c = (this._segmentsW + 1) * (j - 1) + i - 1;
				var d = (this._segmentsW + 1) * (j - 1) + i;
				if (j == this._segmentsH) {
					vertices[index - 9] = vertices[startIndex];
					vertices[index - 8] = vertices[startIndex + 1];
					vertices[index - 7] = vertices[startIndex + 2];
					indices[triIndex++] = a;
					indices[triIndex++] = c;
					indices[triIndex++] = d;
				} else if (j == 1) {
					indices[triIndex++] = a;
					indices[triIndex++] = b;
					indices[triIndex++] = c;
				} else {
					indices[triIndex++] = a;
					indices[triIndex++] = b;
					indices[triIndex++] = c;
					indices[triIndex++] = a;
					indices[triIndex++] = c;
					indices[triIndex++] = d;
				}
			}
			index += skip;
		}
	}
	target.updateData(vertices);
	target.updateIndexData(indices);
};

away.primitives.SphereGeometry.prototype.pBuildUVs = function(target) {
	var i, j;
	var stride = target.get_UVStride();
	var numUvs = (this._segmentsH + 1) * (this._segmentsW + 1) * stride;
	var data;
	var skip = stride - 2;
	if (target.get_UVData() && numUvs == target.get_UVData().length)
		data = target.get_UVData(); else {
		data = [];
		this.pInvalidateGeometry();
	}
	var index = target.get_UVOffset();
	for (j = 0; j <= this._segmentsH; ++j) {
		for (i = 0; i <= this._segmentsW; ++i) {
			data[index++] = 1 - (i / this._segmentsW) * target.get_scaleU();
			data[index++] = (j / this._segmentsH) * target.get_scaleV();
			index += skip;
		}
	}
	target.updateData(data);
};

away.primitives.SphereGeometry.prototype.get_radius = function() {
	return this._radius;
};

away.primitives.SphereGeometry.prototype.set_radius = function(value) {
	this._radius = value;
	this.pInvalidateGeometry();
};

away.primitives.SphereGeometry.prototype.get_segmentsW = function() {
	return this._segmentsW;
};

away.primitives.SphereGeometry.prototype.set_segmentsW = function(value) {
	this._segmentsW = value;
	this.pInvalidateGeometry();
	this.pInvalidateUVs();
};

away.primitives.SphereGeometry.prototype.get_segmentsH = function() {
	return this._segmentsH;
};

away.primitives.SphereGeometry.prototype.set_segmentsH = function(value) {
	this._segmentsH = value;
	this.pInvalidateGeometry();
	this.pInvalidateUVs();
};

away.primitives.SphereGeometry.prototype.get_yUp = function() {
	return this._yUp;
};

away.primitives.SphereGeometry.prototype.set_yUp = function(value) {
	this._yUp = value;
	this.pInvalidateGeometry();
};

$inherit(away.primitives.SphereGeometry, away.primitives.PrimitiveBase);

away.primitives.SphereGeometry.className = "away.primitives.SphereGeometry";

away.primitives.SphereGeometry.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.primitives.SphereGeometry.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.primitives.SphereGeometry.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'radius', t:'Number'});
			p.push({n:'segmentsW', t:'Number'});
			p.push({n:'segmentsH', t:'Number'});
			p.push({n:'yUp', t:'Boolean'});
			break;
		case 1:
			p = away.primitives.PrimitiveBase.injectionPoints(t);
			break;
		case 2:
			p = away.primitives.PrimitiveBase.injectionPoints(t);
			break;
		case 3:
			p = away.primitives.PrimitiveBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

