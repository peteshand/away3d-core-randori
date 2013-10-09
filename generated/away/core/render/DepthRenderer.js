/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:41 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.render == "undefined")
	away.core.render = {};

away.core.render.DepthRenderer = function(renderBlended, distanceBased) {
	this._activeMaterial = null;
	this._distanceBased = false;
	this._renderBlended = false;
	this._disableColor = false;
	away.core.render.RendererBase.call(this, false);
	this._renderBlended = renderBlended;
	this._distanceBased = distanceBased;
	this.set_iBackgroundR(1);
	this.set_iBackgroundG(1);
	this.set_iBackgroundB(1);
};

away.core.render.DepthRenderer.prototype.get_disableColor = function() {
	return this._disableColor;
};

away.core.render.DepthRenderer.prototype.set_disableColor = function(value) {
	this._disableColor = value;
};

away.core.render.DepthRenderer.prototype.set_iBackgroundR = function(value) {
};

away.core.render.DepthRenderer.prototype.set_iBackgroundG = function(value) {
};

away.core.render.DepthRenderer.prototype.set_iBackgroundB = function(value) {
};

away.core.render.DepthRenderer.prototype.iRenderCascades = function(entityCollector, target, numCascades, scissorRects, cameras) {
	this._pRenderTarget = target;
	this._pRenderTargetSurface = 0;
	this._pRenderableSorter.sort(entityCollector);
	this._pStage3DProxy.setRenderTarget(target, true, 0);
	this._pContext.clear(1, 1, 1, 1, 1, 0, 17664);
	this._pContext.setBlendFactors(away.core.display3D.Context3DBlendFactor.ONE, away.core.display3D.Context3DBlendFactor.ZERO);
	this._pContext.setDepthTest(true, away.core.display3D.Context3DCompareMode.LESS);
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
	this._pContext.setDepthTest(false, away.core.display3D.Context3DCompareMode.LESS_EQUAL);
	this._pStage3DProxy.set_scissorRect(null);
};

away.core.render.DepthRenderer.prototype.drawCascadeRenderables = function(item, camera, cullPlanes) {
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

away.core.render.DepthRenderer.prototype.pDraw = function(entityCollector, target) {
	this._pContext.setBlendFactors(away.core.display3D.Context3DBlendFactor.ONE, away.core.display3D.Context3DBlendFactor.ZERO);
	this._pContext.setDepthTest(true, away.core.display3D.Context3DCompareMode.LESS);
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

away.core.render.DepthRenderer.prototype.drawRenderables = function(item, entityCollector) {
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

$inherit(away.core.render.DepthRenderer, away.core.render.RendererBase);

away.core.render.DepthRenderer.className = "away.core.render.DepthRenderer";

away.core.render.DepthRenderer.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.core.display3D.Context3DBlendFactor');
	p.push('away.core.traverse.EntityCollector');
	p.push('away.core.data.RenderableListItem');
	p.push('away.cameras.Camera3D');
	p.push('away.core.display3D.Context3DCompareMode');
	return p;
};

away.core.render.DepthRenderer.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.core.render.DepthRenderer.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'renderBlended', t:'Boolean'});
			p.push({n:'distanceBased', t:'Boolean'});
			break;
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

