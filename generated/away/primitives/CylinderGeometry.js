/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 21 16:02:23 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.primitives == "undefined")
	away.primitives = {};

away.primitives.CylinderGeometry = function(topRadius, bottomRadius, height, segmentsW, segmentsH, topClosed, bottomClosed, surfaceClosed, yUp) {
	this._nextVertexIndex = 0;
	this._currentIndex = 0;
	this._pSegmentsH = 0;
	this._yUp = null;
	this._stride = 0;
	this._numVertices = 0;
	this._height = 0;
	this._rawData = null;
	this._rawIndices = null;
	this._vertexOffset = 0;
	this._currentTriangleIndex = 0;
	this._surfaceClosed = null;
	this._topRadius = 0;
	this._bottomClosed = null;
	this._pBottomRadius = 0;
	this._topClosed = null;
	this._pSegmentsW = 0;
	away.primitives.PrimitiveBase.call(this);
	this._topRadius = topRadius;
	this._pBottomRadius = bottomRadius;
	this._height = height;
	this._pSegmentsW = segmentsW;
	this._pSegmentsH = segmentsH;
	this._topClosed = topClosed;
	this._bottomClosed = bottomClosed;
	this._surfaceClosed = surfaceClosed;
	this._yUp = yUp;
};

away.primitives.CylinderGeometry.prototype.addVertex = function(px, py, pz, nx, ny, nz, tx, ty, tz) {
	var compVertInd = this._vertexOffset + this._nextVertexIndex * this._stride;
	this._rawData[compVertInd++] = px;
	this._rawData[compVertInd++] = py;
	this._rawData[compVertInd++] = pz;
	this._rawData[compVertInd++] = nx;
	this._rawData[compVertInd++] = ny;
	this._rawData[compVertInd++] = nz;
	this._rawData[compVertInd++] = tx;
	this._rawData[compVertInd++] = ty;
	this._rawData[compVertInd++] = tz;
	this._nextVertexIndex++;
};

away.primitives.CylinderGeometry.prototype.addTriangleClockWise = function(cwVertexIndex0, cwVertexIndex1, cwVertexIndex2) {
	this._rawIndices[this._currentIndex++] = cwVertexIndex0;
	this._rawIndices[this._currentIndex++] = cwVertexIndex1;
	this._rawIndices[this._currentIndex++] = cwVertexIndex2;
	this._currentTriangleIndex++;
};

away.primitives.CylinderGeometry.prototype.pBuildGeometry = function(target) {
	var i;
	var j;
	var x;
	var y;
	var z;
	var radius;
	var revolutionAngle;
	var dr;
	var latNormElev;
	var latNormBase;
	var numTriangles = 0;
	var comp1;
	var comp2;
	var startIndex = 0;
	var t1;
	var t2;
	this._stride = target.get_vertexStride();
	this._vertexOffset = target.get_vertexOffset();
	this._numVertices = 0;
	this._nextVertexIndex = 0;
	this._currentIndex = 0;
	this._currentTriangleIndex = 0;
	if (this._surfaceClosed) {
		this._numVertices += (this._pSegmentsH + 1) * (this._pSegmentsW + 1);
		numTriangles += this._pSegmentsH * this._pSegmentsW * 2;
	}
	if (this._topClosed) {
		this._numVertices += 2 * (this._pSegmentsW + 1);
		numTriangles += this._pSegmentsW;
	}
	if (this._bottomClosed) {
		this._numVertices += 2 * (this._pSegmentsW + 1);
		numTriangles += this._pSegmentsW;
	}
	if (this._numVertices == target.get_numVertices()) {
		this._rawData = target.get_vertexData();
		if (target.get_indexData()) {
			this._rawIndices = target.get_indexData();
		} else {
			this._rawIndices = [];
		}
	} else {
		var numVertComponents = this._numVertices * this._stride;
		this._rawData = [];
		this._rawIndices = [];
	}
	var revolutionAngleDelta = 2 * 3.141592653589793 / this._pSegmentsW;
	if (this._topClosed && this._topRadius > 0) {
		z = -0.5 * this._height;
		for (i = 0; i <= this._pSegmentsW; ++i) {
			if (this._yUp) {
				t1 = 1;
				t2 = 0;
				comp1 = -z;
				comp2 = 0;
			} else {
				t1 = 0;
				t2 = -1;
				comp1 = 0;
				comp2 = z;
			}
			this.addVertex(0, comp1, comp2, 0, t1, t2, 1, 0, 0);
			revolutionAngle = i * revolutionAngleDelta;
			x = this._topRadius * Math.cos(revolutionAngle);
			y = this._topRadius * Math.sin(revolutionAngle);
			if (this._yUp) {
				comp1 = -z;
				comp2 = y;
			} else {
				comp1 = y;
				comp2 = z;
			}
			if (i == this._pSegmentsW)
				this.addVertex(this._rawData[startIndex + this._stride], this._rawData[startIndex + this._stride + 1], this._rawData[startIndex + this._stride + 2], 0, t1, t2, 1, 0, 0);
			else
				this.addVertex(x, comp1, comp2, 0, t1, t2, 1, 0, 0);
			if (i > 0)
				this.addTriangleClockWise(this._nextVertexIndex - 1, this._nextVertexIndex - 3, this._nextVertexIndex - 2);
		}
	}
	if (this._bottomClosed && this._pBottomRadius > 0) {
		z = 0.5 * this._height;
		startIndex = this._vertexOffset + this._nextVertexIndex * this._stride;
		for (i = 0; i <= this._pSegmentsW; ++i) {
			if (this._yUp) {
				t1 = -1;
				t2 = 0;
				comp1 = -z;
				comp2 = 0;
			} else {
				t1 = 0;
				t2 = 1;
				comp1 = 0;
				comp2 = z;
			}
			this.addVertex(0, comp1, comp2, 0, t1, t2, 1, 0, 0);
			revolutionAngle = i * revolutionAngleDelta;
			x = this._pBottomRadius * Math.cos(revolutionAngle);
			y = this._pBottomRadius * Math.sin(revolutionAngle);
			if (this._yUp) {
				comp1 = -z;
				comp2 = y;
			} else {
				comp1 = y;
				comp2 = z;
			}
			if (i == this._pSegmentsW)
				this.addVertex(x, this._rawData[startIndex + 1], this._rawData[startIndex + 2], 0, t1, t2, 1, 0, 0);
			else
				this.addVertex(x, comp1, comp2, 0, t1, t2, 1, 0, 0);
			if (i > 0)
				this.addTriangleClockWise(this._nextVertexIndex - 2, this._nextVertexIndex - 3, this._nextVertexIndex - 1);
		}
	}
	dr = (this._pBottomRadius - this._topRadius);
	latNormElev = dr / this._height;
	latNormBase = (latNormElev == 0) ? 1 : this._height / dr;
	if (this._surfaceClosed) {
		var a;
		var b;
		var c;
		var d;
		var na0, na1, naComp1, naComp2;
		for (j = 0; j <= this._pSegmentsH; ++j) {
			radius = this._topRadius - ((j / this._pSegmentsH) * (this._topRadius - this._pBottomRadius));
			z = -(this._height / 2) + (j / this._pSegmentsH * this._height);
			startIndex = this._vertexOffset + this._nextVertexIndex * this._stride;
			for (i = 0; i <= this._pSegmentsW; ++i) {
				revolutionAngle = i * revolutionAngleDelta;
				x = radius * Math.cos(revolutionAngle);
				y = radius * Math.sin(revolutionAngle);
				na0 = latNormBase * Math.cos(revolutionAngle);
				na1 = latNormBase * Math.sin(revolutionAngle);
				if (this._yUp) {
					t1 = 0;
					t2 = -na0;
					comp1 = -z;
					comp2 = y;
					naComp1 = latNormElev;
					naComp2 = na1;
				} else {
					t1 = -na0;
					t2 = 0;
					comp1 = y;
					comp2 = z;
					naComp1 = na1;
					naComp2 = latNormElev;
				}
				if (i == this._pSegmentsW) {
					this.addVertex(this._rawData[startIndex], this._rawData[startIndex + 1], this._rawData[startIndex + 2], na0, latNormElev, na1, na1, t1, t2);
				} else {
					this.addVertex(x, comp1, comp2, na0, naComp1, naComp2, -na1, t1, t2);
				}
				if (i > 0 && j > 0) {
					a = this._nextVertexIndex - 1;
					b = this._nextVertexIndex - 2;
					c = b - this._pSegmentsW - 1;
					d = a - this._pSegmentsW - 1;
					this.addTriangleClockWise(a, b, c);
					this.addTriangleClockWise(a, c, d);
				}
			}
		}
	}
	target.updateData(this._rawData);
	target.updateIndexData(this._rawIndices);
};

away.primitives.CylinderGeometry.prototype.pBuildUVs = function(target) {
	var i;
	var j;
	var x;
	var y;
	var revolutionAngle;
	var stride = target.get_UVStride();
	var skip = stride - 2;
	var UVData;
	var numUvs = this._numVertices * stride;
	if (target.get_UVData() && numUvs == target.get_UVData().length) {
		UVData = target.get_UVData();
	} else {
		UVData = [];
		this.pInvalidateGeometry();
	}
	var revolutionAngleDelta = 2 * 3.141592653589793 / this._pSegmentsW;
	var currentUvCompIndex = target.get_UVOffset();
	if (this._topClosed) {
		for (i = 0; i <= this._pSegmentsW; ++i) {
			revolutionAngle = i * revolutionAngleDelta;
			x = 0.5 + 0.5 * -Math.cos(revolutionAngle);
			y = 0.5 + 0.5 * Math.sin(revolutionAngle);
			UVData[currentUvCompIndex++] = 0.5 * target.get_scaleU();
			UVData[currentUvCompIndex++] = 0.5 * target.get_scaleV();
			currentUvCompIndex += skip;
			UVData[currentUvCompIndex++] = x * target.get_scaleU();
			UVData[currentUvCompIndex++] = y * target.get_scaleV();
			currentUvCompIndex += skip;
		}
	}
	if (this._bottomClosed) {
		for (i = 0; i <= this._pSegmentsW; ++i) {
			revolutionAngle = i * revolutionAngleDelta;
			x = 0.5 + 0.5 * Math.cos(revolutionAngle);
			y = 0.5 + 0.5 * Math.sin(revolutionAngle);
			UVData[currentUvCompIndex++] = 0.5 * target.get_scaleU();
			UVData[currentUvCompIndex++] = 0.5 * target.get_scaleV();
			currentUvCompIndex += skip;
			UVData[currentUvCompIndex++] = x * target.get_scaleU();
			UVData[currentUvCompIndex++] = y * target.get_scaleV();
			currentUvCompIndex += skip;
		}
	}
	if (this._surfaceClosed) {
		for (j = 0; j <= this._pSegmentsH; ++j) {
			for (i = 0; i <= this._pSegmentsW; ++i) {
				UVData[currentUvCompIndex++] = (i / this._pSegmentsW) * target.get_scaleU();
				UVData[currentUvCompIndex++] = (j / this._pSegmentsH) * target.get_scaleV();
				currentUvCompIndex += skip;
			}
		}
	}
	target.updateData(UVData);
};

away.primitives.CylinderGeometry.prototype.get_topRadius = function() {
	return this._topRadius;
};

away.primitives.CylinderGeometry.prototype.set_topRadius = function(value) {
	this._topRadius = value;
	this.pInvalidateGeometry();
};

away.primitives.CylinderGeometry.prototype.get_bottomRadius = function() {
	return this._pBottomRadius;
};

away.primitives.CylinderGeometry.prototype.set_bottomRadius = function(value) {
	this._pBottomRadius = value;
	this.pInvalidateGeometry();
};

away.primitives.CylinderGeometry.prototype.get_height = function() {
	return this._height;
};

away.primitives.CylinderGeometry.prototype.set_height = function(value) {
	this._height = value;
	this.pInvalidateGeometry();
};

away.primitives.CylinderGeometry.prototype.get_segmentsW = function() {
	return this._pSegmentsW;
};

away.primitives.CylinderGeometry.prototype.set_segmentsW = function(value) {
	this.setSegmentsW(value);
};

away.primitives.CylinderGeometry.prototype.setSegmentsW = function(value) {
	this._pSegmentsW = value;
	this.pInvalidateGeometry();
	this.pInvalidateUVs();
};

away.primitives.CylinderGeometry.prototype.get_segmentsH = function() {
	return this._pSegmentsH;
};

away.primitives.CylinderGeometry.prototype.set_segmentsH = function(value) {
	this.setSegmentsH(value);
};

away.primitives.CylinderGeometry.prototype.setSegmentsH = function(value) {
	this._pSegmentsH = value;
	this.pInvalidateGeometry();
	this.pInvalidateUVs();
};

away.primitives.CylinderGeometry.prototype.get_topClosed = function() {
	return this._topClosed;
};

away.primitives.CylinderGeometry.prototype.set_topClosed = function(value) {
	this._topClosed = value;
	this.pInvalidateGeometry();
};

away.primitives.CylinderGeometry.prototype.get_bottomClosed = function() {
	return this._bottomClosed;
};

away.primitives.CylinderGeometry.prototype.set_bottomClosed = function(value) {
	this._bottomClosed = value;
	this.pInvalidateGeometry();
};

away.primitives.CylinderGeometry.prototype.get_yUp = function() {
	return this._yUp;
};

away.primitives.CylinderGeometry.prototype.set_yUp = function(value) {
	this._yUp = value;
	this.pInvalidateGeometry();
};

$inherit(away.primitives.CylinderGeometry, away.primitives.PrimitiveBase);

away.primitives.CylinderGeometry.className = "away.primitives.CylinderGeometry";

away.primitives.CylinderGeometry.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.primitives.CylinderGeometry.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.primitives.CylinderGeometry.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'topRadius', t:'Number'});
			p.push({n:'bottomRadius', t:'Number'});
			p.push({n:'height', t:'Number'});
			p.push({n:'segmentsW', t:'Number'});
			p.push({n:'segmentsH', t:'Number'});
			p.push({n:'topClosed', t:'Boolean'});
			p.push({n:'bottomClosed', t:'Boolean'});
			p.push({n:'surfaceClosed', t:'Boolean'});
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

