/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:36 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.base == "undefined")
	away.core.base = {};

away.core.base.SkinnedSubGeometry = function(jointsPerVertex) {
	this._jointWeightsBuffer = away.utils.VectorInit.AnyClass(8);
	this._jointIndexBuffer = away.utils.VectorInit.AnyClass(8);
	this._jointWeightContext = away.utils.VectorInit.AnyClass(8);
	this._bufferFormat = null;
	this._animatedData = null;
	this._jointWeightsInvalid = away.utils.VectorInit.Bool(8, false);
	this._jointIndicesInvalid = away.utils.VectorInit.Bool(8, false);
	this._condensedIndexLookUp = null;
	this._jointWeightsData = null;
	this._jointIndexData = null;
	this._jointIndexContext = away.utils.VectorInit.AnyClass(8);
	this._condensedJointIndexData = null;
	this._numCondensedJoints = 0;
	this._jointsPerVertex = 0;
	away.core.base.CompactSubGeometry.call(this);
	this._jointsPerVertex = jointsPerVertex;
	this._bufferFormat = "float" + this._jointsPerVertex;
};

away.core.base.SkinnedSubGeometry.prototype.get_condensedIndexLookUp = function() {
	return this._condensedIndexLookUp;
};

away.core.base.SkinnedSubGeometry.prototype.get_numCondensedJoints = function() {
	return this._numCondensedJoints;
};

away.core.base.SkinnedSubGeometry.prototype.get_animatedData = function() {
	return this._animatedData || this._vertexData.concat();
};

away.core.base.SkinnedSubGeometry.prototype.updateAnimatedData = function(value) {
	this._animatedData = value;
	this.pInvalidateBuffers(this._pVertexDataInvalid);
};

away.core.base.SkinnedSubGeometry.prototype.activateJointWeightsBuffer = function(index, stage3DProxy) {
	var contextIndex = stage3DProxy._iStage3DIndex;
	var context = stage3DProxy._iContext3D;
	if (this._jointWeightContext[contextIndex] != context || !this._jointWeightsBuffer[contextIndex]) {
		this._jointWeightsBuffer[contextIndex] = context.createVertexBuffer(this._pNumVertices, this._jointsPerVertex);
		this._jointWeightContext[contextIndex] = context;
		this._jointWeightsInvalid[contextIndex] = true;
	}
	if (this._jointWeightsInvalid[contextIndex]) {
		this._jointWeightsBuffer[contextIndex].uploadFromArray(this._jointWeightsData, 0, this._jointWeightsData.length / this._jointsPerVertex);
		this._jointWeightsInvalid[contextIndex] = false;
	}
	context.setVertexBufferAt(index, this._jointWeightsBuffer[contextIndex], 0, this._bufferFormat);
};

away.core.base.SkinnedSubGeometry.prototype.activateJointIndexBuffer = function(index, stage3DProxy) {
	var contextIndex = stage3DProxy._iStage3DIndex;
	var context = stage3DProxy._iContext3D;
	if (this._jointIndexContext[contextIndex] != context || !this._jointIndexBuffer[contextIndex]) {
		this._jointIndexBuffer[contextIndex] = context.createVertexBuffer(this._pNumVertices, this._jointsPerVertex);
		this._jointIndexContext[contextIndex] = context;
		this._jointIndicesInvalid[contextIndex] = true;
	}
	if (this._jointIndicesInvalid[contextIndex]) {
		this._jointIndexBuffer[contextIndex].uploadFromArray(this._numCondensedJoints > 0 ? this._condensedJointIndexData : this._jointIndexData, 0, this._jointIndexData.length / this._jointsPerVertex);
		this._jointIndicesInvalid[contextIndex] = false;
	}
	context.setVertexBufferAt(index, this._jointIndexBuffer[contextIndex], 0, this._bufferFormat);
};

away.core.base.SkinnedSubGeometry.prototype.pUploadData = function(contextIndex) {
	if (this._animatedData) {
		this._pActiveBuffer.uploadFromArray(this._animatedData, 0, this._pNumVertices);
		this._pActiveDataInvalid = false;
		this._pVertexDataInvalid[contextIndex] = this._pActiveDataInvalid;
	} else {
		away.core.base.CompactSubGeometry.prototype.pUploadData.call(this,contextIndex);
	}
};

away.core.base.SkinnedSubGeometry.prototype.clone = function() {
	var clone = new away.core.base.SkinnedSubGeometry(this._jointsPerVertex);
	clone.updateData(this._vertexData.concat());
	clone.updateIndexData(this._indices.concat());
	clone.iUpdateJointIndexData(this._jointIndexData.concat());
	clone.iUpdateJointWeightsData(this._jointWeightsData.concat());
	clone._autoDeriveVertexNormals = this._autoDeriveVertexNormals;
	clone._autoDeriveVertexTangents = this._autoDeriveVertexTangents;
	clone._numCondensedJoints = this._numCondensedJoints;
	clone._condensedIndexLookUp = this._condensedIndexLookUp;
	clone._condensedJointIndexData = this._condensedJointIndexData;
	return clone;
};

away.core.base.SkinnedSubGeometry.prototype.dispose = function() {
	away.core.base.CompactSubGeometry.prototype.dispose.call(this);
	this.pDisposeVertexBuffers(this._jointWeightsBuffer);
	this.pDisposeVertexBuffers(this._jointIndexBuffer);
};

away.core.base.SkinnedSubGeometry.prototype.iCondenseIndexData = function() {
	var len = this._jointIndexData.length;
	var oldIndex;
	var newIndex = 0;
	var dic = {};
	this._condensedJointIndexData = away.utils.VectorInit.Num(len, 0);
	this._condensedIndexLookUp = away.utils.VectorInit.Num(0, 0);
	for (var i = 0; i < len; ++i) {
		oldIndex = this._jointIndexData[i];
		if (dic[oldIndex] == undefined) {
			dic[oldIndex] = newIndex;
			this._condensedIndexLookUp[newIndex++] = oldIndex;
			this._condensedIndexLookUp[newIndex++] = oldIndex + 1;
			this._condensedIndexLookUp[newIndex++] = oldIndex + 2;
		}
		this._condensedJointIndexData[i] = dic[oldIndex];
	}
	this._numCondensedJoints = newIndex / 3;
	this.pInvalidateBuffers(this._jointIndicesInvalid);
};

away.core.base.SkinnedSubGeometry.prototype.get_iJointWeightsData = function() {
	return this._jointWeightsData;
};

away.core.base.SkinnedSubGeometry.prototype.iUpdateJointWeightsData = function(value) {
	this._numCondensedJoints = 0;
	this._condensedIndexLookUp = null;
	this._condensedJointIndexData = null;
	this._jointWeightsData = value;
	this.pInvalidateBuffers(this._jointWeightsInvalid);
};

away.core.base.SkinnedSubGeometry.prototype.get_iJointIndexData = function() {
	return this._jointIndexData;
};

away.core.base.SkinnedSubGeometry.prototype.iUpdateJointIndexData = function(value) {
	this._jointIndexData = value;
	this.pInvalidateBuffers(this._jointIndicesInvalid);
};

$inherit(away.core.base.SkinnedSubGeometry, away.core.base.CompactSubGeometry);

away.core.base.SkinnedSubGeometry.className = "away.core.base.SkinnedSubGeometry";

away.core.base.SkinnedSubGeometry.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.utils.VectorInit');
	return p;
};

away.core.base.SkinnedSubGeometry.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('away.utils.VectorInit');
	return p;
};

away.core.base.SkinnedSubGeometry.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'jointsPerVertex', t:'Number'});
			break;
		case 1:
			p = away.core.base.CompactSubGeometry.injectionPoints(t);
			break;
		case 2:
			p = away.core.base.CompactSubGeometry.injectionPoints(t);
			break;
		case 3:
			p = away.core.base.CompactSubGeometry.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

