package examples
{
import away.cameras.lenses.PerspectiveLens;
import away.containers.Scene3D;
import away.containers.View3D;
import away.display.BlendMode;
import away.entities.Mesh;
import away.events.Event;
import away.geom.Vector3D;
import away.materials.ColorMaterial;
import away.materials.TextureMaterial;
import away.net.IMGLoader;
import away.net.URLRequest;
import away.primitives.CubeGeometry;
import away.primitives.TorusGeometry;
import away.textures.HTMLImageElementTexture;
import away.utils.Debug;
import away.utils.RequestAnimationFrame;

import randori.webkit.html.HTMLImageElement;
import randori.webkit.page.Window;

/**
     * Created with IntelliJ IDEA.
     * User: pete
     * Date: 13/09/13
     * Time: 9:48 PM
     * To change this template use File | Settings | File Templates.
     */
    public class CubeDemo
    {
        private var _scene			: Scene3D;
        private var _view			: View3D;

        private var _cube      		: CubeGeometry;
        private var _torus       	: TorusGeometry;
        private var _mesh  			: Mesh;
        private var _mesh2  		: Mesh;

        private var _raf			:RequestAnimationFrame;
        private var _image			:HTMLImageElement;
        private var _cameraAxis		:Vector3D;

        public function CubeDemo()
        {
            Debug.THROW_ERRORS = false;

            this._view              = new View3D( );

            this._view.backgroundColor = 0xFF0000;
            this._view.camera.x = 130;
            this._view.camera.y = 0;
            this._view.camera.z = 0;
            this._cameraAxis = new Vector3D( 0, 0, 1 );

            this._view.camera.lens = new PerspectiveLens( 120 );

            this._cube              = new CubeGeometry( 20.0, 20.0, 20.0 );
            this._torus             = new TorusGeometry( 150, 80, 32, 16, true );

            //this.loadResources();
        //}

        /*private function loadResources():void
        {
            var urlRequest:URLRequest = new URLRequest( "assets/130909wall_big.png" );
            var imgLoader:IMGLoader = new IMGLoader();
            imgLoader.addEventListener( Event.COMPLETE, this.imageCompleteHandler, this );
            imgLoader.load( urlRequest );
        }*/

        //private function imageCompleteHandler(e):void
        //{
            //var imageLoader:IMGLoader = e.target as IMGLoader;
            //this._image = imageLoader.image;

            //var ts :HTMLImageElementTexture = new HTMLImageElementTexture( this._image, false );

            //var matTx: TextureMaterial = new TextureMaterial( ts, true, true, false );

            //matTx.blendMode = BlendMode.ADD;
            //matTx.bothSides = true;

            var colourMaterial:ColorMaterial = new ColorMaterial(0xFF0000)
            colourMaterial.bothSides = true;

            this._mesh              = new Mesh( this._torus, colourMaterial );
            this._mesh2              = new Mesh( this._cube, colourMaterial );
            this._mesh2.x = 130;
            this._mesh2.z = 40;

            this._view.scene.addChild( this._mesh );
            this._view.scene.addChild( this._mesh2 );

            this._raf = new RequestAnimationFrame( render , this );
            this._raf.start();

            this.resize( null );
        }

        private function render( dt:Number = null ):void
        {
            this._view.camera.rotate( this._cameraAxis, 1 );
            this._mesh.rotationY += 1;
            this._mesh2.rotationX += 0.4;
            this._mesh2.rotationY += 0.4;
            this._view.render();
        }

        private function resize( e ):void
        {
            this._view.y         = 0;
            this._view.x         = 0;

            this._view.width     = window.innerWidth;
            this._view.height    = window.innerHeight;

            Window.console.log( this._view.width , this._view.height );

            this._view.render();
        }
    }
}





