package examples
{
import away.base.CompactSubGeometry;
import away.display.BitmapData;
    import away.display.Stage;
    import away.display.Stage3D;
    import away.display3D.Context3D;
    import away.display3D.Context3DTextureFormat;
    import away.display3D.Context3DVertexBufferFormat;
    import away.display3D.IndexBuffer3D;
    import away.display3D.Program3D;
    import away.display3D.Texture;
    import away.display3D.VertexBuffer3D;
    import away.events.Event;
    import away.geom.Matrix3D;
    import away.geom.Vector3D;
    import away.net.IMGLoader;
    import away.net.URLRequest;
    import away.primitives.TorusGeometry;
    import away.utils.PerspectiveMatrix3D;
    import away.utils.RequestAnimationFrame;
    import randori.webkit.html.HTMLImageElement;
import randori.webkit.page.Window;
import randori.webkit.page.Window;

    /**
     * Created with IntelliJ IDEA.
     * User: pete
     * Date: 31/08/13
     * Time: 11:17 PM
     * To change this template use File | Settings | File Templates.
     */
    public class RotatingTorus
    {
        private var _requestAnimationFrameTimer:RequestAnimationFrame;
        private var _image:HTMLImageElement;
        private var _context3D:Context3D;

        private var _iBuffer:IndexBuffer3D;
        private var _mvMatrix:Matrix3D;
        private var _pMatrix:PerspectiveMatrix3D;
        private var _texture:Texture;
        private var _program:Program3D;
        private var _stage:Stage;

        public function RotatingTorus()
        {
            if( !Window.document )
            {
                throw "The document root object must be avaiable";
            }
            this._stage = new Stage( 800, 600 );
            this.loadResources();
        }


        public function get stage():away.display.Stage
        {
            return this._stage;
        }

        private function loadResources()
        {
            var urlRequest:URLRequest = new URLRequest( "assets/130909wall_big.png" );
            var imgLoader:IMGLoader = new IMGLoader();
            imgLoader.addEventListener( Event.COMPLETE, imageCompleteHandler, this );
            imgLoader.load( urlRequest );
        }

        private function imageCompleteHandler(e)
        {
            var imageLoader:IMGLoader = IMGLoader(e.target);
            _image = imageLoader.image;

            _stage.stage3Ds[0].addEventListener( Event.CONTEXT3D_CREATE, onContext3DCreateHandler, this );
            _stage.stage3Ds[0].requestContext();
        }

        private function onContext3DCreateHandler( e )
        {
            _stage.stage3Ds[0].removeEventListener( Event.CONTEXT3D_CREATE, onContext3DCreateHandler, this );

            var stage3D:Stage3D = Stage3D(e.target);
            _context3D = stage3D.context3D;

            _texture = _context3D.createTexture( 512, 512, Context3DTextureFormat.BGRA, true );

            var bitmapData:BitmapData = new BitmapData( 512, 512, true, 0x02C3D4 );
            _texture.uploadFromBitmapData( bitmapData );

            _context3D.configureBackBuffer( 800, 600, 0, true );
            _context3D.setColorMask( true, true, true, true );

            var torus:TorusGeometry = new TorusGeometry( 1, 0.5, 16, 8, false );
            torus.iValidate();

            var vertices:Vector.<Number> = CompactSubGeometry(torus.getSubGeometries()[0]).vertexData;
            var indices:Vector.<Number> = CompactSubGeometry(torus.getSubGeometries()[0]).indexData;

            /**
            * Updates the vertex data. All vertex properties are contained in a single Vector, and the order is as follows:
            * 0 - 2: vertex position X, Y, Z
            * 3 - 5: normal X, Y, Z
            * 6 - 8: tangent X, Y, Z
            * 9 - 10: U V
            * 11 - 12: Secondary U V
            */
            var stride:Number = 13;
            var numVertices:Number = vertices.length / stride;

            var vBuffer:VertexBuffer3D = _context3D.createVertexBuffer( numVertices, stride );
            vBuffer.uploadFromArray( vertices, 0, numVertices );

            var numIndices:Number = indices.length;
            _iBuffer = _context3D.createIndexBuffer( numIndices );
            _iBuffer.uploadFromArray( indices, 0, numIndices );

            _program = _context3D.createProgram();

            var vProgram:String = "uniform mat4 mvMatrix;\n" +
            "uniform mat4 pMatrix;\n" +
            "attribute vec2 aTextureCoord;\n" +
            "attribute vec3 aVertexPosition;\n" +
            "varying vec2 vTextureCoord;\n" +

            "void main() {\n" +
            "		gl_Position = pMatrix * mvMatrix * vec4(aVertexPosition, 1.0);\n" +
            "		vTextureCoord = aTextureCoord;\n" +
            "}\n";

            var fProgram:String = "varying mediump vec2 vTextureCoord;\n" +
            "uniform sampler2D uSampler;\n" +

            "void main() {\n" +
                    "		gl_FragColor = texture2D(uSampler, vTextureCoord);\n" +
                    "}\n";

            _program.upload( vProgram, fProgram );
            _context3D.setProgram( _program );

            _pMatrix = new PerspectiveMatrix3D();
            _pMatrix.perspectiveFieldOfViewLH( 45, 800/600, 0.1, 1000 );

            _mvMatrix = new Matrix3D(new <Number>[]);
            _mvMatrix.appendTranslation( 0, 0, 5 );

            _context3D.setGLSLVertexBufferAt( "aVertexPosition", vBuffer, 0, Context3DVertexBufferFormat.FLOAT_3 );
            _context3D.setGLSLVertexBufferAt( "aTextureCoord", vBuffer, 9, Context3DVertexBufferFormat.FLOAT_2 );

            _requestAnimationFrameTimer = new RequestAnimationFrame( tick , this );
            _requestAnimationFrameTimer.start();


        }

        private function tick( dt:Number )
        {
            Window.console.log('tick');
            _mvMatrix.appendRotation( dt * 0.1, new Vector3D( 0, 1, 0 ) );
            _context3D.setProgram( _program );
            _context3D.setGLSLProgramConstantsFromMatrix( "pMatrix", _pMatrix, true );
            _context3D.setGLSLProgramConstantsFromMatrix( "mvMatrix", _mvMatrix, true );

            _context3D.setGLSLTextureAt( "uSampler", _texture, 0 );

            _context3D.clear( 0.16, 0.16, 0.16, 1 );
            _context3D.drawTriangles( _iBuffer, 0, _iBuffer.numIndices/3 );
            _context3D.present();
        }
    }
}





