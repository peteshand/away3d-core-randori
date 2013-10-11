/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:08 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.traverse == "undefined")
	away.core.traverse = {};

away.core.traverse.ShadowCasterCollector = function() {
	away.core.traverse.EntityCollector.call(this);
};

away.core.traverse.ShadowCasterCollector.prototype.applyRenderable = function(renderable) {
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

away.core.traverse.ShadowCasterCollector.prototype.applyUnknownLight = function(light) {
};

away.core.traverse.ShadowCasterCollector.prototype.applyDirectionalLight = function(light) {
};

away.core.traverse.ShadowCasterCollector.prototype.applyPointLight = function(light) {
};

away.core.traverse.ShadowCasterCollector.prototype.applyLightProbe = function(light) {
};

away.core.traverse.ShadowCasterCollector.prototype.applySkyBox = function(renderable) {
};

$inherit(away.core.traverse.ShadowCasterCollector, away.core.traverse.EntityCollector);

away.core.traverse.ShadowCasterCollector.className = "away.core.traverse.ShadowCasterCollector";

away.core.traverse.ShadowCasterCollector.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.core.traverse.ShadowCasterCollector.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.core.traverse.ShadowCasterCollector.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 1:
			p = away.core.traverse.EntityCollector.injectionPoints(t);
			break;
		case 2:
			p = away.core.traverse.EntityCollector.injectionPoints(t);
			break;
		case 3:
			p = away.core.traverse.EntityCollector.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

