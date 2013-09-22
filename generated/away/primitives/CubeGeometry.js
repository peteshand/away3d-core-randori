/** Compiled by the Randori compiler v0.2.6.2 on Sun Sep 22 11:21:18 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.primitives == "undefined")
	away.primitives = {};

away.primitives.CubeGeometry = function(width, height, depth, segmentsW, segmentsH, segmentsD, tile6) {
	this._segmentsD = 0;
	this._depth = 0;
	this._segmentsH = 0;
	this._width = 0;
	this._height = 0;
	this._tile6 = null;
	this._segmentsW = 0;
	width = width || 100;
	height = height || 100;
	depth = depth || 100;
	segmentsW = segmentsW || 1;
	segmentsH = segmentsH || 1;
	segmentsD = segmentsD || 1;
	tile6 = tile6 || true;
	away.primitives.PrimitiveBase.call(this);
	this._width = width;
	this._height = height;
	this._depth = depth;
	this._segmentsW = segmentsW;
	this._segmentsH = segmentsH;
	this._segmentsD = segmentsD;
	this._tile6 = tile6;
};

away.primitives.CubeGeometry.prototype.get_width = function() {
	return this._width;
};

away.primitives.CubeGeometry.prototype.set_width = function(value) {
	this._width = value;
	this.pInvalidateGeometry();
};

away.primitives.CubeGeometry.prototype.get_height = function() {
	return this._height;
};

away.primitives.CubeGeometry.prototype.set_height = function(value) {
	this._height = value;
	this.pInvalidateGeometry();
};

away.primitives.CubeGeometry.prototype.get_depth = function() {
	return this._depth;
};

away.primitives.CubeGeometry.prototype.set_depth = function(value) {
	this._depth = value;
	this.pInvalidateGeometry();
};

away.primitives.CubeGeometry.prototype.get_tile6 = function() {
	return this._tile6;
};

away.primitives.CubeGeometry.prototype.set_tile6 = function(value) {
	this._tile6 = value;
	this.pInvalidateGeometry();
};

away.primitives.CubeGeometry.prototype.get_segmentsW = function() {
	return this._segmentsW;
};

away.primitives.CubeGeometry.prototype.set_segmentsW = function(value) {
	this._segmentsW = value;
	this.pInvalidateGeometry();
	this.pInvalidateUVs();
};

away.primitives.CubeGeometry.prototype.get_segmentsH = function() {
	return this._segmentsH;
};

away.primitives.CubeGeometry.prototype.set_segmentsH = function(value) {
	this._segmentsH = value;
	this.pInvalidateGeometry();
	this.pInvalidateUVs();
};

away.primitives.CubeGeometry.prototype.get_segmentsD = function() {
	return this._segmentsD;
};

away.primitives.CubeGeometry.prototype.set_segmentsD = function(value) {
	this._segmentsD = value;
	this.pInvalidateGeometry();
	this.pInvalidateUVs();
};

away.primitives.CubeGeometry.prototype.pBuildGeometry = function(target) {
	var data;
	var indices;
	var tl, tr, bl, br;
	var i, j, inc = 0;
	var vidx, fidx;
	var hw, hh, hd;
	var dw, dh, dd;
	var outer_pos;
	var numVerts = ((this._segmentsW + 1) * (this._segmentsH + 1) + (this._segmentsW + 1) * (this._segmentsD + 1) + (this._segmentsH + 1) * (this._segmentsD + 1)) * 2;
	var stride = target.get_vertexStride();
	var skip = stride - 9;
	if (numVerts == target.get_numVertices()) {
		data = target.get_vertexData();
		indices = target.get_indexData() ? target.get_indexData() : away.utils.VectorNumber.init((this._segmentsW * this._segmentsH + this._segmentsW * this._segmentsD + this._segmentsH * this._segmentsD) * 12, 0);
	} else {
		data = away.utils.VectorNumber.init(numVerts * stride, 0);
		indices = away.utils.VectorNumber.init((this._segmentsW * this._segmentsH + this._segmentsW * this._segmentsD + this._segmentsH * this._segmentsD) * 12, 0);
		this.pInvalidateUVs();
	}
	vidx = target.get_vertexOffset();
	fidx = 0;
	hw = this._width / 2;
	hh = this._height / 2;
	hd = this._depth / 2;
	dw = this._width / this._segmentsW;
	dh = this._height / this._segmentsH;
	dd = this._depth / this._segmentsD;
	for (i = 0; i <= this._segmentsW; i++) {
		outer_pos = -hw + i * dw;
		for (j = 0; j <= this._segmentsH; j++) {
			data[vidx++] = outer_pos;
			data[vidx++] = -hh + j * dh;
			data[vidx++] = -hd;
			data[vidx++] = 0;
			data[vidx++] = 0;
			data[vidx++] = -1;
			data[vidx++] = 1;
			data[vidx++] = 0;
			data[vidx++] = 0;
			vidx += skip;
			data[vidx++] = outer_pos;
			data[vidx++] = -hh + j * dh;
			data[vidx++] = hd;
			data[vidx++] = 0;
			data[vidx++] = 0;
			data[vidx++] = 1;
			data[vidx++] = -1;
			data[vidx++] = 0;
			data[vidx++] = 0;
			vidx += skip;
			if (i && j) {
				tl = 2 * ((i - 1) * (this._segmentsH + 1) + (j - 1));
				tr = 2 * (i * (this._segmentsH + 1) + (j - 1));
				bl = tl + 2;
				br = tr + 2;
				indices[fidx++] = tl;
				indices[fidx++] = bl;
				indices[fidx++] = br;
				indices[fidx++] = tl;
				indices[fidx++] = br;
				indices[fidx++] = tr;
				indices[fidx++] = tr + 1;
				indices[fidx++] = br + 1;
				indices[fidx++] = bl + 1;
				indices[fidx++] = tr + 1;
				indices[fidx++] = bl + 1;
				indices[fidx++] = tl + 1;
			}
		}
	}
	inc += 2 * (this._segmentsW + 1) * (this._segmentsH + 1);
	for (i = 0; i <= this._segmentsW; i++) {
		outer_pos = -hw + i * dw;
		for (j = 0; j <= this._segmentsD; j++) {
			data[vidx++] = outer_pos;
			data[vidx++] = hh;
			data[vidx++] = -hd + j * dd;
			data[vidx++] = 0;
			data[vidx++] = 1;
			data[vidx++] = 0;
			data[vidx++] = 1;
			data[vidx++] = 0;
			data[vidx++] = 0;
			vidx += skip;
			data[vidx++] = outer_pos;
			data[vidx++] = -hh;
			data[vidx++] = -hd + j * dd;
			data[vidx++] = 0;
			data[vidx++] = -1;
			data[vidx++] = 0;
			data[vidx++] = 1;
			data[vidx++] = 0;
			data[vidx++] = 0;
			vidx += skip;
			if (i && j) {
				tl = inc + 2 * ((i - 1) * (this._segmentsD + 1) + (j - 1));
				tr = inc + 2 * (i * (this._segmentsD + 1) + (j - 1));
				bl = tl + 2;
				br = tr + 2;
				indices[fidx++] = tl;
				indices[fidx++] = bl;
				indices[fidx++] = br;
				indices[fidx++] = tl;
				indices[fidx++] = br;
				indices[fidx++] = tr;
				indices[fidx++] = tr + 1;
				indices[fidx++] = br + 1;
				indices[fidx++] = bl + 1;
				indices[fidx++] = tr + 1;
				indices[fidx++] = bl + 1;
				indices[fidx++] = tl + 1;
			}
		}
	}
	inc += 2 * (this._segmentsW + 1) * (this._segmentsD + 1);
	for (i = 0; i <= this._segmentsD; i++) {
		outer_pos = hd - i * dd;
		for (j = 0; j <= this._segmentsH; j++) {
			data[vidx++] = -hw;
			data[vidx++] = -hh + j * dh;
			data[vidx++] = outer_pos;
			data[vidx++] = -1;
			data[vidx++] = 0;
			data[vidx++] = 0;
			data[vidx++] = 0;
			data[vidx++] = 0;
			data[vidx++] = -1;
			vidx += skip;
			data[vidx++] = hw;
			data[vidx++] = -hh + j * dh;
			data[vidx++] = outer_pos;
			data[vidx++] = 1;
			data[vidx++] = 0;
			data[vidx++] = 0;
			data[vidx++] = 0;
			data[vidx++] = 0;
			data[vidx++] = 1;
			vidx += skip;
			if (i && j) {
				tl = inc + 2 * ((i - 1) * (this._segmentsH + 1) + (j - 1));
				tr = inc + 2 * (i * (this._segmentsH + 1) + (j - 1));
				bl = tl + 2;
				br = tr + 2;
				indices[fidx++] = tl;
				indices[fidx++] = bl;
				indices[fidx++] = br;
				indices[fidx++] = tl;
				indices[fidx++] = br;
				indices[fidx++] = tr;
				indices[fidx++] = tr + 1;
				indices[fidx++] = br + 1;
				indices[fidx++] = bl + 1;
				indices[fidx++] = tr + 1;
				indices[fidx++] = bl + 1;
				indices[fidx++] = tl + 1;
			}
		}
	}
	target.updateData(data);
	target.updateIndexData(indices);
};

away.primitives.CubeGeometry.prototype.pBuildUVs = function(target) {
	var i, j, uidx;
	var data;
	var u_tile_dim, v_tile_dim;
	var u_tile_step, v_tile_step;
	var tl0u, tl0v;
	var tl1u, tl1v;
	var du, dv;
	var stride = target.get_UVStride();
	var numUvs = ((this._segmentsW + 1) * (this._segmentsH + 1) + (this._segmentsW + 1) * (this._segmentsD + 1) + (this._segmentsH + 1) * (this._segmentsD + 1)) * 2 * stride;
	var skip = stride - 2;
	if (target.get_UVData() && numUvs == target.get_UVData().length)
		data = target.get_UVData(); else {
		data = away.utils.VectorNumber.init(numUvs, 0);
		this.pInvalidateGeometry();
	}
	if (this._tile6) {
		u_tile_dim = 1 / 3;
		u_tile_step = 1 / 3;
		v_tile_dim = 1 / 2;
		v_tile_step = 1 / 2;
	} else {
		u_tile_dim = 1;
		v_tile_dim = 1;
		u_tile_step = 0;
		v_tile_step = 0;
	}
	uidx = target.get_UVOffset();
	tl0u = 1 * u_tile_step;
	tl0v = 1 * v_tile_step;
	tl1u = 2 * u_tile_step;
	tl1v = 0 * v_tile_step;
	du = u_tile_dim / this._segmentsW;
	dv = v_tile_dim / this._segmentsH;
	for (i = 0; i <= this._segmentsW; i++) {
		for (j = 0; j <= this._segmentsH; j++) {
			data[uidx++] = (tl0u + i * du) * target.get_scaleU();
			data[uidx++] = (tl0v + (v_tile_dim - j * dv)) * target.get_scaleV();
			uidx += skip;
			data[uidx++] = (tl1u + (u_tile_dim - i * du)) * target.get_scaleU();
			data[uidx++] = (tl1v + (v_tile_dim - j * dv)) * target.get_scaleV();
			uidx += skip;
		}
	}
	tl0u = 1 * u_tile_step;
	tl0v = 0 * v_tile_step;
	tl1u = 0 * u_tile_step;
	tl1v = 0 * v_tile_step;
	du = u_tile_dim / this._segmentsW;
	dv = v_tile_dim / this._segmentsD;
	for (i = 0; i <= this._segmentsW; i++) {
		for (j = 0; j <= this._segmentsD; j++) {
			data[uidx++] = (tl0u + i * du) * target.get_scaleU();
			data[uidx++] = (tl0v + (v_tile_dim - j * dv)) * target.get_scaleV();
			uidx += skip;
			data[uidx++] = (tl1u + i * du) * target.get_scaleU();
			data[uidx++] = (tl1v + j * dv) * target.get_scaleV();
			uidx += skip;
		}
	}
	tl0u = 0 * u_tile_step;
	tl0v = 1 * v_tile_step;
	tl1u = 2 * u_tile_step;
	tl1v = 1 * v_tile_step;
	du = u_tile_dim / this._segmentsD;
	dv = v_tile_dim / this._segmentsH;
	for (i = 0; i <= this._segmentsD; i++) {
		for (j = 0; j <= this._segmentsH; j++) {
			data[uidx++] = (tl0u + i * du) * target.get_scaleU();
			data[uidx++] = (tl0v + (v_tile_dim - j * dv)) * target.get_scaleV();
			uidx += skip;
			data[uidx++] = (tl1u + (u_tile_dim - i * du)) * target.get_scaleU();
			data[uidx++] = (tl1v + (v_tile_dim - j * dv)) * target.get_scaleV();
			uidx += skip;
		}
	}
	target.updateData(data);
};

$inherit(away.primitives.CubeGeometry, away.primitives.PrimitiveBase);

away.primitives.CubeGeometry.className = "away.primitives.CubeGeometry";

away.primitives.CubeGeometry.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.utils.VectorNumber');
	return p;
};

away.primitives.CubeGeometry.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.primitives.CubeGeometry.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'width', t:'Number'});
			p.push({n:'height', t:'Number'});
			p.push({n:'depth', t:'Number'});
			p.push({n:'segmentsW', t:'Number'});
			p.push({n:'segmentsH', t:'Number'});
			p.push({n:'segmentsD', t:'Number'});
			p.push({n:'tile6', t:'Boolean'});
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

