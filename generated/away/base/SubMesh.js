/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 04 21:18:41 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.base == "undefined")
	away.base = {};

away.base.SubMesh = function(subGeometry, parentMesh, material) {
	this._scaleU = 1;
	this._scaleV = 1;
	this._uvTransform = null;
	this._parentMesh = null;
	this._subGeometry = null;
	this._iIndex = 0;
	this._offsetV = 0;
	this._offsetU = 0;
	this._uvTransformDirty = null;
	this._uvRotation = 0;
	this._iMaterial = null;
	this._parentMesh = parentMesh;
	this._subGeometry = subGeometry;
	this.set_material(material);
};

away.base.SubMesh.prototype.get_shaderPickingDetails = function() {
	return this.get_sourceEntity().get_shaderPickingDetails();
};

away.base.SubMesh.prototype.get_offsetU = function() {
	return this._offsetU;
};

away.base.SubMesh.prototype.set_offsetU = function(value) {
	if (value == this._offsetU) {
		return;
	}
	this._offsetU = value;
	this._uvTransformDirty = true;
};

away.base.SubMesh.prototype.get_offsetV = function() {
	return this._offsetV;
};

away.base.SubMesh.prototype.set_offsetV = function(value) {
	if (value == this._offsetV) {
		return;
	}
	this._offsetV = value;
	this._uvTransformDirty = true;
};

away.base.SubMesh.prototype.get_scaleU = function() {
	return this._scaleU;
};

away.base.SubMesh.prototype.set_scaleU = function(value) {
	if (value == this._scaleU) {
		return;
	}
	this._scaleU = value;
	this._uvTransformDirty = true;
};

away.base.SubMesh.prototype.get_scaleV = function() {
	return this._scaleV;
};

away.base.SubMesh.prototype.set_scaleV = function(value) {
	if (value == this._scaleV) {
		return;
	}
	this._scaleV = value;
	this._uvTransformDirty = true;
};

away.base.SubMesh.prototype.get_uvRotation = function() {
	return this._uvRotation;
};

away.base.SubMesh.prototype.set_uvRotation = function(value) {
	if (value == this._uvRotation) {
		return;
	}
	this._uvRotation = value;
	this._uvTransformDirty = true;
};

away.base.SubMesh.prototype.get_sourceEntity = function() {
	return this._parentMesh;
};

away.base.SubMesh.prototype.get_subGeometry = function() {
	return this._subGeometry;
};

away.base.SubMesh.prototype.set_subGeometry = function(value) {
	this._subGeometry = value;
};

away.base.SubMesh.prototype.get_material = function() {
	return this._iMaterial || this._parentMesh.get_material();
};

away.base.SubMesh.prototype.set_material = function(value) {
	if (this._iMaterial) {
		this._iMaterial.iRemoveOwner(this);
	}
	this._iMaterial = value;
	if (this._iMaterial) {
		this._iMaterial.iAddOwner(this);
	}
};

away.base.SubMesh.prototype.get_sceneTransform = function() {
	return this._parentMesh.get_sceneTransform();
};

away.base.SubMesh.prototype.get_inverseSceneTransform = function() {
	return this._parentMesh.get_inverseSceneTransform();
};

away.base.SubMesh.prototype.activateVertexBuffer = function(index, stage3DProxy) {
	this._subGeometry.activateVertexBuffer(index, stage3DProxy);
};

away.base.SubMesh.prototype.activateVertexNormalBuffer = function(index, stage3DProxy) {
	this._subGeometry.activateVertexNormalBuffer(index, stage3DProxy);
};

away.base.SubMesh.prototype.activateVertexTangentBuffer = function(index, stage3DProxy) {
	this._subGeometry.activateVertexTangentBuffer(index, stage3DProxy);
};

away.base.SubMesh.prototype.activateUVBuffer = function(index, stage3DProxy) {
	this._subGeometry.activateUVBuffer(index, stage3DProxy);
};

away.base.SubMesh.prototype.activateSecondaryUVBuffer = function(index, stage3DProxy) {
	this._subGeometry.activateSecondaryUVBuffer(index, stage3DProxy);
};

away.base.SubMesh.prototype.getIndexBuffer = function(stage3DProxy) {
	return this._subGeometry.getIndexBuffer(stage3DProxy);
};

away.base.SubMesh.prototype.get_numTriangles = function() {
	return this._subGeometry.get_numTriangles();
};

away.base.SubMesh.prototype.get_animator = function() {
	return this._parentMesh.get_animator();
};

away.base.SubMesh.prototype.get_mouseEnabled = function() {
	return this._parentMesh.get_mouseEnabled() || this._parentMesh._iAncestorsAllowMouseEnabled;
};

away.base.SubMesh.prototype.get_castsShadows = function() {
	return this._parentMesh.get_castsShadows();
};

away.base.SubMesh.prototype.get_iParentMesh = function() {
	return this._parentMesh;
};

away.base.SubMesh.prototype.set_iParentMesh = function(value) {
	this._parentMesh = value;
};

away.base.SubMesh.prototype.get_uvTransform = function() {
	if (this._uvTransformDirty) {
		this.updateUVTransform();
	}
	return this._uvTransform;
};

away.base.SubMesh.prototype.updateUVTransform = function() {
	if (this._uvTransform == null) {
		this._uvTransform = new away.geom.Matrix(1, 0, 0, 1, 0, 0);
	}
	this._uvTransform.identity();
	if (this._uvRotation != 0) {
		this._uvTransform.rotate(this._uvRotation);
	}
	if (this._scaleU != 1 || this._scaleV != 1) {
		this._uvTransform.scale(this._scaleU, this._scaleV);
	}
	this._uvTransform.translate(this._offsetU, this._offsetV);
	this._uvTransformDirty = false;
};

away.base.SubMesh.prototype.dispose = function() {
	this.set_material(null);
};

away.base.SubMesh.prototype.get_vertexData = function() {
	return this._subGeometry.get_vertexData();
};

away.base.SubMesh.prototype.get_indexData = function() {
	return this._subGeometry.get_indexData();
};

away.base.SubMesh.prototype.get_UVData = function() {
	return this._subGeometry.get_UVData();
};

away.base.SubMesh.prototype.get_bounds = function() {
	return this._parentMesh.getBounds();
};

away.base.SubMesh.prototype.get_visible = function() {
	return this._parentMesh.get_visible();
};

away.base.SubMesh.prototype.get_numVertices = function() {
	return this._subGeometry.get_numVertices();
};

away.base.SubMesh.prototype.get_vertexStride = function() {
	return this._subGeometry.get_vertexStride();
};

away.base.SubMesh.prototype.get_UVStride = function() {
	return this._subGeometry.get_UVStride();
};

away.base.SubMesh.prototype.get_vertexNormalData = function() {
	return this._subGeometry.get_vertexNormalData();
};

away.base.SubMesh.prototype.get_vertexTangentData = function() {
	return this._subGeometry.get_vertexTangentData();
};

away.base.SubMesh.prototype.get_UVOffset = function() {
	return this._subGeometry.get_UVOffset();
};

away.base.SubMesh.prototype.get_vertexOffset = function() {
	return this._subGeometry.get_vertexOffset();
};

away.base.SubMesh.prototype.get_vertexNormalOffset = function() {
	return this._subGeometry.get_vertexNormalOffset();
};

away.base.SubMesh.prototype.get_vertexTangentOffset = function() {
	return this._subGeometry.get_vertexTangentOffset();
};

away.base.SubMesh.prototype.getRenderSceneTransform = function(camera) {
	return this._parentMesh.get_sceneTransform();
};

away.base.SubMesh.className = "away.base.SubMesh";

away.base.SubMesh.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.Matrix');
	return p;
};

away.base.SubMesh.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.base.SubMesh.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'subGeometry', t:'away.base.ISubGeometry'});
			p.push({n:'parentMesh', t:'away.entities.Mesh'});
			p.push({n:'material', t:'away.materials.MaterialBase'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

