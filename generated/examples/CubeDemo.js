/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 25 08:08:27 EST 2013 */

if (typeof examples == "undefined")
	var examples = {};

examples.CubeDemo = function() {
	this.geo = null;
	this.cameraAxis = null;
	this.image = null;
	this.scene = null;
	this.view = null;
	this.raf = null;
	this.mesh = null;
	away.utils.Debug.THROW_ERRORS = false;
	away.utils.Debug.ENABLE_LOG = true;
	this.view = new away.containers.View3D(null, null, null, false, "baseline");
	this.view.set_backgroundColor(0xFF3399);
	this.view.get_camera().set_z(-1000);
	this.view.get_camera().set_lens(new away.cameras.lenses.PerspectiveLens(40));
	this.scene = this.view.get_scene();
	var urlRequest = new away.net.URLRequest("assets\/130909wall_big.png");
	var imgLoader = new away.net.IMGLoader("");
	imgLoader.addEventListener(away.events.Event.COMPLETE, $createStaticDelegate(this, this.imageCompleteHandler), this);
	imgLoader.load(urlRequest);
};

examples.CubeDemo.prototype.imageCompleteHandler = function(e) {
	var imageLoader = e.target;
	console.log("Load complete");
	var bmd = new away.display.BitmapData(256, 256, true, 0x66FF00FF);
	var texture = new away.textures.BitmapTexture(bmd, false);
	var material = new away.materials.TextureMaterial(texture, true, false, false);
	this.geo = new away.primitives.CubeGeometry(200, 200, 200, 1, 1, 1, true);
	this.mesh = new away.entities.Mesh(this.geo, material);
	this.scene.addChild(this.mesh);
	this.resize();
	this.raf = new away.utils.RequestAnimationFrame($createStaticDelegate(this, this.render), this);
	this.raf.start();
};

examples.CubeDemo.prototype.render = function(dt) {
	this.mesh.set_rotationX(this.mesh.get_rotationX() + 0.4);
	this.mesh.set_rotationY(this.mesh.get_rotationY() + 0.4);
	this.view.get_camera().lookAt(this.mesh.get_position());
	this.view.render();
	this.raf.stop();
};

examples.CubeDemo.prototype.resize = function() {
	this.view.set_y(0);
	this.view.set_x(0);
	this.view.set_width(window.innerWidth);
	this.view.set_height(window.innerHeight);
	console.log(this.view.get_width(), this.view.get_height());
};

examples.CubeDemo.className = "examples.CubeDemo";

examples.CubeDemo.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.utils.Debug');
	p.push('away.containers.View3D');
	p.push('away.net.IMGLoader');
	p.push('away.materials.TextureMaterial');
	p.push('Object');
	p.push('away.utils.RequestAnimationFrame');
	p.push('away.net.URLRequest');
	p.push('away.primitives.CubeGeometry');
	p.push('away.cameras.lenses.PerspectiveLens');
	p.push('away.events.Event');
	p.push('away.textures.BitmapTexture');
	p.push('away.entities.Mesh');
	p.push('away.display.BitmapData');
	return p;
};

examples.CubeDemo.getStaticDependencies = function(t) {
	var p;
	return [];
};

examples.CubeDemo.injectionPoints = function(t) {
	return [];
};
