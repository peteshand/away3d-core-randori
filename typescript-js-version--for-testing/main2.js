/**
 * Created by pete on 12/08/13.
 */


/** Compiled by the Randori compiler v0.2.5.2 on Mon Aug 12 20:34:34 HST 2013 */


MainRotation = function() {
    this._stage = new away.display.Stage(640, 480);

    this.loadResources();
};

MainRotation.prototype.loadResources = function() {
    var urlRequest = new away.net.URLRequest("130909wall_big.png");
    var imgLoader = new away.net.IMGLoader();
    imgLoader.addEventListener(away.events.Event.COMPLETE, this.imageCompleteHandler, this);
    imgLoader.load(urlRequest);
};

MainRotation.prototype.imageCompleteHandler = function(event) {
    var imageLoader = event.target;
    this._image = imageLoader.image;

    this._stage.stage3Ds[0].addEventListener(away.events.Event.CONTEXT3D_CREATE, this.onContext3DCreateHandler, this);
    this._stage.stage3Ds[0].requestContext();
};

MainRotation.prototype.onContext3DCreateHandler = function(event) {
    this._stage.stage3Ds[0].removeEventListener(away.events.Event.CONTEXT3D_CREATE, this.onContext3DCreateHandler, this);

    var stage3D = event.target;
    this._context3D = stage3D.context3D;

    this._texture = this._context3D.createTexture(512, 512, away.display3D.Context3DTextureFormat.BGRA, true);
    this._texture.uploadFromHTMLImageElement(this._image);

    this._context3D.configureBackBuffer(800, 600, 0, true);
    this._context3D.setColorMask(true, true, true, true);

    var vertices = [
        -1.0,
        -1.0,
        0.0,
        1.0,
        -1.0,
        0.0,
        1.0,
        1.0,
        0.0,
        -1.0,
        1.0,
        0.0
    ];

    var uvCoords = [
        0,
        0,
        1,
        0,
        1,
        1,
        0,
        1
    ];

    var indices = [
        0,
        1,
        2,
        0,
        2,
        3
    ];

    var vBuffer = this._context3D.createVertexBuffer(4, 3);
    vBuffer.uploadFromArray(vertices, 0, 4);

    var tCoordBuffer = this._context3D.createVertexBuffer(4, 2);
    tCoordBuffer.uploadFromArray(uvCoords, 0, 4);

    this._iBuffer = this._context3D.createIndexBuffer(6);
    this._iBuffer.uploadFromArray(indices, 0, 6);

    this._program = this._context3D.createProgram();

    var vProgram = "uniform mat4 mvMatrix;\n" + "uniform mat4 pMatrix;\n" + "attribute vec2 aTextureCoord;\n" + "attribute vec3 aVertexPosition;\n" + "varying vec2 vTextureCoord;\n" + "void main() {\n" + "		gl_Position = pMatrix * mvMatrix * vec4(aVertexPosition, 1.0);\n" + "		vTextureCoord = aTextureCoord;\n" + "}\n";

    var fProgram = "varying mediump vec2 vTextureCoord;\n" + "uniform sampler2D uSampler;\n" + "void main() {\n" + "		gl_FragColor = texture2D(uSampler, vTextureCoord);\n" + "}\n";

    this._program.upload(vProgram, fProgram);
    this._context3D.setProgram(this._program);
    console.log('-----------------------------------------------------------');
    this._pMatrix = new away.utils.PerspectiveMatrix3D();
    this._pMatrix.perspectiveFieldOfViewLH(45, 800 / 600, 0.1, 1000);

    this._mvMatrix = new away.geom.Matrix3D();
    this._mvMatrix.appendTranslation(0, 0, 4);

    this._context3D.setGLSLVertexBufferAt("aVertexPosition", vBuffer, 0, away.display3D.Context3DVertexBufferFormat.FLOAT_3);
    this._context3D.setGLSLVertexBufferAt("aTextureCoord", tCoordBuffer, 0, away.display3D.Context3DVertexBufferFormat.FLOAT_2);

    this._requestAnimationFrameTimer = new away.utils.RequestAnimationFrame(this.tick, this);
    this._requestAnimationFrameTimer.start();
};

MainRotation.prototype.tick = function(dt) {
    //this._mvMatrix.appendRotation(dt * 0.1, new away.geom.Vector3D(0, 1, 0));
    this._context3D.setProgram(this._program);
    this._context3D.setGLSLProgramConstantsFromMatrix("pMatrix", this._pMatrix, true);
    this._context3D.setGLSLProgramConstantsFromMatrix("mvMatrix", this._mvMatrix, true);

    this._context3D.setGLSLTextureAt("uSampler", this._texture, 0);

    this._context3D.clear(0.1, 0.2, 0.3, 1);
    this._context3D.drawTriangles(this._iBuffer, 0, 2);
    this._context3D.present();

    this._requestAnimationFrameTimer.stop();
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