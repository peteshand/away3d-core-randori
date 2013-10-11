/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:08 EST 2013 */

if (typeof examples == "undefined")
	var examples = {};

examples.AWDSuzanneLights = function(_index) {
	this.lastTiltAngle = 0;
	this.hoverControl = null;
	this.lastPanAngle = 0;
	this.lightPicker = null;
	this.token = null;
	this.lastMouseY = 0;
	this.lastMouseX = 0;
	this.suzane = null;
	this.light = null;
	this.move = false;
	examples.BaseExample.call(this, _index);
	away.utils.Debug.LOG_PI_ERRORS = true;
	away.utils.Debug.THROW_ERRORS = false;
	away.library.AssetLibrary.enableParser(away.loaders.parsers.AWDParser);
	this.token = away.library.AssetLibrary.load(new away.core.net.URLRequest("assets\/suzanne.awd"));
	this.token.addEventListener(away.events.LoaderEvent.RESOURCE_COMPLETE, $createStaticDelegate(this, this.onResourceComplete), this);
	this.token.addEventListener(away.events.AssetEvent.ASSET_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	this.view = new away.containers.View3D(null, null, null, false, "baseline");
	this.view.set_backgroundColor(0x666666);
	this.light = new away.lights.DirectionalLight(0, -1, 1);
	this.light.set_color(0x683019);
	this.light.set_direction(new away.core.geom.Vector3D(1, 0, 0, 0));
	this.light.set_ambient(0.1);
	this.light.set_ambientColor(0x85b2cd);
	this.light.set_diffuse(2.8);
	this.light.set_specular(1.8);
	this.view.get_scene().addChild(this.light);
	this.lightPicker = new away.materials.lightpickers.StaticLightPicker([this.light]);
};

examples.AWDSuzanneLights.prototype.resize = function() {
	if (this.view) {
		this.view.set_y(0);
		this.view.set_x(0);
		this.view.set_width(window.innerWidth);
		this.view.set_height(window.innerHeight);
	}
};

examples.AWDSuzanneLights.prototype.tick = function(dt) {
	console.log("tick");
	if (this.suzane) {
		this.suzane.set_rotationY(this.suzane.get_rotationY() + 1);
		this.view.render();
	}
	if (this.hoverControl) {
		this.hoverControl.update(false);
	}
};

examples.AWDSuzanneLights.prototype.onAssetComplete = function(e) {
	console.log("------------------------------------------------------------------------------");
	console.log("AssetEvent.ASSET_COMPLETE", away.library.AssetLibrary.getAsset(e.get_asset().get_name()));
	console.log("------------------------------------------------------------------------------");
};

examples.AWDSuzanneLights.prototype.onResourceComplete = function(e) {
	console.log("------------------------------------------------------------------------------");
	console.log("LoaderEvent.RESOURCE_COMPLETE", e);
	console.log("------------------------------------------------------------------------------");
	var loader = e.target;
	var numAssets = loader.get_baseDependency().get_assets().length;
	for (var i = 0; i < numAssets; ++i) {
		var asset = loader.get_baseDependency().get_assets()[i];
		switch (asset.get_assetType()) {
			case away.library.assets.AssetType.MESH:
				var mesh = asset;
				mesh.scale(400);
				this.suzane = mesh;
				this.suzane.get_material().set_lightPicker(this.lightPicker);
				this.suzane.set_y(-100);
				this.view.get_scene().addChild(mesh);
				this.resize();
				break;
			case away.library.assets.AssetType.GEOMETRY:
				break;
			case away.library.assets.AssetType.MATERIAL:
				break;
		}
	}
	this.resize();
};

$inherit(examples.AWDSuzanneLights, examples.BaseExample);

examples.AWDSuzanneLights.className = "examples.AWDSuzanneLights";

examples.AWDSuzanneLights.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.library.AssetLibrary');
	p.push('away.utils.Debug');
	p.push('away.lights.DirectionalLight');
	p.push('away.core.net.URLRequest');
	p.push('away.materials.lightpickers.StaticLightPicker');
	p.push('away.core.geom.Vector3D');
	p.push('away.containers.View3D');
	p.push('*away.library.assets.IAsset');
	p.push('away.events.LoaderEvent');
	p.push('away.events.AssetEvent');
	p.push('away.library.assets.AssetType');
	p.push('away.loaders.parsers.AWDParser');
	return p;
};

examples.AWDSuzanneLights.getStaticDependencies = function(t) {
	var p;
	return [];
};

examples.AWDSuzanneLights.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'_index', t:'int'});
			break;
		case 1:
			p = examples.BaseExample.injectionPoints(t);
			break;
		case 2:
			p = examples.BaseExample.injectionPoints(t);
			break;
		case 3:
			p = examples.BaseExample.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

