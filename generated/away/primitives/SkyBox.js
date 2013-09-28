/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 28 11:54:52 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.primitives == "undefined")
	away.primitives = {};

away.primitives.SkyBox = function(cubeMap) {
	this._uvTransform = new away.geom.Matrix(1, 0, 0, 1, 0, 0);
	this._animator = null;
	this._geometry = null;
	this._material = null;
	away.entities.Entity.call(this);
	this._material = new away.materials.SkyBoxMaterial(cubeMap);
	this._material.iAddOwner(this);
	this._geometry = new away.base.SubGeometry();
	this.buildGeometry(this._geometry);
};

away.primitives.SkyBox.prototype.get_animator = function() {
	return this._animator;
};

away.primitives.SkyBox.prototype.pGetDefaultBoundingVolume = function() {
	return new away.bounds.NullBounds(true);
};

away.primitives.SkyBox.prototype.activateVertexBuffer = function(index, stage3DProxy) {
	this._geometry.activateVertexBuffer(index, stage3DProxy);
};

away.primitives.SkyBox.prototype.activateUVBuffer = function(index, stage3DProxy) {
};

away.primitives.SkyBox.prototype.activateVertexNormalBuffer = function(index, stage3DProxy) {
};

away.primitives.SkyBox.prototype.activateVertexTangentBuffer = function(index, stage3DProxy) {
};

away.primitives.SkyBox.prototype.activateSecondaryUVBuffer = function(index, stage3DProxy) {
};

away.primitives.SkyBox.prototype.getIndexBuffer = function(stage3DProxy) {
	return this._geometry.getIndexBuffer(stage3DProxy);
};

away.primitives.SkyBox.prototype.get_numTriangles = function() {
	return this._geometry.get_numTriangles();
};

away.primitives.SkyBox.prototype.get_sourceEntity = function() {
	return null;
};

away.primitives.SkyBox.prototype.get_material = function() {
	return this._material;
};

away.primitives.SkyBox.prototype.set_material = function(value) {
	throw new away.errors.AbstractMethodError("Unsupported method!", 0);
};

away.primitives.SkyBox.prototype.get_assetType = function() {
	return away.library.assets.AssetType.SKYBOX;
};

away.primitives.SkyBox.prototype.pInvalidateBounds = function() {
};

away.primitives.SkyBox.prototype.pCreateEntityPartitionNode = function() {
	var node = new away.partition.SkyBoxNode(this);
	return node;
};

away.primitives.SkyBox.prototype.pUpdateBounds = function() {
	this._pBoundsInvalid = false;
};

away.primitives.SkyBox.prototype.buildGeometry = function(target) {
	var vertices = [-1, 1, -1, 1, 1, -1, 1, 1, 1, -1, 1, 1, -1, -1, -1, 1, -1, -1, 1, -1, 1, -1, -1, 1];
	var indices = [0, 1, 2, 2, 3, 0, 6, 5, 4, 4, 7, 6, 2, 6, 7, 7, 3, 2, 4, 5, 1, 1, 0, 4, 4, 0, 3, 3, 7, 4, 2, 1, 5, 5, 6, 2];
	target.updateVertexData(vertices);
	target.updateIndexData(indices);
};

away.primitives.SkyBox.prototype.get_castsShadows = function() {
	return false;
};

away.primitives.SkyBox.prototype.get_uvTransform = function() {
	return this._uvTransform;
};

away.primitives.SkyBox.prototype.get_vertexData = function() {
	return this._geometry.get_vertexData();
};

away.primitives.SkyBox.prototype.get_indexData = function() {
	return this._geometry.get_indexData();
};

away.primitives.SkyBox.prototype.get_UVData = function() {
	return this._geometry.get_UVData();
};

away.primitives.SkyBox.prototype.get_numVertices = function() {
	return this._geometry.get_numVertices();
};

away.primitives.SkyBox.prototype.get_vertexStride = function() {
	return this._geometry.get_vertexStride();
};

away.primitives.SkyBox.prototype.get_vertexNormalData = function() {
	return this._geometry.get_vertexNormalData();
};

away.primitives.SkyBox.prototype.get_vertexTangentData = function() {
	return this._geometry.get_vertexTangentData();
};

away.primitives.SkyBox.prototype.get_vertexOffset = function() {
	return this._geometry.get_vertexOffset();
};

away.primitives.SkyBox.prototype.get_vertexNormalOffset = function() {
	return this._geometry.get_vertexNormalOffset();
};

away.primitives.SkyBox.prototype.get_vertexTangentOffset = function() {
	return this._geometry.get_vertexTangentOffset();
};

away.primitives.SkyBox.prototype.getRenderSceneTransform = function(camera) {
	return this._pSceneTransform;
};

$inherit(away.primitives.SkyBox, away.entities.Entity);

away.primitives.SkyBox.className = "away.primitives.SkyBox";

away.primitives.SkyBox.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.base.SubGeometry');
	p.push('away.materials.SkyBoxMaterial');
	p.push('away.bounds.NullBounds');
	p.push('away.errors.AbstractMethodError');
	p.push('away.partition.SkyBoxNode');
	p.push('away.library.assets.AssetType');
	return p;
};

away.primitives.SkyBox.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.Matrix');
	return p;
};

away.primitives.SkyBox.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'cubeMap', t:'away.textures.CubeTextureBase'});
			break;
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

