/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 04 21:18:40 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.render == "undefined")
	away.render = {};

away.render.RenderBase = function(renderToTexture) {
	this._snapshotRequired = null;
	this._pShareContext = false;
	this._pBackgroundAlpha = 1;
	this._pBackgroundB = 0;
	this._pBackgroundG = 0;
	this._pStage3DProxy = null;
	this._clearOnRender = true;
	this._pTextureRatioY = 1;
	this._pBackgroundR = 0;
	this._snapshotBitmapData = null;
	this._pTextureRatioX = 1;
	this._pAntiAlias = 0;
	this._pRttViewProjectionMatrix = new away.geom.Matrix3D();
	this._pViewHeight = 0;
	this._pRenderToTexture = null;
	this._pRenderableSorter = null;
	this._pRenderTarget = null;
	this._pViewWidth = 0;
	this._pContext = null;
	this._pRenderTargetSurface = 0;
	this._background = null;
	this._pRenderableSorter = new away.sort.RenderableMergeSort();
	this._pRenderToTexture = renderToTexture;
};

away.render.RenderBase.prototype.iCreateEntityCollector = function() {
	return new away.traverse.EntityCollector();
};

away.render.RenderBase.prototype.get_iViewWidth = function() {
	return this._pViewWidth;
};

away.render.RenderBase.prototype.set_iViewWidth = function(value) {
	this._pViewWidth = value;
};

away.render.RenderBase.prototype.get_iViewHeight = function() {
	return this._pViewHeight;
};

away.render.RenderBase.prototype.set_iViewHeight = function(value) {
	this._pViewHeight = value;
};

away.render.RenderBase.prototype.get_iRenderToTexture = function() {
	return this._pRenderToTexture;
};

away.render.RenderBase.prototype.get_renderableSorter = function() {
	return this._pRenderableSorter;
};

away.render.RenderBase.prototype.set_renderableSorter = function(value) {
	this._pRenderableSorter = value;
};

away.render.RenderBase.prototype.get_iClearOnRender = function() {
	return this._clearOnRender;
};

away.render.RenderBase.prototype.set_iClearOnRender = function(value) {
	this._clearOnRender = value;
};

away.render.RenderBase.prototype.get_iBackgroundR = function() {
	return this._pBackgroundR;
};

away.render.RenderBase.prototype.set_iBackgroundR = function(value) {
	this._pBackgroundR = value;
};

away.render.RenderBase.prototype.get_iBackgroundG = function() {
	return this._pBackgroundG;
};

away.render.RenderBase.prototype.set_iBackgroundG = function(value) {
	this._pBackgroundG = value;
};

away.render.RenderBase.prototype.get_iBackgroundB = function() {
	return this._pBackgroundB;
};

away.render.RenderBase.prototype.set_iBackgroundB = function(value) {
	this._pBackgroundB = value;
};

away.render.RenderBase.prototype.get_iStage3DProxy = function() {
	return this._pStage3DProxy;
};

away.render.RenderBase.prototype.set_iStage3DProxy = function(value) {
	if (value == this._pStage3DProxy) {
		return;
	}
	if (!value) {
		if (this._pStage3DProxy) {
			this._pStage3DProxy.removeEventListener(away.events.Stage3DEvent.CONTEXT3D_CREATED, $createStaticDelegate(, this.onContextUpdate), this);
			this._pStage3DProxy.removeEventListener(away.events.Stage3DEvent.CONTEXT3D_RECREATED, $createStaticDelegate(, this.onContextUpdate), this);
		}
		this._pStage3DProxy = null;
		this._pContext = null;
		return;
	}
	this._pStage3DProxy = value;
	this._pStage3DProxy.addEventListener(away.events.Stage3DEvent.CONTEXT3D_CREATED, $createStaticDelegate(, this.onContextUpdate), this);
	this._pStage3DProxy.addEventListener(away.events.Stage3DEvent.CONTEXT3D_RECREATED, $createStaticDelegate(, this.onContextUpdate), this);
	if (value.get_context3D()) {
		this._pContext = value.get_context3D();
	}
};

away.render.RenderBase.prototype.get_iShareContext = function() {
	return this._pShareContext;
};

away.render.RenderBase.prototype.set_iShareContext = function(value) {
	this._pShareContext = value;
};

away.render.RenderBase.prototype.iDispose = function() {
	this._pStage3DProxy = null;
};

away.render.RenderBase.prototype.iRender = function(entityCollector, target, scissorRect, surfaceSelector) {
	if (!this._pStage3DProxy || !this._pContext) {
		return;
	}
	this._pRttViewProjectionMatrix.copyFrom(entityCollector.get_camera().get_viewProjection());
	this._pRttViewProjectionMatrix.appendScale(this._pTextureRatioX, this._pTextureRatioY, 1);
	this.pExecuteRender(entityCollector, target, scissorRect, surfaceSelector);
	for (var i = 0; i < 8; ++i) {
		this._pContext.setVertexBufferAt(i, null, 0);
		this._pContext.setTextureAt(i, null);
	}
};

away.render.RenderBase.prototype.pExecuteRender = function(entityCollector, target, scissorRect, surfaceSelector) {
	this._pRenderTarget = target;
	this._pRenderTargetSurface = surfaceSelector;
	if (this._pRenderableSorter) {
		this._pRenderableSorter.sort(entityCollector);
	}
	if (this._pRenderToTexture) {
		this.pExecuteRenderToTexturePass(entityCollector);
	}
	this._pStage3DProxy.setRenderTarget(target, true, surfaceSelector);
	if ((target || !this._pShareContext) && this._clearOnRender) {
		this._pContext.clear(this._pBackgroundR, this._pBackgroundG, this._pBackgroundB, this._pBackgroundAlpha, 1, 0, 0);
	}
	this._pContext.setDepthTest(false, away.display3D.Context3DCompareMode.ALWAYS);
	this._pStage3DProxy.set_scissorRect(scissorRect);
	this.pDraw(entityCollector, target);
	this._pContext.setDepthTest(false, away.display3D.Context3DCompareMode.LESS_EQUAL);
	if (!this._pShareContext) {
		if (this._snapshotRequired && this._snapshotBitmapData) {
			this._pContext.drawToBitmapData(this._snapshotBitmapData);
			this._snapshotRequired = false;
		}
	}
	this._pStage3DProxy.set_scissorRect(null);
};

away.render.RenderBase.prototype.queueSnapshot = function(bmd) {
	this._snapshotRequired = true;
	this._snapshotBitmapData = bmd;
};

away.render.RenderBase.prototype.pExecuteRenderToTexturePass = function(entityCollector) {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.render.RenderBase.prototype.pDraw = function(entityCollector, target) {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.render.RenderBase.prototype.onContextUpdate = function(event) {
	this._pContext = this._pStage3DProxy.get_context3D();
};

away.render.RenderBase.prototype.get_iBackgroundAlpha = function() {
	return this._pBackgroundAlpha;
};

away.render.RenderBase.prototype.set_iBackgroundAlpha = function(value) {
	this._pBackgroundAlpha = value;
};

away.render.RenderBase.prototype.get_iBackground = function() {
	return this._background;
};

away.render.RenderBase.prototype.get_antiAlias = function() {
	return this._pAntiAlias;
};

away.render.RenderBase.className = "away.render.RenderBase";

away.render.RenderBase.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.events.Stage3DEvent');
	p.push('away.traverse.EntityCollector');
	p.push('away.errors.AbstractMethodError');
	p.push('away.cameras.Camera3D');
	p.push('away.display3D.Context3DCompareMode');
	p.push('away.sort.RenderableMergeSort');
	return p;
};

away.render.RenderBase.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.Matrix3D');
	return p;
};

away.render.RenderBase.injectionPoints = function(t) {
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

