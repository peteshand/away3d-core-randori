/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 21 16:02:36 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.entities == "undefined")
	away.entities = {};

away.entities.Sprite3D = function(material, width, height) {
	this._spriteMatrix = null;
	this._height = 0;
	this._pickingSubMesh = null;
	this._pickingTransform = null;
	this._animator = null;
	this._shadowCaster = false;
	this._geometry = null;
	this._camera = null;
	this._width = 0;
	this._material = null;
	away.entities.Entity.call(this);
	this.set_material(material);
	this._width = width;
	this._height = height;
	this._spriteMatrix = new away.geom.Matrix3D();
	if (!away.entities.Sprite3D._geometry) {
		away.entities.Sprite3D._geometry = new away.base.SubGeometry();
		away.entities.Sprite3D._geometry.updateVertexData(-.5, .5, .0, .5, .5, .0, .5, -.5, .0, -.5, -.5, .0);
		away.entities.Sprite3D._geometry.updateUVData(.0, .0, 1.0, .0, 1.0, 1.0, .0, 1.0);
		away.entities.Sprite3D._geometry.updateIndexData(0, 1, 2, 0, 2, 3);
		away.entities.Sprite3D._geometry.updateVertexTangentData(1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0);
		away.entities.Sprite3D._geometry.updateVertexNormalData(.0, .0, -1.0, .0, .0, -1.0, .0, .0, -1.0, .0, .0, -1.0);
	}
};

away.entities.Sprite3D._geometry;

away.entities.Sprite3D.prototype.set_pickingCollider = function(value) {
	away.entities.Entity.prototype.setPickingCollider.call(this,value);
	if (value) {
		this._pickingSubMesh = new away.base.SubMesh(away.entities.Sprite3D._geometry, null);
		this._pickingTransform = new away.geom.Matrix3D();
	}
};

away.entities.Sprite3D.prototype.get_width = function() {
	return this._width;
};

away.entities.Sprite3D.prototype.set_width = function(value) {
	if (this._width == value)
		return;
	this._width = value;
	this.iInvalidateTransform();
};

away.entities.Sprite3D.prototype.get_height = function() {
	return this._height;
};

away.entities.Sprite3D.prototype.set_height = function(value) {
	if (this._height == value)
		return;
	this._height = value;
	this.iInvalidateTransform();
};

away.entities.Sprite3D.prototype.activateVertexBuffer = function(index, stage3DProxy) {
	away.entities.Sprite3D._geometry.activateVertexBuffer(index, stage3DProxy);
};

away.entities.Sprite3D.prototype.activateUVBuffer = function(index, stage3DProxy) {
	away.entities.Sprite3D._geometry.activateUVBuffer(index, stage3DProxy);
};

away.entities.Sprite3D.prototype.activateSecondaryUVBuffer = function(index, stage3DProxy) {
	away.entities.Sprite3D._geometry.activateSecondaryUVBuffer(index, stage3DProxy);
};

away.entities.Sprite3D.prototype.activateVertexNormalBuffer = function(index, stage3DProxy) {
	away.entities.Sprite3D._geometry.activateVertexNormalBuffer(index, stage3DProxy);
};

away.entities.Sprite3D.prototype.activateVertexTangentBuffer = function(index, stage3DProxy) {
	away.entities.Sprite3D._geometry.activateVertexTangentBuffer(index, stage3DProxy);
};

away.entities.Sprite3D.prototype.getIndexBuffer = function(stage3DProxy) {
	return away.entities.Sprite3D._geometry.getIndexBuffer(stage3DProxy);
};

away.entities.Sprite3D.prototype.get_numTriangles = function() {
	return 2;
};

away.entities.Sprite3D.prototype.get_sourceEntity = function() {
	return this;
};

away.entities.Sprite3D.prototype.get_material = function() {
	return this._material;
};

away.entities.Sprite3D.prototype.set_material = function(value) {
	if (value == this._material)
		return;
	if (this._material)
		this._material.iRemoveOwner(this);
	this._material = value;
	if (this._material)
		this._material.iAddOwner(this);
};

away.entities.Sprite3D.prototype.get_animator = function() {
	return this._animator;
};

away.entities.Sprite3D.prototype.get_castsShadows = function() {
	return this._shadowCaster;
};

away.entities.Sprite3D.prototype.pGetDefaultBoundingVolume = function() {
	return new away.bounds.AxisAlignedBoundingBox();
};

away.entities.Sprite3D.prototype.pUpdateBounds = function() {
	this._pBounds.fromExtremes(-.5 * this._pScaleX, -.5 * this._pScaleY, -.5 * this._pScaleZ, .5 * this._pScaleX, .5 * this._pScaleY, .5 * this._pScaleZ);
	this._pBoundsInvalid = false;
};

away.entities.Sprite3D.prototype.pCreateEntityPartitionNode = function() {
	return new away.partition.RenderableNode(this);
};

away.entities.Sprite3D.prototype.pUpdateTransform = function() {
	away.entities.Entity.prototype.pUpdateTransform.call(this);
	this._pTransform.prependScale(this._width, this._height, Math.max(this._width, this._height));
};

away.entities.Sprite3D.prototype.get_uvTransform = function() {
	return null;
};

away.entities.Sprite3D.prototype.get_vertexData = function() {
	return away.entities.Sprite3D._geometry.get_vertexData();
};

away.entities.Sprite3D.prototype.get_indexData = function() {
	return away.entities.Sprite3D._geometry.get_indexData();
};

away.entities.Sprite3D.prototype.get_UVData = function() {
	return away.entities.Sprite3D._geometry.get_UVData();
};

away.entities.Sprite3D.prototype.get_numVertices = function() {
	return away.entities.Sprite3D._geometry.get_numVertices();
};

away.entities.Sprite3D.prototype.get_vertexStride = function() {
	return away.entities.Sprite3D._geometry.get_vertexStride();
};

away.entities.Sprite3D.prototype.get_vertexNormalData = function() {
	return away.entities.Sprite3D._geometry.get_vertexNormalData();
};

away.entities.Sprite3D.prototype.get_vertexTangentData = function() {
	return away.entities.Sprite3D._geometry.get_vertexTangentData();
};

away.entities.Sprite3D.prototype.get_vertexOffset = function() {
	return away.entities.Sprite3D._geometry.get_vertexOffset();
};

away.entities.Sprite3D.prototype.get_vertexNormalOffset = function() {
	return away.entities.Sprite3D._geometry.get_vertexNormalOffset();
};

away.entities.Sprite3D.prototype.get_vertexTangentOffset = function() {
	return away.entities.Sprite3D._geometry.get_vertexTangentOffset();
};

away.entities.Sprite3D.prototype.iCollidesBefore = function(shortestCollisionDistance, findClosest) {
	findClosest = findClosest;
	var viewTransform = this._camera.get_inverseSceneTransform().clone();
	viewTransform.transpose();
	var rawViewTransform = away.math.Matrix3DUtils.RAW_DATA_CONTAINER;
	viewTransform.copyRawDataTo(rawViewTransform, 0, false);
	rawViewTransform[3] = 0;
	rawViewTransform[7] = 0;
	rawViewTransform[11] = 0;
	rawViewTransform[12] = 0;
	rawViewTransform[13] = 0;
	rawViewTransform[14] = 0;
	this._pickingTransform.copyRawDataFrom(rawViewTransform, 0, false);
	this._pickingTransform.prependScale(this._width, this._height, Math.max(this._width, this._height));
	this._pickingTransform.appendTranslation(this.get_scenePosition().x, this.get_scenePosition().y, this.get_scenePosition().z);
	this._pickingTransform.invert();
	var localRayPosition = this._pickingTransform.transformVector(this._iPickingCollisionVO.rayPosition);
	var localRayDirection = this._pickingTransform.deltaTransformVector(this._iPickingCollisionVO.rayDirection);
	this._iPickingCollider.setLocalRay(localRayPosition, localRayDirection);
	this._iPickingCollisionVO.renderable = null;
	if (this._iPickingCollider.testSubMeshCollision(this._pickingSubMesh, this._iPickingCollisionVO, shortestCollisionDistance))
		this._iPickingCollisionVO.renderable = this._pickingSubMesh;
	return this._iPickingCollisionVO.renderable != null;
};

away.entities.Sprite3D.prototype.getRenderSceneTransform = function(camera) {
	var comps = camera.get_sceneTransform().decompose();
	var scale = comps[2];
	comps[0] = this.get_scenePosition();
	scale.x = this._width * this._pScaleX;
	scale.y = this._height * this._pScaleY;
	this._spriteMatrix.recompose(comps);
	return this._spriteMatrix;
};

$inherit(away.entities.Sprite3D, away.entities.Entity);

away.entities.Sprite3D.className = "away.entities.Sprite3D";

away.entities.Sprite3D.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.base.SubGeometry');
	p.push('away.pick.PickingCollisionVO');
	p.push('away.bounds.AxisAlignedBoundingBox');
	p.push('away.geom.Vector3D');
	p.push('away.geom.Matrix3D');
	p.push('away.math.Matrix3DUtils');
	p.push('away.base.SubMesh');
	p.push('away.entities.Sprite3D');
	p.push('away.partition.RenderableNode');
	return p;
};

away.entities.Sprite3D.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.entities.Sprite3D.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'material', t:'away.materials.MaterialBase'});
			p.push({n:'width', t:'Number'});
			p.push({n:'height', t:'Number'});
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

