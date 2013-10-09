/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 21:45:47 EST 2013 */

if (typeof examples == "undefined")
	var examples = {};

examples.ViewPlane = function(_index) {
	this.geo = null;
	this.image = null;
	this.cameraAxis = null;
	this.canvas = null;
	this.ready = false;
	this.lightPicker = null;
	this.scene = null;
	this.raf = null;
	this.light = null;
	this.mesh = null;
	examples.BaseExample.call(this, _index);
	this.view = new away.containers.View3D(null, null, null, false, "baseline");
	this.view.set_backgroundColor(0xFF3399);
	this.view.get_camera().set_z(-1000);
	this.view.get_camera().set_lens(new away.cameras.lenses.PerspectiveLens(40));
	this.view.set_width(800);
	this.view.set_height(500);
	this.scene = this.view.get_scene();
	var urlRequest = new away.core.net.URLRequest("assets\/130909wall_big.png");
	var imgLoader = new away.core.net.IMGLoader("");
	imgLoader.addEventListener(away.events.Event.COMPLETE, $createStaticDelegate(this, this.imageCompleteHandler), this);
	imgLoader.load(urlRequest);
};

examples.ViewPlane.prototype.imageCompleteHandler = function(e) {
	var imageLoader = e.target;
	var htmlImageElement = imageLoader.get_image();
	var texture = new away.textures.HTMLImageElementTexture(htmlImageElement, false);
	var material = new away.materials.ColorMaterial(0xFFFFFF, 1);
	this.light = new away.lights.PointLight();
	this.light.set_color(0x683019);
	this.light.set_ambient(0.3);
	this.light.set_ambientColor(0xFFFFFF);
	this.light.set_diffuse(2.8);
	this.light.set_specular(1.8);
	this.view.get_scene().addChild(this.light);
	this.lightPicker = new away.materials.lightpickers.StaticLightPicker([this.light]);
	material.set_lightPicker(this.lightPicker);
	this.lightPicker = new away.materials.lightpickers.StaticLightPicker([this.light]);
	this.geo = new away.primitives.PlaneGeometry(200, 200, 1, 1, false, false);
	this.mesh = new away.entities.Mesh(this.geo, material);
	this.scene.addChild(this.mesh);
	this.resize();
	this.ready = true;
};

examples.ViewPlane.prototype.tick = function(dt) {
	if (this.ready) {
		this.mesh.set_rotationY(this.mesh.get_rotationY() + 0.4);
		this.view.get_camera().lookAt(this.mesh.get_position());
		this.view.render();
	}
};

examples.ViewPlane.prototype.resize = function() {
	if (this.view) {
		this.view.set_y(0);
		this.view.set_x(0);
		this.view.set_width(window.innerWidth);
		this.view.set_height(window.innerHeight);
	}
};

$inherit(examples.ViewPlane, examples.BaseExample);

examples.ViewPlane.className = "examples.ViewPlane";

examples.ViewPlane.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.cameras.lenses.PerspectiveLens');
	p.push('away.events.Event');
	p.push('away.lights.PointLight');
	p.push('away.core.net.URLRequest');
	p.push('away.entities.Mesh');
	p.push('away.materials.lightpickers.StaticLightPicker');
	p.push('away.containers.View3D');
	p.push('Object');
	p.push('away.textures.HTMLImageElementTexture');
	p.push('away.materials.ColorMaterial');
	p.push('away.primitives.PlaneGeometry');
	p.push('away.core.net.IMGLoader');
	return p;
};

examples.ViewPlane.getStaticDependencies = function(t) {
	var p;
	return [];
};

examples.ViewPlane.injectionPoints = function(t) {
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

