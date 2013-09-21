/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 21 16:02:39 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.traverse == "undefined")
	away.traverse = {};

away.traverse.EntityCollector = function() {
	this._pNumLights = 0;
	this._cullPlanes = null;
	this._numCullPlanes = 0;
	this._pNumEntities = 0;
	this._pRenderableListItemPool = null;
	this._pBlendedRenderableHead = null;
	this._pNumTriangles = 0;
	this._numPointLights = 0;
	this._pEntityListItemPool = null;
	this._customCullPlanes = null;
	this._pCameraForward = null;
	this._numDirectionalLights = 0;
	this._pCamera = null;
	this._pLights = null;
	this._pointLights = null;
	this._pSkyBox = null;
	this._pOpaqueRenderableHead = null;
	this._numLightProbes = 0;
	this._entityHead = null;
	this._pNumMouseEnableds = 0;
	this._directionalLights = null;
	this._lightProbes = null;
	away.traverse.PartitionTraverser.call(this);
	this.init();
};

away.traverse.EntityCollector.prototype.init = function() {
	this._pLights = [];
	this._directionalLights = [];
	this._pointLights = [];
	this._lightProbes = [];
	this._pRenderableListItemPool = new away.data.RenderableListItemPool();
	this._pEntityListItemPool = new away.data.EntityListItemPool();
};

away.traverse.EntityCollector.prototype.get_camera = function() {
	return this._pCamera;
};

away.traverse.EntityCollector.prototype.set_camera = function(value) {
	this._pCamera = value;
	this._iEntryPoint = this._pCamera.get_scenePosition();
	this._pCameraForward = this._pCamera.get_forwardVector();
	this._cullPlanes = this._pCamera.get_frustumPlanes();
};

away.traverse.EntityCollector.prototype.get_cullPlanes = function() {
	return this._customCullPlanes;
};

away.traverse.EntityCollector.prototype.set_cullPlanes = function(value) {
	this._customCullPlanes = value;
};

away.traverse.EntityCollector.prototype.get_numMouseEnableds = function() {
	return this._pNumMouseEnableds;
};

away.traverse.EntityCollector.prototype.get_skyBox = function() {
	return this._pSkyBox;
};

away.traverse.EntityCollector.prototype.get_opaqueRenderableHead = function() {
	return this._pOpaqueRenderableHead;
};

away.traverse.EntityCollector.prototype.set_opaqueRenderableHead = function(value) {
	this._pOpaqueRenderableHead = value;
};

away.traverse.EntityCollector.prototype.get_blendedRenderableHead = function() {
	return this._pBlendedRenderableHead;
};

away.traverse.EntityCollector.prototype.set_blendedRenderableHead = function(value) {
	this._pBlendedRenderableHead = value;
};

away.traverse.EntityCollector.prototype.get_entityHead = function() {
	return this._entityHead;
};

away.traverse.EntityCollector.prototype.get_lights = function() {
	return this._pLights;
};

away.traverse.EntityCollector.prototype.get_directionalLights = function() {
	return this._directionalLights;
};

away.traverse.EntityCollector.prototype.get_pointLights = function() {
	return this._pointLights;
};

away.traverse.EntityCollector.prototype.get_lightProbes = function() {
	return this._lightProbes;
};

away.traverse.EntityCollector.prototype.clear = function() {
	this._cullPlanes = this._customCullPlanes ? this._customCullPlanes : this._pCamera ? this._pCamera.get_frustumPlanes() : null;
	this._numCullPlanes = this._cullPlanes ? this._cullPlanes.length : 0;
	this._pNumTriangles = 0;
	this._pNumMouseEnableds = 0;
	this._pBlendedRenderableHead = null;
	this._pOpaqueRenderableHead = null;
	this._entityHead = null;
	this._pRenderableListItemPool.freeAll();
	this._pEntityListItemPool.freeAll();
	this._pSkyBox = null;
	if (this._pNumLights > 0) {
		this._pLights.length = 0;
		this._pNumLights = 0;
	}
	if (this._numDirectionalLights > 0) {
		this._directionalLights.length = 0;
		this._numDirectionalLights = 0;
	}
	if (this._numPointLights > 0) {
		this._pointLights.length = 0;
		this._numPointLights = 0;
	}
	if (this._numLightProbes > 0) {
		this._lightProbes.length = 0;
		this._numLightProbes = 0;
	}
};

away.traverse.EntityCollector.prototype.enterNode = function(node) {
	var enter = away.traverse.PartitionTraverser._iCollectionMark != node._iCollectionMark && node.isInFrustum(this._cullPlanes, this._numCullPlanes);
	node._iCollectionMark = away.traverse.PartitionTraverser._iCollectionMark;
	return enter;
};

away.traverse.EntityCollector.prototype.applySkyBox = function(renderable) {
	this._pSkyBox = renderable;
};

away.traverse.EntityCollector.prototype.applyRenderable = function(renderable) {
	var material;
	var entity = renderable.get_sourceEntity();
	if (renderable.get_mouseEnabled()) {
		++this._pNumMouseEnableds;
	}
	this._pNumTriangles += renderable.get_numTriangles();
	material = renderable.get_material();
	if (material) {
		var item = this._pRenderableListItemPool.getItem();
		item.renderable = renderable;
		item.materialId = material._iUniqueId;
		item.renderOrderId = material._iRenderOrderId;
		item.cascaded = false;
		var dx = this._iEntryPoint.x - entity.get_x();
		var dy = this._iEntryPoint.y - entity.get_y();
		var dz = this._iEntryPoint.z - entity.get_z();
		item.zIndex = dx * this._pCameraForward.x + dy * this._pCameraForward.y + dz * this._pCameraForward.z + entity.get_zOffset();
		item.renderSceneTransform = renderable.getRenderSceneTransform(this._pCamera);
		if (material.get_requiresBlending()) {
			item.next = this._pBlendedRenderableHead;
			this._pBlendedRenderableHead = item;
		} else {
			item.next = this._pOpaqueRenderableHead;
			this._pOpaqueRenderableHead = item;
		}
	}
};

away.traverse.EntityCollector.prototype.applyEntity = function(entity) {
	++this._pNumEntities;
	var item = this._pEntityListItemPool.getItem();
	item.entity = entity;
	item.next = this._entityHead;
	this._entityHead = item;
};

away.traverse.EntityCollector.prototype.applyUnknownLight = function(light) {
	this._pLights[this._pNumLights++] = light;
};

away.traverse.EntityCollector.prototype.applyDirectionalLight = function(light) {
	this._pLights[this._pNumLights++] = light;
	this._directionalLights[this._numDirectionalLights++] = light;
};

away.traverse.EntityCollector.prototype.applyPointLight = function(light) {
	this._pLights[this._pNumLights++] = light;
	this._pointLights[this._numPointLights++] = light;
};

away.traverse.EntityCollector.prototype.applyLightProbe = function(light) {
	this._pLights[this._pNumLights++] = light;
	this._lightProbes[this._numLightProbes++] = light;
};

away.traverse.EntityCollector.prototype.cleanUp = function() {
};

$inherit(away.traverse.EntityCollector, away.traverse.PartitionTraverser);

away.traverse.EntityCollector.className = "away.traverse.EntityCollector";

away.traverse.EntityCollector.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.data.RenderableListItemPool');
	p.push('away.data.EntityListItemPool');
	p.push('away.traverse.PartitionTraverser');
	return p;
};

away.traverse.EntityCollector.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.traverse.EntityCollector.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 1:
			p = away.traverse.PartitionTraverser.injectionPoints(t);
			break;
		case 2:
			p = away.traverse.PartitionTraverser.injectionPoints(t);
			break;
		case 3:
			p = away.traverse.PartitionTraverser.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

