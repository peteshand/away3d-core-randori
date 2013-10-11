

package examples
{
import aglsl.AGLSLCompiler;

import away.core.base.CompactSubGeometry;

import away.core.base.Geometry;
import away.core.display.Stage;
import away.core.display.Stage3D;
import away.core.display3D.AGLSLContext3D;
import away.core.display3D.Context3DProgramType;
import away.core.display3D.Context3DVertexBufferFormat;
import away.core.display3D.IndexBuffer3D;
import away.core.display3D.Program3D;
import away.core.display3D.VertexBuffer3D;
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
     * Time: 10:52 PM
     * To change this template use File | Settings | File Templates.
     */
    public class AGALTorus 
    {
        private var requestAnimationFrameTimer:RequestAnimationFrame;
        private var stage3D:Stage3D;
        private var image:HTMLImageElement;
        private var context3D:AGLSLContext3D;
    
        private var iBuffer:IndexBuffer3D;
        private var matrix:PerspectiveMatrix3D;
        private var program:Program3D;
    
        private var vBuffer:VertexBuffer3D;
    
        private var geometry:Geometry;
    
        private var stage:Stage;
        
        public function AGALTorus() 
        {
            super();

            if( !Window.document )
            {
                throw "The Window.document root object must be avaiable";
            }
            stage = new Stage( 800, 600 );

            stage.stage3Ds[0].addEventListener( Event.CONTEXT3D_CREATE, onContext3DCreateHandler, this );
            stage.stage3Ds[0].requestContext( true );
        }

        private function onContext3DCreateHandler( e )
        {
            stage.stage3Ds[0].removeEventListener( Event.CONTEXT3D_CREATE, onContext3DCreateHandler, this );

            var stage3D: Stage3D = Stage3D(e.target);
            context3D = AGLSLContext3D(stage3D.context3D);

            context3D.configureBackBuffer( 800, 600, 0, true );
            context3D.setColorMask( true, true, true, true );

            geometry = new Geometry();

            var torus: TorusGeometry = new TorusGeometry( 1, 0.5, 32, 16, false );
            torus.iValidate();

            var geo:CompactSubGeometry = CompactSubGeometry(torus.subGeometries[0]);

            var vertices:Vector.<Number> = geo.vertexData;
            var indices:Vector.<Number> = geo.indexData;
            Window.console.log(vertices);

            var stride:Number = 13;
            var numVertices: Number = vertices.length / stride;
            vBuffer = context3D.createVertexBuffer( numVertices, stride );
            vBuffer.uploadFromArray( vertices, 0, numVertices );

            var numIndices:Number = indices.length;
            iBuffer = context3D.createIndexBuffer( numIndices );
            iBuffer.uploadFromArray( indices, 0, numIndices );

            program = context3D.createProgram();

            var vProgram:String = "m44 op, va0, vc0  \n" +
            "mov v0, va1       \n";

            var fProgram:String = "mov oc, v0 \n";

            var vertCompiler:AGLSLCompiler = new AGLSLCompiler();
            var fragCompiler:AGLSLCompiler = new AGLSLCompiler();

            var compVProgram:String = vertCompiler.compile( Context3DProgramType.VERTEX, vProgram );
            var compFProgram:String = fragCompiler.compile( Context3DProgramType.FRAGMENT, fProgram );

            Window.console.log( "=== compVProgram ===" );
            Window.console.log( compVProgram );

            Window.console.log( "\n" );

            Window.console.log( "=== compFProgram ===" );
            Window.console.log( compFProgram );

            program.upload( compVProgram, compFProgram );
            context3D.setProgram( program );

            matrix = new PerspectiveMatrix3D();
            matrix.perspectiveFieldOfViewLH( 85, 800/600, 0.1, 1000 );

            context3D.setVertexBufferAt( 0, vBuffer, 0, Context3DVertexBufferFormat.FLOAT_3 );
            context3D.setVertexBufferAt( 1, vBuffer, 6, Context3DVertexBufferFormat.FLOAT_3 ); // test varying interpolation with normal channel as some colors

            //requestAnimationFrameTimer = new RequestAnimationFrame( tick , this );
            //requestAnimationFrameTimer.start();

            tick( 0 );
        }

        private function tick( dt:Number )
		{
            context3D.setProgram( program );
            context3D.setProgramConstantsFromMatrix( Context3DProgramType.VERTEX, 0, matrix, true );

            context3D.clear( 0.16, 0.16, 0.16, 1 );
            context3D.drawTriangles( iBuffer, 0, iBuffer.numIndices/3 );
            context3D.present();

            //requestAnimationFrameTimer.stop();
        }
    }
}