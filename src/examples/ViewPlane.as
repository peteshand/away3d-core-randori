
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
import away.lights.DirectionalLight;
import away.materials.ColorMaterial;
    import away.materials.TextureMaterial;
import away.materials.lightpickers.StaticLightPicker;
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

    public class ViewPlane extends BaseExample
    {
        private var scene:Scene3D;
        private var geo:PlaneGeometry;
        private var mesh:Mesh;
        private var raf:RequestAnimationFrame;
        private var image:HTMLImageElement;
        private var cameraAxis:Vector3D;
        private var ready:Boolean = false;

        private var canvas:HTMLCanvasElement;
        private var light          : DirectionalLight;
        private var lightPicker    : StaticLightPicker;

        public function ViewPlane(_index:int)
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

            //var bmd:BitmapData = new BitmapData(256,256,true,0xFF44AAFF);
            //var texture:BitmapTexture = new BitmapTexture(bmd, false);
            var htmlImageElement:HTMLImageElement = imageLoader.image as HTMLImageElement
            var texture:HTMLImageElementTexture = new HTMLImageElementTexture(htmlImageElement, false);
            var material:ColorMaterial = new ColorMaterial(0xFFFFFF);

            light                  = new DirectionalLight();
            light.color            = 0x683019;//683019;
            light.direction        = new Vector3D( 0, -1, 1, 0 );
            light.ambient          = 0.1;//0.05;//.4;
            light.ambientColor     = 0xFFFFFF;//4F6877;//313D51;
            light.diffuse          = 2.8;
            light.specular         = 1.8;
            view.scene.addChild( light );

            lightPicker = new StaticLightPicker( [light] );

            material.lightPicker = lightPicker;

            lightPicker           = new StaticLightPicker( [light] );

            geo = new PlaneGeometry(200, 200, 1, 1, false, false);
            mesh = new Mesh(geo, material);
            scene.addChild(mesh);

            resize();

            ready = true;
        }

        override protected function tick(dt:Number):void
        {
            if (ready){
                //mesh.rotationX += 0.4;
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





