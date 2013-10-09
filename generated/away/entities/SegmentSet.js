/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:37 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.entities == "undefined")
	away.entities = {};

away.entities.SegmentSet = function() {
	this._activeSubSet = null;
	this.LIMIT = 3 * 0xFFFF;
	this._hasData = false;
	this._animator = null;
	this._pSegments = null;
	this._indexSegments = 0;
	this._subSets = null;
	this._subSetCount = 0;
	this._material = null;
	this._numIndices = 0;
	away.entities.Entity.call(this);
	this._subSetCount = 0;
	this._subSets = [];
	this.addSubSet();
	this._pSegments = {};
	this.set_material(new away.materials.SegmentMaterial(1.25));
};

away.entities.SegmentSet.prototype.addSegment = function(segment) {
	segment.set_iSegmentsBase(this);
	this._hasData = true;
	var subSetIndex = this._subSets.length - 1;
	var subSet = this._subSets[subSetIndex];
	if (subSet.vertices.length + 44 > this.LIMIT) {
		subSet = this.addSubSet();
		subSetIndex++;
	}
	segment.set_iIndex(subSet.vertices.length);
	segment.set_iSubSetIndex(subSetIndex);
	this.iUpdateSegment(segment);
	var index = subSet.lineCount << 2;
	subSet.indices.push(index, index + 1, index + 2, index + 3, index + 2, index + 1);
	subSet.numVertices = subSet.vertices.length / 11;
	subSet.numIndices = subSet.indices.length;
	subSet.lineCount++;
	var segRef = new away.entities.SegRef();
	segRef.index = index;
	segRef.subSetIndex = subSetIndex;
	segRef.segment = segment;
	this._pSegments[this._indexSegments] = segRef;
	this._indexSegments++;
};

away.entities.SegmentSet.prototype.removeSegmentByIndex = function(index, dispose) {
	var segRef;
	if (index >= this._indexSegments) {
		return;
	}
	if (this._pSegments[index]) {
		segRef = this._pSegments[index];
	} else {
		return;
	}
	var subSet;
	if (!this._subSets[segRef.subSetIndex]) {
		return;
	}
	var subSetIndex = segRef.subSetIndex;
	subSet = this._subSets[segRef.subSetIndex];
	var segment = segRef.segment;
	var indices = subSet.indices;
	var ind = index * 6;
	for (var i = ind; i < indices.length; ++i) {
		indices[i] -= 4;
	}
	subSet.indices.splice(index * 6, 6);
	subSet.vertices.splice(index * 44, 44);
	subSet.numVertices = subSet.vertices.length / 11;
	subSet.numIndices = indices.length;
	subSet.vertexBufferDirty = true;
	subSet.indexBufferDirty = true;
	subSet.lineCount--;
	if (dispose) {
		segment.dispose();
		segment = null;
	} else {
		segment.set_iIndex(-1);
		segment.set_iSegmentsBase(null);
	}
	if (subSet.lineCount == 0) {
		if (subSetIndex == 0) {
			this._hasData = false;
		} else {
			subSet.dispose();
			this._subSets[subSetIndex] = null;
			this._subSets.splice(subSetIndex, 1);
		}
	}
	this.reOrderIndices(subSetIndex, index);
	segRef = null;
	this._pSegments[this._indexSegments] = null;
	this._indexSegments--;
};

away.entities.SegmentSet.prototype.removeSegment = function(segment, dispose) {
	if (segment.get_iIndex() == -1) {
		return;
	}
	this.removeSegmentByIndex(segment.get_iIndex() / 44, false);
};

away.entities.SegmentSet.prototype.removeAllSegments = function() {
	var subSet;
	for (var i = 0; i < this._subSetCount; ++i) {
		subSet = this._subSets[i];
		subSet.vertices = null;
		subSet.indices = null;
		if (subSet.vertexBuffer) {
			subSet.vertexBuffer.dispose();
		}
		if (subSet.indexBuffer) {
			subSet.indexBuffer.dispose();
		}
		subSet = null;
	}
	for (var segRef in this._pSegments) {
		segRef = null;
	}
	this._pSegments = null;
	this._subSetCount = 0;
	this._activeSubSet = null;
	this._indexSegments = 0;
	this._subSets = [];
	this._pSegments = {};
	this.addSubSet();
	this._hasData = false;
};

away.entities.SegmentSet.prototype.getSegment = function(index) {
	if (index > this._indexSegments - 1) {
		return null;
	}
	return this._pSegments[index].segment;
};

away.entities.SegmentSet.prototype.get_segmentCount = function() {
	return this._indexSegments;
};

away.entities.SegmentSet.prototype.get_iSubSetCount = function() {
	return this._subSetCount;
};

away.entities.SegmentSet.prototype.iUpdateSegment = function(segment) {
	var start = segment._pStart;
	var end = segment._pEnd;
	var startX = start.x, startY = start.y, startZ = start.z;
	var endX = end.x, endY = end.y, endZ = end.z;
	var startR = segment._pStartR, startG = segment._pStartG, startB = segment._pStartB;
	var endR = segment._pEndR, endG = segment._pEndG, endB = segment._pEndB;
	var index = segment.get_iIndex();
	var t = segment.get_thickness();
	var subSet = this._subSets[segment.get_iSubSetIndex()];
	var vertices = subSet.vertices;
	vertices[index++] = startX;
	vertices[index++] = startY;
	vertices[index++] = startZ;
	vertices[index++] = endX;
	vertices[index++] = endY;
	vertices[index++] = endZ;
	vertices[index++] = t;
	vertices[index++] = startR;
	vertices[index++] = startG;
	vertices[index++] = startB;
	vertices[index++] = 1;
	vertices[index++] = endX;
	vertices[index++] = endY;
	vertices[index++] = endZ;
	vertices[index++] = startX;
	vertices[index++] = startY;
	vertices[index++] = startZ;
	vertices[index++] = -t;
	vertices[index++] = endR;
	vertices[index++] = endG;
	vertices[index++] = endB;
	vertices[index++] = 1;
	vertices[index++] = startX;
	vertices[index++] = startY;
	vertices[index++] = startZ;
	vertices[index++] = endX;
	vertices[index++] = endY;
	vertices[index++] = endZ;
	vertices[index++] = -t;
	vertices[index++] = startR;
	vertices[index++] = startG;
	vertices[index++] = startB;
	vertices[index++] = 1;
	vertices[index++] = endX;
	vertices[index++] = endY;
	vertices[index++] = endZ;
	vertices[index++] = startX;
	vertices[index++] = startY;
	vertices[index++] = startZ;
	vertices[index++] = t;
	vertices[index++] = endR;
	vertices[index++] = endG;
	vertices[index++] = endB;
	vertices[index++] = 1;
	subSet.vertexBufferDirty = true;
	this._pBoundsInvalid = true;
};

away.entities.SegmentSet.prototype.get_hasData = function() {
	return this._hasData;
};

away.entities.SegmentSet.prototype.getIndexBuffer = function(stage3DProxy) {
	if (this._activeSubSet.indexContext3D != stage3DProxy.get_context3D() || this._activeSubSet.indexBufferDirty) {
		this._activeSubSet.indexBuffer = stage3DProxy._iContext3D.createIndexBuffer(this._activeSubSet.numIndices);
		this._activeSubSet.indexBuffer.uploadFromArray(this._activeSubSet.indices, 0, this._activeSubSet.numIndices);
		this._activeSubSet.indexBufferDirty = false;
		this._activeSubSet.indexContext3D = stage3DProxy.get_context3D();
	}
	return this._activeSubSet.indexBuffer;
};

away.entities.SegmentSet.prototype.activateVertexBuffer = function(index, stage3DProxy) {
	var subSet = this._subSets[index];
	this._activeSubSet = subSet;
	this._numIndices = subSet.numIndices;
	var vertexBuffer = subSet.vertexBuffer;
	if (subSet.vertexContext3D != stage3DProxy.get_context3D() || subSet.vertexBufferDirty) {
		subSet.vertexBuffer = stage3DProxy._iContext3D.createVertexBuffer(subSet.numVertices, 11);
		subSet.vertexBuffer.uploadFromArray(subSet.vertices, 0, subSet.numVertices);
		subSet.vertexBufferDirty = false;
		subSet.vertexContext3D = stage3DProxy.get_context3D();
	}
	var context3d = stage3DProxy._iContext3D;
	context3d.setVertexBufferAt(0, vertexBuffer, 0, away.core.display3D.Context3DVertexBufferFormat.FLOAT_3);
	context3d.setVertexBufferAt(1, vertexBuffer, 3, away.core.display3D.Context3DVertexBufferFormat.FLOAT_3);
	context3d.setVertexBufferAt(2, vertexBuffer, 6, away.core.display3D.Context3DVertexBufferFormat.FLOAT_1);
	context3d.setVertexBufferAt(3, vertexBuffer, 7, away.core.display3D.Context3DVertexBufferFormat.FLOAT_4);
};

away.entities.SegmentSet.prototype.activateUVBuffer = function(index, stage3DProxy) {
};

away.entities.SegmentSet.prototype.activateVertexNormalBuffer = function(index, stage3DProxy) {
};

away.entities.SegmentSet.prototype.activateVertexTangentBuffer = function(index, stage3DProxy) {
};

away.entities.SegmentSet.prototype.activateSecondaryUVBuffer = function(index, stage3DProxy) {
};

away.entities.SegmentSet.prototype.reOrderIndices = function(subSetIndex, index) {
	var segRef;
	for (var i = index; i < this._indexSegments - 1; ++i) {
		segRef = this._pSegments[i + 1];
		segRef.index = i;
		if (segRef.subSetIndex == subSetIndex) {
			segRef.segment.set_iIndex(segRef.segment.get_iIndex() - 44);
		}
		this._pSegments[i] = segRef;
	}
};

away.entities.SegmentSet.prototype.addSubSet = function() {
	var subSet = new away.entities.SubSet();
	this._subSets.push(subSet);
	subSet.vertices = [];
	subSet.numVertices = 0;
	subSet.indices = [];
	subSet.numIndices = 0;
	subSet.vertexBufferDirty = true;
	subSet.indexBufferDirty = true;
	subSet.lineCount = 0;
	this._subSetCount++;
	return subSet;
};

away.entities.SegmentSet.prototype.dispose = function() {
	away.entities.Entity.prototype.dispose.call(this);
	this.removeAllSegments();
	this._pSegments = null;
	this._material = null;
	var subSet = this._subSets[0];
	subSet.vertices = null;
	subSet.indices = null;
	this._subSets = null;
};

away.entities.SegmentSet.prototype.get_mouseEnabled = function() {
	return false;
};

away.entities.SegmentSet.prototype.pGetDefaultBoundingVolume = function() {
	return new away.bounds.BoundingSphere();
};

away.entities.SegmentSet.prototype.pUpdateBounds = function() {
	var subSet;
	var len;
	var v;
	var index;
	var minX = Infinity;
	var minY = Infinity;
	var minZ = Infinity;
	var maxX = -Infinity;
	var maxY = -Infinity;
	var maxZ = -Infinity;
	var vertices;
	for (var i = 0; i < this._subSetCount; ++i) {
		subSet = this._subSets[i];
		index = 0;
		vertices = subSet.vertices;
		len = vertices.length;
		if (len == 0) {
			continue;
		}
		while (index < len) {
			v = vertices[index++];
			if (v < minX)
				minX = v;
			else if (v > maxX)
				maxX = v;
			v = vertices[index++];
			if (v < minY)
				minY = v;
			else if (v > maxY)
				maxY = v;
			v = vertices[index++];
			if (v < minZ)
				minZ = v;
			else if (v > maxZ)
				maxZ = v;
			index += 8;
		}
	}
	if (minX != Infinity) {
		this._pBounds.fromExtremes(minX, minY, minZ, maxX, maxY, maxZ);
	} else {
		var min = .5;
		this._pBounds.fromExtremes(-min, -min, -min, min, min, min);
	}
	this._pBoundsInvalid = false;
};

away.entities.SegmentSet.prototype.pCreateEntityPartitionNode = function() {
	return new away.core.partition.RenderableNode(this);
};

away.entities.SegmentSet.prototype.get_numTriangles = function() {
	return this._numIndices / 3;
};

away.entities.SegmentSet.prototype.get_sourceEntity = function() {
	return this;
};

away.entities.SegmentSet.prototype.get_castsShadows = function() {
	return false;
};

away.entities.SegmentSet.prototype.get_material = function() {
	return this._material;
};

away.entities.SegmentSet.prototype.get_animator = function() {
	return this._animator;
};

away.entities.SegmentSet.prototype.set_animator = function(value) {
	this._animator = value;
};

away.entities.SegmentSet.prototype.set_material = function(value) {
	if (value == this._material) {
		return;
	}
	if (this._material) {
		this._material.iRemoveOwner(this);
	}
	this._material = value;
	if (this._material) {
		this._material.iAddOwner(this);
	}
};

away.entities.SegmentSet.prototype.get_uvTransform = function() {
	return null;
};

away.entities.SegmentSet.prototype.get_vertexData = function() {
	return null;
};

away.entities.SegmentSet.prototype.get_indexData = function() {
	return null;
};

away.entities.SegmentSet.prototype.get_UVData = function() {
	return null;
};

away.entities.SegmentSet.prototype.get_numVertices = function() {
	return null;
};

away.entities.SegmentSet.prototype.get_vertexStride = function() {
	return 11;
};

away.entities.SegmentSet.prototype.get_vertexNormalData = function() {
	return null;
};

away.entities.SegmentSet.prototype.get_vertexTangentData = function() {
	return null;
};

away.entities.SegmentSet.prototype.get_vertexOffset = function() {
	return 0;
};

away.entities.SegmentSet.prototype.get_vertexNormalOffset = function() {
	return 0;
};

away.entities.SegmentSet.prototype.get_vertexTangentOffset = function() {
	return 0;
};

away.entities.SegmentSet.prototype.get_assetType = function() {
	return away.library.assets.AssetType.SEGMENT_SET;
};

away.entities.SegmentSet.prototype.getRenderSceneTransform = function(camera) {
	return this._pSceneTransform;
};

$inherit(away.entities.SegmentSet, away.entities.Entity);

away.entities.SegmentSet.className = "away.entities.SegmentSet";

away.entities.SegmentSet.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.core.display3D.Context3DVertexBufferFormat');
	p.push('away.core.partition.RenderableNode');
	p.push('away.bounds.BoundingSphere');
	p.push('away.entities.SubSet');
	p.push('away.entities.SegRef');
	p.push('away.materials.SegmentMaterial');
	p.push('away.library.assets.AssetType');
	return p;
};

away.entities.SegmentSet.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.entities.SegmentSet.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 1:
			p = away.entities.Entity.injectionPoints(t);
			break;
		case 2:
			p = away.entities.Entity.injectionPoints(t);
			break;
		case 3:
			p = away.entities.Entity.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

