/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 04 21:18:42 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.primitives == "undefined")
	away.primitives = {};

away.primitives.PlaneGeometry = function(width, height, segmentsW, segmentsH, yUp, doubleSided) {
	this._yUp = null;
	this._segmentsH = 0;
	this._width = 0;
	this._height = 0;
	this._doubleSided = null;
	this._segmentsW = 0;
	away.primitives.PrimitiveBase.call(this);
	this._segmentsW = segmentsW;
	this._segmentsH = segmentsH;
	this._yUp = yUp;
	this._width = width;
	this._height = height;
	this._doubleSided = doubleSided;
};

away.primitives.PlaneGeometry.prototype.get_segmentsW = function() {
	return this._segmentsW;
};

away.primitives.PlaneGeometry.prototype.set_segmentsW = function(value) {
	this._segmentsW = value;
	this.pInvalidateGeometry();
	this.pInvalidateUVs();
};

away.primitives.PlaneGeometry.prototype.get_segmentsH = function() {
	return this._segmentsH;
};

away.primitives.PlaneGeometry.prototype.set_segmentsH = function(value) {
	this._segmentsH = value;
	this.pInvalidateGeometry();
	this.pInvalidateUVs();
};

away.primitives.PlaneGeometry.prototype.get_yUp = function() {
	return this._yUp;
};

away.primitives.PlaneGeometry.prototype.set_yUp = function(value) {
	this._yUp = value;
	this.pInvalidateGeometry();
};

away.primitives.PlaneGeometry.prototype.get_doubleSided = function() {
	return this._doubleSided;
};

away.primitives.PlaneGeometry.prototype.set_doubleSided = function(value) {
	this._doubleSided = value;
	this.pInvalidateGeometry();
};

away.primitives.PlaneGeometry.prototype.get_width = function() {
	return this._width;
};

away.primitives.PlaneGeometry.prototype.set_width = function(value) {
	this._width = value;
	this.pInvalidateGeometry();
};

away.primitives.PlaneGeometry.prototype.get_height = function() {
	return this._height;
};

away.primitives.PlaneGeometry.prototype.set_height = function(value) {
	this._height = value;
	this.pInvalidateGeometry();
};

away.primitives.PlaneGeometry.prototype.pBuildGeometry = function(target) {
	var data;
	var indices;
	var x, y;
	var numIndices;
	var base;
	var tw = this._segmentsW + 1;
	var numVertices = (this._segmentsH + 1) * tw;
	var stride = target.get_vertexStride();
	var skip = stride - 9;
	if (this._doubleSided)
		numVertices *= 2;
	numIndices = this._segmentsH * this._segmentsW * 6;
	if (this._doubleSided)
		numIndices <<= 1;
	if (numVertices == target.get_numVertices()) {
		data = target.get_vertexData();
		if (indices == null) {
			indices = [];
		} else {
			indices = target.get_indexData();
		}
	} else {
		data = [];
		indices = [];
		this.pInvalidateUVs();
	}
	numIndices = 0;
	var index = target.get_vertexOffset();
	for (var yi = 0; yi <= this._segmentsH; ++yi) {
		for (var xi = 0; xi <= this._segmentsW; ++xi) {
			x = (xi / this._segmentsW - .5) * this._width;
			y = (yi / this._segmentsH - .5) * this._height;
			data[index++] = x;
			if (this._yUp) {
				data[index++] = 0;
				data[index++] = y;
			} else {
				data[index++] = y;
				data[index++] = 0;
			}
			data[index++] = 0;
			if (this._yUp) {
				data[index++] = 1;
				data[index++] = 0;
			} else {
				data[index++] = 0;
				data[index++] = -1;
			}
			data[index++] = 1;
			data[index++] = 0;
			data[index++] = 0;
			index += skip;
			if (this._doubleSided) {
				for (var i = 0; i < 3; ++i) {
					data[index] = data[index - stride];
					++index;
				}
				for (i = 0; i < 3; ++i) {
					data[index] = -data[index - stride];
					++index;
				}
				for (i = 0; i < 3; ++i) {
					data[index] = -data[index - stride];
					++index;
				}
				index += skip;
			}
			if (xi != this._segmentsW && yi != this._segmentsH) {
				base = xi + yi * tw;
				var mult = this._doubleSided ? 2 : 1;
				indices[numIndices++] = base * mult;
				indices[numIndices++] = (base + tw) * mult;
				indices[numIndices++] = (base + tw + 1) * mult;
				indices[numIndices++] = base * mult;
				indices[numIndices++] = (base + tw + 1) * mult;
				indices[numIndices++] = (base + 1) * mult;
				if (this._doubleSided) {
					indices[numIndices++] = (base + tw + 1) * mult + 1;
					indices[numIndices++] = (base + tw) * mult + 1;
					indices[numIndices++] = base * mult + 1;
					indices[numIndices++] = (base + 1) * mult + 1;
					indices[numIndices++] = (base + tw + 1) * mult + 1;
					indices[numIndices++] = base * mult + 1;
				}
			}
		}
	}
	target.updateData(data);
	target.updateIndexData(indices);
};

away.primitives.PlaneGeometry.prototype.pBuildUVs = function(target) {
	var data;
	var stride = target.get_UVStride();
	var numUvs = (this._segmentsH + 1) * (this._segmentsW + 1) * stride;
	var skip = stride - 2;
	if (this._doubleSided) {
		numUvs *= 2;
	}
	if (target.get_UVData() && numUvs == target.get_UVData().length) {
		data = target.get_UVData();
	} else {
		data = [];
		this.pInvalidateGeometry();
	}
	var index = target.get_UVOffset();
	for (var yi = 0; yi <= this._segmentsH; ++yi) {
		for (var xi = 0; xi <= this._segmentsW; ++xi) {
			data[index++] = (1 - (xi / this._segmentsW) * target.get_scaleU());
			data[index++] = (1 - yi / this._segmentsH) * target.get_scaleV();
			index += skip;
			if (this._doubleSided) {
				data[index++] = (1 - (xi / this._segmentsW) * target.get_scaleU());
				data[index++] = (1 - yi / this._segmentsH) * target.get_scaleV();
				index += skip;
			}
		}
	}
	target.updateData(data);
};

$inherit(away.primitives.PlaneGeometry, away.primitives.PrimitiveBase);

away.primitives.PlaneGeometry.className = "away.primitives.PlaneGeometry";

away.primitives.PlaneGeometry.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.primitives.PlaneGeometry.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.primitives.PlaneGeometry.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'width', t:'Number'});
			p.push({n:'height', t:'Number'});
			p.push({n:'segmentsW', t:'Number'});
			p.push({n:'segmentsH', t:'Number'});
			p.push({n:'yUp', t:'Boolean'});
			p.push({n:'doubleSided', t:'Boolean'});
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

