/**
 * Created by pete on 12/08/13.
 */


/** Compiled by the Randori compiler v0.2.5.2 on Mon Aug 12 20:34:34 HST 2013 */


MainRotation = function() {
    this.geo = null;
    this.canvas = null;
    this.cameraAxis = null;
    this.image = null;
    this.scene = null;
    this.raf = null;
    this.ready = false;
    this.mesh = null;

    this.requestAnimationFrame = null;
    this.index = 0;
    this.view = null;
    this.index = 0;
    this.requestAnimationFrame = new away.utils.RequestAnimationFrame(this.tick, this);
    var that = this;
    onresize = function() {
        that.resize();
    };
    this.resize();

    this.view = new away.containers.View3D(null, null, null, false, "baseline");
    this.view.backgroundColor = 0xFF3399;
    this.view.camera.z = -1000;
    this.view.camera.lens = new away.cameras.PerspectiveLens(40);
    this.view.width = 800;
    this.view.height = 500;
    this.scene = this.view.scene;
    var urlRequest = new away.net.URLRequest("130909wall_big.png");
    var imgLoader = new away.net.IMGLoader("");
    imgLoader.addEventListener(away.events.Event.COMPLETE, this.imageCompleteHandler, this);
    imgLoader.load(urlRequest);
};

MainRotation.prototype.imageCompleteHandler = function(e) {
    var imageLoader = e.target;
    var htmlImageElement = imageLoader.image;
    var texture = new away.textures.HTMLImageElementTexture(htmlImageElement, false);
    var material = new away.materials.ColorMaterial(0xFFFFFF);

    this.light = new away.lights.DirectionalLight(0, -1, 1);

    this.light.color = 0x683019;
    this.light.direction = new away.geom.Vector3D(0, -1, 1, 0);
    this.light.ambient = 0.3;
    this.light.ambientColor = 0xFFFFFF;
    this.light.diffuse = 2.8;
    this.light.specular = 1.8;
    this.view.scene.addChild(this.light);
    this.lightPicker = new away.materials.StaticLightPicker([this.light]);
    material.lightPicker = this.lightPicker;

    window.console.log(this.light);

    this.geo = new away.primitives.PlaneGeometry(200, 200, 1, 1, false, false);
    this.mesh = new away.entities.Mesh(this.geo, material);
    this.scene.addChild(this.mesh);
    this.resize();
    this.ready = true;

    this.Show();
};

MainRotation.prototype.tick = function(dt) {
    if (this.ready) {
        //this.mesh.rotationX = this.mesh.rotationX + 0.4;
        this.mesh.rotationY = this.mesh.rotationY + 0.4;
        this.view.camera.lookAt(this.mesh.position);
        this.view.render();
    }
};

MainRotation.prototype.resize = function() {
    if (this.view) {
        this.view.y = 0;
        this.view.x = 0;
        this.view.width = window.innerWidth;
        this.view.height = window.innerHeight;
    }
};

MainRotation.prototype.Show = function() {
    if (this.view)
        this.view.canvas.style.setProperty("visibility", "visible");
    this.requestAnimationFrame.start();
};

MainRotation.prototype.Hide = function() {
    if (this.view)
        this.view.canvas.style.setProperty("visibility", "hidden");
    this.requestAnimationFrame.stop();
};

MainRotation.className = "MainRotation";

MainRotation.getRuntimeDependencies = function(t) {
    var p;
    return [];
};

MainRotation.getStaticDependencies = function(t) {
    var p;
    return [];
};

MainRotation.injectionPoints = function(t) {
    return [];
};