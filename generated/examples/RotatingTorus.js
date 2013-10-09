/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:41 EST 2013 */

if (typeof examples == "undefined")
	var examples = {};

examples.RotatingTorus = function() {
	this._pMatrix = null;
	this._iBuffer = null;
	this._texture = null;
	this._context3D = null;
	this._requestAnimationFrameTimer = null;
	this._image = null;
	this._stage = null;
	this._program = null;
	this._mvMatrix = null;
	if (!document) {
		throw "The document root object must be avaiable";
	}
	this._stage = new away.core.display.Stage(800, 600);
	this.loadResources();
};

examples.RotatingTorus.prototype.get_stage = function() {
	return this._stage;
};

examples.RotatingTorus.prototype.loadResources = function() {
	var urlRequest = new away.core.net.URLRequest("assets\/130909wall_big.png");
	var imgLoader = new away.core.net.IMGLoader("");
	imgLoader.addEventListener(away.events.Event.COMPLETE, $createStaticDelegate(this, this.imageCompleteHandler), this);
	imgLoader.load(urlRequest);
};

examples.RotatingTorus.prototype.imageCompleteHandler = function(e) {
	var imageLoader = e.target;
	this._image = imageLoader.get_image();
	this._stage.stage3Ds[0].addEventListener(away.events.Event.CONTEXT3D_CREATE, $createStaticDelegate(this, this.onContext3DCreateHandler), this);
	this._stage.stage3Ds[0].requestContext();
};

examples.RotatingTorus.prototype.onContext3DCreateHandler = function(e) {
	this._stage.stage3Ds[0].removeEventListener(away.events.Event.CONTEXT3D_CREATE, $createStaticDelegate(this, this.onContext3DCreateHandler), this);
	var stage3D = e.target;
	this._context3D = stage3D.get_context3D();
	this._texture = this._context3D.createTexture(512, 512, away.core.display3D.Context3DTextureFormat.BGRA, true, 0);
	var bitmapData = new away.core.display.BitmapData(512, 512, true, 0x02C3D4);
	this._texture.uploadFromBitmapData(bitmapData, 0);
	this._context3D.configureBackBuffer(800, 600, 0, true);
	this._context3D.setColorMask(true, true, true, true);
	var torus = new away.primitives.TorusGeometry(1, 0.5, 16, 8, false);
	torus.iValidate();
	var vertices = torus.getSubGeometries()[0].get_vertexData();
	var indices = torus.getSubGeometries()[0].get_indexData();
	var stride = 13;
	var numVertices = vertices.length / stride;
	var vBuffer = this._context3D.createVertexBuffer(numVertices, stride);
	vBuffer.uploadFromArray(vertices, 0, numVertices);
	var numIndices = indices.length;
	this._iBuffer = this._context3D.createIndexBuffer(numIndices);
	this._iBuffer.uploadFromArray(indices, 0, numIndices);
	this._program = this._context3D.createProgram();
	var vProgram = "uniform mat4 mvMatrix;\n" + "uniform mat4 pMatrix;\n" + "attribute vec2 aTextureCoord;\n" + "attribute vec3 aVertexPosition;\n" + "varying vec2 vTextureCoord;\n" + "void main() {\n" + "\t\tgl_Position = pMatrix * mvMatrix * vec4(aVertexPosition, 1.0);\n" + "\t\tvTextureCoord = aTextureCoord;\n" + "}\n";
	var fProgram = "varying mediump vec2 vTextureCoord;\n" + "uniform sampler2D uSampler;\n" + "void main() {\n" + "\t\tgl_FragColor = texture2D(uSampler, vTextureCoord);\n" + "}\n";
	this._program.upload(vProgram, fProgram);
	this._context3D.setProgram(this._program);
	this._pMatrix = new away.utils.PerspectiveMatrix3D();
	this._pMatrix.perspectiveFieldOfViewLH(45, 800 / 600, 0.1, 1000);
	this._mvMatrix = new away.core.geom.Matrix3D([]);
	this._mvMatrix.appendTranslation(0, 0, 5);
	this._context3D.setGLSLVertexBufferAt("aVertexPosition", vBuffer, 0, away.core.display3D.Context3DVertexBufferFormat.FLOAT_3);
	this._context3D.setGLSLVertexBufferAt("aTextureCoord", vBuffer, 9, away.core.display3D.Context3DVertexBufferFormat.FLOAT_2);
	this._requestAnimationFrameTimer = new away.utils.RequestAnimationFrame($createStaticDelegate(this, this.tick), this);
	this._requestAnimationFrameTimer.start();
};

examples.RotatingTorus.prototype.tick = function(dt) {
	console.log("tick");
	this._mvMatrix.appendRotation(dt * 0.1, new away.core.geom.Vector3D(0, 1, 0, 0));
	this._context3D.setProgram(this._program);
	this._context3D.setGLSLProgramConstantsFromMatrix("pMatrix", this._pMatrix, true);
	this._context3D.setGLSLProgramConstantsFromMatrix("mvMatrix", this._mvMatrix, true);
	this._context3D.setGLSLTextureAt("uSampler", this._texture, 0);
	this._context3D.clear(0.16, 0.16, 0.16, 1, 1, 0, 17664);
	this._context3D.drawTriangles(this._iBuffer, 0, this._iBuffer.get_numIndices() / 3);
	this._context3D.present();
};

examples.RotatingTorus.className = "examples.RotatingTorus";

examples.RotatingTorus.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.core.net.URLRequest');
	p.push('away.core.display3D.Context3DTextureFormat');
	p.push('Object');
	p.push('away.primitives.TorusGeometry');
	p.push('away.core.net.IMGLoader');
	p.push('away.core.display.BitmapData');
	p.push('away.core.display.Stage');
	p.push('away.core.display3D.Context3DVertexBufferFormat');
	p.push('away.utils.RequestAnimationFrame');
	p.push('away.events.Event');
	p.push('away.utils.PerspectiveMatrix3D');
	p.push('away.core.geom.Vector3D');
	p.push('away.core.geom.Matrix3D');
	return p;
};

examples.RotatingTorus.getStaticDependencies = function(t) {
	var p;
	return [];
};

examples.RotatingTorus.injectionPoints = function(t) {
	return [];
};
