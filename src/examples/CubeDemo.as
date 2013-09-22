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
    import away.primitives.PlaneGeometry;
    import away.primitives.TorusGeometry;
    import away.textures.HTMLImageElementTexture;
    import away.utils.Debug;
    import away.utils.RequestAnimationFrame;

    import randori.webkit.html.HTMLImageElement;
    import randori.webkit.page.Window;

    public class CubeDemo
    {
        private var scene:Scene3D;
        private var view:View3D;
        private var geo:CubeGeometry;
        private var mesh:Mesh;
        private var raf:RequestAnimationFrame;
        private var image:HTMLImageElement;
        private var cameraAxis:Vector3D;

        public function CubeDemo()
        {
            Debug.THROW_ERRORS = false;

            view = new View3D( );
            view.backgroundColor = 0xEEAA00;
            view.camera.z = -1000;
            view.camera.lens = new PerspectiveLens(120);

            scene = view.scene;

            geo = new CubeGeometry(200, 200, 200);
            var colourMaterial:ColorMaterial = new ColorMaterial(0xFF00FF, 1);
            colourMaterial.bothSides = true;

            mesh = new Mesh(geo, colourMaterial);
            scene.addChild(mesh);

            resize();

            raf = new RequestAnimationFrame(render ,this);
            raf.start();
        }

        private function render(dt:Number = null):void
        {
            mesh.rotationX += 0.4;
            mesh.rotationY += 0.4;
            view.camera.lookAt(mesh.position);
            view.render();


        }

        private function resize():void
        {
            view.y         = 0;
            view.x         = 0;

            view.width     = window.innerWidth;
            view.height    = window.innerHeight;

            Window.console.log( view.width , view.height );
        }
    }
}





