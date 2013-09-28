/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 28 11:54:50 EST 2013 */

if (typeof examples == "undefined")
	var examples = {};

examples.CubeDemo = function(_index) {
	this.geo = null;
	this.canvas = null;
	this.cameraAxis = null;
	this.image = null;
	this.scene = null;
	this.raf = null;
	this.ready = false;
	this.mesh = null;
	examples.BaseExample.call(this, _index);
	this.view = new away.containers.View3D(null, null, null, false, "baseline");
	this.view.set_backgroundColor(0xFF3399);
	this.view.get_camera().set_z(-1000);
	this.view.get_camera().set_lens(new away.cameras.lenses.PerspectiveLens(40));
	this.view.set_width(800);
	this.view.set_height(500);
	this.scene = this.view.get_scene();
	var urlRequest = new away.net.URLRequest("assets\/130909wall_big.png");
	var imgLoader = new away.net.IMGLoader("");
	imgLoader.addEventListener(away.events.Event.COMPLETE, $createStaticDelegate(this, this.imageCompleteHandler), this);
	imgLoader.load(urlRequest);
};

examples.CubeDemo.prototype.imageCompleteHandler = function(e) {
	var imageLoader = e.target;
	var texture = new away.textures.HTMLImageElementTexture(imageLoader.get_image(), true);
	var material = new away.materials.TextureMaterial(texture, true, false, false);
	this.geo = new away.primitives.CubeGeometry(200, 200, 200, 1, 1, 1, true);
	this.mesh = new away.entities.Mesh(this.geo, material);
	this.scene.addChild(this.mesh);
	this.resize();
	this.ready = true;
};

examples.CubeDemo.prototype.tick = function(dt) {
	if (this.ready) {
		this.mesh.set_rotationX(this.mesh.get_rotationX() + 0.4);
		this.mesh.set_rotationY(this.mesh.get_rotationY() + 0.4);
		this.view.get_camera().lookAt(this.mesh.get_position());
		this.view.render();
	}
};

examples.CubeDemo.prototype.resize = function() {
	if (this.view) {
		this.view.set_y(0);
		this.view.set_x(0);
		this.view.set_width(window.innerWidth);
		this.view.set_height(window.innerHeight);
	}
};

$inherit(examples.CubeDemo, examples.BaseExample);

examples.CubeDemo.className = "examples.CubeDemo";

examples.CubeDemo.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.primitives.CubeGeometry');
	p.push('away.net.URLRequest');
	p.push('away.cameras.lenses.PerspectiveLens');
	p.push('away.events.Event');
	p.push('away.entities.Mesh');
	p.push('away.materials.TextureMaterial');
	p.push('away.net.IMGLoader');
	p.push('away.containers.View3D');
	p.push('Object');
	p.push('away.textures.HTMLImageElementTexture');
	return p;
};

examples.CubeDemo.getStaticDependencies = function(t) {
	var p;
	return [];
};

examples.CubeDemo.injectionPoints = function(t) {
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

