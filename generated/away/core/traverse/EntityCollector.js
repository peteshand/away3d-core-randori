/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:01 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.traverse == "undefined")
	away.core.traverse = {};

away.core.traverse.EntityCollector = function() {
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
	away.core.traverse.PartitionTraverser.call(this);
	this.init();
};

away.core.traverse.EntityCollector.prototype.init = function() {
	this._pLights = [];
	this._directionalLights = [];
	this._pointLights = [];
	this._lightProbes = [];
	this._pRenderableListItemPool = new away.core.data.RenderableListItemPool();
	this._pEntityListItemPool = new away.core.data.EntityListItemPool();
};

away.core.traverse.EntityCollector.prototype.get_camera = function() {
	return this._pCamera;
};

away.core.traverse.EntityCollector.prototype.set_camera = function(value) {
	this._pCamera = value;
	this._iEntryPoint = this._pCamera.get_scenePosition();
	this._pCameraForward = this._pCamera.get_forwardVector();
	this._cullPlanes = this._pCamera.get_frustumPlanes();
};

away.core.traverse.EntityCollector.prototype.get_cullPlanes = function() {
	return this._customCullPlanes;
};

away.core.traverse.EntityCollector.prototype.set_cullPlanes = function(value) {
	this._customCullPlanes = value;
};

away.core.traverse.EntityCollector.prototype.get_numMouseEnableds = function() {
	return this._pNumMouseEnableds;
};

away.core.traverse.EntityCollector.prototype.get_skyBox = function() {
	return this._pSkyBox;
};

away.core.traverse.EntityCollector.prototype.get_opaqueRenderableHead = function() {
	return this._pOpaqueRenderableHead;
};

away.core.traverse.EntityCollector.prototype.set_opaqueRenderableHead = function(value) {
	this._pOpaqueRenderableHead = value;
};

away.core.traverse.EntityCollector.prototype.get_blendedRenderableHead = function() {
	return this._pBlendedRenderableHead;
};

away.core.traverse.EntityCollector.prototype.set_blendedRenderableHead = function(value) {
	this._pBlendedRenderableHead = value;
};

away.core.traverse.EntityCollector.prototype.get_entityHead = function() {
	return this._entityHead;
};

away.core.traverse.EntityCollector.prototype.get_lights = function() {
	return this._pLights;
};

away.core.traverse.EntityCollector.prototype.get_directionalLights = function() {
	return this._directionalLights;
};

away.core.traverse.EntityCollector.prototype.get_pointLights = function() {
	return this._pointLights;
};

away.core.traverse.EntityCollector.prototype.get_lightProbes = function() {
	return this._lightProbes;
};

away.core.traverse.EntityCollector.prototype.clear = function() {
	this._cullPlanes = this._customCullPlanes ? this._customCullPlanes : this._pCamera ? this._pCamera.get_frustumPlanes() : null;
	this._numCullPlanes = this._cullPlanes ? this._cullPlanes.length : 0;
	this._pNumMouseEnableds = 0;
	this._pNumTriangles = this._pNumMouseEnableds;
	this._pBlendedRenderableHead = null;
	this._pOpaqueRenderableHead = null;
	this._entityHead = null;
	this._pRenderableListItemPool.freeAll();
	this._pEntityListItemPool.freeAll();
	this._pSkyBox = null;
	if (this._pNumLights > 0) {
		this._pNumLights = 0;
		this._pLights.length = this._pNumLights;
	}
	if (this._numDirectionalLights > 0) {
		this._numDirectionalLights = 0;
		this._directionalLights.length = this._numDirectionalLights;
	}
	if (this._numPointLights > 0) {
		this._numPointLights = 0;
		this._pointLights.length = this._numPointLights;
	}
	if (this._numLightProbes > 0) {
		this._numLightProbes = 0;
		this._lightProbes.length = this._numLightProbes;
	}
};

away.core.traverse.EntityCollector.prototype.enterNode = function(node) {
	var enter = away.core.traverse.PartitionTraverser._iCollectionMark != node._iCollectionMark && node.isInFrustum(this._cullPlanes, this._numCullPlanes);
	node._iCollectionMark = away.core.traverse.PartitionTraverser._iCollectionMark;
	return enter;
};

away.core.traverse.EntityCollector.prototype.applySkyBox = function(renderable) {
	this._pSkyBox = renderable;
};

away.core.traverse.EntityCollector.prototype.applyRenderable = function(renderable) {
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

away.core.traverse.EntityCollector.prototype.applyEntity = function(entity) {
	++this._pNumEntities;
	var item = this._pEntityListItemPool.getItem();
	item.entity = entity;
	item.next = this._entityHead;
	this._entityHead = item;
};

away.core.traverse.EntityCollector.prototype.applyUnknownLight = function(light) {
	this._pLights[this._pNumLights++] = light;
};

away.core.traverse.EntityCollector.prototype.applyDirectionalLight = function(light) {
	this._pLights[this._pNumLights++] = light;
	this._directionalLights[this._numDirectionalLights++] = light;
};

away.core.traverse.EntityCollector.prototype.applyPointLight = function(light) {
	this._pLights[this._pNumLights++] = light;
	this._pointLights[this._numPointLights++] = light;
};

away.core.traverse.EntityCollector.prototype.applyLightProbe = function(light) {
	this._pLights[this._pNumLights++] = light;
	this._lightProbes[this._numLightProbes++] = light;
};

away.core.traverse.EntityCollector.prototype.cleanUp = function() {
};

$inherit(away.core.traverse.EntityCollector, away.core.traverse.PartitionTraverser);

away.core.traverse.EntityCollector.className = "away.core.traverse.EntityCollector";

away.core.traverse.EntityCollector.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.core.data.RenderableListItemPool');
	p.push('away.core.data.EntityListItemPool');
	p.push('away.core.traverse.PartitionTraverser');
	return p;
};

away.core.traverse.EntityCollector.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.core.traverse.EntityCollector.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 1:
			p = away.core.traverse.PartitionTraverser.injectionPoints(t);
			break;
		case 2:
			p = away.core.traverse.PartitionTraverser.injectionPoints(t);
			break;
		case 3:
			p = away.core.traverse.PartitionTraverser.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

