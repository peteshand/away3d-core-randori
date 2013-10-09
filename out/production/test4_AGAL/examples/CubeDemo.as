
package examples
{
    import away.cameras.lenses.PerspectiveLens;
    import away.containers.Scene3D;
    import away.containers.View3D;
import away.core.display.BitmapData;
import away.core.geom.Vector3D;
import away.core.net.IMGLoader;
import away.core.net.URLRequest;
import away.entities.Mesh;
    import away.events.Event;
    import away.materials.ColorMaterial;
    import away.materials.TextureMaterial;
    import away.primitives.CubeGeometry;
    import away.primitives.PlaneGeometry;
    import away.primitives.TorusGeometry;
    import away.textures.BitmapTexture;
    import away.textures.HTMLImageElementTexture;
    import away.utils.Debug;
    import away.utils.RequestAnimationFrame;

import randori.webkit.html.HTMLCanvasElement;

import randori.webkit.html.HTMLImageElement;
    import randori.webkit.page.Window;

    public class CubeDemo extends BaseExample
    {
        private var scene:Scene3D;
        private var geo:CubeGeometry;
        private var mesh:Mesh;
        private var raf:RequestAnimationFrame;
        private var image:HTMLImageElement;
        private var cameraAxis:Vector3D;
        private var ready:Boolean = false;

        private var canvas:HTMLCanvasElement;

        public function CubeDemo(_index:int)
        {
            super(_index);

            //Debug.THROW_ERRORS = false;
            //Debug.ENABLE_LOG = true;

            view = new View3D( );
            view.backgroundColor = 0xFF3399;
            view.camera.z = -1000;
            view.camera.lens = new PerspectiveLens(40);
            view.width = 800;
            view.height = 500;
            scene = view.scene;

            var urlRequest:URLRequest = new URLRequest( "assets/130909wall_big.png" );
            var imgLoader:IMGLoader = new IMGLoader();
            imgLoader.addEventListener( Event.COMPLETE, imageCompleteHandler, this );
            imgLoader.load( urlRequest );
        }

        private function imageCompleteHandler(e)
        {
            var imageLoader:IMGLoader = IMGLoader(e.target);

            var bmd:BitmapData = new BitmapData(256,256,true,0xFF44AAFF);
            var texture:BitmapTexture = new BitmapTexture(bmd, false);
            //var texture:HTMLImageElementTexture = new HTMLImageElementTexture(imageLoader.image as HTMLImageElement);
            var material:TextureMaterial = new TextureMaterial(texture);

            geo = new CubeGeometry(200, 200, 200);
            mesh = new Mesh(geo, material);
            scene.addChild(mesh);

            resize();

            ready = true;
        }

        override protected function tick(dt:Number):void
        {
            if (ready){
                mesh.rotationX += 0.4;
                mesh.rotationY += 0.4;
                view.camera.lookAt(mesh.position);
                view.render();
            }
        }

        override protected function resize():void
        {
            if (view){
                view.y         = 0;
                view.x         = 0;
                view.width     = window.innerWidth;
                view.height    = window.innerHeight;
            }
        }
    }
}





