

package examples
{
import away.core.base.ISubGeometry;
import away.core.display.Stage;
import away.core.display.Stage3D;
import away.core.display3D.Context3D;
import away.core.display3D.Context3DVertexBufferFormat;
import away.core.display3D.IndexBuffer3D;
import away.core.display3D.Program3D;
import away.core.display3D.Texture;
import away.core.display3D.VertexBuffer3D;
import away.core.geom.Matrix3D;
import away.core.geom.Vector3D;
import away.core.net.IMGLoader;
import away.core.net.URLRequest;
import away.events.Event;
    import away.primitives.TorusGeometry;
    import away.utils.PerspectiveMatrix3D;
    import away.utils.RequestAnimationFrame;

    import randori.webkit.html.HTMLImageElement;
    import randori.webkit.page.Window;

/**
     * Created with IntelliJ IDEA.
     * User: pete
     * Date: 22/09/13
     * Time: 11:05 PM
     * To change this template use File | Settings | File Templates.
     */
    public class PhongTorus 
    {
        private var requestAnimationFrameTimer:RequestAnimationFrame;
        private var image:HTMLImageElement;
        private var context3D:Context3D;
    
        private var iBuffer:IndexBuffer3D;
        private var normalMatrix:Matrix3D;
        private var mvMatrix:Matrix3D;
        private var pMatrix:PerspectiveMatrix3D;
        private var texture:Texture;
        private var program:Program3D;
    
        private var stage:Stage;
            
        public function PhongTorus() 
        {
            super();

            if( !Window.document )
            {
                throw "The Window.document root object must be avaiable";
            }
            stage = new Stage( 800, 600 );
            loadResources();   
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
            var imageLoader:IMGLoader = e.target as IMGLoader;
            image = imageLoader.image;

            stage.stage3Ds[0].addEventListener( Event.CONTEXT3D_CREATE, onContext3DCreateHandler, this );
            stage.stage3Ds[0].requestContext();
            }

        private function onContext3DCreateHandler( e )
		{
                stage.stage3Ds[0].removeEventListener( Event.CONTEXT3D_CREATE, onContext3DCreateHandler, this );

                var stage3D: Stage3D = e.target as Stage3D;
                context3D = stage3D.context3D;

                //texture = context3D.createTexture( 512, 512, Context3DTextureFormat.BGRA, true );
                //texture.uploadFromHTMLImageElement( image );

                //var bitmapData: BitmapData = new BitmapData( 512, 512, true, 0x02C3D4 );
                //texture.uploadFromBitmapData( bitmapData );

                context3D.configureBackBuffer( 800, 600, 0, true );
                context3D.setColorMask( true, true, true, true );

                var torus: TorusGeometry = new TorusGeometry( 1, 0.5, 32, 16, false );
                torus.iValidate();

                var geo:ISubGeometry = torus.subGeometries[0];
                var vertices:Vector.<Number> = geo.vertexData;
                var indices:Vector.<Number> = geo.indexData;

                /**
                * Updates the vertex data. All vertex properties are contained in a single Vector, and the order is as follows:
                * 0 - 2: vertex position X, Y, Z
                * 3 - 5: normal X, Y, Z
                * 6 - 8: tangent X, Y, Z
                * 9 - 10: U V
                * 11 - 12: Secondary U V
                */
                var stride:Number = 13;
                var numVertices: Number = vertices.length / stride;
                var vBuffer: VertexBuffer3D = context3D.createVertexBuffer( numVertices, stride );
                vBuffer.uploadFromArray( vertices, 0, numVertices );

                var numIndices:Number = indices.length;
                iBuffer = context3D.createIndexBuffer( numIndices );
                iBuffer.uploadFromArray( indices, 0, numIndices );

                program = context3D.createProgram();

                var vProgram:String = 	"attribute vec3 aVertexPosition;\n" +
                "attribute vec2 aTextureCoord;\n" +
                "attribute vec3 aVertexNormal;\n" +

                "uniform mat4 uPMatrix;\n" +
                "uniform mat4 uMVMatrix;\n" +
                "uniform mat4 uNormalMatrix;\n" +

                "varying vec3 vNormalInterp;\n" +
                "varying vec3 vVertPos;\n" +

                "void main(){\n" +
                "	gl_Position = uPMatrix * uMVMatrix * vec4( aVertexPosition, 1.0 );\n" +
                "	vec4 vertPos4 = uMVMatrix * vec4( aVertexPosition, 1.0 );\n" +
                "	vVertPos = vec3( vertPos4 ) / vertPos4.w;\n" +
                "	vNormalInterp = vec3( uNormalMatrix * vec4( aVertexNormal, 0.0 ) );\n" +
                "}\n";

            var fProgram:String = 	"precision mediump float;\n" +
            "varying vec3 vNormalInterp;\n" +
            "varying vec3 vVertPos;\n" +

            "const vec3 lightPos = vec3( 1.0,1.0,1.0 );\n" +
            "const vec3 diffuseColor = vec3( 0.3, 0.6, 0.9 );\n" +
            "const vec3 specColor = vec3( 1.0, 1.0, 1.0 );\n" +

            "void main() {\n" +
                    "	vec3 normal = normalize( vNormalInterp );\n" +
                    "	vec3 lightDir = normalize( lightPos - vVertPos );\n" +
                    "	float lambertian = max( dot( lightDir,normal ), 0.0 );\n" +
                    "	float specular = 0.0;\n" +

                    "	if( lambertian > 0.0 ) {\n" +
                    "		vec3 reflectDir = reflect( -lightDir, normal );\n" +
                    "		vec3 viewDir = normalize( -vVertPos );\n" +
                    "		float specAngle = max( dot( reflectDir, viewDir ), 0.0 );\n" +
                    "		specular = pow( specAngle, 4.0 );\n" +
                    "		specular *= lambertian;\n" +
                    "	}\n" +

            "	gl_FragColor = vec4( lambertian * diffuseColor + specular * specColor, 1.0 );\n" +
            "}\n";

            program.upload( vProgram, fProgram );
            context3D.setProgram( program );

            pMatrix = new PerspectiveMatrix3D();
            pMatrix.perspectiveFieldOfViewLH( 45, 800/600, 0.1, 1000 );

            mvMatrix = new Matrix3D();
            mvMatrix.appendTranslation( 0, 0, 7 );

            normalMatrix = mvMatrix.clone();
            normalMatrix.invert();
            normalMatrix.transpose();

            context3D.setGLSLVertexBufferAt( "aVertexPosition", vBuffer, 0, Context3DVertexBufferFormat.FLOAT_3 );
            context3D.setGLSLVertexBufferAt( "aVertexNormal", vBuffer, 3, Context3DVertexBufferFormat.FLOAT_3 )

            requestAnimationFrameTimer = new RequestAnimationFrame( tick , this );
            requestAnimationFrameTimer.start();
        }

        private function tick( dt:Number )
		{
            mvMatrix.appendRotation( dt * 0.05, new Vector3D( 0, 1, 0 ) );
            context3D.setProgram( program );
            context3D.setGLSLProgramConstantsFromMatrix( "uNormalMatrix", normalMatrix, true );
            context3D.setGLSLProgramConstantsFromMatrix( "uMVMatrix", mvMatrix, true );
            context3D.setGLSLProgramConstantsFromMatrix( "uPMatrix", pMatrix, true );

            context3D.clear( 0.16, 0.16, 0.16, 1 );
            context3D.drawTriangles( iBuffer, 0, iBuffer.numIndices/3 );
            context3D.present();
        }
    }
}