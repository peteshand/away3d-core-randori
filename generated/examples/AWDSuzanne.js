/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 28 11:54:55 EST 2013 */

if (typeof examples == "undefined")
	var examples = {};

examples.AWDSuzanne = function(_index) {
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
	this.token = away.library.AssetLibrary.load(new away.net.URLRequest("assets\/suzanne.awd"));
	this.token.addEventListener(away.events.LoaderEvent.RESOURCE_COMPLETE, $createStaticDelegate(this, this.onResourceComplete), this);
	this.token.addEventListener(away.events.AssetEvent.ASSET_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	this.view = new away.containers.View3D(null, null, null, false, "baseline");
	this.view.set_backgroundColor(0x666666);
};

examples.AWDSuzanne.prototype.resize = function() {
	if (this.view) {
		this.view.set_y(0);
		this.view.set_x(0);
		this.view.set_width(window.innerWidth);
		this.view.set_height(window.innerHeight);
	}
};

examples.AWDSuzanne.prototype.tick = function(dt) {
	if (this.suzane) {
		this.suzane.set_rotationY(this.suzane.get_rotationY() + 1);
	}
	this.view.render();
	if (this.hoverControl) {
		this.hoverControl.update(false);
	}
};

examples.AWDSuzanne.prototype.onAssetComplete = function(e) {
	console.log("------------------------------------------------------------------------------");
	console.log("AssetEvent.ASSET_COMPLETE", away.library.AssetLibrary.getAsset(e.get_asset().get_name()));
	console.log("------------------------------------------------------------------------------");
};

examples.AWDSuzanne.prototype.onResourceComplete = function(e) {
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
};

$inherit(examples.AWDSuzanne, examples.BaseExample);

examples.AWDSuzanne.className = "examples.AWDSuzanne";

examples.AWDSuzanne.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.net.URLRequest');
	p.push('away.library.AssetLibrary');
	p.push('away.utils.Debug');
	p.push('away.containers.View3D');
	p.push('*away.library.assets.IAsset');
	p.push('away.events.LoaderEvent');
	p.push('away.events.AssetEvent');
	p.push('away.library.assets.AssetType');
	p.push('away.loaders.parsers.AWDParser');
	return p;
};

examples.AWDSuzanne.getStaticDependencies = function(t) {
	var p;
	return [];
};

examples.AWDSuzanne.injectionPoints = function(t) {
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

