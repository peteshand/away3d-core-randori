/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 21 16:02:23 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.primitives == "undefined")
	away.primitives = {};

away.primitives.CapsuleGeometry = function(radius, height, segmentsW, segmentsH, yUp) {
	this._height = 0;
	this._yUp = null;
	this._radius = 0;
	this._segmentsH = 0;
	this._segmentsW = 0;
	away.primitives.PrimitiveBase.call(this);
	this._radius = radius;
	this._height = height;
	this._segmentsW = segmentsW;
	this._segmentsH = (segmentsH % 2 == 0) ? segmentsH + 1 : segmentsH;
	this._yUp = yUp;
};

away.primitives.CapsuleGeometry.prototype.pBuildGeometry = function(target) {
	var data;
	var indices;
	var i;
	var j;
	var triIndex = 0;
	var numVerts = (this._segmentsH + 1) * (this._segmentsW + 1);
	var stride = target.get_vertexStride();
	var skip = stride - 9;
	var index = 0;
	var startIndex;
	var comp1, comp2, t1, t2;
	if (numVerts == target.get_numVertices()) {
		data = target.get_vertexData();
		if (target.get_indexData()) {
			indices = target.get_indexData();
		} else {
			indices = [];
		}
	} else {
		data = [];
		indices = [];
		this.pInvalidateUVs();
	}
	for (j = 0; j <= this._segmentsH; ++j) {
		var horangle = 3.141592653589793 * j / this._segmentsH;
		var z = -this._radius * Math.cos(horangle);
		var ringradius = this._radius * Math.sin(horangle);
		startIndex = index;
		for (i = 0; i <= this._segmentsW; ++i) {
			var verangle = 2 * 3.141592653589793 * i / this._segmentsW;
			var x = ringradius * Math.cos(verangle);
			var offset = j > this._segmentsH / 2 ? this._height / 2 : -this._height / 2;
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
				data[index++] = data[startIndex];
				data[index++] = data[startIndex + 1];
				data[index++] = data[startIndex + 2];
				data[index++] = (data[startIndex + 3] + (x * normLen)) * .5;
				data[index++] = (data[startIndex + 4] + (comp1 * normLen)) * .5;
				data[index++] = (data[startIndex + 5] + (comp2 * normLen)) * .5;
				data[index++] = (data[startIndex + 6] + tanLen > .007 ? -y / tanLen : 1) * .5;
				data[index++] = (data[startIndex + 7] + t1) * .5;
				data[index++] = (data[startIndex + 8] + t2) * .5;
			} else {
				data[index++] = x;
				data[index++] = this._yUp ? comp1 - offset : comp1;
				data[index++] = this._yUp ? comp2 : comp2 + offset;
				data[index++] = x * normLen;
				data[index++] = comp1 * normLen;
				data[index++] = comp2 * normLen;
				data[index++] = tanLen > .007 ? -y / tanLen : 1;
				data[index++] = t1;
				data[index++] = t2;
			}
			if (i > 0 && j > 0) {
				var a = (this._segmentsW + 1) * j + i;
				var b = (this._segmentsW + 1) * j + i - 1;
				var c = (this._segmentsW + 1) * (j - 1) + i - 1;
				var d = (this._segmentsW + 1) * (j - 1) + i;
				if (j == this._segmentsH) {
					data[index - 9] = data[startIndex];
					data[index - 8] = data[startIndex + 1];
					data[index - 7] = data[startIndex + 2];
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
	target.updateData(data);
	target.updateIndexData(indices);
};

away.primitives.CapsuleGeometry.prototype.pBuildUVs = function(target) {
	var i;
	var j;
	var index;
	var data;
	var stride = target.get_UVStride();
	var UVlen = (this._segmentsH + 1) * (this._segmentsW + 1) * stride;
	var skip = stride - 2;
	if (target.get_UVData() && UVlen == target.get_UVData().length) {
		data = target.get_UVData();
	} else {
		data = [];
		this.pInvalidateGeometry();
	}
	index = target.get_UVOffset();
	for (j = 0; j <= this._segmentsH; ++j) {
		for (i = 0; i <= this._segmentsW; ++i) {
			data[index++] = (i / this._segmentsW) * target.get_scaleU();
			data[index++] = (j / this._segmentsH) * target.get_scaleV();
			index += skip;
		}
	}
	target.updateData(data);
};

away.primitives.CapsuleGeometry.prototype.get_radius = function() {
	return this._radius;
};

away.primitives.CapsuleGeometry.prototype.set_radius = function(value) {
	this._radius = value;
	this.pInvalidateGeometry();
};

away.primitives.CapsuleGeometry.prototype.get_height = function() {
	return this._height;
};

away.primitives.CapsuleGeometry.prototype.set_height = function(value) {
	this._height = value;
	this.pInvalidateGeometry();
};

away.primitives.CapsuleGeometry.prototype.get_segmentsW = function() {
	return this._segmentsW;
};

away.primitives.CapsuleGeometry.prototype.set_segmentsW = function(value) {
	this._segmentsW = value;
	this.pInvalidateGeometry();
	this.pInvalidateUVs();
};

away.primitives.CapsuleGeometry.prototype.get_segmentsH = function() {
	return this._segmentsH;
};

away.primitives.CapsuleGeometry.prototype.set_segmentsH = function(value) {
	this._segmentsH = (value % 2 == 0) ? value + 1 : value;
	this.pInvalidateGeometry();
	this.pInvalidateUVs();
};

away.primitives.CapsuleGeometry.prototype.get_yUp = function() {
	return this._yUp;
};

away.primitives.CapsuleGeometry.prototype.set_yUp = function(value) {
	this._yUp = value;
	this.pInvalidateGeometry();
};

$inherit(away.primitives.CapsuleGeometry, away.primitives.PrimitiveBase);

away.primitives.CapsuleGeometry.className = "away.primitives.CapsuleGeometry";

away.primitives.CapsuleGeometry.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.primitives.CapsuleGeometry.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.primitives.CapsuleGeometry.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'radius', t:'Number'});
			p.push({n:'height', t:'Number'});
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

