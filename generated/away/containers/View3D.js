/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 21 16:02:40 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.containers == "undefined")
	away.containers = {};

away.containers.View3D = function(scene, camera, renderer, forceSoftware, profile) {
	this._scissorRectDirty = true;
	this._pRenderer = null;
	this._deltaTime = 0;
	this._depthPrepass = false;
	this._pStage3DProxy = null;
	this._pDepthRender = null;
	this._forceSoftware = null;
	this._localPos = new away.geom.Point(0, 0);
	this._aspectRatio = 0;
	this._antiAlias = 0;
	this._time = 0;
	this.sStage = null;
	this._globalPos = new away.geom.Point(0, 0);
	this._backgroundColor = 0x000000;
	this._width = 0;
	this._addedToStage = null;
	this._pFilter3DRenderer = null;
	this._layeredView = false;
	this._viewportDirty = true;
	this._globalPosDirty = null;
	this._pShareContext = false;
	this._pScene = null;
	this._depthTextureInvalid = true;
	this.stage = null;
	this._backgroundAlpha = 1;
	this._height = 0;
	this._depthRenderer = null;
	this._pRttBufferManager = null;
	this._pBackBufferInvalid = true;
	this._pScissorRect = null;
	this._pCamera = null;
	this._pRequireDepthRender = null;
	this._profile = null;
	this._pEntityCollector = null;
	if (away.containers.View3D.sStage == null) {
		away.containers.View3D.sStage = new away.display.Stage(640, 480);
	}
	this._profile = profile;
	this._pScene = scene || new away.containers.Scene3D();
	this._pScene.addEventListener(away.events.Scene3DEvent.PARTITION_CHANGED, $createStaticDelegate(this, this.onScenePartitionChanged), this);
	this._pCamera = camera || new away.cameras.Camera3D();
	this._pRenderer = renderer || new away.render.DefaultRenderer();
	this._depthRenderer = new away.render.DepthRenderer(false, false);
	this._forceSoftware = forceSoftware;
	this._pEntityCollector = this._pRenderer.iCreateEntityCollector();
	this._pEntityCollector.set_camera(this._pCamera);
	this._pScissorRect = new away.geom.Rectangle(0, 0, 0, 0);
	this._pCamera.addEventListener(away.events.CameraEvent.LENS_CHANGED, $createStaticDelegate(this, this.onLensChanged), this);
	this._pCamera.set_partition(this._pScene.get_partition());
	this.stage = away.containers.View3D.sStage;
	this.onAddedToStage();
};

away.containers.View3D.sStage;

away.containers.View3D.prototype.onScenePartitionChanged = function(e) {
	if (this._pCamera) {
		this._pCamera.set_partition(this.get_scene().get_partition());
	}
};

away.containers.View3D.prototype.get_stage3DProxy = function() {
	return this._pStage3DProxy;
};

away.containers.View3D.prototype.set_stage3DProxy = function(stage3DProxy) {
	if (this._pStage3DProxy) {
		this._pStage3DProxy.removeEventListener(away.events.Stage3DEvent.VIEWPORT_UPDATED, $createStaticDelegate(this, this.onViewportUpdated), this);
	}
	this._pStage3DProxy = stage3DProxy;
	this._pStage3DProxy.addEventListener(away.events.Stage3DEvent.VIEWPORT_UPDATED, $createStaticDelegate(this, this.onViewportUpdated), this);
	this._pRenderer.set_iStage3DProxy(this._pStage3DProxy);
	this._depthRenderer.set_iStage3DProxy(this._pStage3DProxy);
	this._globalPosDirty = true;
	this._pBackBufferInvalid = true;
};

away.containers.View3D.prototype.get_layeredView = function() {
	return this._layeredView;
};

away.containers.View3D.prototype.set_layeredView = function(value) {
	this._layeredView = value;
};

away.containers.View3D.prototype.get_filters3d = function() {
	return this._pFilter3DRenderer ? this._pFilter3DRenderer.get_filters() : null;
};

away.containers.View3D.prototype.set_filters3d = function(value) {
	if (value && value.length == 0)
		value = null;
	if (this._pFilter3DRenderer && !value) {
		this._pFilter3DRenderer.dispose();
		this._pFilter3DRenderer = null;
	} else if (!this._pFilter3DRenderer && value) {
		this._pFilter3DRenderer = new away.render.Filter3DRenderer(this._pStage3DProxy);
		this._pFilter3DRenderer.set_filters(value);
	}
	if (this._pFilter3DRenderer) {
		this._pFilter3DRenderer.set_filters(value);
		this._pRequireDepthRender = this._pFilter3DRenderer.get_requireDepthRender();
	} else {
		this._pRequireDepthRender = false;
		if (this._pDepthRender) {
			this._pDepthRender.dispose();
			this._pDepthRender = null;
		}
	}
};

away.containers.View3D.prototype.get_renderer = function() {
	return this._pRenderer;
};

away.containers.View3D.prototype.set_renderer = function(value) {
	this._pRenderer.iDispose();
	this._pRenderer = value;
	this._pEntityCollector = this._pRenderer.iCreateEntityCollector();
	this._pEntityCollector.set_camera(this._pCamera);
	this._pRenderer.set_iStage3DProxy(this._pStage3DProxy);
	this._pRenderer.set_antiAlias(this._antiAlias);
	this._pRenderer.set_iBackgroundR(((this._backgroundColor >> 16) & 0xff) / 0xff);
	this._pRenderer.set_iBackgroundG(((this._backgroundColor >> 8) & 0xff) / 0xff);
	this._pRenderer.set_iBackgroundB((this._backgroundColor & 0xff) / 0xff);
	this._pRenderer.set_iBackgroundAlpha(this._backgroundAlpha);
	this._pRenderer.set_iViewWidth(this._width);
	this._pRenderer.set_iViewHeight(this._height);
	this._pBackBufferInvalid = true;
};

away.containers.View3D.prototype.get_backgroundColor = function() {
	return this._backgroundColor;
};

away.containers.View3D.prototype.set_backgroundColor = function(value) {
	this._backgroundColor = value;
	this._pRenderer.set_iBackgroundR(((value >> 16) & 0xff) / 0xff);
	this._pRenderer.set_iBackgroundG(((value >> 8) & 0xff) / 0xff);
	this._pRenderer.set_iBackgroundB((value & 0xff) / 0xff);
};

away.containers.View3D.prototype.get_backgroundAlpha = function() {
	return this._backgroundAlpha;
};

away.containers.View3D.prototype.set_backgroundAlpha = function(value) {
	if (value > 1) {
		value = 1;
	} else if (value < 0) {
		value = 0;
	}
	this._pRenderer.set_iBackgroundAlpha(value);
	this._backgroundAlpha = value;
};

away.containers.View3D.prototype.get_camera = function() {
	return this._pCamera;
};

away.containers.View3D.prototype.set_camera = function(camera) {
	this._pCamera.removeEventListener(away.events.CameraEvent.LENS_CHANGED, $createStaticDelegate(this, this.onLensChanged), this);
	this._pCamera = camera;
	this._pEntityCollector.set_camera(this._pCamera);
	if (this._pScene) {
		this._pCamera.set_partition(this._pScene.get_partition());
	}
	this._pCamera.addEventListener(away.events.CameraEvent.LENS_CHANGED, $createStaticDelegate(this, this.onLensChanged), this);
	this._scissorRectDirty = true;
	this._viewportDirty = true;
};

away.containers.View3D.prototype.get_scene = function() {
	return this._pScene;
};

away.containers.View3D.prototype.set_scene = function(scene) {
	this._pScene.removeEventListener(away.events.Scene3DEvent.PARTITION_CHANGED, $createStaticDelegate(this, this.onScenePartitionChanged), this);
	this._pScene = scene;
	this._pScene.addEventListener(away.events.Scene3DEvent.PARTITION_CHANGED, $createStaticDelegate(this, this.onScenePartitionChanged), this);
	if (this._pCamera) {
		this._pCamera.set_partition(this._pScene.get_partition());
	}
};

away.containers.View3D.prototype.get_deltaTime = function() {
	return this._deltaTime;
};

away.containers.View3D.prototype.get_width = function() {
	return this._width;
};

away.containers.View3D.prototype.set_width = function(value) {
	if (this._width == value) {
		return;
	}
	if (this._pRttBufferManager) {
		this._pRttBufferManager.set_viewWidth(value);
	}
	this._width = value;
	this._aspectRatio = this._width / this._height;
	this._pCamera.get_lens().set_iAspectRatio(this._aspectRatio);
	this._depthTextureInvalid = true;
	this._pRenderer.set_iViewWidth(value);
	this._pScissorRect.width = value;
	this._pBackBufferInvalid = true;
	this._scissorRectDirty = true;
};

away.containers.View3D.prototype.get_height = function() {
	return this._height;
};

away.containers.View3D.prototype.set_height = function(value) {
	if (this._height == value) {
		return;
	}
	if (this._pRttBufferManager) {
		this._pRttBufferManager.set_viewHeight(value);
	}
	this._height = value;
	this._aspectRatio = this._width / this._height;
	this._pCamera.get_lens().set_iAspectRatio(this._aspectRatio);
	this._depthTextureInvalid = true;
	this._pRenderer.set_iViewHeight(value);
	this._pScissorRect.height = value;
	this._pBackBufferInvalid = true;
	this._scissorRectDirty = true;
};

away.containers.View3D.prototype.set_x = function(value) {
	if (this.get_x() == value)
		return;
	this._globalPos.x = value;
	this._localPos.x = value;
	this._globalPosDirty = true;
};

away.containers.View3D.prototype.set_y = function(value) {
	if (this.get_y() == value)
		return;
	this._globalPos.y = value;
	this._localPos.y = value;
	this._globalPosDirty = true;
};

away.containers.View3D.prototype.get_x = function() {
	return this._localPos.x;
};

away.containers.View3D.prototype.get_y = function() {
	return this._localPos.y;
};

away.containers.View3D.prototype.get_visible = function() {
	return true;
};

away.containers.View3D.prototype.set_visible = function(v) {
};

away.containers.View3D.prototype.get_canvas = function() {
	return this._pStage3DProxy.get_canvas();
};

away.containers.View3D.prototype.get_antiAlias = function() {
	return this._antiAlias;
};

away.containers.View3D.prototype.set_antiAlias = function(value) {
	this._antiAlias = value;
	this._pRenderer.set_antiAlias(value);
	this._pBackBufferInvalid = true;
};

away.containers.View3D.prototype.get_renderedFacesCount = function() {
	return this._pEntityCollector._pNumTriangles;
};

away.containers.View3D.prototype.get_shareContext = function() {
	return this._pShareContext;
};

away.containers.View3D.prototype.set_shareContext = function(value) {
	if (this._pShareContext == value) {
		return;
	}
	this._pShareContext = value;
	this._globalPosDirty = true;
};

away.containers.View3D.prototype.pUpdateBackBuffer = function() {
	if (this._pStage3DProxy._iContext3D && !this._pShareContext) {
		if (this._width && this._height) {
			this._pStage3DProxy.configureBackBuffer(this._width, this._height, this._antiAlias, true);
			this._pBackBufferInvalid = false;
		}
	}
};

away.containers.View3D.prototype.render = function() {
	if (!this._pStage3DProxy.recoverFromDisposal()) {
		this._pBackBufferInvalid = true;
		return;
	}
	if (this._pBackBufferInvalid) {
		this.pUpdateBackBuffer();
	}
	if (this._pShareContext && this._layeredView) {
		this._pStage3DProxy.clearDepthBuffer();
	}
	if (this._globalPosDirty) {
		this.pUpdateGlobalPos();
	}
	this.pUpdateTime();
	this.pUpdateViewSizeData();
	this._pEntityCollector.clear();
	this._pScene.traversePartitions(this._pEntityCollector);
	if (this._pRequireDepthRender) {
		this.pRenderSceneDepthToTexture(this._pEntityCollector);
	}
	if (this._depthPrepass) {
		this.pRenderDepthPrepass(this._pEntityCollector);
	}
	this._pRenderer.set_iClearOnRender(!this._depthPrepass);
	if (this._pFilter3DRenderer && this._pStage3DProxy._iContext3D) {
		this._pRenderer.iRender(this._pEntityCollector, this._pFilter3DRenderer.getMainInputTexture(this._pStage3DProxy), this._pRttBufferManager.get_renderToTextureRect(), 0);
		this._pFilter3DRenderer.render(this._pStage3DProxy, this._pCamera, this._pDepthRender);
	} else {
		this._pRenderer.set_iShareContext(this._pShareContext);
		if (this._pShareContext) {
			this._pRenderer.iRender(this._pEntityCollector, null, this._pScissorRect, 0);
		} else {
			this._pRenderer.iRender(this._pEntityCollector, null, null, 0);
		}
	}
	if (!this._pShareContext) {
		this._pStage3DProxy.present();
	}
	this._pEntityCollector.cleanUp();
	this._pStage3DProxy.set_bufferClear(false);
};

away.containers.View3D.prototype.pUpdateGlobalPos = function() {
	this._globalPosDirty = false;
	if (!this._pStage3DProxy) {
		return;
	}
	if (this._pShareContext) {
		this._pScissorRect.x = this._globalPos.x - this._pStage3DProxy.get_x();
		this._pScissorRect.y = this._globalPos.y - this._pStage3DProxy.get_y();
	} else {
		this._pScissorRect.x = 0;
		this._pScissorRect.y = 0;
		this._pStage3DProxy.set_x(this._globalPos.x);
		this._pStage3DProxy.set_y(this._globalPos.y);
	}
	this._scissorRectDirty = true;
};

away.containers.View3D.prototype.pUpdateTime = function() {
	var time = new Date().getTime();
	if (this._time == 0) {
		this._time = time;
	}
	this._deltaTime = time - this._time;
	this._time = time;
};

away.containers.View3D.prototype.pUpdateViewSizeData = function() {
	this._pCamera.get_lens().set_iAspectRatio(this._aspectRatio);
	if (this._scissorRectDirty) {
		this._scissorRectDirty = false;
		this._pCamera.get_lens().iUpdateScissorRect(this._pScissorRect.x, this._pScissorRect.y, this._pScissorRect.width, this._pScissorRect.height);
	}
	if (this._viewportDirty) {
		this._viewportDirty = false;
		this._pCamera.get_lens().iUpdateViewport(this._pStage3DProxy.get_viewPort().x, this._pStage3DProxy.get_viewPort().y, this._pStage3DProxy.get_viewPort().width, this._pStage3DProxy.get_viewPort().height);
	}
	if (this._pFilter3DRenderer || this._pRenderer.get_iRenderToTexture()) {
		this._pRenderer.set_iTextureRatioX(this._pRttBufferManager.get_textureRatioX());
		this._pRenderer.set_iTextureRatioY(this._pRttBufferManager.get_textureRatioY());
	} else {
		this._pRenderer.set_iTextureRatioX(1);
		this._pRenderer.set_iTextureRatioY(1);
	}
};

away.containers.View3D.prototype.pRenderDepthPrepass = function(entityCollector) {
	this._depthRenderer.set_disableColor(true);
	if (this._pFilter3DRenderer || this._pRenderer.get_iRenderToTexture()) {
		this._depthRenderer.set_iTextureRatioX(this._pRttBufferManager.get_textureRatioX());
		this._depthRenderer.set_iTextureRatioY(this._pRttBufferManager.get_textureRatioY());
		this._depthRenderer.iRender(entityCollector, this._pFilter3DRenderer.getMainInputTexture(this._pStage3DProxy), this._pRttBufferManager.get_renderToTextureRect(), 0);
	} else {
		this._depthRenderer.set_iTextureRatioX(1);
		this._depthRenderer.set_iTextureRatioY(1);
		this._depthRenderer.iRender(entityCollector, null, null, 0);
	}
	this._depthRenderer.set_disableColor(false);
};

away.containers.View3D.prototype.pRenderSceneDepthToTexture = function(entityCollector) {
	if (this._depthTextureInvalid || !this._pDepthRender) {
		this.initDepthTexture(this._pStage3DProxy._iContext3D);
	}
	this._depthRenderer.set_iTextureRatioX(this._pRttBufferManager.get_textureRatioX());
	this._depthRenderer.set_iTextureRatioY(this._pRttBufferManager.get_textureRatioY());
	this._depthRenderer.iRender(entityCollector, this._pDepthRender, null, 0);
};

away.containers.View3D.prototype.initDepthTexture = function(context) {
	this._depthTextureInvalid = false;
	if (this._pDepthRender) {
		this._pDepthRender.dispose();
	}
	this._pDepthRender = context.createTexture(this._pRttBufferManager.get_textureWidth(), this._pRttBufferManager.get_textureHeight(), away.display3D.Context3DTextureFormat.BGRA, true, 0);
};

away.containers.View3D.prototype.dispose = function() {
	this._pStage3DProxy.removeEventListener(away.events.Stage3DEvent.VIEWPORT_UPDATED, $createStaticDelegate(this, this.onViewportUpdated), this);
	if (!this.get_shareContext()) {
		this._pStage3DProxy.dispose();
	}
	this._pRenderer.iDispose();
	if (this._pDepthRender) {
		this._pDepthRender.dispose();
	}
	if (this._pRttBufferManager) {
		this._pRttBufferManager.dispose();
	}
	this._pRttBufferManager = null;
	this._pDepthRender = null;
	this._depthRenderer = null;
	this._pStage3DProxy = null;
	this._pRenderer = null;
	this._pEntityCollector = null;
};

away.containers.View3D.prototype.get_iEntityCollector = function() {
	return this._pEntityCollector;
};

away.containers.View3D.prototype.onLensChanged = function(event) {
	this._scissorRectDirty = true;
	this._viewportDirty = true;
};

away.containers.View3D.prototype.onViewportUpdated = function(event) {
	if (this._pShareContext) {
		this._pScissorRect.x = this._globalPos.x - this._pStage3DProxy.get_x();
		this._pScissorRect.y = this._globalPos.y - this._pStage3DProxy.get_y();
		this._scissorRectDirty = true;
	}
	this._viewportDirty = true;
};

away.containers.View3D.prototype.get_depthPrepass = function() {
	return this._depthPrepass;
};

away.containers.View3D.prototype.set_depthPrepass = function(value) {
	this._depthPrepass = value;
};

away.containers.View3D.prototype.onAddedToStage = function() {
	this._addedToStage = true;
	if (this._pStage3DProxy == null) {
		this._pStage3DProxy = away.managers.Stage3DManager.getInstance(this.stage).getFreeStage3DProxy(this._forceSoftware, this._profile);
		this._pStage3DProxy.addEventListener(away.events.Stage3DEvent.VIEWPORT_UPDATED, $createStaticDelegate(this, this.onViewportUpdated), this);
	}
	this._globalPosDirty = true;
	this._pRttBufferManager = away.managers.RTTBufferManager.getInstance(this._pStage3DProxy);
	this._pRenderer.set_iStage3DProxy(this._pStage3DProxy);
	this._depthRenderer.set_iStage3DProxy(this._pStage3DProxy);
	if (this._width == 0) {
		this.set_width(this.stage.get_stageWidth());
	} else {
		this._pRttBufferManager.set_viewWidth(this._width);
	}
	if (this._height == 0) {
		this.set_height(this.stage.get_stageHeight());
	} else {
		this._pRttBufferManager.set_viewHeight(this._height);
	}
};

away.containers.View3D.prototype.project = function(point3d) {
	var v = this._pCamera.project(point3d);
	v.x = (v.x + 1.0) * this._width / 2.0;
	v.y = (v.y + 1.0) * this._height / 2.0;
	return v;
};

away.containers.View3D.prototype.unproject = function(sX, sY, sZ) {
	return this._pCamera.unproject((sX * 2 - this._width) / this._pStage3DProxy.get_width(), (sY * 2 - this._height) / this._pStage3DProxy.get_height(), sZ);
};

away.containers.View3D.prototype.getRay = function(sX, sY, sZ) {
	return this._pCamera.getRay((sX * 2 - this._width) / this._width, (sY * 2 - this._height) / this._height, sZ);
};

away.containers.View3D.className = "away.containers.View3D";

away.containers.View3D.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.events.Stage3DEvent');
	p.push('away.managers.Stage3DManager');
	p.push('away.render.DefaultRenderer');
	p.push('away.containers.Scene3D');
	p.push('away.render.DepthRenderer');
	p.push('away.cameras.Camera3D');
	p.push('away.display.Stage');
	p.push('away.managers.RTTBufferManager');
	p.push('away.events.Scene3DEvent');
	p.push('away.managers.Stage3DProxy');
	p.push('away.events.CameraEvent');
	p.push('away.render.Filter3DRenderer');
	p.push('away.geom.Rectangle');
	p.push('away.display3D.Context3DTextureFormat');
	return p;
};

away.containers.View3D.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.Point');
	return p;
};

away.containers.View3D.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'scene', t:'away.containers.Scene3D'});
			p.push({n:'camera', t:'away.cameras.Camera3D'});
			p.push({n:'renderer', t:'away.render.RendererBase'});
			p.push({n:'forceSoftware', t:'Boolean'});
			p.push({n:'profile', t:'String'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

