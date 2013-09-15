/** Compiled by the Randori compiler v0.2.6.2 on Fri Sep 13 21:44:02 EST 2013 */

if (typeof examples == "undefined")
	var examples = {};

examples.ObjChiefTestDay = function() {
	this.terrain = null;
	this.spartan = new away.containers.ObjectContainer3D();
	this.meshes = [];
	this.t800M = null;
	this.mat = null;
	this.t = 0;
	this.height = 0;
	this.token = null;
	this.terrainMaterial = null;
	this.spartanFlag = false;
	this.terrainObjFlag = false;
	this.view = null;
	this.multiMat = null;
	this.raf = null;
	this.light = null;
	this.mesh = null;
	away.utils.Debug.LOG_PI_ERRORS = false;
	away.utils.Debug.THROW_ERRORS = false;
	this.view = new away.containers.View3D(null, null, null, false, "baseline");
	this.view.get_camera().set_z(-50);
	this.view.get_camera().set_y(20);
	this.view.get_camera().get_lens().set_near(0.1);
	this.view.set_backgroundColor(0xFF0000);
	this.raf = new away.utils.RequestAnimationFrame($createStaticDelegate(this, this.render), this);
	this.raf.start();
	this.light = new away.lights.DirectionalLight(0, -1, 1);
	this.light.set_color(0xc1582d);
	this.light.set_direction(new away.geom.Vector3D(1, 0, 0, 0));
	this.light.set_ambient(0.4);
	this.light.set_ambientColor(0x85b2cd);
	this.light.set_diffuse(2.8);
	this.light.set_specular(1.8);
	this.spartan.scale(.25);
	this.spartan.set_y(0);
	this.view.get_scene().addChild(this.light);
	away.library.AssetLibrary.enableParser(away.loaders.parsers.OBJParser);
	this.token = away.library.AssetLibrary.load(new away.net.URLRequest("assets\/Halo_3_SPARTAN4.obj"));
	this.token.addEventListener(away.events.LoaderEvent.RESOURCE_COMPLETE, $createStaticDelegate(this, this.onResourceComplete), this);
	this.token.addEventListener(away.events.AssetEvent.ASSET_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	this.token = away.library.AssetLibrary.load(new away.net.URLRequest("assets\/terrain.obj"));
	this.token.addEventListener(away.events.LoaderEvent.RESOURCE_COMPLETE, $createStaticDelegate(this, this.onResourceComplete), this);
	this.token.addEventListener(away.events.AssetEvent.ASSET_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	this.token = away.library.AssetLibrary.load(new away.net.URLRequest("assets\/masterchief_base.png"));
	this.token.addEventListener(away.events.LoaderEvent.RESOURCE_COMPLETE, $createStaticDelegate(this, this.onResourceComplete), this);
	this.token.addEventListener(away.events.AssetEvent.ASSET_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	this.token = away.library.AssetLibrary.load(new away.net.URLRequest("assets\/stone_tx.jpg"));
	this.token.addEventListener(away.events.LoaderEvent.RESOURCE_COMPLETE, $createStaticDelegate(this, this.onResourceComplete), this);
	this.token.addEventListener(away.events.AssetEvent.ASSET_COMPLETE, $createStaticDelegate(this, this.onAssetComplete), this);
	window.onresize = this.resize();
};

examples.ObjChiefTestDay.prototype.render = function() {
	if (this.terrain)
		this.terrain.set_rotationY(this.terrain.get_rotationY() + 0.4);
	this.spartan.set_rotationY(this.spartan.get_rotationY() + 0.4);
	this.view.render();
};

examples.ObjChiefTestDay.prototype.onAssetComplete = function(e) {
};

examples.ObjChiefTestDay.prototype.onResourceComplete = function(e) {
	var loader = e.target;
	var l = loader.get_baseDependency().get_assets().length;
	console.log("------------------------------------------------------------------------------");
	console.log("away.events.LoaderEvent.RESOURCE_COMPLETE", e, l, loader);
	console.log("------------------------------------------------------------------------------");
	var loader = e.target;
	var l = loader.get_baseDependency().get_assets().length;
	for (var c = 0; c < l; ++c) {
		var d = loader.get_baseDependency().get_assets()[c];
		console.log(d.get_name(), e.get_url());
		switch (d.get_assetType()) {
			case away.library.assets.AssetType.MESH:
				if (e.get_url() == "Halo_3_SPARTAN4.obj") {
					var mesh = away.library.AssetLibrary.getAsset(d.get_name());
					this.spartan.addChild(mesh);
					this.raf.start();
					this.spartanFlag = true;
					this.meshes.push(mesh);
				}
				if (e.get_url() == "terrain.obj") {
					this.terrainObjFlag = true;
					this.terrain = away.library.AssetLibrary.getAsset(d.get_name());
					this.terrain.set_y(98);
					this.view.get_scene().addChild(this.terrain);
				}
				break;
			case away.library.assets.AssetType.TEXTURE:
				if (e.get_url() == "masterchief_base.png") {
					var lightPicker = new away.materials.lightpickers.StaticLightPicker([this.light]);
					var tx = away.library.AssetLibrary.getAsset(d.get_name());
					this.mat = new away.materials.TextureMaterial(tx, true, true, false);
					this.mat.set_lightPicker(lightPicker);
				}
				if (e.get_url() == "stone_tx.jpg") {
					var lp = new away.materials.lightpickers.StaticLightPicker([this.light]);
					var txT = away.library.AssetLibrary.getAsset(d.get_name());
					this.terrainMaterial = new away.materials.TextureMaterial(txT, true, true, false);
					this.terrainMaterial.set_lightPicker(lp);
				}
				break;
		}
		if (this.terrainObjFlag && this.terrainMaterial) {
			this.terrain.set_material(this.terrainMaterial);
			this.terrain.get_geometry().scaleUV(20, 20);
		}
		if (this.mat && this.spartanFlag) {
			for (var b = 0; b < this.meshes.length; b++) {
				this.meshes[b].material = this.mat;
			}
		}
		this.view.get_scene().addChild(this.spartan);
		this.resize();
	}
};

examples.ObjChiefTestDay.prototype.resize = function() {
	this.view.set_y(0);
	this.view.set_x(0);
	this.view.set_width(window.innerWidth);
	this.view.set_height(window.innerHeight);
	console.log("resize");
};

examples.ObjChiefTestDay.className = "examples.ObjChiefTestDay";

examples.ObjChiefTestDay.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.utils.Debug');
	p.push('away.library.AssetLibrary');
	p.push('away.lights.DirectionalLight');
	p.push('away.materials.TextureMaterial');
	p.push('away.containers.View3D');
	p.push('away.loaders.parsers.OBJParser');
	p.push('away.events.LoaderEvent');
	p.push('away.events.AssetEvent');
	p.push('away.utils.RequestAnimationFrame');
	p.push('away.net.URLRequest');
	p.push('away.geom.Vector3D');
	p.push('away.materials.lightpickers.StaticLightPicker');
	p.push('*away.library.assets.IAsset');
	p.push('away.library.assets.AssetType');
	return p;
};

examples.ObjChiefTestDay.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('away.containers.ObjectContainer3D');
	return p;
};

examples.ObjChiefTestDay.injectionPoints = function(t) {
	return [];
};
