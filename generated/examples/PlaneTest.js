/** Compiled by the Randori compiler v0.2.6.2 on Sun Sep 22 12:31:04 EST 2013 */

if (typeof examples == "undefined")
	var examples = {};

examples.PlaneTest = function() {
	this.urlRequest = null;
	this.texture = null;
	this.vertices = null;
	this.uvCoords = null;
	this.pMatrix = null;
	this.image = null;
	this.context3D = null;
	this.stage = new away.display.Stage(640, 480);
	this.iBuffer = null;
	this.mvMatrix = null;
	this.program = null;
	this.indices = null;
	this.requestAnimationFrameTimer = null;
	this.stage3D = null;
	this.imgLoader = null;
	this.imageURL = "assets\/130909wall_big.png";
	this.urlRequest = new away.net.URLRequest(this.imageURL);
	this.imgLoader = new away.net.IMGLoader("");
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
	var stage3D = event.target;
	this.context3D = stage3D.get_context3D();
	this.texture = this.context3D.createTexture(512, 512, away.display3D.Context3DTextureFormat.BGRA, true, 0);
	this.texture.uploadFromHTMLImageElement(this.image, 0);
	this.context3D.configureBackBuffer(800, 600, 0, true);
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
	this.pMatrix = new away.utils.PerspectiveMatrix3D();
	this.pMatrix.perspectiveFieldOfViewLH(45, 800 / 600, 0.1, 1000);
	this.mvMatrix = new away.geom.Matrix3D([]);
	this.mvMatrix.appendTranslation(0, 0, 4);
	this.context3D.setGLSLVertexBufferAt("aVertexPosition", vBuffer, 0, away.display3D.Context3DVertexBufferFormat.FLOAT_3);
	this.context3D.setGLSLVertexBufferAt("aTextureCoord", tCoordBuffer, 0, away.display3D.Context3DVertexBufferFormat.FLOAT_2);
	this.requestAnimationFrameTimer = new away.utils.RequestAnimationFrame($createStaticDelegate(this, this.tick), this);
	this.requestAnimationFrameTimer.start();
	console.log("start");
};

examples.PlaneTest.prototype.tick = function(dt) {
	this.context3D.setProgram(this.program);
	this.context3D.setGLSLProgramConstantsFromMatrix("pMatrix", this.pMatrix, true);
	this.context3D.setGLSLProgramConstantsFromMatrix("mvMatrix", this.mvMatrix, true);
	this.context3D.setGLSLTextureAt("uSampler", this.texture, 0);
	this.context3D.clear(1.0, 1.0, 0.0, 1, 1, 0, 17664);
	this.context3D.drawTriangles(this.iBuffer, 0, 2);
	this.context3D.present();
};

examples.PlaneTest.className = "examples.PlaneTest";

examples.PlaneTest.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.utils.RequestAnimationFrame');
	p.push('away.net.URLRequest');
	p.push('away.events.Stage3DEvent');
	p.push('away.events.Event');
	p.push('away.display3D.Context3DVertexBufferFormat');
	p.push('away.utils.PerspectiveMatrix3D');
	p.push('away.geom.Matrix3D');
	p.push('away.net.IMGLoader');
	p.push('away.display3D.Context3DTextureFormat');
	return p;
};

examples.PlaneTest.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('away.display.Stage');
	return p;
};

examples.PlaneTest.injectionPoints = function(t) {
	return [];
};
