/** Compiled by the Randori compiler v0.2.6.2 on Thu Sep 05 22:19:22 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.lights == "undefined")
	away.lights = {};
if (typeof away.lights.shadowmaps == "undefined")
	away.lights.shadowmaps = {};

away.lights.shadowmaps.CubeMapShadowMapper = function() {
	this._needsRender = null;
	this._depthCameras = null;
	this._lenses = null;
	away.lights.shadowmaps.ShadowMapperBase.call(this);
	this._pDepthMapSize = 512;
	this._needsRender = [];
	this.initCameras();
};

away.lights.shadowmaps.CubeMapShadowMapper.prototype.initCameras = function() {
	this._depthCameras = [];
	this._lenses = [];
	this.addCamera(0, 90, 0);
	this.addCamera(0, -90, 0);
	this.addCamera(-90, 0, 0);
	this.addCamera(90, 0, 0);
	this.addCamera(0, 0, 0);
	this.addCamera(0, 180, 0);
};

away.lights.shadowmaps.CubeMapShadowMapper.prototype.addCamera = function(rotationX, rotationY, rotationZ) {
	var cam = new away.cameras.Camera3D();
	cam.set_rotationX(rotationX);
	cam.set_rotationY(rotationY);
	cam.set_rotationZ(rotationZ);
	cam.get_lens().set_near(.01);
	var lens = cam.get_lens();
	lens.set_fieldOfView(90);
	this._lenses.push(lens);
	cam.get_lens().set_iAspectRatio(1);
	this._depthCameras.push(cam);
};

away.lights.shadowmaps.CubeMapShadowMapper.prototype.pCreateDepthTexture = function() {
	throw new away.errors.PartialImplementationError("", 0);
};

away.lights.shadowmaps.CubeMapShadowMapper.prototype.pUpdateDepthProjection = function(viewCamera) {
	var light = this._pLight;
	var maxDistance = light._pFallOff;
	var pos = this._pLight.get_scenePosition();
	for (var i = 0; i < 6; ++i) {
		this._lenses[i].far = maxDistance;
		this._depthCameras[i].position = pos;
		this._needsRender[i] = true;
	}
};

away.lights.shadowmaps.CubeMapShadowMapper.prototype.pDrawDepthMap = function(target, scene, renderer) {
	for (var i = 0; i < 6; ++i) {
		if (this._needsRender[i]) {
			this._pCasterCollector.set_camera(this._depthCameras[i]);
			this._pCasterCollector.clear();
			scene.traversePartitions(this._pCasterCollector);
			renderer.iRender(this._pCasterCollector, target, null, i);
			this._pCasterCollector.cleanUp();
		}
	}
};

$inherit(away.lights.shadowmaps.CubeMapShadowMapper, away.lights.shadowmaps.ShadowMapperBase);

away.lights.shadowmaps.CubeMapShadowMapper.className = "away.lights.shadowmaps.CubeMapShadowMapper";

away.lights.shadowmaps.CubeMapShadowMapper.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.errors.PartialImplementationError');
	p.push('away.cameras.Camera3D');
	return p;
};

away.lights.shadowmaps.CubeMapShadowMapper.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.lights.shadowmaps.CubeMapShadowMapper.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 1:
			p = away.lights.shadowmaps.ShadowMapperBase.injectionPoints(t);
			break;
		case 2:
			p = away.lights.shadowmaps.ShadowMapperBase.injectionPoints(t);
			break;
		case 3:
			p = away.lights.shadowmaps.ShadowMapperBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

