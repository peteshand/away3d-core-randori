/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:39 EST 2013 */

if (typeof examples == "undefined")
	var examples = {};

examples.AGALTorus = function() {
	this.matrix = null;
	this.image = null;
	this.context3D = null;
	this.vBuffer = null;
	this.stage = null;
	this.geometry = null;
	this.iBuffer = null;
	this.program = null;
	this.requestAnimationFrameTimer = null;
	this.stage3D = null;
	Object.call(this);
	if (!document) {
		throw "The Window.document root object must be avaiable";
	}
	this.stage = new away.core.display.Stage(800, 600);
	this.stage.stage3Ds[0].addEventListener(away.events.Event.CONTEXT3D_CREATE, $createStaticDelegate(this, this.onContext3DCreateHandler), this);
	this.stage.stage3Ds[0].requestContext(true);
};

examples.AGALTorus.prototype.onContext3DCreateHandler = function(e) {
	this.stage.stage3Ds[0].removeEventListener(away.events.Event.CONTEXT3D_CREATE, $createStaticDelegate(this, this.onContext3DCreateHandler), this);
	var stage3D = e.target;
	this.context3D = stage3D.get_context3D();
	this.context3D.configureBackBuffer(800, 600, 0, true);
	this.context3D.setColorMask(true, true, true, true);
	this.geometry = new away.core.base.Geometry();
	var torus = new away.primitives.TorusGeometry(1, 0.5, 32, 16, false);
	torus.iValidate();
	var geo = torus.get_subGeometries()[0];
	var vertices = geo.get_vertexData();
	var indices = geo.get_indexData();
	console.log(vertices);
	var stride = 13;
	var numVertices = vertices.length / stride;
	this.vBuffer = this.context3D.createVertexBuffer(numVertices, stride);
	this.vBuffer.uploadFromArray(vertices, 0, numVertices);
	var numIndices = indices.length;
	this.iBuffer = this.context3D.createIndexBuffer(numIndices);
	this.iBuffer.uploadFromArray(indices, 0, numIndices);
	this.program = this.context3D.createProgram();
	var vProgram = "m44 op, va0, vc0  \n" + "mov v0, va1       \n";
	var fProgram = "mov oc, v0 \n";
	var vertCompiler = new aglsl.AGLSLCompiler();
	var fragCompiler = new aglsl.AGLSLCompiler();
	var compVProgram = vertCompiler.compile(away.core.display3D.Context3DProgramType.VERTEX, vProgram);
	var compFProgram = fragCompiler.compile(away.core.display3D.Context3DProgramType.FRAGMENT, fProgram);
	console.log("=== compVProgram ===");
	console.log(compVProgram);
	console.log("\n");
	console.log("=== compFProgram ===");
	console.log(compFProgram);
	this.program.upload(compVProgram, compFProgram);
	this.context3D.setProgram(this.program);
	this.matrix = new away.utils.PerspectiveMatrix3D();
	this.matrix.perspectiveFieldOfViewLH(85, 800 / 600, 0.1, 1000);
	this.context3D.setVertexBufferAt(0, this.vBuffer, 0, away.core.display3D.Context3DVertexBufferFormat.FLOAT_3);
	this.context3D.setVertexBufferAt(1, this.vBuffer, 6, away.core.display3D.Context3DVertexBufferFormat.FLOAT_3);
	this.tick(0);
};

examples.AGALTorus.prototype.tick = function(dt) {
	this.context3D.setProgram(this.program);
	this.context3D.setProgramConstantsFromMatrix(away.core.display3D.Context3DProgramType.VERTEX, 0, this.matrix, true);
	this.context3D.clear(0.16, 0.16, 0.16, 1, 1, 0, 17664);
	this.context3D.drawTriangles(this.iBuffer, 0, this.iBuffer.get_numIndices() / 3);
	this.context3D.present();
};

examples.AGALTorus.className = "examples.AGALTorus";

examples.AGALTorus.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.core.display3D.Context3DVertexBufferFormat');
	p.push('away.core.display.Stage');
	p.push('away.events.Event');
	p.push('away.utils.PerspectiveMatrix3D');
	p.push('away.core.display.Stage3D');
	p.push('aglsl.AGLSLCompiler');
	p.push('away.primitives.TorusGeometry');
	p.push('Object');
	p.push('away.core.display3D.Context3DProgramType');
	p.push('away.core.base.Geometry');
	return p;
};

examples.AGALTorus.getStaticDependencies = function(t) {
	var p;
	return [];
};

examples.AGALTorus.injectionPoints = function(t) {
	return [];
};
