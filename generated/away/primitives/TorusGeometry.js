/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 10 22:28:10 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.primitives == "undefined")
	away.primitives = {};

away.primitives.TorusGeometry = function(radius, tubeRadius, segmentsR, segmentsT, yUp) {
	this._currentIndex = 0;
	this._nextVertexIndex = 0;
	this._vertexStride = 0;
	this._tubeRadius = 0;
	this._rawVertexData = null;
	this._yUp = null;
	this._numVertices = 0;
	this._rawIndices = null;
	this._vertexOffset = 0;
	this._currentTriangleIndex = 0;
	this._segmentsT = 0;
	this._segmentsR = 0;
	this._radius = 0;
	away.primitives.PrimitiveBase.call(this);
	this._radius = radius;
	this._tubeRadius = tubeRadius;
	this._segmentsR = segmentsR;
	this._segmentsT = segmentsT;
	this._yUp = yUp;
};

away.primitives.TorusGeometry.prototype.addVertex = function(px, py, pz, nx, ny, nz, tx, ty, tz) {
	var compVertInd = this._vertexOffset + this._nextVertexIndex * this._vertexStride;
	this._rawVertexData[compVertInd++] = px;
	this._rawVertexData[compVertInd++] = py;
	this._rawVertexData[compVertInd++] = pz;
	this._rawVertexData[compVertInd++] = nx;
	this._rawVertexData[compVertInd++] = ny;
	this._rawVertexData[compVertInd++] = nz;
	this._rawVertexData[compVertInd++] = tx;
	this._rawVertexData[compVertInd++] = ty;
	this._rawVertexData[compVertInd] = tz;
	this._nextVertexIndex++;
};

away.primitives.TorusGeometry.prototype.addTriangleClockWise = function(cwVertexIndex0, cwVertexIndex1, cwVertexIndex2) {
	this._rawIndices[this._currentIndex++] = cwVertexIndex0;
	this._rawIndices[this._currentIndex++] = cwVertexIndex1;
	this._rawIndices[this._currentIndex++] = cwVertexIndex2;
	this._currentTriangleIndex++;
};

away.primitives.TorusGeometry.prototype.pBuildGeometry = function(target) {
	var i, j;
	var x, y, z, nx, ny, nz, revolutionAngleR, revolutionAngleT;
	var numTriangles;
	this._numVertices = 0;
	this._nextVertexIndex = 0;
	this._currentIndex = 0;
	this._currentTriangleIndex = 0;
	this._vertexStride = target.get_vertexStride();
	this._vertexOffset = target.get_vertexOffset();
	this._numVertices = (this._segmentsT + 1) * (this._segmentsR + 1);
	numTriangles = this._segmentsT * this._segmentsR * 2;
	if (this._numVertices == target.get_numVertices()) {
		this._rawVertexData = target.get_vertexData();
		if (target.get_indexData() == null) {
			this._rawIndices = [];
		} else {
			this._rawIndices = target.get_indexData();
		}
	} else {
		var numVertComponents = this._numVertices * this._vertexStride;
		this._rawVertexData = [];
		this._rawIndices = [];
		this.pInvalidateUVs();
	}
	var revolutionAngleDeltaR = 2 * 3.141592653589793 / this._segmentsR;
	var revolutionAngleDeltaT = 2 * 3.141592653589793 / this._segmentsT;
	var comp1, comp2;
	var t1, t2, n1, n2;
	var startIndex;
	var a, b, c, d, length;
	for (j = 0; j <= this._segmentsT; ++j) {
		startIndex = this._vertexOffset + this._nextVertexIndex * this._vertexStride;
		for (i = 0; i <= this._segmentsR; ++i) {
			revolutionAngleR = i * revolutionAngleDeltaR;
			revolutionAngleT = j * revolutionAngleDeltaT;
			length = Math.cos(revolutionAngleT);
			nx = length * Math.cos(revolutionAngleR);
			ny = length * Math.sin(revolutionAngleR);
			nz = Math.sin(revolutionAngleT);
			x = this._radius * Math.cos(revolutionAngleR) + this._tubeRadius * nx;
			y = this._radius * Math.sin(revolutionAngleR) + this._tubeRadius * ny;
			z = (j == this._segmentsT) ? 0 : this._tubeRadius * nz;
			if (this._yUp) {
				n1 = -nz;
				n2 = ny;
				t1 = 0;
				t2 = length ? nx / length : x / this._radius;
				comp1 = -z;
				comp2 = y;
			} else {
				n1 = ny;
				n2 = nz;
				t1 = length ? nx / length : x / this._radius;
				t2 = 0;
				comp1 = y;
				comp2 = z;
			}
			if (i == this._segmentsR) {
				this.addVertex(x, this._rawVertexData[startIndex + 1], this._rawVertexData[startIndex + 2], nx, n1, n2, -length ? ny / length : y / this._radius, t1, t2);
			} else {
				this.addVertex(x, comp1, comp2, nx, n1, n2, -length ? ny / length : y / this._radius, t1, t2);
			}
			if (i > 0 && j > 0) {
				a = this._nextVertexIndex - 1;
				b = this._nextVertexIndex - 2;
				c = b - this._segmentsR - 1;
				d = a - this._segmentsR - 1;
				this.addTriangleClockWise(a, b, c);
				this.addTriangleClockWise(a, c, d);
			}
		}
	}
	target.updateData(this._rawVertexData);
	target.updateIndexData(this._rawIndices);
};

away.primitives.TorusGeometry.prototype.pBuildUVs = function(target) {
	var i, j;
	var data;
	var stride = target.get_UVStride();
	var offset = target.get_UVOffset();
	var skip = target.get_UVStride() - 2;
	var numUvs = this._numVertices * stride;
	if (target.get_UVData() && numUvs == target.get_UVData().length) {
		data = target.get_UVData();
	} else {
		data = [];
		this.pInvalidateGeometry();
	}
	var currentUvCompIndex = offset;
	for (j = 0; j <= this._segmentsT; ++j) {
		for (i = 0; i <= this._segmentsR; ++i) {
			data[currentUvCompIndex++] = 1 - (i / this._segmentsR) * target.get_scaleU();
			data[currentUvCompIndex++] = (j / this._segmentsT) * target.get_scaleV();
			currentUvCompIndex += skip;
		}
	}
	target.updateData(data);
};

away.primitives.TorusGeometry.prototype.get_radius = function() {
	return this._radius;
};

away.primitives.TorusGeometry.prototype.set_radius = function(value) {
	this._radius = value;
	this.pInvalidateGeometry();
};

away.primitives.TorusGeometry.prototype.get_tubeRadius = function() {
	return this._tubeRadius;
};

away.primitives.TorusGeometry.prototype.set_tubeRadius = function(value) {
	this._tubeRadius = value;
	this.pInvalidateGeometry();
};

away.primitives.TorusGeometry.prototype.get_segmentsR = function() {
	return this._segmentsR;
};

away.primitives.TorusGeometry.prototype.set_segmentsR = function(value) {
	this._segmentsR = value;
	this.pInvalidateGeometry();
	this.pInvalidateUVs();
};

away.primitives.TorusGeometry.prototype.get_segmentsT = function() {
	return this._segmentsT;
};

away.primitives.TorusGeometry.prototype.set_segmentsT = function(value) {
	this._segmentsT = value;
	this.pInvalidateGeometry();
	this.pInvalidateUVs();
};

away.primitives.TorusGeometry.prototype.get_yUp = function() {
	return this._yUp;
};

away.primitives.TorusGeometry.prototype.set_yUp = function(value) {
	this._yUp = value;
	this.pInvalidateGeometry();
};

$inherit(away.primitives.TorusGeometry, away.primitives.PrimitiveBase);

away.primitives.TorusGeometry.className = "away.primitives.TorusGeometry";

away.primitives.TorusGeometry.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.primitives.TorusGeometry.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.primitives.TorusGeometry.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'radius', t:'Number'});
			p.push({n:'tubeRadius', t:'Number'});
			p.push({n:'segmentsR', t:'Number'});
			p.push({n:'segmentsT', t:'Number'});
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

