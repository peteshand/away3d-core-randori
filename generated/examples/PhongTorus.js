/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 28 11:54:50 EST 2013 */

if (typeof examples == "undefined")
	var examples = {};

examples.PhongTorus = function() {
	this.texture = null;
	this.pMatrix = null;
	this.image = null;
	this.context3D = null;
	this.stage = null;
	this.normalMatrix = null;
	this.iBuffer = null;
	this.mvMatrix = null;
	this.program = null;
	this.requestAnimationFrameTimer = null;
	Object.call(this);
	if (!document) {
		throw "The Window.document root object must be avaiable";
	}
	this.stage = new away.display.Stage(800, 600);
	this.loadResources();
};

examples.PhongTorus.prototype.loadResources = function() {
	var urlRequest = new away.net.URLRequest("assets\/130909wall_big.png");
	var imgLoader = new away.net.IMGLoader("");
	imgLoader.addEventListener(away.events.Event.COMPLETE, $createStaticDelegate(this, this.imageCompleteHandler), this);
	imgLoader.load(urlRequest);
};

examples.PhongTorus.prototype.imageCompleteHandler = function(e) {
	var imageLoader = e.target;
	this.image = imageLoader.get_image();
	this.stage.stage3Ds[0].addEventListener(away.events.Event.CONTEXT3D_CREATE, $createStaticDelegate(this, this.onContext3DCreateHandler), this);
	this.stage.stage3Ds[0].requestContext();
};

examples.PhongTorus.prototype.onContext3DCreateHandler = function(e) {
	this.stage.stage3Ds[0].removeEventListener(away.events.Event.CONTEXT3D_CREATE, $createStaticDelegate(this, this.onContext3DCreateHandler), this);
	var stage3D = e.target;
	this.context3D = stage3D.get_context3D();
	this.context3D.configureBackBuffer(800, 600, 0, true);
	this.context3D.setColorMask(true, true, true, true);
	var torus = new away.primitives.TorusGeometry(1, 0.5, 32, 16, false);
	torus.iValidate();
	var geo = torus.get_subGeometries()[0];
	var vertices = geo.get_vertexData();
	var indices = geo.get_indexData();
	var stride = 13;
	var numVertices = vertices.length / stride;
	var vBuffer = this.context3D.createVertexBuffer(numVertices, stride);
	vBuffer.uploadFromArray(vertices, 0, numVertices);
	var numIndices = indices.length;
	this.iBuffer = this.context3D.createIndexBuffer(numIndices);
	this.iBuffer.uploadFromArray(indices, 0, numIndices);
	this.program = this.context3D.createProgram();
	var vProgram = "attribute vec3 aVertexPosition;\n" + "attribute vec2 aTextureCoord;\n" + "attribute vec3 aVertexNormal;\n" + "uniform mat4 uPMatrix;\n" + "uniform mat4 uMVMatrix;\n" + "uniform mat4 uNormalMatrix;\n" + "varying vec3 vNormalInterp;\n" + "varying vec3 vVertPos;\n" + "void main(){\n" + "\tgl_Position = uPMatrix * uMVMatrix * vec4( aVertexPosition, 1.0 );\n" + "\tvec4 vertPos4 = uMVMatrix * vec4( aVertexPosition, 1.0 );\n" + "\tvVertPos = vec3( vertPos4 ) \/ vertPos4.w;\n" + "\tvNormalInterp = vec3( uNormalMatrix * vec4( aVertexNormal, 0.0 ) );\n" + "}\n";
	var fProgram = "precision mediump float;\n" + "varying vec3 vNormalInterp;\n" + "varying vec3 vVertPos;\n" + "const vec3 lightPos = vec3( 1.0,1.0,1.0 );\n" + "const vec3 diffuseColor = vec3( 0.3, 0.6, 0.9 );\n" + "const vec3 specColor = vec3( 1.0, 1.0, 1.0 );\n" + "void main() {\n" + "\tvec3 normal = normalize( vNormalInterp );\n" + "\tvec3 lightDir = normalize( lightPos - vVertPos );\n" + "\tfloat lambertian = max( dot( lightDir,normal ), 0.0 );\n" + "\tfloat specular = 0.0;\n" + "\tif( lambertian > 0.0 ) {\n" + "\t\tvec3 reflectDir = reflect( -lightDir, normal );\n" + "\t\tvec3 viewDir = normalize( -vVertPos );\n" + "\t\tfloat specAngle = max( dot( reflectDir, viewDir ), 0.0 );\n" + "\t\tspecular = pow( specAngle, 4.0 );\n" + "\t\tspecular *= lambertian;\n" + "\t}\n" + "\tgl_FragColor = vec4( lambertian * diffuseColor + specular * specColor, 1.0 );\n" + "}\n";
	this.program.upload(vProgram, fProgram);
	this.context3D.setProgram(this.program);
	this.pMatrix = new away.utils.PerspectiveMatrix3D();
	this.pMatrix.perspectiveFieldOfViewLH(45, 800 / 600, 0.1, 1000);
	this.mvMatrix = new away.geom.Matrix3D();
	this.mvMatrix.appendTranslation(0, 0, 7);
	this.normalMatrix = this.mvMatrix.clone();
	this.normalMatrix.invert();
	this.normalMatrix.transpose();
	this.context3D.setGLSLVertexBufferAt("aVertexPosition", vBuffer, 0, away.display3D.Context3DVertexBufferFormat.FLOAT_3);
	this.context3D.setGLSLVertexBufferAt("aVertexNormal", vBuffer, 3, away.display3D.Context3DVertexBufferFormat.FLOAT_3);
	this.requestAnimationFrameTimer = new away.utils.RequestAnimationFrame($createStaticDelegate(this, this.tick), this);
	this.requestAnimationFrameTimer.start();
};

examples.PhongTorus.prototype.tick = function(dt) {
	this.mvMatrix.appendRotation(dt * 0.05, new away.geom.Vector3D(0, 1, 0, 0));
	this.context3D.setProgram(this.program);
	this.context3D.setGLSLProgramConstantsFromMatrix("uNormalMatrix", this.normalMatrix, true);
	this.context3D.setGLSLProgramConstantsFromMatrix("uMVMatrix", this.mvMatrix, true);
	this.context3D.setGLSLProgramConstantsFromMatrix("uPMatrix", this.pMatrix, true);
	this.context3D.clear(0.16, 0.16, 0.16, 1, 1, 0, 17664);
	this.context3D.drawTriangles(this.iBuffer, 0, this.iBuffer.get_numIndices() / 3);
	this.context3D.present();
};

examples.PhongTorus.className = "examples.PhongTorus";

examples.PhongTorus.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.utils.RequestAnimationFrame');
	p.push('away.net.URLRequest');
	p.push('away.geom.Vector3D');
	p.push('away.events.Event');
	p.push('away.display3D.Context3DVertexBufferFormat');
	p.push('away.utils.PerspectiveMatrix3D');
	p.push('away.geom.Matrix3D');
	p.push('away.net.IMGLoader');
	p.push('away.primitives.TorusGeometry');
	p.push('away.display.Stage');
	return p;
};

examples.PhongTorus.getStaticDependencies = function(t) {
	var p;
	return [];
};

examples.PhongTorus.injectionPoints = function(t) {
	return [];
};
