/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:41 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.lights == "undefined")
	away.lights = {};
if (typeof away.lights.shadowmaps == "undefined")
	away.lights.shadowmaps = {};

away.lights.shadowmaps.ShadowMapperBase = function() {
	this._depthMap = null;
	this._pDepthMapSize = 2048;
	this._explicitDepthMap = false;
	this._iShadowsInvalid = false;
	this._pCasterCollector = null;
	this._pLight = null;
	this._autoUpdateShadows = true;
	this._pCasterCollector = this.pCreateCasterCollector();
};

away.lights.shadowmaps.ShadowMapperBase.prototype.pCreateCasterCollector = function() {
	return new away.core.traverse.ShadowCasterCollector();
};

away.lights.shadowmaps.ShadowMapperBase.prototype.get_autoUpdateShadows = function() {
	return this._autoUpdateShadows;
};

away.lights.shadowmaps.ShadowMapperBase.prototype.set_autoUpdateShadows = function(value) {
	this._autoUpdateShadows = value;
};

away.lights.shadowmaps.ShadowMapperBase.prototype.updateShadows = function() {
	this._iShadowsInvalid = true;
};

away.lights.shadowmaps.ShadowMapperBase.prototype.iSetDepthMap = function(depthMap) {
	if (this._depthMap == depthMap) {
		return;
	}
	if (this._depthMap && !this._explicitDepthMap) {
		this._depthMap.dispose();
	}
	this._depthMap = depthMap;
	if (this._depthMap) {
		this._explicitDepthMap = true;
		this._pDepthMapSize = this._depthMap.get_width();
	} else {
		this._explicitDepthMap = false;
	}
};

away.lights.shadowmaps.ShadowMapperBase.prototype.get_light = function() {
	return this._pLight;
};

away.lights.shadowmaps.ShadowMapperBase.prototype.set_light = function(value) {
	this._pLight = value;
};

away.lights.shadowmaps.ShadowMapperBase.prototype.get_depthMap = function() {
	if (!this._depthMap) {
		this._depthMap = this.pCreateDepthTexture();
	}
	return this._depthMap;
};

away.lights.shadowmaps.ShadowMapperBase.prototype.get_depthMapSize = function() {
	return this._pDepthMapSize;
};

away.lights.shadowmaps.ShadowMapperBase.prototype.set_depthMapSize = function(value) {
	if (value == this._pDepthMapSize) {
		return;
	}
	this._pDepthMapSize = value;
	if (this._explicitDepthMap) {
		throw "Cannot set depth map size for the current renderer.", 0;
	} else if (this._depthMap) {
		this._depthMap.dispose();
		this._depthMap = null;
	}
};

away.lights.shadowmaps.ShadowMapperBase.prototype.dispose = function() {
	this._pCasterCollector = null;
	if (this._depthMap && !this._explicitDepthMap) {
		this._depthMap.dispose();
	}
	this._depthMap = null;
};

away.lights.shadowmaps.ShadowMapperBase.prototype.pCreateDepthTexture = function() {
	return new away.textures.RenderTexture(this._pDepthMapSize, this._pDepthMapSize);
};

away.lights.shadowmaps.ShadowMapperBase.prototype.iRenderDepthMap = function(stage3DProxy, entityCollector, renderer) {
	this._iShadowsInvalid = false;
	this.pUpdateDepthProjection(entityCollector.get_camera());
	if (!this._depthMap) {
		this._depthMap = this.pCreateDepthTexture();
	}
	this.pDrawDepthMap(this._depthMap.getTextureForStage3D(stage3DProxy), entityCollector.scene, renderer);
};

away.lights.shadowmaps.ShadowMapperBase.prototype.pUpdateDepthProjection = function(viewCamera) {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.lights.shadowmaps.ShadowMapperBase.prototype.pDrawDepthMap = function(target, scene, renderer) {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.lights.shadowmaps.ShadowMapperBase.className = "away.lights.shadowmaps.ShadowMapperBase";

away.lights.shadowmaps.ShadowMapperBase.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.textures.RenderTexture');
	p.push('away.core.traverse.ShadowCasterCollector');
	p.push('away.core.traverse.EntityCollector');
	p.push('away.errors.AbstractMethodError');
	return p;
};

away.lights.shadowmaps.ShadowMapperBase.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.lights.shadowmaps.ShadowMapperBase.injectionPoints = function(t) {
	return [];
};
