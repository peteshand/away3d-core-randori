/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:04 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.render == "undefined")
	away.core.render = {};

away.core.render.RendererBase = function(renderToTexture) {
	this._snapshotRequired = false;
	this._backgroundG = 0;
	this._backgroundB = 0;
	this._backgroundAlpha = 1;
	this._pStage3DProxy = null;
	this._viewHeight = 0;
	this._clearOnRender = true;
	this._antiAlias = 0;
	this._snapshotBitmapData = null;
	this._shareContext = false;
	this._textureRatioY = 1;
	this._textureRatioX = 1;
	this._viewWidth = 0;
	this._pRttViewProjectionMatrix = new away.core.geom.Matrix3D();
	this._pRenderableSorter = null;
	this._pRenderTarget = null;
	this._renderToTexture = false;
	this._backgroundR = 0;
	this._pContext = null;
	this._pRenderTargetSurface = 0;
	this._pRenderableSorter = new away.core.sort.RenderableMergeSort();
	this._renderToTexture = renderToTexture;
};

away.core.render.RendererBase.prototype.iCreateEntityCollector = function() {
	return new away.core.traverse.EntityCollector();
};

away.core.render.RendererBase.prototype.get_iViewWidth = function() {
	return this._viewWidth;
};

away.core.render.RendererBase.prototype.set_iViewWidth = function(value) {
	this._viewWidth = value;
};

away.core.render.RendererBase.prototype.get_iViewHeight = function() {
	return this._viewHeight;
};

away.core.render.RendererBase.prototype.set_iViewHeight = function(value) {
	this._viewHeight = value;
};

away.core.render.RendererBase.prototype.get_iRenderToTexture = function() {
	return this._renderToTexture;
};

away.core.render.RendererBase.prototype.get_renderableSorter = function() {
	return this._pRenderableSorter;
};

away.core.render.RendererBase.prototype.set_renderableSorter = function(value) {
	this._pRenderableSorter = value;
};

away.core.render.RendererBase.prototype.get_iClearOnRender = function() {
	return this._clearOnRender;
};

away.core.render.RendererBase.prototype.set_iClearOnRender = function(value) {
	this._clearOnRender = value;
};

away.core.render.RendererBase.prototype.get_iBackgroundR = function() {
	return this._backgroundR;
};

away.core.render.RendererBase.prototype.set_iBackgroundR = function(value) {
	this._backgroundR = value;
};

away.core.render.RendererBase.prototype.get_iBackgroundG = function() {
	return this._backgroundG;
};

away.core.render.RendererBase.prototype.set_iBackgroundG = function(value) {
	this._backgroundG = value;
};

away.core.render.RendererBase.prototype.get_iBackgroundB = function() {
	return this._backgroundB;
};

away.core.render.RendererBase.prototype.set_iBackgroundB = function(value) {
	this._backgroundB = value;
};

away.core.render.RendererBase.prototype.get_iStage3DProxy = function() {
	return this._pStage3DProxy;
};

away.core.render.RendererBase.prototype.set_iStage3DProxy = function(value) {
	this.iSetStage3DProxy(value);
};

away.core.render.RendererBase.prototype.iSetStage3DProxy = function(value) {
	if (value == this._pStage3DProxy) {
		return;
	}
	if (!value) {
		if (this._pStage3DProxy) {
			this._pStage3DProxy.removeEventListener(away.events.Stage3DEvent.CONTEXT3D_CREATED, $createStaticDelegate(this, this.onContextUpdate), this);
			this._pStage3DProxy.removeEventListener(away.events.Stage3DEvent.CONTEXT3D_RECREATED, $createStaticDelegate(this, this.onContextUpdate), this);
		}
		this._pStage3DProxy = null;
		this._pContext = null;
		return;
	}
	this._pStage3DProxy = value;
	this._pStage3DProxy.addEventListener(away.events.Stage3DEvent.CONTEXT3D_CREATED, $createStaticDelegate(this, this.onContextUpdate), this);
	this._pStage3DProxy.addEventListener(away.events.Stage3DEvent.CONTEXT3D_RECREATED, $createStaticDelegate(this, this.onContextUpdate), this);
	if (value.get_context3D())
		this._pContext = value.get_context3D();
};

away.core.render.RendererBase.prototype.get_iShareContext = function() {
	return this._shareContext;
};

away.core.render.RendererBase.prototype.set_iShareContext = function(value) {
	this._shareContext = value;
};

away.core.render.RendererBase.prototype.iDispose = function() {
	this._pStage3DProxy = null;
};

away.core.render.RendererBase.prototype.iRender = function(entityCollector, target, scissorRect, surfaceSelector) {
	target = target || null;
	scissorRect = scissorRect || null;
	surfaceSelector = surfaceSelector || 0;
	if (!this._pStage3DProxy || !this._pContext) {
		return;
	}
	this._pRttViewProjectionMatrix.copyFrom(entityCollector.get_camera().get_viewProjection());
	this._pRttViewProjectionMatrix.appendScale(this._textureRatioX, this._textureRatioY, 1);
	this.pExecuteRender(entityCollector, target, scissorRect, surfaceSelector);
	for (var i = 0; i < 8; ++i) {
		this._pContext.setVertexBufferAt(i, null, 0);
		this._pContext.setTextureAt(i, null);
	}
};

away.core.render.RendererBase.prototype.pExecuteRender = function(entityCollector, target, scissorRect, surfaceSelector) {
	target = target || null;
	scissorRect = scissorRect || null;
	surfaceSelector = surfaceSelector || 0;
	this._pRenderTarget = target;
	this._pRenderTargetSurface = surfaceSelector;
	if (this._pRenderableSorter) {
		this._pRenderableSorter.sort(entityCollector);
	}
	if (this._renderToTexture) {
		this.pExecuteRenderToTexturePass(entityCollector);
	}
	this._pStage3DProxy.setRenderTarget(target, true, surfaceSelector);
	if ((target || !this._shareContext) && this._clearOnRender) {
		this._pContext.clear(this._backgroundR, this._backgroundG, this._backgroundB, this._backgroundAlpha, 1, 0, 17664);
	}
	this._pContext.setDepthTest(false, away.core.display3D.Context3DCompareMode.ALWAYS);
	this._pStage3DProxy.set_scissorRect(scissorRect);
	this.pDraw(entityCollector, target);
	this._pContext.setDepthTest(false, away.core.display3D.Context3DCompareMode.LESS_EQUAL);
	if (!this._shareContext) {
		if (this._snapshotRequired && this._snapshotBitmapData) {
			this._pContext.drawToBitmapData(this._snapshotBitmapData);
			this._snapshotRequired = false;
		}
	}
	this._pStage3DProxy.set_scissorRect(null);
};

away.core.render.RendererBase.prototype.queueSnapshot = function(bmd) {
	this._snapshotRequired = true;
	this._snapshotBitmapData = bmd;
};

away.core.render.RendererBase.prototype.pExecuteRenderToTexturePass = function(entityCollector) {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.core.render.RendererBase.prototype.pDraw = function(entityCollector, target) {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.core.render.RendererBase.prototype.onContextUpdate = function(event) {
	this._pContext = this._pStage3DProxy.get_context3D();
};

away.core.render.RendererBase.prototype.get_iBackgroundAlpha = function() {
	return this._backgroundAlpha;
};

away.core.render.RendererBase.prototype.set_iBackgroundAlpha = function(value) {
	this._backgroundAlpha = value;
};

away.core.render.RendererBase.prototype.get_antiAlias = function() {
	return this._antiAlias;
};

away.core.render.RendererBase.prototype.set_antiAlias = function(antiAlias) {
	this._antiAlias = antiAlias;
};

away.core.render.RendererBase.prototype.get_iTextureRatioX = function() {
	return this._textureRatioX;
};

away.core.render.RendererBase.prototype.set_iTextureRatioX = function(value) {
	this._textureRatioX = value;
};

away.core.render.RendererBase.prototype.get_iTextureRatioY = function() {
	return this._textureRatioY;
};

away.core.render.RendererBase.prototype.set_iTextureRatioY = function(value) {
	this._textureRatioY = value;
};

away.core.render.RendererBase.className = "away.core.render.RendererBase";

away.core.render.RendererBase.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.events.Stage3DEvent');
	p.push('away.core.traverse.EntityCollector');
	p.push('away.errors.AbstractMethodError');
	p.push('away.core.sort.RenderableMergeSort');
	p.push('away.cameras.Camera3D');
	p.push('away.core.display3D.Context3DCompareMode');
	return p;
};

away.core.render.RendererBase.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('away.core.geom.Matrix3D');
	return p;
};

away.core.render.RendererBase.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'renderToTexture', t:'Boolean'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

