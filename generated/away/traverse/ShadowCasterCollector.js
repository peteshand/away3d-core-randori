/** Compiled by the Randori compiler v0.2.6.2 on Sun Sep 22 12:28:45 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.traverse == "undefined")
	away.traverse = {};

away.traverse.ShadowCasterCollector = function() {
	away.traverse.EntityCollector.call(this);
};

away.traverse.ShadowCasterCollector.prototype.applyRenderable = function(renderable) {
	var material = renderable.get_material();
	var entity = renderable.get_sourceEntity();
	if (renderable.get_castsShadows() && material) {
		var item = this._pRenderableListItemPool.getItem();
		item.renderable = renderable;
		item.next = this._pOpaqueRenderableHead;
		item.cascaded = false;
		var dx = this._iEntryPoint.x - entity.get_x();
		var dy = this._iEntryPoint.y - entity.get_y();
		var dz = this._iEntryPoint.z - entity.get_z();
		item.zIndex = dx * this._pCameraForward.x + dy * this._pCameraForward.y + dz * this._pCameraForward.z;
		item.renderSceneTransform = renderable.getRenderSceneTransform(this._pCamera);
		item.renderOrderId = material._iDepthPassId;
		this._pOpaqueRenderableHead = item;
	}
};

away.traverse.ShadowCasterCollector.prototype.applyUnknownLight = function(light) {
};

away.traverse.ShadowCasterCollector.prototype.applyDirectionalLight = function(light) {
};

away.traverse.ShadowCasterCollector.prototype.applyPointLight = function(light) {
};

away.traverse.ShadowCasterCollector.prototype.applyLightProbe = function(light) {
};

away.traverse.ShadowCasterCollector.prototype.applySkyBox = function(renderable) {
};

$inherit(away.traverse.ShadowCasterCollector, away.traverse.EntityCollector);

away.traverse.ShadowCasterCollector.className = "away.traverse.ShadowCasterCollector";

away.traverse.ShadowCasterCollector.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.traverse.ShadowCasterCollector.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.traverse.ShadowCasterCollector.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 1:
			p = away.traverse.EntityCollector.injectionPoints(t);
			break;
		case 2:
			p = away.traverse.EntityCollector.injectionPoints(t);
			break;
		case 3:
			p = away.traverse.EntityCollector.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

