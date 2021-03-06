/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:04 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.render == "undefined")
	away.core.render = {};

away.core.render.DefaultRenderer = function() {
	this._activeMaterial = null;
	this.SCREEN_PASSES = 2;
	this._skyboxProjection = new away.core.geom.Matrix3D();
	this._pDepthRenderer = null;
	this.ALL_PASSES = 3;
	this.RTT_PASSES = 1;
	this._pDistanceRenderer = null;
	away.core.render.RendererBase.call(this, false);
	this._pDepthRenderer = new away.core.render.DepthRenderer(false, false);
	this._pDistanceRenderer = new away.core.render.DepthRenderer(false, true);
};

away.core.render.DefaultRenderer.RTT_PASSES = 1;

away.core.render.DefaultRenderer.SCREEN_PASSES = 2;

away.core.render.DefaultRenderer.ALL_PASSES = 3;

away.core.render.DefaultRenderer.prototype.set_iStage3DProxy = function(value) {
	away.core.render.RendererBase.prototype.iSetStage3DProxy.call(this,value);
	this._pDepthRenderer.set_iStage3DProxy(value);
	this._pDistanceRenderer.set_iStage3DProxy(this._pDepthRenderer.get_iStage3DProxy());
};

away.core.render.DefaultRenderer.prototype.pExecuteRender = function(entityCollector, target, scissorRect, surfaceSelector) {
	target = target || null;
	scissorRect = scissorRect || null;
	surfaceSelector = surfaceSelector || 0;
	this.updateLights(entityCollector);
	if (target) {
		this.drawRenderables(entityCollector.get_opaqueRenderableHead(), entityCollector, away.core.render.DefaultRenderer.RTT_PASSES);
		this.drawRenderables(entityCollector.get_blendedRenderableHead(), entityCollector, away.core.render.DefaultRenderer.RTT_PASSES);
	}
	away.core.render.RendererBase.prototype.pExecuteRender.call(this,entityCollector, target, scissorRect, surfaceSelector);
};

away.core.render.DefaultRenderer.prototype.updateLights = function(entityCollector) {
	var dirLights = entityCollector.get_directionalLights();
	var pointLights = entityCollector.get_pointLights();
	var len, i;
	var light;
	var shadowMapper;
	len = dirLights.length;
	for (i = 0; i < len; ++i) {
		light = dirLights[i];
		shadowMapper = light.get_shadowMapper();
		if (light.get_castsShadows() && (shadowMapper.get_autoUpdateShadows() || shadowMapper._iShadowsInvalid)) {
			shadowMapper.iRenderDepthMap(this._pStage3DProxy, entityCollector, this._pDepthRenderer);
		}
	}
	len = pointLights.length;
	for (i = 0; i < len; ++i) {
		light = pointLights[i];
		shadowMapper = light.get_shadowMapper();
		if (light.get_castsShadows() && (shadowMapper.get_autoUpdateShadows() || shadowMapper._iShadowsInvalid)) {
			shadowMapper.iRenderDepthMap(this._pStage3DProxy, entityCollector, this._pDistanceRenderer);
		}
	}
};

away.core.render.DefaultRenderer.prototype.pDraw = function(entityCollector, target) {
	this._pContext.setBlendFactors(away.core.display3D.Context3DBlendFactor.ONE, away.core.display3D.Context3DBlendFactor.ZERO);
	if (entityCollector.get_skyBox()) {
		if (this._activeMaterial) {
			this._activeMaterial.iDeactivate(this._pStage3DProxy);
		}
		this._activeMaterial = null;
		this._pContext.setDepthTest(false, away.core.display3D.Context3DCompareMode.ALWAYS);
		this.drawSkyBox(entityCollector);
	}
	this._pContext.setDepthTest(true, away.core.display3D.Context3DCompareMode.LESS_EQUAL);
	var which = target ? away.core.render.DefaultRenderer.SCREEN_PASSES : away.core.render.DefaultRenderer.ALL_PASSES;
	this.drawRenderables(entityCollector.get_opaqueRenderableHead(), entityCollector, which);
	this.drawRenderables(entityCollector.get_blendedRenderableHead(), entityCollector, which);
	this._pContext.setDepthTest(false, away.core.display3D.Context3DCompareMode.LESS_EQUAL);
	if (this._activeMaterial) {
		this._activeMaterial.iDeactivate(this._pStage3DProxy);
	}
	this._activeMaterial = null;
};

away.core.render.DefaultRenderer.prototype.drawSkyBox = function(entityCollector) {
	var skyBox = entityCollector.get_skyBox();
	var material = skyBox.get_material();
	var camera = entityCollector.get_camera();
	this.updateSkyBoxProjection(camera);
	material.iActivatePass(0, this._pStage3DProxy, camera);
	material.iRenderPass(0, skyBox, this._pStage3DProxy, entityCollector, this._skyboxProjection);
	material.iDeactivatePass(0, this._pStage3DProxy);
};

away.core.render.DefaultRenderer.prototype.updateSkyBoxProjection = function(camera) {
	var near = new away.core.geom.Vector3D(0, 0, 0, 0);
	this._skyboxProjection.copyFrom(this._pRttViewProjectionMatrix);
	this._skyboxProjection.copyRowTo(2, near);
	var camPos = camera.get_scenePosition();
	var cx = near.x;
	var cy = near.y;
	var cz = near.z;
	var cw = -(near.x * camPos.x + near.y * camPos.y + near.z * camPos.z + Math.sqrt(cx * cx + cy * cy + cz * cz));
	var signX = cx >= 0 ? 1 : -1;
	var signY = cy >= 0 ? 1 : -1;
	var p = new away.core.geom.Vector3D(signX, signY, 1, 1);
	var inverse = this._skyboxProjection.clone();
	inverse.invert();
	var q = inverse.transformVector(p);
	this._skyboxProjection.copyRowTo(3, p);
	var a = (q.x * p.x + q.y * p.y + q.z * p.z + q.w * p.w) / (cx * q.x + cy * q.y + cz * q.z + cw * q.w);
	this._skyboxProjection.copyRowFrom(2, new away.core.geom.Vector3D(cx * a, cy * a, cz * a, cw * a));
};

away.core.render.DefaultRenderer.prototype.drawRenderables = function(item, entityCollector, which) {
	var numPasses;
	var j;
	var camera = entityCollector.get_camera();
	var item2;
	while (item) {
		this._activeMaterial = item.renderable.get_material();
		this._activeMaterial.iUpdateMaterial(this._pContext);
		numPasses = this._activeMaterial.get__iNumPasses();
		j = 0;
		do {
			item2 = item;
			var rttMask = this._activeMaterial.iPassRendersToTexture(j) ? 1 : 2;
			if ((rttMask & which) != 0) {
				this._activeMaterial.iActivatePass(j, this._pStage3DProxy, camera);
				do {
					this._activeMaterial.iRenderPass(j, item2.renderable, this._pStage3DProxy, entityCollector, this._pRttViewProjectionMatrix);
					item2 = item2.next;
				} while (item2 && item2.renderable.get_material() == this._activeMaterial);
				this._activeMaterial.iDeactivatePass(j, this._pStage3DProxy);
			} else {
				do {
					item2 = item2.next;
				} while (item2 && item2.renderable.get_material() == this._activeMaterial);
			}
		} while (++j < numPasses);
		item = item2;
	}
};

away.core.render.DefaultRenderer.prototype.iDispose = function() {
	away.core.render.RendererBase.prototype.iDispose.call(this);
	this._pDepthRenderer.iDispose();
	this._pDistanceRenderer.iDispose();
	this._pDepthRenderer = null;
	this._pDistanceRenderer = null;
};

$inherit(away.core.render.DefaultRenderer, away.core.render.RendererBase);

away.core.render.DefaultRenderer.className = "away.core.render.DefaultRenderer";

away.core.render.DefaultRenderer.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.core.display3D.Context3DBlendFactor');
	p.push('away.core.render.DefaultRenderer');
	p.push('away.core.traverse.EntityCollector');
	p.push('away.core.data.RenderableListItem');
	p.push('away.core.geom.Vector3D');
	p.push('away.core.render.DepthRenderer');
	p.push('away.core.display3D.Context3DCompareMode');
	return p;
};

away.core.render.DefaultRenderer.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('away.core.geom.Matrix3D');
	return p;
};

away.core.render.DefaultRenderer.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 1:
			p = away.core.render.RendererBase.injectionPoints(t);
			break;
		case 2:
			p = away.core.render.RendererBase.injectionPoints(t);
			break;
		case 3:
			p = away.core.render.RendererBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

