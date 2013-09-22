/** Compiled by the Randori compiler v0.2.6.2 on Sun Sep 22 12:43:14 EST 2013 */

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
	this.view = new away.containers.View3D(null, null, null, false, "baseline");
	this.view.set_backgroundColor(0xEEAA00);
	this.view.get_camera().set_z(-1000);
	this.view.get_camera().set_lens(new away.cameras.lenses.PerspectiveLens(120));
	this.scene = this.view.get_scene();
	this.geo = new away.primitives.CubeGeometry(200, 200, 200, 1, 1, 1, true);
	var colourMaterial = new away.materials.ColorMaterial(0xFF00FF, 1);
	colourMaterial.set_bothSides(true);
	this.mesh = new away.entities.Mesh(this.geo, colourMaterial);
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
	p.push('away.utils.RequestAnimationFrame');
	p.push('away.primitives.CubeGeometry');
	p.push('away.utils.Debug');
	p.push('away.cameras.lenses.PerspectiveLens');
	p.push('away.entities.Mesh');
	p.push('away.containers.View3D');
	p.push('away.materials.ColorMaterial');
	return p;
};

examples.CubeDemo.getStaticDependencies = function(t) {
	var p;
	return [];
};

examples.CubeDemo.injectionPoints = function(t) {
	return [];
};
