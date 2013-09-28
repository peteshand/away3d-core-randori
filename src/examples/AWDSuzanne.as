package examples
{
import away.containers.View3D;
import away.controllers.HoverController;
import away.display.BitmapData;
import away.entities.Mesh;
import away.events.AssetEvent;
import away.events.LoaderEvent;
import away.geom.Vector3D;
import away.library.AssetLibrary;
import away.library.assets.AssetType;
import away.library.assets.IAsset;
import away.lights.DirectionalLight;
import away.loaders.AssetLoader;
import away.loaders.misc.AssetLoaderToken;
import away.loaders.parsers.AWDParser;
import away.materials.ColorMaterial;
import away.materials.TextureMaterial;
import away.materials.lightpickers.StaticLightPicker;
import away.net.URLRequest;
import away.textures.BitmapTexture;
import away.utils.Debug;
import away.utils.RequestAnimationFrame;

import randori.webkit.page.Window;

/**
     * Created with IntelliJ IDEA.
     * User: pete
     * Date: 23/09/13
     * Time: 7:52 AM
     * To change this template use File | Settings | File Templates.
     */
    public class AWDSuzanne extends BaseExample
    {
        private var token          : AssetLoaderToken;
        private var suzane         : Mesh;
        private var light          : DirectionalLight;
        private var lightPicker    : StaticLightPicker;
        private var hoverControl   : HoverController;
    
        private var move           : Boolean = false;
        private var lastPanAngle   : Number;
        private var lastTiltAngle  : Number;
        private var lastMouseX     : Number;
        private var lastMouseY     : Number;
        
        public function AWDSuzanne(_index:int)
        {
            super(_index);

            Debug.LOG_PI_ERRORS = true;
            Debug.THROW_ERRORS = false;

            AssetLibrary.enableParser( AWDParser ) ;

            token = AssetLibrary.load(new URLRequest('assets/suzanne.awd') );
            token.addEventListener( LoaderEvent.RESOURCE_COMPLETE , onResourceComplete , this );
            token.addEventListener(AssetEvent.ASSET_COMPLETE , onAssetComplete, this );

            view = new View3D();
            view.backgroundColor = 0x666666;

            /*light                  = new DirectionalLight();
            light.color            = 0x683019;//683019;
            light.direction        = new Vector3D( 1 , 0 ,0 );
            light.ambient          = 0.1;//0.05;//.4;
            light.ambientColor     = 0x85b2cd;//4F6877;//313D51;
            light.diffuse          = 2.8;
            light.specular         = 1.8;
            view.scene.addChild( light );



            lightPicker           = new StaticLightPicker( [light] );
            */
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

        override protected function tick(dt:Number):void
        {
            if ( suzane )
            {
                suzane.rotationY += 1;
            }

            view.render();

            if ( hoverControl  )
            {
                hoverControl.update(false);
            }

        }

        public function onAssetComplete ( e : AssetEvent )
        {

            Window.console.log( '------------------------------------------------------------------------------');
            Window.console.log( 'AssetEvent.ASSET_COMPLETE' , AssetLibrary.getAsset(e.asset.name) );
            Window.console.log( '------------------------------------------------------------------------------');

        }

        public function onResourceComplete ( e : LoaderEvent )
        {

            Window.console.log( '------------------------------------------------------------------------------');
            Window.console.log( 'LoaderEvent.RESOURCE_COMPLETE' , e  );
            Window.console.log( '------------------------------------------------------------------------------');

            var loader			: AssetLoader   	= e.target as AssetLoader;
            var numAssets		: Number = loader.baseDependency.assets.length;

            for( var i : Number = 0; i < numAssets; ++i )
            {
                var asset: IAsset = loader.baseDependency.assets[ i ];

                switch ( asset.assetType )
                {
                    case AssetType.MESH:

                    var mesh : Mesh = asset as Mesh;
                    mesh.scale( 400 );

                    suzane = mesh;
                    //suzane.material.lightPicker = lightPicker;

                    //var bmd:BitmapData = new BitmapData(256, 256, true, 0x66FF0000);
                    //var texture:BitmapTexture = new BitmapTexture(bmd, false);
                    //var material:TextureMaterial = new TextureMaterial(texture, true, false, false);
                    //material.alpha = 0.2;
                    //suzane.material = material;//new ColorMaterial(0xFF0000, 0.2)
                    suzane.y = -100;

                    view.scene.addChild( mesh );

                    resize();

                    break;

                    case AssetType.GEOMETRY:
                    break;

                    case AssetType.MATERIAL:
                    break;
                }
            }
        }
    }
}