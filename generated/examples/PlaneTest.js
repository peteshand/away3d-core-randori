/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:41 EST 2013 */

if (typeof examples == "undefined")
	var examples = {};

examples.PlaneTest = function(_index) {
	this.urlRequest = null;
	this.texture = null;
	this.vertices = null;
	this.uvCoords = null;
	this.pMatrix = null;
	this.image = null;
	this.context3D = null;
	this.ready = false;
	this.stage = null;
	this.iBuffer = null;
	this.mvMatrix = null;
	this.program = null;
	this.indices = null;
	this.stage3D = null;
	this.imgLoader = null;
	this.imageURL = "assets\/130909wall_big.png";
	this.stage = new away.core.display.Stage(window.innerWidth, window.innerHeight);
	examples.BaseExample.call(this, _index);
	this.urlRequest = new away.core.net.URLRequest(this.imageURL);
	this.imgLoader = new away.core.net.IMGLoader("");
	this.imgLoader.addEventListener(away.events.Event.COMPLETE, $createStaticDelegate(this, this.imageCompleteHandler), this);
	this.imgLoader.load(this.urlRequest);
};

examples.PlaneTest.prototype.imageCompleteHandler = function(event) {
	this.image = this.imgLoader.get_image();
	this.stage.stage3Ds[0].addEventListener(away.events.Event.CONTEXT3D_CREATE, $createStaticDelegate(this, this.onContext3DCreateHandler), this);
	this.stage.stage3Ds[0].requestContext();
};

examples.PlaneTest.prototype.onContext3DCreateHandler = function(event) {
	this.stage.stage3Ds[0].removeEventListener(away.events.Event.CONTEXT3D_CREATE, $createStaticDelegate(this, this.onContext3DCreateHandler), this);
	this.stage3D = event.target;
	this.context3D = this.stage3D.get_context3D();
	this.texture = this.context3D.createTexture(512, 512, away.core.display3D.Context3DTextureFormat.BGRA, false, 0);
	this.texture.uploadFromHTMLImageElement(this.image, 0);
	this.context3D.configureBackBuffer(window.innerWidth, window.innerHeight, 0, true);
	this.context3D.setColorMask(true, true, true, true);
	this.vertices = [-1.0, -1.0, 0.0, 1.0, -1.0, 0.0, 1.0, 1.0, 0.0, -1.0, 1.0, 0.0];
	this.uvCoords = [0, 0, 1, 0, 1, 1, 0, 1];
	this.indices = [0, 1, 2, 0, 2, 3];
	var vBuffer = this.context3D.createVertexBuffer(4, 3);
	console.log(vBuffer);
	vBuffer.uploadFromArray(this.vertices, 0, 4);
	var tCoordBuffer = this.context3D.createVertexBuffer(4, 2);
	tCoordBuffer.uploadFromArray(this.uvCoords, 0, 4);
	this.iBuffer = this.context3D.createIndexBuffer(6);
	this.iBuffer.uploadFromArray(this.indices, 0, 6);
	this.program = this.context3D.createProgram();
	var vProgram = "uniform mat4 mvMatrix;\n" + "uniform mat4 pMatrix;\n" + "attribute vec2 aTextureCoord;\n" + "attribute vec3 aVertexPosition;\n" + "varying vec2 vTextureCoord;\n" + "void main() {\n" + "\t\tgl_Position = pMatrix * mvMatrix * vec4(aVertexPosition, 1.0);\n" + "\t\tvTextureCoord = aTextureCoord;\n" + "}\n";
	var fProgram = "varying mediump vec2 vTextureCoord;\n" + "uniform sampler2D uSampler;\n" + "void main() {\n" + "\t\tgl_FragColor = texture2D(uSampler, vTextureCoord);\n" + "}\n";
	this.program.upload(vProgram, fProgram);
	this.context3D.setProgram(this.program);
	console.log("-----------------------------------------------------------");
	this.pMatrix = new away.utils.PerspectiveMatrix3D();
	this.pMatrix.perspectiveFieldOfViewLH(45, window.innerWidth / window.innerHeight, 0.1, 1000);
	this.mvMatrix = new away.core.geom.Matrix3D([]);
	this.mvMatrix.appendTranslation(0, 0, 4);
	this.context3D.setGLSLVertexBufferAt("aVertexPosition", vBuffer, 0, away.core.display3D.Context3DVertexBufferFormat.FLOAT_3);
	this.context3D.setGLSLVertexBufferAt("aTextureCoord", tCoordBuffer, 0, away.core.display3D.Context3DVertexBufferFormat.FLOAT_2);
	this.ready = true;
};

examples.PlaneTest.prototype.tick = function(dt) {
	if (this.ready) {
		this.mvMatrix.appendRotation(dt * 0.1, new away.core.geom.Vector3D(0, 1, 0, 0));
		this.context3D.setProgram(this.program);
		this.context3D.setGLSLProgramConstantsFromMatrix("pMatrix", this.pMatrix, true);
		this.context3D.setGLSLProgramConstantsFromMatrix("mvMatrix", this.mvMatrix, true);
		this.context3D.setGLSLTextureAt("uSampler", this.texture, 0);
		this.context3D.clear(0.1, 0.2, 0.3, 1, 1, 0, 17664);
		this.context3D.drawTriangles(this.iBuffer, 0, 2);
		this.context3D.present();
	}
};

examples.PlaneTest.prototype.Show = function() {
	examples.BaseExample.prototype.Show.call(this);
	if (this.stage3D)
		this.stage3D.get_canvas().style.setProperty("visibility", "visible");
};

examples.PlaneTest.prototype.Hide = function() {
	examples.BaseExample.prototype.Hide.call(this);
	if (this.stage3D)
		this.stage3D.get_canvas().style.setProperty("visibility", "hidden");
};

$inherit(examples.PlaneTest, examples.BaseExample);

examples.PlaneTest.className = "examples.PlaneTest";

examples.PlaneTest.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.core.display3D.Context3DVertexBufferFormat');
	p.push('away.core.display.Stage');
	p.push('away.events.Stage3DEvent');
	p.push('away.events.Event');
	p.push('away.utils.PerspectiveMatrix3D');
	p.push('away.core.net.URLRequest');
	p.push('away.core.geom.Vector3D');
	p.push('away.core.display3D.Context3DTextureFormat');
	p.push('away.core.geom.Matrix3D');
	p.push('away.core.net.IMGLoader');
	return p;
};

examples.PlaneTest.getStaticDependencies = function(t) {
	var p;
	return [];
};

examples.PlaneTest.injectionPoints = function(t) {
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

