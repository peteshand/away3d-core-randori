/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 25 08:08:27 EST 2013 */

if (typeof examples == "undefined")
	var examples = {};

examples.AWDSuzanne = function() {
	this.lastTiltAngle = 0;
	this.hoverControl = null;
	this.lastPanAngle = 0;
	this.lightPicker = null;
	this.lastMouseY = 0;
	this.token = null;
	this.lastMouseX = 0;
	this.timer = null;
	this.suzane = null;
	this.view = null;
	this.light = null;
	this.move = false;
	away.utils.Debug.LOG_PI_ERRORS = true;
	away.utils.Debug.THROW_ERRORS = false;
	away.library.AssetLibrary.enableParser(away.loaders.parsers.AWDParser);
	this.token = away.library.AssetLibrary.load(new away.net.URLRequest("assets\/suzanne.awd"));
	this.token.addEventListener(away.events.LoaderEvent.RESOURCE_COMPLETE, $createStaticDelegate(this, this.onResourceComplete), this);
	this.token.addEventListener(away.events.AssetEvent.ASSET_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	this.view = new away.containers.View3D(null, null, null, false, "baseline");
	this.view.set_backgroundColor(0x666666);
	this.timer = new away.utils.RequestAnimationFrame($createStaticDelegate(this, this.render), this);
	var that = this;
	window.onresize = function() {
		that.resize();
	};
};

examples.AWDSuzanne.prototype.resize = function() {
	this.view.set_y(0);
	this.view.set_x(0);
	this.view.set_width(window.innerWidth);
	this.view.set_height(window.innerHeight);
};

examples.AWDSuzanne.prototype.render = function(dt) {
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
				var bmd = new away.display.BitmapData(256, 256, true, 0x66FF0000);
				var texture = new away.textures.BitmapTexture(bmd, false);
				var material = new away.materials.TextureMaterial(texture, true, false, false);
				material.set_alpha(0.2);
				this.suzane.set_material(material);
				this.suzane.set_y(-100);
				this.view.get_scene().addChild(mesh);
				this.timer.start();
				this.resize();
				break;
			case away.library.assets.AssetType.GEOMETRY:
				break;
			case away.library.assets.AssetType.MATERIAL:
				break;
		}
	}
};

examples.AWDSuzanne.className = "examples.AWDSuzanne";

examples.AWDSuzanne.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.utils.Debug');
	p.push('away.library.AssetLibrary');
	p.push('away.materials.TextureMaterial');
	p.push('away.containers.View3D');
	p.push('away.events.LoaderEvent');
	p.push('away.events.AssetEvent');
	p.push('away.loaders.parsers.AWDParser');
	p.push('away.net.URLRequest');
	p.push('away.utils.RequestAnimationFrame');
	p.push('away.textures.BitmapTexture');
	p.push('*away.library.assets.IAsset');
	p.push('away.display.BitmapData');
	p.push('away.library.assets.AssetType');
	return p;
};

examples.AWDSuzanne.getStaticDependencies = function(t) {
	var p;
	return [];
};

examples.AWDSuzanne.injectionPoints = function(t) {
	return [];
};
