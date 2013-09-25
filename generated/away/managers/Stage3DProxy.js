/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 25 20:35:40 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.managers == "undefined")
	away.managers = {};

away.managers.Stage3DProxy = function(stage3DIndex, stage3D, stage3DManager, forceSoftware, profile) {
	this._stage3DManager = null;
	this._stage3D = null;
	this._viewportUpdated = null;
	this._renderSurfaceSelector = 0;
	this._iStage3DIndex = -1;
	this._activeProgram3D = null;
	this._antiAlias = 0;
	this._renderTarget = null;
	this._enterFrame = null;
	this._exitFrame = null;
	this._contextRequested = false;
	this._color = 0;
	this._enableDepthAndStencil = false;
	this._viewportDirty = false;
	this._bufferClear = false;
	this._iContext3D = null;
	this._backBufferDirty = false;
	this._scissorRect = null;
	this._viewPort = null;
	this._profile = null;
	this._mouse3DManager = null;
	this._backBufferHeight = 0;
	this._backBufferWidth = 0;
	this._usesSoftwareRendering = false;
	forceSoftware = forceSoftware || false;
	profile = profile || "baseline";
	away.events.EventDispatcher.call(this);
	this._iStage3DIndex = stage3DIndex;
	this._stage3D = stage3D;
	this._stage3D.set_x(0);
	this._stage3D.set_y(0);
	this._stage3D.set_visible(true);
	this._stage3DManager = stage3DManager;
	this._viewPort = new away.geom.Rectangle(0, 0, 0, 0);
	this._enableDepthAndStencil = true;
	this._stage3D.addEventListener(away.events.Event.CONTEXT3D_CREATE, $createStaticDelegate(this, this.onContext3DUpdate), this);
	this.requestContext(forceSoftware, this.get_profile());
};

away.managers.Stage3DProxy.prototype.notifyViewportUpdated = function() {
	if (this._viewportDirty) {
		return;
	}
	this._viewportDirty = true;
	this._viewportUpdated = new away.events.Stage3DEvent(away.events.Stage3DEvent.VIEWPORT_UPDATED);
	this.dispatchEvent(this._viewportUpdated);
};

away.managers.Stage3DProxy.prototype.notifyEnterFrame = function() {
	if (!this._enterFrame) {
		this._enterFrame = new away.events.Event(away.events.Event.ENTER_FRAME);
	}
	this.dispatchEvent(this._enterFrame);
};

away.managers.Stage3DProxy.prototype.notifyExitFrame = function() {
	if (!this._exitFrame)
		this._exitFrame = new away.events.Event(away.events.Event.EXIT_FRAME);
	this.dispatchEvent(this._exitFrame);
};

away.managers.Stage3DProxy.prototype.get_profile = function() {
	return this._profile;
};

away.managers.Stage3DProxy.prototype.dispose = function() {
	this._stage3DManager.iRemoveStage3DProxy(this);
	this._stage3D.removeEventListener(away.events.Event.CONTEXT3D_CREATE, $createStaticDelegate(this, this.onContext3DUpdate), this);
	this.freeContext3D();
	this._stage3D = null;
	this._stage3DManager = null;
	this._iStage3DIndex = -1;
};

away.managers.Stage3DProxy.prototype.configureBackBuffer = function(backBufferWidth, backBufferHeight, antiAlias, enableDepthAndStencil) {
	var oldWidth = this._backBufferWidth;
	var oldHeight = this._backBufferHeight;
	this._backBufferWidth = backBufferWidth;
	this._viewPort.width = backBufferWidth;
	this._backBufferHeight = backBufferHeight;
	this._viewPort.height = backBufferHeight;
	if (oldWidth != this._backBufferWidth || oldHeight != this._backBufferHeight)
		this.notifyViewportUpdated();
	this._antiAlias = antiAlias;
	this._enableDepthAndStencil = enableDepthAndStencil;
	if (this._iContext3D)
		this._iContext3D.configureBackBuffer(backBufferWidth, backBufferHeight, antiAlias, enableDepthAndStencil);
	this._stage3D.set_width(backBufferWidth);
	this._stage3D.set_height(backBufferHeight);
};

away.managers.Stage3DProxy.prototype.get_enableDepthAndStencil = function() {
	return this._enableDepthAndStencil;
};

away.managers.Stage3DProxy.prototype.set_enableDepthAndStencil = function(enableDepthAndStencil) {
	this._enableDepthAndStencil = enableDepthAndStencil;
	this._backBufferDirty = true;
};

away.managers.Stage3DProxy.prototype.get_renderTarget = function() {
	return this._renderTarget;
};

away.managers.Stage3DProxy.prototype.get_renderSurfaceSelector = function() {
	return this._renderSurfaceSelector;
};

away.managers.Stage3DProxy.prototype.setRenderTarget = function(target, enableDepthAndStencil, surfaceSelector) {
	enableDepthAndStencil = enableDepthAndStencil || false;
	surfaceSelector = surfaceSelector || 0;
	if (this._renderTarget === target && surfaceSelector == this._renderSurfaceSelector && this._enableDepthAndStencil == enableDepthAndStencil) {
		return;
	}
	this._renderTarget = target;
	this._renderSurfaceSelector = surfaceSelector;
	this._enableDepthAndStencil = enableDepthAndStencil;
	away.utils.Debug.throwPIR("Stage3DProxy", "setRenderTarget", "away.display3D.Context3D: setRenderToTexture , setRenderToBackBuffer");
};

away.managers.Stage3DProxy.prototype.clear = function() {
	if (!this._iContext3D)
		return;
	if (this._backBufferDirty) {
		this.configureBackBuffer(this._backBufferWidth, this._backBufferHeight, this._antiAlias, this._enableDepthAndStencil);
		this._backBufferDirty = false;
	}
	this._iContext3D.clear((this._color & 0xff000000) >>> 24, (this._color & 0xff0000) >>> 16, (this._color & 0xff00) >>> 8, this._color & 0xff, 1, 0, 17664);
	this._bufferClear = true;
};

away.managers.Stage3DProxy.prototype.present = function() {
	if (!this._iContext3D)
		return;
	this._iContext3D.present();
	this._activeProgram3D = null;
	if (this._mouse3DManager)
		this._mouse3DManager.fireMouseEvents();
};

away.managers.Stage3DProxy.prototype.addEventListener = function(type, listener, target) {
	away.events.EventDispatcher.prototype.addEventListener.call(this,type, $createStaticDelegate(this, listener), target);
};

away.managers.Stage3DProxy.prototype.removeEventListener = function(type, listener, target) {
	away.events.EventDispatcher.prototype.removeEventListener.call(this,type, $createStaticDelegate(this, listener), target);
};

away.managers.Stage3DProxy.prototype.get_scissorRect = function() {
	return this._scissorRect;
};

away.managers.Stage3DProxy.prototype.set_scissorRect = function(value) {
	this._scissorRect = value;
	this._iContext3D.setScissorRectangle(this._scissorRect);
};

away.managers.Stage3DProxy.prototype.get_stage3DIndex = function() {
	return this._iStage3DIndex;
};

away.managers.Stage3DProxy.prototype.get_stage3D = function() {
	return this._stage3D;
};

away.managers.Stage3DProxy.prototype.get_context3D = function() {
	return this._iContext3D;
};

away.managers.Stage3DProxy.prototype.get_usesSoftwareRendering = function() {
	return this._usesSoftwareRendering;
};

away.managers.Stage3DProxy.prototype.get_x = function() {
	return this._stage3D.get_x();
};

away.managers.Stage3DProxy.prototype.set_x = function(value) {
	if (this._viewPort.x == value)
		return;
	this._stage3D.set_x(value);
	this._viewPort.x = value;
	this.notifyViewportUpdated();
};

away.managers.Stage3DProxy.prototype.get_y = function() {
	return this._stage3D.get_y();
};

away.managers.Stage3DProxy.prototype.set_y = function(value) {
	if (this._viewPort.y == value)
		return;
	this._stage3D.set_y(value);
	this._viewPort.y = value;
	this.notifyViewportUpdated();
};

away.managers.Stage3DProxy.prototype.get_canvas = function() {
	return this._stage3D.get_canvas();
};

away.managers.Stage3DProxy.prototype.get_width = function() {
	return this._backBufferWidth;
};

away.managers.Stage3DProxy.prototype.set_width = function(width) {
	if (this._viewPort.width == width)
		return;
	this._stage3D.set_width(width);
	this._backBufferWidth = width;
	this._viewPort.width = width;
	this._backBufferDirty = true;
	this.notifyViewportUpdated();
};

away.managers.Stage3DProxy.prototype.get_height = function() {
	return this._backBufferHeight;
};

away.managers.Stage3DProxy.prototype.set_height = function(height) {
	if (this._viewPort.height == height)
		return;
	this._stage3D.set_height(height);
	this._backBufferHeight = height;
	this._viewPort.height = height;
	this._backBufferDirty = true;
	this.notifyViewportUpdated();
};

away.managers.Stage3DProxy.prototype.get_antiAlias = function() {
	return this._antiAlias;
};

away.managers.Stage3DProxy.prototype.set_antiAlias = function(antiAlias) {
	this._antiAlias = antiAlias;
	this._backBufferDirty = true;
};

away.managers.Stage3DProxy.prototype.get_viewPort = function() {
	this._viewportDirty = false;
	return this._viewPort;
};

away.managers.Stage3DProxy.prototype.get_color = function() {
	return this._color;
};

away.managers.Stage3DProxy.prototype.set_color = function(color) {
	this._color = color;
};

away.managers.Stage3DProxy.prototype.get_visible = function() {
	return this._stage3D.get_visible();
};

away.managers.Stage3DProxy.prototype.set_visible = function(value) {
	this._stage3D.set_visible(value);
};

away.managers.Stage3DProxy.prototype.get_bufferClear = function() {
	return this._bufferClear;
};

away.managers.Stage3DProxy.prototype.set_bufferClear = function(newBufferClear) {
	this._bufferClear = newBufferClear;
};

away.managers.Stage3DProxy.prototype.get_mouse3DManager = function() {
	return this._mouse3DManager;
};

away.managers.Stage3DProxy.prototype.set_mouse3DManager = function(value) {
	this._mouse3DManager = value;
};

away.managers.Stage3DProxy.prototype.freeContext3D = function() {
	if (this._iContext3D) {
		this._iContext3D.dispose();
		this.dispatchEvent(new away.events.Stage3DEvent(away.events.Stage3DEvent.CONTEXT3D_DISPOSED));
	}
	this._iContext3D = null;
};

away.managers.Stage3DProxy.prototype.onContext3DUpdate = function(event) {
	if (this._stage3D.get_context3D()) {
		var hadContext = (this._iContext3D != null);
		this._iContext3D = this._stage3D.get_context3D();
		if (this._backBufferWidth && this._backBufferHeight) {
			this._iContext3D.configureBackBuffer(this._backBufferWidth, this._backBufferHeight, this._antiAlias, this._enableDepthAndStencil);
		}
		this.dispatchEvent(new away.events.Stage3DEvent(hadContext ? away.events.Stage3DEvent.CONTEXT3D_RECREATED : away.events.Stage3DEvent.CONTEXT3D_CREATED));
	} else {
		throw new Error("Rendering context lost!", 0);
	}
};

away.managers.Stage3DProxy.prototype.requestContext = function(forceSoftware, profile) {
	forceSoftware = forceSoftware || false;
	profile = profile || "baseline";
	if (this._usesSoftwareRendering != null) {
		this._usesSoftwareRendering = forceSoftware;
	}
	this._profile = profile;
	this._stage3D.requestContext(true);
};

away.managers.Stage3DProxy.prototype.onEnterFrame = function(event) {
	if (!this._iContext3D) {
		return;
	}
	this.clear();
	this.notifyEnterFrame();
	this.present();
	this.notifyExitFrame();
};

away.managers.Stage3DProxy.prototype.recoverFromDisposal = function() {
	if (!this._iContext3D) {
		return false;
	}
	return true;
};

away.managers.Stage3DProxy.prototype.clearDepthBuffer = function() {
	if (!this._iContext3D) {
		return;
	}
	this._iContext3D.clear(0, 0, 0, 1, 1, 0, away.display3D.Context3DClearMask.DEPTH);
};

$inherit(away.managers.Stage3DProxy, away.events.EventDispatcher);

away.managers.Stage3DProxy.className = "away.managers.Stage3DProxy";

away.managers.Stage3DProxy.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.utils.Debug');
	p.push('away.events.Stage3DEvent');
	p.push('away.events.Event');
	p.push('away.display3D.Context3DClearMask');
	p.push('away.geom.Rectangle');
	return p;
};

away.managers.Stage3DProxy.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.managers.Stage3DProxy.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'stage3DIndex', t:'Number'});
			p.push({n:'stage3D', t:'away.display.Stage3D'});
			p.push({n:'stage3DManager', t:'away.managers.Stage3DManager'});
			p.push({n:'forceSoftware', t:'Boolean'});
			p.push({n:'profile', t:'String'});
			break;
		case 1:
			p = away.events.EventDispatcher.injectionPoints(t);
			break;
		case 2:
			p = away.events.EventDispatcher.injectionPoints(t);
			break;
		case 3:
			p = away.events.EventDispatcher.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

