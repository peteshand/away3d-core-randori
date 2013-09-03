/** Compiled by the Randori compiler v0.2.6.2 on Mon Sep 02 23:32:29 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.render == "undefined")
	away.render = {};

away.render.DepthRenderer = function(renderBlended, distanceBased) {
	this._activeMaterial = null;
	this._distanceBased = null;
	this._renderBlended = null;
	this._disableColor = null;
	away.render.RendererBase.call(thisfalse);
	this._renderBlended = renderBlended;
	this._distanceBased = distanceBased;
	this.set_iBackgroundR(1);
	this.set_iBackgroundG(1);
	this.set_iBackgroundB(1);
};

away.render.DepthRenderer.prototype.get_disableColor = function() {
	return this._disableColor;
};

away.render.DepthRenderer.prototype.set_disableColor = function(value) {
	this._disableColor = value;
};

away.render.DepthRenderer.prototype.set_iBackgroundR = function(value) {
};

away.render.DepthRenderer.prototype.set_iBackgroundG = function(value) {
};

away.render.DepthRenderer.prototype.set_iBackgroundB = function(value) {
};

away.render.DepthRenderer.prototype.iRenderCascades = function(entityCollector, target, numCascades, scissorRects, cameras) {
	this._pRenderTarget = target;
	this._pRenderTargetSurface = 0;
	this._pRenderableSorter.sort(entityCollector);
	this._pStage3DProxy.setRenderTarget(target, true, 0);
	this._pContext.clear(1, 1, 1, 1, 1, 0, 0);
	this._pContext.setBlendFactors(away.display3D.Context3DBlendFactor.ONE, away.display3D.Context3DBlendFactor.ZERO);
	this._pContext.setDepthTest(true, away.display3D.Context3DCompareMode.LESS);
	var head = entityCollector.get_opaqueRenderableHead();
	var first = true;
	for (var i = numCascades - 1; i >= 0; --i) {
		this._pStage3DProxy.set_scissorRect(scissorRects[i]);
		this.drawCascadeRenderables(head, cameras[i], first ? null : cameras[i].frustumPlanes);
		first = false;
	}
	if (this._activeMaterial) {
		this._activeMaterial.iDeactivateForDepth(this._pStage3DProxy);
	}
	this._activeMaterial = null;
	this._pContext.setDepthTest(false, away.display3D.Context3DCompareMode.LESS_EQUAL);
	this._pStage3DProxy.set_scissorRect(null);
};

away.render.DepthRenderer.prototype.drawCascadeRenderables = function(item, camera, cullPlanes) {
	var material;
	while (item) {
		if (item.cascaded) {
			item = item.next;
			continue;
		}
		var renderable = item.renderable;
		var entity = renderable.get_sourceEntity();
		if (!cullPlanes || entity.get_worldBounds().isInFrustum(cullPlanes, 4)) {
			material = renderable.get_material();
			if (this._activeMaterial != material) {
				if (this._activeMaterial) {
					this._activeMaterial.iDeactivateForDepth(this._pStage3DProxy);
				}
				this._activeMaterial = material;
				this._activeMaterial.iActivateForDepth(this._pStage3DProxy, camera, false);
			}
			this._activeMaterial.iRenderDepth(renderable, this._pStage3DProxy, camera, camera.get_viewProjection());
		} else {
			item.cascaded = true;
		}
		item = item.next;
	}
};

away.render.DepthRenderer.prototype.pDraw = function(entityCollector, target) {
	this._pContext.setBlendFactors(away.display3D.Context3DBlendFactor.ONE, away.display3D.Context3DBlendFactor.ZERO);
	this._pContext.setDepthTest(true, away.display3D.Context3DCompareMode.LESS);
	this.drawRenderables(entityCollector.get_opaqueRenderableHead(), entityCollector);
	if (this._disableColor)
		this._pContext.setColorMask(false, false, false, false);
	if (this._renderBlended)
		this.drawRenderables(entityCollector.get_blendedRenderableHead(), entityCollector);
	if (this._activeMaterial)
		this._activeMaterial.iDeactivateForDepth(this._pStage3DProxy);
	if (this._disableColor)
		this._pContext.setColorMask(true, true, true, true);
	this._activeMaterial = null;
};

away.render.DepthRenderer.prototype.drawRenderables = function(item, entityCollector) {
	var camera = entityCollector.get_camera();
	var item2;
	while (item) {
		this._activeMaterial = item.renderable.get_material();
		if (this._disableColor && this._activeMaterial.iHasDepthAlphaThreshold()) {
			item2 = item;
			do {
				item2 = item2.next;
			} while (item2 && item2.renderable.get_material() == this._activeMaterial);
		} else {
			this._activeMaterial.iActivateForDepth(this._pStage3DProxy, camera, this._distanceBased);
			item2 = item;
			do {
				this._activeMaterial.iRenderDepth(item2.renderable, this._pStage3DProxy, camera, this._pRttViewProjectionMatrix);
				item2 = item2.next;
			} while (item2 && item2.renderable.get_material() == this._activeMaterial);
			this._activeMaterial.iDeactivateForDepth(this._pStage3DProxy);
		}
		item = item2;
	}
};

$inherit(away.render.DepthRenderer, away.render.RendererBase);

away.render.DepthRenderer.className = "away.render.DepthRenderer";

away.render.DepthRenderer.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.traverse.EntityCollector');
	p.push('away.display3D.Context3DBlendFactor');
	p.push('away.cameras.Camera3D');
	p.push('away.display3D.Context3DCompareMode');
	p.push('away.data.RenderableListItem');
	return p;
};

away.render.DepthRenderer.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.render.DepthRenderer.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'renderBlended', t:'Boolean'});
			p.push({n:'distanceBased', t:'Boolean'});
			break;
		case 1:
			p = away.render.RendererBase.injectionPoints(t);
			break;
		case 2:
			p = away.render.RendererBase.injectionPoints(t);
			break;
		case 3:
			p = away.render.RendererBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

