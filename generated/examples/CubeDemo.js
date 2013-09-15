/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 14 19:10:14 EST 2013 */

if (typeof examples == "undefined")
	var examples = {};

examples.CubeDemo = function() {
	this._cameraAxis = null;
	this._mesh2 = null;
	this._raf = null;
	this._view = null;
	this._scene = null;
	this._mesh = null;
	this._torus = null;
	this._image = null;
	this._cube = null;
	away.utils.Debug.THROW_ERRORS = false;
	this._view = new away.containers.View3D(null, null, null, false, "baseline");
	this._view.set_backgroundColor(0xFF0000);
	this._view.get_camera().set_x(130);
	this._view.get_camera().set_y(0);
	this._view.get_camera().set_z(0);
	this._cameraAxis = new away.geom.Vector3D(0, 0, 1, 0);
	this._view.get_camera().set_lens(new away.cameras.lenses.PerspectiveLens(120));
	this._cube = new away.primitives.CubeGeometry(20.0, 20.0, 20.0, 1, 1, 1, true);
	this._torus = new away.primitives.TorusGeometry(150, 80, 32, 16, true);
	var colourMaterial = new away.materials.ColorMaterial(0xFF0000, 1);
	colourMaterial.set_bothSides(true);
	this._mesh = new away.entities.Mesh(this._torus, colourMaterial);
	this._mesh2 = new away.entities.Mesh(this._cube, colourMaterial);
	this._mesh2.set_x(130);
	this._mesh2.set_z(40);
	this._view.get_scene().addChild(this._mesh);
	this._view.get_scene().addChild(this._mesh2);
	this._raf = new away.utils.RequestAnimationFrame($createStaticDelegate(this, this.render), this);
	this._raf.start();
	this.resize(null);
};

examples.CubeDemo.prototype.render = function(dt) {
	this._view.get_camera().rotate(this._cameraAxis, 1);
	this._mesh.set_rotationY(this._mesh.get_rotationY() + 1);
	this._mesh2.set_rotationX(this._mesh2.get_rotationX() + 0.4);
	this._mesh2.set_rotationY(this._mesh2.get_rotationY() + 0.4);
	this._view.render();
	console.log("render");
};

examples.CubeDemo.prototype.resize = function(e) {
	this._view.set_y(0);
	this._view.set_x(0);
	this._view.set_width(window.innerWidth);
	this._view.set_height(window.innerHeight);
	console.log(this._view.get_width(), this._view.get_height());
	this._view.render();
};

examples.CubeDemo.className = "examples.CubeDemo";

examples.CubeDemo.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.utils.RequestAnimationFrame');
	p.push('away.primitives.CubeGeometry');
	p.push('away.utils.Debug');
	p.push('away.cameras.lenses.PerspectiveLens');
	p.push('away.geom.Vector3D');
	p.push('away.entities.Mesh');
	p.push('away.containers.View3D');
	p.push('away.primitives.TorusGeometry');
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
