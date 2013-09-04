/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 04 21:18:36 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.primitives == "undefined")
	away.primitives = {};

away.primitives.WireframeSphere = function(radius, segmentsW, segmentsH, color, thickness) {
	this._segmentsW = 0;
	this._segmentsH = 0;
	this._radius = 0;
	away.primitives.WireframePrimitiveBase.call(this, color, thickness);
	this._radius = radius;
	this._segmentsW = segmentsW;
	this._segmentsH = segmentsH;
};

away.primitives.WireframeSphere.prototype.pBuildGeometry = function() {
	var vertices = [16777215, 1];
	var v0 = new away.geom.Vector3D(0, 0, 0, 0);
	var v1 = new away.geom.Vector3D(0, 0, 0, 0);
	var i, j;
	var numVerts = 0;
	var index = 0;
	for (j = 0; j <= this._segmentsH; ++j) {
		var horangle = 3.141592653589793 * j / this._segmentsH;
		var z = -this._radius * Math.cos(horangle);
		var ringradius = this._radius * Math.sin(horangle);
		for (i = 0; i <= this._segmentsW; ++i) {
			var verangle = 2 * 3.141592653589793 * i / this._segmentsW;
			var x = ringradius * Math.cos(verangle);
			var y = ringradius * Math.sin(verangle);
			vertices[numVerts++] = x;
			vertices[numVerts++] = -z;
			vertices[numVerts++] = y;
		}
	}
	for (j = 1; j <= this._segmentsH; ++j) {
		for (i = 1; i <= this._segmentsW; ++i) {
			var a = ((this._segmentsW + 1) * j + i) * 3;
			var b = ((this._segmentsW + 1) * j + i - 1) * 3;
			var c = ((this._segmentsW + 1) * (j - 1) + i - 1) * 3;
			var d = ((this._segmentsW + 1) * (j - 1) + i) * 3;
			if (j == this._segmentsH) {
				v0.x = vertices[c];
				v0.y = vertices[c + 1];
				v0.z = vertices[c + 2];
				v1.x = vertices[d];
				v1.y = vertices[d + 1];
				v1.z = vertices[d + 2];
				this.pUpdateOrAddSegment(index++, v0, v1);
				v0.x = vertices[a];
				v0.y = vertices[a + 1];
				v0.z = vertices[a + 2];
				this.pUpdateOrAddSegment(index++, v0, v1);
			} else if (j == 1) {
				v1.x = vertices[b];
				v1.y = vertices[b + 1];
				v1.z = vertices[b + 2];
				v0.x = vertices[c];
				v0.y = vertices[c + 1];
				v0.z = vertices[c + 2];
				this.pUpdateOrAddSegment(index++, v0, v1);
			} else {
				v1.x = vertices[b];
				v1.y = vertices[b + 1];
				v1.z = vertices[b + 2];
				v0.x = vertices[c];
				v0.y = vertices[c + 1];
				v0.z = vertices[c + 2];
				this.pUpdateOrAddSegment(index++, v0, v1);
				v1.x = vertices[d];
				v1.y = vertices[d + 1];
				v1.z = vertices[d + 2];
				this.pUpdateOrAddSegment(index++, v0, v1);
			}
		}
	}
};

$inherit(away.primitives.WireframeSphere, away.primitives.WireframePrimitiveBase);

away.primitives.WireframeSphere.className = "away.primitives.WireframeSphere";

away.primitives.WireframeSphere.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.Vector3D');
	return p;
};

away.primitives.WireframeSphere.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.primitives.WireframeSphere.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'radius', t:'Number'});
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

